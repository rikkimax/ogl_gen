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
		string name = entry[FilesLocation.length .. $-4];
		if (name.length > 3 && name[0 .. 3] != "glX")
			ret ~= OGLFunctionFamily(entry, name);
	}

	foreach(ref family; ret) {
		family.functions = family.readInFunctions;
	}

	return ret;
}