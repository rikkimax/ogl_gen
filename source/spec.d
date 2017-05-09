module spec;
import defs;

enum IndexFile = "api/gl.xml";
enum PrependXMLFileLocation = "api/";

OGLFunctionFamily[] readInFunctionFamilies(ref OGLEnumGroup[] enums) {
	import std.file : readText;
	import std.experimental.xml;
	
	string raw_input = readText(IndexFile);
	OGLFunctionFamily[] ret;
	
	auto domBuilder = raw_input
		.lexer
			.parser
			.cursor((CursorError err){})
			.domBuilder;
	domBuilder.setSource(raw_input);
	domBuilder.buildRecursive;
	auto dom = domBuilder.getDocument;

	// Structure:
	//  - comment
	//  - types
	//  - groups (enums)
	//  - enums (value)
	//  - feature
	//  - extensions

	auto rootNode = dom.firstChild;

	// lets extra the enums values
F1: foreach(child; rootNode.childNodes) {
		if (child.nodeName == "enums") {
			string groupName, groupType;

			if (child.attributes.getNamedItem("start") !is null) {
				switch(child.attributes.getNamedItem("start").nodeValue) {
					case "0x96B0":
					case "100000":
					case "101000":
					case "102000":
					case "103000":
					case "104000":
					case "105000":
					case "106000":
					case "107000":
					case "108000":
					
						continue F1;
					default:
						break;
				}
			}
			
			if (child.attributes.getNamedItem("namespace").nodeValue == "OcclusionQueryEventMaskAMD") {
				groupName = "OcclusionQueryEventMaskAMD";
				groupType = "bitmask";
			} else if (child.attributes.getNamedItem("group") !is null) {
				groupName = child.attributes.getNamedItem("group").nodeValue;
				if (child.attributes.getNamedItem("type") !is null)
					groupType = child.attributes.getNamedItem("type").nodeValue;
			}

			enums ~= OGLEnumGroup(groupName, groupType == "bitmask");
			OGLEnumGroup* group = &enums[$-1];

			foreach(child2; child.childNodes) {
				if (child2.nodeName == "enum") {
					string name = child2.attributes.getNamedItem("name").nodeValue;
					string value = child2.attributes.getNamedItem("value").nodeValue;
					group.enums ~= OGLEnum(name, value);
				}
			}
		}
	}

	return ret;
}