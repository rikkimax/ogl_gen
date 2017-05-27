import std.stdio : writeln;
import defs;

string _gen_D_filename, _gen_D_module, _gen_D_wrapperName;
bool _gen_D_static;

bool _get_core_4_5, _get_core_3, _get_core_2, _get_spec;
bool _debug_everything, _debug_errors;

void main(string[] args) {
	import std.getopt;

	auto helpInformation = getopt(
		args,

		"gen-d", &_gen_D_filename,
		"gen-d-module", &_gen_D_module,
		"gen-d-wrapperName", &_gen_D_wrapperName,
		"gen-d-static", &_gen_D_static,

		"load-core-4.5", &_get_core_4_5,
		"load-core-3", &_get_core_3,
		"load-core-2", &_get_core_2,
		"load-spec", &_get_spec,

		"debug-everything", &_debug_everything,
		"debug-errors", &_debug_errors
	);

	if (helpInformation.helpWanted || (_gen_D_module.length == 0)) {
		defaultGetoptPrinter("", helpInformation.options);
	} else {
		run();
	}
}

void run() {
	import printers;
	import codegen_d;

	OGLFunctionFamily[] functionFamilies;
	OGLEnumGroup[] enums;
	
	// load up documentation first for the core profiles

	if (_get_core_4_5)
		functionFamilies.core_4_5_families;
	if (_get_core_3)
		functionFamilies.core_3_families;
	if (_get_core_2)
		functionFamilies.core_2_families;
	if (_get_spec)
		functionFamilies.spec_families(enums);
	
	// now that we have documentation for the core profiles
	//  lets try and load up all functions
	//  and set the extension that introduces them via a "uda"

	// print
	if (_debug_everything)
		functionFamilies.print_everything;
	if (_debug_errors)
		functionFamilies.print_only_with_errors;
	functionFamilies.print_misc_info(enums);

	if (_gen_D_filename.length > 0)
		functionFamilies.gencode_d(enums, _gen_D_filename, _gen_D_module, _gen_D_static, _gen_D_wrapperName);
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

			OGLFunction[] functions;
			functions.length = toAddFamily.functions.length;
			size_t i;
		F3: foreach(ref toAddFunc; toAddFamily.functions) {
				foreach(ref gf; ctx) {
					foreach(fff; gf.functions) {
						if (fff.name == toAddFunc.name) {
							functions.length--;
							continue F3;
						}
					}
				}
				functions[i] = toAddFunc;
				i++;
			}
			toAddFamily.functions = functions;

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

void spec_families(ref OGLFunctionFamily[] functionFamilies, ref OGLEnumGroup[] enums) {
	import spec;
	
	readInFunctionFamilies(enums, functionFamilies);
}