module core_2;
import defs;

enum FilesLocation = "man2/";
enum FileGlob = "gl*.xml";
enum PrependXMLFileLocation = "man2/";

OGLFunctionFamily[] readInFunctionFamilies() {
	import core_3 : readInFunctions;
	import std.file : dirEntries, SpanMode;
	OGLFunctionFamily[] ret;

	foreach(string entry; dirEntries(FilesLocation, FileGlob, SpanMode.shallow)) {
		//if (entry == FilesLocation ~ "glVertexAttrib.xml")
			ret ~= OGLFunctionFamily(entry, entry[FilesLocation.length .. $-4]);
	}

	foreach(ref family; ret) {
		family.functions = family.readInFunctions;

		import std.stdio;
		//writeln(family);
	}

	return ret;
}