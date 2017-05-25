module util;

const(char)[] removeUnicodeBOM(const(char)[] input) {
	if (input.length >= 3 && input[0 .. 3] == x"ef bb bf") {
		return input[3 .. $];
	} else {
		return input;
	}
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

	return cast(string)ret;
}

unittest {
	assert(makeValidCIdentifier("abc") == "abc");
	assert(makeValidCIdentifier("_abc") == "_abc");
	assert(makeValidCIdentifier("4_abc") == "abc_4");
	assert(makeValidCIdentifier("4g_abc") == "abc_4g");
	assert(makeValidCIdentifier("4g") == "_4g");
	assert(makeValidCIdentifier("") == "");
}