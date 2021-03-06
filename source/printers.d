module printers;
import defs;

string toString(ref OGLDocumentation ctx, string linetabs="") {
	import std.string : splitLines, strip;
	with(ctx) {
		string sublinetabs = linetabs ~ "|    ";
		string suffix;

		switch(type) {
			case OGLDocumentationType.LookupParameter:
				suffix = "^parameter";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.LookupConstant:
				suffix = "^constant";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.LookupFunction:
				suffix = "^function";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.Title:
				suffix = "title";
				goto case OGLDocumentationType.Container;
				
			case OGLDocumentationType.TableContainer:
				import std.conv : text;
				suffix = "table>[cols=" ~ value_numcols.text ~ "]";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.TableHeader:
				suffix = "head";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.TableBody:
				suffix = "body";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.TableRow:
				suffix = "row";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.TableEntry:
				suffix = "entry";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.Trademark:
				suffix = "™";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.Copyright:
				suffix = "©";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.StyleContainer:
				suffix = "style>" ~ value_string;
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.StyleCode:
				suffix = "code";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.Footnote:
				suffix = "\\/footnote";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.InlineEquation:
				suffix = "|<equation";
				goto case OGLDocumentationType.Container;
			
			case OGLDocumentationType.MathMLContainer:
				suffix = "MathML[_]";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_MI:
				suffix = "MathML:mi";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mn:
				suffix = "MathML:mn";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mrow:
				suffix = "MathML:mrow";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_msup:
				suffix = "MathML:msup";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mo:
				suffix = "MathML:mo";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_msub:
				suffix = "MathML:msub";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mfrac:
				suffix = "MathML:mfrac";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mtable:
				suffix = "MathML:mtable[" ~ value_string ~ "]";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mtr:
				suffix = "MathML:mtr";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mtd:
				suffix = "MathML:mtd[" ~ value_string ~ "]";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mspace:
				suffix = "MathML:mspace[ " ~ value_string ~ " ]";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mtext:
				suffix = "MathML:mtext[ " ~ value_string ~ " ]";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_apply:
				suffix = "MathML:apply";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_csymbol:
				suffix = "MathML:csymbol";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_infinity:
				suffix = "MathML:infinity ∞";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_mover:
				suffix = "MathML:mover";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_munderover:
				suffix = "MathML:munderover";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.MathML_msqrt:
				suffix = "MathML:msqrt";
				goto case OGLDocumentationType.Container;

			case OGLDocumentationType.IndexList:
				suffix = "X. []";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.IndexItem:
				suffix = "X. Y";
				goto case OGLDocumentationType.Container;

			case OGLDocumentationType.List:
				suffix = "- []";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.ListItem:
				suffix = "- X";
				goto case OGLDocumentationType.Container;

			case OGLDocumentationType.Link:
				suffix = "link <-> " ~ value_string;
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.StyleSuperScript:
				suffix = "^^superscript";
				goto case OGLDocumentationType.Container;
			case OGLDocumentationType.StyleSubScript:
				suffix = "	⌄	⌄subscript";
				goto case OGLDocumentationType.Container;
				
			case OGLDocumentationType.Paragraph:
			case OGLDocumentationType.Container:
				string ret;
				ret = linetabs ~ "|----" ~ suffix ~ "\n";
				foreach(i, child; value_children)
					ret ~= child.toString(sublinetabs);
				return ret;

			case OGLDocumentationType.Text:
				if (suffix is null)
					suffix = "#text";
				string ret = linetabs ~ "|----" ~ suffix;
				foreach(line; value_string.splitLines) {
					string linestripped = line.strip;
					if (linestripped.length > 0)
						ret ~= "\n" ~ sublinetabs ~ linestripped;
				}
				return ret ~ "\n";
				
			case OGLDocumentationType.MathML_mfenced:
				string ret;
				ret = linetabs ~ "|----MathML:mfenced |--| \n";
				ret ~= sublinetabs ~ "open={ " ~ value_string ~ " } close={ " ~ value_string2 ~ " }\n";
				foreach(i, child; value_children)
					ret ~= child.toString(sublinetabs);
				return ret;
				
			case OGLDocumentationType.MathML_floor:
				return "|__floor__\n";
				
			case OGLDocumentationType.Unknown:
			default:
				suffix = "#ERROR";
				goto case OGLDocumentationType.Text;

		}
	}
}

bool haveAnErrorNode(ref OGLFunctionFamily ctx) {
	if (ctx.docs_copyright.haveAnErrorNode)
		return true;
	else if (ctx.docs_description.haveAnErrorNode)
		return true;
	else if (ctx.docs_notes.haveAnErrorNode)
		return true;
	else if (ctx.docs_seealso.haveAnErrorNode)
		return true;

	foreach(param; ctx.docs_parameters) {
		if (param.documentation.haveAnErrorNode)
			return true;
	}
	
	return false;
}

