module spec;
import defs;
import util;

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

	handleChildren(rootNode, enums, families);

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

void handleChildren(T)(ref T rootNode, ref OGLEnumGroup[] enums, ref OGLFunctionFamily[] ret_Functions) {
	size_t emptyEnumGroup = -1;
	foreach(i, ref e; enums) {
		if (e.name is null)
			emptyEnumGroup = i;
	}
	if (emptyEnumGroup == -1) {
		emptyEnumGroup = enums.length;
		enums ~= OGLEnumGroup();
	}

	size_t emptyFunctionFamily = -1;
	foreach(i, ref fg; ret_Functions) {
		if (fg.familyOfFunction is null)
			emptyFunctionFamily = i;
	}
	if (emptyFunctionFamily == -1) {
		emptyFunctionFamily = ret_Functions.length;
		ret_Functions ~= OGLFunctionFamily();
	}

F1: foreach(child; rootNode.childNodes) {
		// Structure:
		//  - comment
		//  - types
		//  - groups (enums)
		//  - enums (value)
		//  - commands
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
						
						enums[emptyEnumGroup].enums ~= OGLEnum(name, value);
						continue F6;
					}
				}

				if (group !is null)
					group.isBitmask = groupType == "bitmask";
				break;

			case "commands":
			F7: foreach(child2; child.childNodes) {
					if (child2.nodeName == "command") {
						string returnType, name;
						string[] argTypes, argNames;
						size_t argI;

						argTypes.length = child2.childNodes.length-1;
						argNames.length = child2.childNodes.length-1;

						foreach(child3; child2.childNodes) {
							switch(child3.nodeName) {
								case "proto":
									size_t i;
									foreach(child4; child3.childNodes) {
										if (child4.nodeName == "name")
											break;
										
										if (i > 0)
											returnType ~= " ";
										
										if (child4.nodeValue !is null) {
											returnType ~= child4.nodeValue.fixTypePointer;
										}
										
										if (child4.childNodes.length > 0) {
											returnType ~= child4.firstChild.nodeValue.fixTypePointer;
										}
										
										i++;
									}

									returnType = returnType.fixTypePointer;

									name = child3.lastChild.firstChild.nodeValue;
									break;
								case "param":
									size_t i;
									foreach(child4; child3.childNodes) {
										if (child4.nodeName == "name")
											break;

										if (i > 0)
											argTypes[argI] ~= " ";

										if (child4.nodeValue !is null) {
											argTypes[argI] ~= child4.nodeValue.fixTypePointer;
										}

										if (child4.childNodes.length > 0) {
											argTypes[argI] ~= child4.firstChild.nodeValue.fixTypePointer;
										}

										i++;
									}

									argTypes[argI] = argTypes[argI].fixTypePointer;

									foreach(child4; child3.childNodes) {
										if (child4.nodeName == "name") {
											argNames[argI] = child4.firstChild.nodeValue;
											break;
										}
									}
									argI++;
									break;
								default:
									argTypes.length--;
									argNames.length--;
									break;
							}
						}

						foreach(ref fg; ret_Functions) {
							foreach(ref fe; fg.functions) {
								if (fe.name == name) {
									continue F7;
								}
							}
						}

						ret_Functions[emptyFunctionFamily].functions ~= OGLFunction(returnType, name, argTypes, argNames);
					}
				}
				break;

			case "feature":
				if (child.attributes.getNamedItem("api").nodeValue == "gl") {
					string introducedInS = child.attributes.getNamedItem("number").nodeValue;

					foreach(child2; child.childNodes) {
					F8: foreach(child3; child2.childNodes) {
							if (child3.nodeName == "command") {
								string name = child3.attributes.getNamedItem("name").nodeValue;

								foreach(ref fg; ret_Functions) {
									foreach(ref fe; fg.functions) {
										if (fe.name == name && fe.introducedIn == OGLIntroducedIn.Unknown) {
											switch(introducedInS) {
												case "1.0": fe.introducedIn = OGLIntroducedIn.V1P0; break;
												case "1.1": fe.introducedIn = OGLIntroducedIn.V1P1; break;
												case "1.2": fe.introducedIn = OGLIntroducedIn.V1P2; break;
												case "1.3": fe.introducedIn = OGLIntroducedIn.V1P3; break;
												case "1.4": fe.introducedIn = OGLIntroducedIn.V1P4; break;
												case "1.5": fe.introducedIn = OGLIntroducedIn.V1P5; break;
												case "2.0": fe.introducedIn = OGLIntroducedIn.V2P0; break;
												case "2.1": fe.introducedIn = OGLIntroducedIn.V2P1; break;
												case "3.0": fe.introducedIn = OGLIntroducedIn.V3P0; break;
												case "3.1": fe.introducedIn = OGLIntroducedIn.V3P1; break;
												case "3.2": fe.introducedIn = OGLIntroducedIn.V3P2; break;
												case "3.3": fe.introducedIn = OGLIntroducedIn.V3P3; break;
												case "4.0": fe.introducedIn = OGLIntroducedIn.V4P0; break;
												case "4.1": fe.introducedIn = OGLIntroducedIn.V4P1; break;
												case "4.2": fe.introducedIn = OGLIntroducedIn.V4P2; break;
												case "4.3": fe.introducedIn = OGLIntroducedIn.V4P3; break;
												case "4.4": fe.introducedIn = OGLIntroducedIn.V4P4; break;
												case "4.5": fe.introducedIn = OGLIntroducedIn.V4P5; break;
												default: break;
											}
											continue F8;
										}
									}
								}
							}
						}
					}
				}
				break;

			case "extensions":
				foreach(child2; child.childNodes) {
					string extName = child2.attributes.getNamedItem("name").nodeValue;
					
					foreach(child3; child2.childNodes) {
					F9: foreach(child4; child3.childNodes) {
							if (child4.nodeName == "command") {
								string name = child4.attributes.getNamedItem("name").nodeValue;
								foreach(ref fg; ret_Functions) {
									foreach(ref fe; fg.functions) {
										if (fe.name == name && fe.introducedInExtension is null) {
											fe.introducedInExtension = extName;
											continue F9;
										}
									}
								}
							}
						}
					}
				}
				break;

			default:
				break;
		}
	}
}