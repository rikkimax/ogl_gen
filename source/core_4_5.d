module core_4_5;
import std.experimental.xml.dom : Node;
import defs;

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

	auto apiEntryPoints = dom.firstChild.childNodes[1].childNodes[1].firstChild.childNodes[2];
	auto level2 = apiEntryPoints.childNodes[1];
	
	foreach(level3parent; level2.childNodes) {
		if (level3parent.nodeName != "li")
			continue;
		auto level3 = level3parent.childNodes[1];
		ret.length += level3.childNodes.length;
		
		size_t i = level3.childNodes.length;
	F2: foreach(functag; level3.childNodes) {
			auto atag = functag.childNodes[0];
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

			default:
				break;
		}
	}

	//
	
	return ret;
}

string fixTypePointer(string input) {
	import std.string : strip;
	if (input is null)
		return null;
		
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
	if (ret == "const GLvoid*  const*")
		return "const(const(GLvoid*)*)";
	else if (ret == "GLuitn" || ret == "Gluint")
		return "GLuint";
	else if (ret == "Glenum*")
		return "GLenum*";
	else if (ret == "const Glenum*")
		return "const GLenum*";
	else if (ret == "DEBUGPROC")
		return "GLDEBUGPROC";
	else
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
		
		case "table":
		case "informaltable":
			next = OGLDocumentation(OGLDocumentationType.Container);
			goto case "$$container$$";

		case "trademark":
			if (current.attributes.getNamedItem("class").nodeValue == "copyright")
				next = OGLDocumentation(OGLDocumentationType.Copyright);
			else
				next = OGLDocumentation(OGLDocumentationType.Trademark);
			goto case "$$container$$";
		case "link":
			next = OGLDocumentation(OGLDocumentationType.Link);
			next.value_string = current.attributes.getNamedItem("xlink:href").nodeValue;
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
			next.value_string = current.attributes.getNamedItem("columnalign").nodeValue;
			goto case "$$container$$";
		case "mtr":
			next = OGLDocumentation(OGLDocumentationType.MathML_mtr);
			goto case "$$container$$";
		case "mtd":
			next = OGLDocumentation(OGLDocumentationType.MathML_mtd);
			next.value_string = current.attributes.getNamedItem("columnalign").nodeValue;
			goto case "$$container$$";

		case "math":
			next = OGLDocumentation(OGLDocumentationType.MathMLContainer);
			goto case "$$container$$";
			
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

		default:
			parentContainer.evaluateDocs(current);
			break;
	}
}