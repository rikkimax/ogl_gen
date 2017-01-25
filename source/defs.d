module defs;

struct OGLFunctionFamily {
	string fromFilename;
	string familyOfFunction;
	
	string copyright;
	
	OGLFunction[] functions;

	OGLParameter[] docs_parameters;
	OGLDocumentation docs_description = OGLDocumentation(OGLDocumentationType.Container);
	OGLDocumentation docs_notes = OGLDocumentation(OGLDocumentationType.Container);
	OGLDocumentation docs_seealso = OGLDocumentation(OGLDocumentationType.Container);
	OGLDocumentation docs_copyright = OGLDocumentation(OGLDocumentationType.Container);
}

struct OGLFunction {
	string returnType;
	string name;
	
	string[] argTypes;
	string[] argNames;
}

struct OGLParameter {
	string[] appliesToNames;
	OGLDocumentation documentation = OGLDocumentation(OGLDocumentationType.Container);
}

enum OGLDocumentationType {
	Unknown,
	Paragraph,
	Text,
	Title,
	Container,
	
	LookupParameter,
	LookupConstant,
	LookupFunction,
	
	TableContainer,
	TableHeader,
	TableBody,
	TableRow,
	TableEntry,

    IndexList,
	IndexItem,
	
	StyleContainer,
	StyleCode,
	StyleSuperScript,
		
	Footnote,
	InlineEquation,
	Trademark,
	Link,

	MathMLContainer,
	MathML_MI,
	MathML_mfenced,
	MathML_mn,
	MathML_mrow,
	MathML_msup,
	MathML_mo,
	MathML_msub,
	MathML_mfrac,
	MathML_mtable,
	MathML_mtr,
	MathML_mtd,
	MathML_mspace
}

struct OGLDocumentation {
	OGLDocumentationType type;

	string value_string, value_string2;
	OGLDocumentation[] value_children;
	int value_numcols;
}