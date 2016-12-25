﻿module core_3;
import defs;

enum FilesLocation = "man3/";
enum FileGlob = "gl*.xml";
enum PrependXMLFileLocation = "man3/";

OGLFunctionFamily[] readInFunctionFamilies() {
	import std.file : dirEntries, SpanMode;
	OGLFunctionFamily[] ret;

	foreach(string entry; dirEntries(FilesLocation, FileGlob, SpanMode.shallow)) {
		if (entry == FilesLocation ~ "glVertexAttrib.xml")
			ret ~= OGLFunctionFamily(entry, entry[FilesLocation.length .. $-4]);
	}

	foreach(ref family; ret) {
		family.functions = family.readInFunctions;

		import std.stdio;
		//writeln(family);
	}

	return ret;
}


OGLFunction[] readInFunctions(ref OGLFunctionFamily family) {
	import std.file : readText;
	import std.experimental.xml;
	import core_4_5 : fixTypePointer;

	string raw_input = readText(family.fromFilename);
	OGLFunction[] ret;
	
	if (raw_input.length < 72) {
		return null;
	} else
		raw_input = raw_input[71 .. $];
	
	auto domBuilder = raw_input
		.lexer
			.parser
			.cursor((CursorError err){})
			.domBuilder;
	domBuilder.setSource(raw_input);
	domBuilder.buildRecursive;
	auto dom = domBuilder.getDocument;
	
	//

	auto copyrightTags = dom.getElementsByTagName("copyright");
	if (copyrightTags !is null && copyrightTags.length > 0) {
		auto copyright = copyrightTags[0];
		family.copyright = copyright.lastChild.firstChild.nodeValue ~ " " ~ copyright.firstChild.firstChild.nodeValue;
	}

	//

	auto funcSynopsises = dom.getElementsByTagName("funcsynopsis");
	size_t funcprototypesCount;
	foreach(funcSynopsis; funcSynopsises) {
		funcprototypesCount += funcSynopsis.childNodes.length;
	}
	ret.length = funcprototypesCount;

	size_t i;
	foreach(funcSynopsisI; 0 .. funcSynopsises.length) {
	F2: foreach(funcprototype; funcSynopsises[funcSynopsisI].childNodes) {
			switch(funcprototype.nodeName) {
				case "funcprototype":
					break;
				default:
					ret.length--;
					continue F2;
			}

			ret[i].returnType = funcprototype.firstChild.firstChild.nodeValue[0 .. $-1].fixTypePointer;
			ret[i].name = funcprototype.firstChild.lastChild.firstChild.nodeValue;

			ret[i].argNames.length = funcprototype.childNodes.length;
			ret[i].argTypes.length = ret[i].argNames.length;
			
			size_t j;
			foreach(paramdef; funcprototype.childNodes) {
				switch(paramdef.nodeName) {
					case "paramdef":
						break;
					default:
						ret[i].argNames.length--;
						ret[i].argTypes.length--;
						continue;
				}
				
				if (paramdef.firstChild.nodeValue.length > 0) {
					ret[i].argTypes[j] = paramdef.firstChild.nodeValue.fixTypePointer;
					
					if (ret[i].argTypes[j].length > 0 && ret[i].argTypes[j][$-1] == ' ')
						ret[i].argTypes[j].length--;
					
					if (paramdef.childNodes.length == 2)
						ret[i].argNames[j] = paramdef.lastChild.firstChild.nodeValue;
				} else
					ret[i].argTypes[j] = paramdef.firstChild.firstChild.nodeValue.fixTypePointer;
				
				j++;
			}
			
			i++;
		}
	}

	//



	//

	return ret;
}