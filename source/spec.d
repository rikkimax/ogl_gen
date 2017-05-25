module spec;
import defs;

enum IndexFile = "api/gl.xml";
enum PrependXMLFileLocation = "api/";

void readInFunctionFamilies(ref OGLEnumGroup[] enums, ref OGLFunctionFamily[] families) {
	import std.file : readText;
	import std.experimental.xml;
	
	string raw_input = readText(IndexFile);
	
	auto domBuilder = raw_input
		.lexer
		.parser
		.cursor((CursorError err){})
		.domBuilder;
	domBuilder.setSource(raw_input);
	domBuilder.buildRecursive;
	auto dom = domBuilder.getDocument;

	auto rootNode = dom.firstChild;

	OGLFunction[] ret_Functions;
	handleChildren(rootNode, enums, ret_Functions);

	debug(OGL_Spec) {
		import std.stdio;
		foreach(ref e; enums) {
			writeln("- ", e.name, e.isBitmask ? " [bitmask]": "");
			foreach(ref e2; e.enums) {
				if (e2.value !is null)
					writeln("  - ", e2.name, " = ", e2.value);
			}
		}
	}
}

void handleChildren(T)(ref T rootNode, ref OGLEnumGroup[] enums, ref OGLFunction[] ret_Functions) {
	OGLEnumGroup* emptyEnumGroup;
	foreach(ref e; enums) {
		if (e.name is null)
			emptyEnumGroup = &e;
	}
	if (emptyEnumGroup is null) {
		enums ~= OGLEnumGroup();
		emptyEnumGroup = &enums[$-1];
	}

F1: foreach(child; rootNode.childNodes) {
		// Structure:
		//  - comment
		//  - types
		//  - groups (enums)
		//  - enums (value)
		//  - feature
		//  - extensions

		switch(child.nodeName) {
			case "comment":
				break;
			case "groups":
			F2: foreach(group; child.childNodes) {
					string name = group.attributes.getNamedItem("name").nodeValue;
				F3: foreach(ref eg; enums) {
						if (eg.name == name) {
						F4: foreach(child2; group.childNodes) {
								if (child2.nodeName == "enum") {
									string name2 = child2.attributes.getNamedItem("name").nodeValue;
									foreach(ref e; eg.enums) {
										if (e.name == name2) {
											continue F4;
										}
									}

									eg.enums ~= OGLEnum(name2);
									continue F4;
								}
							}

							continue F2;
						}
					}

					enums ~= OGLEnumGroup(name);
					goto F3;
				}
				continue F1;

			case "enums":
				string groupName, groupType;

				if (child.attributes.getNamedItem("namespace").nodeValue == "OcclusionQueryEventMaskAMD") {
					groupName = "OcclusionQueryEventMaskAMD";
					groupType = "bitmask";
				} else if (child.attributes.getNamedItem("group") !is null) {
					groupName = child.attributes.getNamedItem("group").nodeValue;
					if (child.attributes.getNamedItem("type") !is null)
						groupType = child.attributes.getNamedItem("type").nodeValue;
				}

				OGLEnumGroup* group;
				foreach(ref eg; enums) {
					if (eg.name == groupName) {
						group = &eg;
						break;
					}
				}

				// no matter what we want to fill out all enums created
			F6: foreach(child2; child.childNodes) {
					if (child2.nodeName == "enum") {
						string name = child2.attributes.getNamedItem("name").nodeValue;
						string value = child2.attributes.getNamedItem("value").nodeValue;
						
						bool wasSet;
						foreach(ref group2; enums) {
							foreach(ref e; group2.enums) {
								if (e.name == name) {
									e.value = value;
									wasSet = true;
								}
							}
						}
						if (wasSet)
							continue F6;
						
						emptyEnumGroup.enums ~= OGLEnum(name, value);
						continue F6;
					}
				}

				if (group !is null)
					group.isBitmask = groupType == "bitmask";
				break;

			default:
				break;
		}
	}
}