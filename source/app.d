import std.stdio : writeln;
import defs;

void main() {
	OGLFunctionFamily[] functionFamilies;

	// load up documentation first for the core profiles

	functionFamilies.core_4_5_families;
	//functionFamilies.core_3_families;
	//functionFamilies.core_2_families;

	// now that we have documentation for the core profiles
	//  lets try and load up all functions
	//  and set the extension that introduces them via a "uda"

	// print
	import printers;
	//functionFamilies.print_everything;
	//functionFamilies.print_only_with_errors;
	functionFamilies.print_misc_info;

	import codegen_d;
	functionFamilies.gencode_d("out.d", "opengl.bindings", false, "GL");
}

void addAnyNewFunction_Family(ref OGLFunctionFamily[] ctx, OGLFunctionFamily[] toAdd) {
	// the problem here is that newer definitions of function should always take precendence over the older ones
	//  newer functions will always result in this being called first

	if (ctx.length == 0) {
		ctx = toAdd;
	} else {
		size_t unusedEntries = toAdd.length;
		ctx.length += unusedEntries;

	F1: foreach(toAddFamily; toAdd) {
			// does this family already exist in ctx?
			// if not that means we can add safely to it

			bool alreadyExists;
		F2: foreach(ctxFamily; ctx) {
				if (ctxFamily.familyOfFunction == toAddFamily.familyOfFunction) {
					alreadyExists = true;
					break F2;
				}
			}

			if (alreadyExists) {
				// ok so as it turns out this family is already in 
				//  which is kinda a bummer, lets be honest.
				// it means we need to figure out which functions are not already
				//  stored and add only the ones not stored


			} else {
				// this family of functions doesn't exist currently, yay?
				//  so lets add it as is
				ctx[$-unusedEntries] = toAddFamily;
				unusedEntries--;
			}
		}

		ctx.length -= unusedEntries;
	}
}

void core_4_5_families(ref OGLFunctionFamily[] functionFamilies) {
	import core_4_5;

	functionFamilies.addAnyNewFunction_Family(readInFunctionFamilies);
}

void core_3_families(ref OGLFunctionFamily[] functionFamilies) {
	import core_3;
	
	functionFamilies.addAnyNewFunction_Family(readInFunctionFamilies);
}

void core_2_families(ref OGLFunctionFamily[] functionFamilies) {
	import core_2;
	
	functionFamilies.addAnyNewFunction_Family(readInFunctionFamilies);
}