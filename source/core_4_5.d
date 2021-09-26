module core_4_5;
import std.experimental.xml.dom : Node;
import defs;
import util;

enum IndexFile = "man4/html/index.php";
enum PrependXMLFileLocation = "man4/";

OGLFunctionFamily[] readInFunctionFamilies() {
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

	auto apiEntryPoints = dom.firstChild.childNodes.item(1).childNodes.item(1).firstChild.childNodes.item(2);
	auto level2 = apiEntryPoints.childNodes.item(1);

	foreach(level3parent; level2.childNodes) {
		if (level3parent.nodeName != "li")
			continue;
		auto level3 = level3parent.childNodes.item(1);
		ret.length += level3.childNodes.length;

		size_t i = level3.childNodes.length;
	F2: foreach(functag; level3.childNodes) {
			auto atag = functag.childNodes.item(0);
			char[] filename = cast(char[])atag.attributes.getNamedItem("href").nodeValue;
			string value = atag.firstChild.nodeValue;

			switch(filename) {
				case "removedTypes.xhtml":
					ret.length--;
					i--;
					continue F2;
				default:
					filename[$-4] = 'm';
					filename[$-3] = 'l';
					filename = filename[0 .. $-2];
					break;
			}

			filename = PrependXMLFileLocation ~ filename;

			foreach(family; ret) {
				if (family.fromFilename == filename) {
					ret.length--;
					i--;
					continue F2;
				}
			}

			ret[$-i] = OGLFunctionFamily(cast(string)filename, value);
			i--;
		}
	}

	foreach(ref family; ret) {
		family.functions = family.readInFunctions;
	}

	return ret;
}