bool haveAnErrorNode(ref OGLDocumentation ctx) {
	switch(ctx.type) {
		case OGLDocumentationType.LookupParameter:
		case OGLDocumentationType.LookupConstant:
		case OGLDocumentationType.LookupFunction:
		case OGLDocumentationType.TableContainer:
		case OGLDocumentationType.TableHeader:
		case OGLDocumentationType.TableBody:
		case OGLDocumentationType.TableRow:
		case OGLDocumentationType.TableEntry:
		case OGLDocumentationType.StyleContainer:
		case OGLDocumentationType.StyleCode:
		case OGLDocumentationType.StyleSuperScript:
		case OGLDocumentationType.StyleSubScript:
		case OGLDocumentationType.Paragraph:
		case OGLDocumentationType.Footnote:
		case OGLDocumentationType.Container:
		case OGLDocumentationType.InlineEquation:
		case OGLDocumentationType.MathMLContainer:
		case OGLDocumentationType.MathML_MI:
		case OGLDocumentationType.MathML_mfenced:
		case OGLDocumentationType.MathML_mn:
		case OGLDocumentationType.MathML_mrow:
		case OGLDocumentationType.MathML_msup:
		case OGLDocumentationType.MathML_mo:
		case OGLDocumentationType.MathML_msub:
		case OGLDocumentationType.MathML_mfrac:
		case OGLDocumentationType.MathML_mtable:
		case OGLDocumentationType.MathML_mtr:
		case OGLDocumentationType.MathML_mtd:
		case OGLDocumentationType.MathML_mspace:
		case OGLDocumentationType.MathML_mtext:
		case OGLDocumentationType.MathML_apply:
		case OGLDocumentationType.MathML_floor:
		case OGLDocumentationType.MathML_csymbol:
		case OGLDocumentationType.MathML_infinity:
		case OGLDocumentationType.MathML_mover:
		case OGLDocumentationType.MathML_munderover:
		case OGLDocumentationType.MathML_msqrt:
		case OGLDocumentationType.Trademark:
		case OGLDocumentationType.IndexList:
		case OGLDocumentationType.IndexItem:
		case OGLDocumentationType.List:
		case OGLDocumentationType.ListItem:
		case OGLDocumentationType.Copyright:
		case OGLDocumentationType.Link:
			foreach(ref child; ctx.value_children) {
				if (child.haveAnErrorNode)
					return true;
			}
			return false;
		case OGLDocumentationType.Unknown:
			return true;
		default:
			return false;
	}
}

void print_misc_info(OGLFunctionFamily[] familyOfFunctions, OGLEnumGroup[] enums) {
	import std.stdio : writeln;
	
	writeln("Information:");
	
	uint numFunctions, numGroupedEnums, numGroupEnum, numEnums;
	foreach(family; familyOfFunctions)
		numFunctions += family.functions.length;
	foreach(grp; enums) {
		if (grp.name.length > 0) {
			numGroupedEnums++;
			numGroupEnum += grp.enums.length;
		}

		numEnums += grp.enums.length;
	}

	writeln("\tThere is a total of ", familyOfFunctions.length, " function families loaded.");
	writeln("\tOf these there are a total of ", numFunctions, " functions these families provide.");
	writeln("\tThere is a total of ", numGroupedEnums, " enums groups loaded.");
	writeln("\tOf these there are a total of ", numGroupEnum, " enums in these groups.");
	writeln("\tIn total there are ", numEnums, " number of enums in total.");

	writeln;
}

void print_everything(OGLFunctionFamily[] functionFamilies, string forName=null) {
	import std.stdio : write, writeln;
	
	writeln("Families:");
	foreach(family; functionFamilies) {
		if (forName !is null && family.familyOfFunction != forName) continue;

		writeln("- ", family.fromFilename, "[", family.familyOfFunction, "]");
		
		writeln("\tCopyright: ", family.copyright);
		writeln(family.docs_copyright.toString("\t"));

		writeln("\tDescription:");
		writeln(family.docs_description.toString("\t"));
		writeln("\tSee_Also:");
		writeln(family.docs_seealso.toString("\t"));

		writeln("\tParamater documentation:");
		foreach(param; family.docs_parameters) {
			write("\t- ");
			foreach(i, appliesToName; param.appliesToNames) {
				if (i > 0)
					write(", ");
				write(appliesToName);
			}
			writeln;

			write(param.documentation.toString("\t"));
		}
		writeln;

		writeln("\tFunction varients:");
		foreach(func; family.functions) {
			write("\t- ", func.returnType, " ", func.name, "(");

			foreach(i, argType; func.argTypes) {
				if (i > 0)
					write(", ");
				write(argType, " ", func.argNames[i]);
			}

			writeln(")");
		}
		writeln;

		writeln("\tNotes:");
		write(family.docs_notes.toString("\t"));
		writeln;

		writeln("\tErrors:");
		write(family.docs_errors.toString("\t"));
	}
	
	writeln;
}

void print_only_with_errors(OGLFunctionFamily[] functionFamilies) {
	import std.stdio : write, writeln;

	writeln("Errors, Families:");
	foreach(family; functionFamilies) {
		if (!family.haveAnErrorNode) continue;
		
		writeln("- ", family.fromFilename, "[", family.familyOfFunction, "]");
		
		writeln("\tCopyright: ", family.copyright);
		writeln(family.docs_copyright.toString("\t"));

		writeln("\tDescription:");
		writeln(family.docs_description.toString("\t"));
		writeln("\tSee_Also:");
		writeln(family.docs_seealso.toString("\t"));

		writeln("\tParamater documentation:");
		foreach(param; family.docs_parameters) {
			write("\t- ");
			foreach(i, appliesToName; param.appliesToNames) {
				if (i > 0)
					write(", ");
				write(appliesToName);
			}
			writeln;

			write(param.documentation.toString("\t"));
		}
		writeln;

		writeln("\tFunction varients:");
		foreach(func; family.functions) {
			write("\t- ", func.returnType, " ", func.name, "(");

			foreach(i, argType; func.argTypes) {
				if (i > 0)
					write(", ");
				write(argType, " ", func.argNames[i]);
			}

			writeln(")");
		}
		writeln;

		writeln("\tNotes:");
		write(family.docs_notes.toString("\t"));
		writeln;
		
		writeln("\tErrors:");
		write(family.docs_errors.toString("\t"));
	}
}