module util;

const(char)[] removeUnicodeBOM(const(char)[] input) {
	if (input.length >= 3 && input[0 .. 3] == x"ef bb bf") {
		return input[3 .. $];
	} else {
		return input;
	}
}

pure string replace(string text, string oldText, string newText, bool caseSensitive = true, bool first = false) {
	import std.uni : toLower;
	
	string ret;
	string tempData;
	bool stop;
	foreach(char c; text) {
		if (tempData.length > oldText.length && !stop) {
			ret ~= tempData;
			tempData = "";
		}
		if (((caseSensitive && oldText[0 .. tempData.length] != tempData) || (!caseSensitive && oldText[0 .. tempData.length].toLower() != tempData.toLower())) && !stop) {
			ret ~= tempData;
			tempData = "";
		}
		tempData ~= c;
		if (((caseSensitive && tempData == oldText) || (!caseSensitive && tempData.toLower() == oldText.toLower())) && !stop) {
			ret ~= newText;
			tempData = "";
			stop = first;
		}
	}
	if (tempData != "") {
		ret ~= tempData;	
	}
	return ret;
}

string makeValidCIdentifier(string input) {
	import std.string : indexOf;
	char[] ret;

	if (input.length > 0) {
		if ((input[0] >= 'a' && input[0] <= 'z') || (input[0] >= 'A' && input[0] <= 'Z') || input[0] == '_') {
			return input;
		}

		ptrdiff_t i = input.indexOf('_');
		if (i == -1) {
			ret.length = input.length + 1;
			ret[0] = '_';
			ret[1 .. $] = input;
		} else {
			ret.length = input.length;
			ret[0 .. input.length-(i+1)] = input[i+1 .. $];
			ret[input.length-(i+1)] = '_';
			if (i > 0)
				ret[$-i .. $] = input[0 .. i];
		}
	}

	return (cast(string)ret).makeValidCIdentifier;
}

unittest {
	assert(makeValidCIdentifier("abc") == "abc");
	assert(makeValidCIdentifier("_abc") == "_abc");
	assert(makeValidCIdentifier("4_abc") == "abc_4");
	assert(makeValidCIdentifier("4g_abc") == "abc_4g");
	assert(makeValidCIdentifier("4g") == "_4g");
	assert(makeValidCIdentifier("") == "");
}

string fixTypePointer(string input) {
	import std.string : strip, startsWith;
	if (input is null)
		return null;

	input = input.strip;

	if (input.length > 6 && input[0 .. 6] == "struct")
		input = input[6 .. $];

	char[] buffer, buffer2;
	buffer.length = input.length;
	buffer[] = input[];
	
	size_t i;
	while(i < buffer.length) {
		char c = buffer[i];
		char c2 = '\0';
		
		if (i + 1 < buffer.length)
			c2 = buffer[i + 1];
		
		if (c == ' ') {
			if (c2 == '*') {
				buffer[i] = '*';
				buffer[i + 1] = ' ';
			}
		}
		
		i++;
	}
	
	string ret = cast(string)buffer.strip;
	if (ret == "const GLvoid*  const*" || ret == "const GLchar* const*" || ret == "const void* const*")
		return "const(const(GLvoid*)*)";
	else if (ret == "GLuitn" || ret == "Gluint")
		return "GLuint";
	else if (ret == "Glenum*")
		return "GLenum*";
	else if (ret == "const Glenum*")
		return "const(GLenum)*";
	else if (ret == "DEBUGPROC")
		return "GLDEBUGPROC";
	else if (ret == "const GLubyte*" || ret == "const GLubyte *")
		return "const(GLubyte)*";
	else if (ret.startsWith("const "))
		return "const(" ~ ret[5 .. $] ~ ")";
	else
		return ret;
}