OGLFunction[] readInFunctions(ref OGLFunctionFamily family) {
	import std.file : readText;
	import std.conv : to;
	import std.experimental.xml;

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

	auto funcprototypes = dom.getElementsByTagName("funcsynopsis")[0].childNodes;
	ret.length = funcprototypes.length;

	size_t i;
	foreach(funcprototype; funcprototypes) {
		switch(funcprototype.nodeName) {
			case "funcprototype":
				break;
			default:
				ret.length--;
				continue;
		}

		ret[i].returnType = funcprototype.firstChild.firstChild.nodeValue.fixTypePointer;
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

	//

	auto refsect1 = dom.getElementsByTagName("refsect1");
	foreach(node; refsect1) {
		if (node.attributes.getNamedItem("xml:id") is null)
			continue;

		switch(node.attributes.getNamedItem("xml:id").nodeValue) {
			case "parameters":
				auto varlistentries = node.childNodes[1].childNodes;
				family.docs_parameters.length = varlistentries.length;

				i = 0;
				foreach(varlistentry; varlistentries) {
					auto parameters = varlistentry.firstChild.childNodes;
					auto paras = varlistentry.lastChild.childNodes;

					family.docs_parameters[i].appliesToNames.length = parameters.length;

					size_t j;
					foreach(param; parameters) {
						if (param.nodeName == "#text") {
							family.docs_parameters[i].appliesToNames.length--;
							continue;
						}
						family.docs_parameters[i].appliesToNames[j] = param.firstChild.nodeValue;
						j++;
					}

					foreach (para; paras)
						family.docs_parameters[i].documentation.evaluateDocs(para);

					i++;
				}
				break;

			case "description":
				i = 0;
				foreach(child; node.childNodes) {
					i++;
					if (i == 1)
						continue;
					family.docs_description.evaluateDocs(child);
				}
				break;

			case "notes":
				i = 0;
				foreach(child; node.childNodes) {
					i++;
					if (i == 1)
						continue;
					family.docs_notes.evaluateDocs(child);
				}
				break;

			case "seealso":
				i = 0;
				foreach(child; node.childNodes) {
					i++;
					if (i == 1)
						continue;
					family.docs_seealso.evaluateDocs(child);
				}
				break;

			case "Copyright":
			case "copyright":
				i = 0;
				foreach(child; node.childNodes) {
					i++;
					if (i == 1)
						continue;
					family.docs_copyright.evaluateDocs(child);
				}
				break;

			case "versions":
				// refsect1.informaltable.tgroup.tbody.trow.xi:include
				auto xiinclude = node.childNodes[1].childNodes[0].childNodes[1].childNodes[0].childNodes[1];
				string value = xiinclude.attributes.getNamedItem("xpointer").nodeValue;

				// xpointer(/*/*[@role='20']/*)
				family.introducedIn = cast(OGLIntroducedIn)(value["xpointer(/*/*[@role='".length .. $][0 .. 2].to!ushort);

				break;

			case "errors":
				i = 0;
				foreach(child; node.childNodes) {
					i++;
					if (i == 1)
						continue;
					family.docs_errors.evaluateDocs(child);
				}
				break;

			default:
				break;
		}
	}

	//

	return ret;
}

void evaluateDocs(ref OGLDocumentation parentContainer, Node!string current) {
	OGLDocumentation next;

	switch(current.nodeName) {
		case "para":
			next = OGLDocumentation(OGLDocumentationType.Paragraph);
			goto case "$$container$$";
		case "title":
			next = OGLDocumentation(OGLDocumentationType.Title);
			goto case "$$container$$";

		case "constant":
			next = OGLDocumentation(OGLDocumentationType.LookupConstant);
			goto case "$$container$$";
		case "parameter":
			next = OGLDocumentation(OGLDocumentationType.LookupParameter);
			goto case "$$container$$";
		case "refentrytitle":
		case "function":
			next = OGLDocumentation(OGLDocumentationType.LookupFunction);
			goto case "$$container$$";

		case "tgroup":
			import std.conv : to;
			next = OGLDocumentation(OGLDocumentationType.TableContainer);
			next.value_numcols = current.attributes.getNamedItem("cols").nodeValue.to!int;
			goto case "$$container$$";
		case "thead":
			next = OGLDocumentation(OGLDocumentationType.TableHeader);
			goto case "$$container$$";
		case "tbody":
			next = OGLDocumentation(OGLDocumentationType.TableBody);
			goto case "$$container$$";
		case "row":
			next = OGLDocumentation(OGLDocumentationType.TableRow);
			goto case "$$container$$";
		case "entry":
			next = OGLDocumentation(OGLDocumentationType.TableEntry);
			goto case "$$container$$";

		case "superscript":
			next = OGLDocumentation(OGLDocumentationType.StyleSuperScript);
			goto case "$$container$$";
		case "subscript":
			next = OGLDocumentation(OGLDocumentationType.StyleSubScript);
			goto case "$$container$$";

		case "term":
		case "table":
		case "informaltable":
			next = OGLDocumentation(OGLDocumentationType.Container);
			goto case "$$container$$";

		case "itemizedlist":
			next = OGLDocumentation(OGLDocumentationType.IndexList);
			goto case "$$container$$";
		case "listitem":
			next = OGLDocumentation(OGLDocumentationType.IndexItem);
			goto case "$$container$$";

		case "variablelist":
			next = OGLDocumentation(OGLDocumentationType.List);
			goto case "$$container$$";
		case "varlistentry":
			next = OGLDocumentation(OGLDocumentationType.ListItem);
			goto case "$$container$$";

		case "trademark":
			if (current.attributes is null)
				break;
			if (current.attributes.getNamedItem("class").nodeValue == "copyright")
				next = OGLDocumentation(OGLDocumentationType.Copyright);
			else
				next = OGLDocumentation(OGLDocumentationType.Trademark);
			goto case "$$container$$";
		case "link":
			next = OGLDocumentation(OGLDocumentationType.Link);
			next.value_string = current.attributes.getNamedItem("xlink:href").nodeValue;
			goto case "$$container$$";
		case "ulink":
			next = OGLDocumentation(OGLDocumentationType.Link);
			next.value_string = current.attributes.getNamedItem("url").nodeValue;
			goto case "$$container$$";

		case "citerefentry":
			next = OGLDocumentation(OGLDocumentationType.Container);
			goto case "$$container$$";
		case "footnote":
			next = OGLDocumentation(OGLDocumentationType.Footnote);
			goto case "$$container$$";

		case "emphasis":
			if (current.attributes is null)
				break;
			auto roleAttribute = current.attributes.getNamedItem("role");
			if (roleAttribute !is null) {
				next = OGLDocumentation(OGLDocumentationType.StyleContainer, roleAttribute.nodeValue);
				goto case "$$container$$";
			} else {
				break;
			}
		case "code":
		case "programlisting":
			next = OGLDocumentation(OGLDocumentationType.StyleCode);
			goto case "$$container$$";

		case "$$container$$":
			auto children = current.childNodes;
			foreach(childI; 0 .. children.length) {
				next.evaluateDocs(children.item(childI));
			}

			parentContainer.value_children ~= next;
			break;

		case "xi:include":
			string newfile = PrependXMLFileLocation ~ current.attributes.getNamedItem("href").nodeValue;

			import std.file : readText;
			import std.experimental.xml;

			string raw_input = readText(newfile);
			auto domBuilder = raw_input
				.lexer
				.parser
				.cursor((CursorError err){})
				.domBuilder;
			domBuilder.setSource(raw_input);
			domBuilder.buildRecursive;
			auto dom = domBuilder.getDocument;

			next = OGLDocumentation(OGLDocumentationType.Container);

			auto root = dom.lastChild;
			if (root.nodeName == "informaltable" || root.nodeName == "table") {
				auto children = root.childNodes;

				foreach(childI; 0 .. children.length) {
					next.evaluateDocs(children.item(childI));
				}

				parentContainer.value_children ~= next;
			} else {
				parentContainer.value_children ~= OGLDocumentation(OGLDocumentationType.Unknown, current.nodeName);
			}

			break;

		case "inlineequation":
			next = OGLDocumentation(OGLDocumentationType.InlineEquation);
			auto children = current.childNodes;
			foreach(childI; 0 .. children.length) {
				next.evaluateDocs(children.item(childI));
			}

			parentContainer.value_children ~= next;
			break;
		case "mml:apply":
		case "informalequation":
		case "mml:math":
			parentContainer.evaluateDocs_MathML(current);
			break;


		case "#text":
			parentContainer.value_children ~= OGLDocumentation(OGLDocumentationType.Text, current.nodeValue);
			break;

		case "#comment":
		case "colspec":
			break;

		default:
			parentContainer.value_children ~= OGLDocumentation(OGLDocumentationType.Unknown, current.nodeName);
			break;
	}
}

void evaluateDocs_MathML(ref OGLDocumentation parentContainer, Node!string current) {
	OGLDocumentation next;

	string nodeName = current.nodeName;
	if (nodeName.length > 3 && nodeName[0 .. 4] == "mml:")
		nodeName = nodeName[4 .. $];

	switch(nodeName) {
		case "mi":
			next = OGLDocumentation(OGLDocumentationType.MathML_MI);
			if (current.attributes !is null && current.attributes.getNamedItem("mathvariant") !is null)
				next.value_string = current.attributes.getNamedItem("mathvariant").nodeValue;
			goto case "$$container$$";
		case "mfenced":
			next = OGLDocumentation(OGLDocumentationType.MathML_mfenced);
			if (current.attributes.getNamedItem("open") !is null)
				next.value_string = current.attributes.getNamedItem("open").nodeValue;
			if (current.attributes.getNamedItem("close") !is null)
				next.value_string2 = current.attributes.getNamedItem("close").nodeValue;
			goto case "$$container$$";
		case "mn":
			next = OGLDocumentation(OGLDocumentationType.MathML_mn);
			goto case "$$container$$";
		case "mrow":
			next = OGLDocumentation(OGLDocumentationType.MathML_mrow);
			goto case "$$container$$";
		case "msup":
			next = OGLDocumentation(OGLDocumentationType.MathML_msup);
			goto case "$$container$$";
		case "mo":
			next = OGLDocumentation(OGLDocumentationType.MathML_mo);
			goto case "$$container$$";
		case "msub":
			next = OGLDocumentation(OGLDocumentationType.MathML_msub);
			goto case "$$container$$";
		case "mfrac":
			next = OGLDocumentation(OGLDocumentationType.MathML_mfrac);
			goto case "$$container$$";
		case "mtable":
			next = OGLDocumentation(OGLDocumentationType.MathML_mtable);
			if (current.attributes !is null && current.attributes.length > 0 && current.attributes.getNamedItem("columnalign") !is null)
				next.value_string = current.attributes.getNamedItem("columnalign").nodeValue;
			goto case "$$container$$";
		case "mtr":
			next = OGLDocumentation(OGLDocumentationType.MathML_mtr);
			goto case "$$container$$";
		case "mtd":
			next = OGLDocumentation(OGLDocumentationType.MathML_mtd);
			if (current.attributes !is null && current.attributes.length > 0 && current.attributes.getNamedItem("columnalign") !is null)
				next.value_string = current.attributes.getNamedItem("columnalign").nodeValue;
			goto case "$$container$$";
		case "mtext":
			next = OGLDocumentation(OGLDocumentationType.MathML_mtext);
			if (current.attributes !is null && current.attributes.length > 0 && current.attributes.getNamedItem("mathvariant") !is null)
				next.value_string = current.attributes.getNamedItem("mathvariant").nodeValue;
			goto case "$$container$$";
		case "apply":
			next = OGLDocumentation(OGLDocumentationType.MathML_apply);
			goto case "$$container$$";
		case "mover":
			next = OGLDocumentation(OGLDocumentationType.MathML_mover);
			goto case "$$container$$";
		case "munderover":
			next = OGLDocumentation(OGLDocumentationType.MathML_munderover);
			goto case "$$container$$";
		case "msqrt":
			next = OGLDocumentation(OGLDocumentationType.MathML_msqrt);
			goto case "$$container$$";

		case "csymbol":
			next = OGLDocumentation(OGLDocumentationType.MathML_csymbol);
			goto case "$$container$$";

		case "math":
			next = OGLDocumentation(OGLDocumentationType.MathMLContainer);
			goto case "$$container$$";

		case "informalequation":
			auto children = current.childNodes;
			foreach(childI; 0 .. children.length) {
				parentContainer.evaluateDocs_MathML(children.item(childI));
			}
			break;

		case "$$container$$":
			auto children = current.childNodes;
			foreach(childI; 0 .. children.length) {
				next.evaluateDocs_MathML(children.item(childI));
			}

			parentContainer.value_children ~= next;
			break;

		case "mspace":
			next = OGLDocumentation(OGLDocumentationType.MathML_mspace);
			next.value_string = current.attributes.getNamedItem("width").nodeValue;
			parentContainer.value_children ~= next;
			break;

		case "floor":
			next = OGLDocumentation(OGLDocumentationType.MathML_floor);
			parentContainer.value_children ~= next;
			break;
		case "infinity":
			next = OGLDocumentation(OGLDocumentationType.MathML_infinity);
			parentContainer.value_children ~= next;
			break;

		default:
			parentContainer.evaluateDocs(current);
			break;
	}
}