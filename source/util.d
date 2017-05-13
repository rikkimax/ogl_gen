module util;

const(char)[] removeUnicodeBOM(const(char)[] input) {
	if (input.length >= 3 && input[0 .. 3] == x"ef bb bf") {
		return input[3 .. $];
	} else {
		return input;
	}
}