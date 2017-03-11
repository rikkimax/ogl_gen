module defs;

struct OGLFunctionFamily {
	string fromFilename;
	string familyOfFunction;
	
	string copyright;
	
	OGLFunction[] functions;
	OGLIntroducedIn introducedIn;

	OGLParameter[] docs_parameters;
	OGLDocumentation docs_description = OGLDocumentation(OGLDocumentationType.Container);
	OGLDocumentation docs_notes = OGLDocumentation(OGLDocumentationType.Container);
	OGLDocumentation docs_seealso = OGLDocumentation(OGLDocumentationType.Container);
	OGLDocumentation docs_copyright = OGLDocumentation(OGLDocumentationType.Container);
	OGLDocumentation docs_errors = OGLDocumentation(OGLDocumentationType.Container);
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

enum OGLIntroducedIn : ushort {
	Unknown,
	V2P0 = 20,
	V2P1 = 21,
	V2P2 = 22,
	V3P0 = 30,
	V3P1 = 31,
	V3P2 = 32,
	V3P3 = 33,
	V4P0 = 40,
	V4P1 = 41,
	V4P2 = 42,
	V4P3 = 43,
	V4P4 = 44,
	V4P5 = 45,
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
	List,
	ListItem,
	
	StyleContainer,
	StyleCode,
	StyleSuperScript,
	StyleSubScript,
		
	Footnote,
	InlineEquation,
	Trademark,
	Copyright,
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
	MathML_mspace,
	MathML_mtext,
	MathML_apply,
	MathML_floor,
	MathML_csymbol,
	MathML_infinity,
	MathML_mover,
	MathML_munderover,
	MathML_msqrt
}

struct OGLDocumentation {
	OGLDocumentationType type;

	string value_string, value_string2;
	OGLDocumentation[] value_children;
	int value_numcols;
}