alias int64_t = long;
alias uint64_t = ulong;
alias int32_t = int;

///
alias GLboolean = bool;
///
alias GLbyte = byte;
///
alias GLubyte = ubyte;
///
alias GLshort = short;
///
alias GLushort = ushort;
///
alias GLhalf = ushort;
///
alias GLint = int;
///
alias GLuint = uint;
///
alias GLfixed = int;
///
alias GLint64 = long;
///
alias GLuint64 = ulong;
///
alias GLsizei = int;
///
alias GLenum = uint;
///
alias GLintptr = ptrdiff_t;
///
alias GLsizeiptr = ptrdiff_t;
///
alias GLsync = void*;
///
alias GLbitfield = uint;
///
alias GLfloat = float;
///
alias GLclampf = float;
///
alias GLdouble = double;
///
alias GLclampd = double;
///
alias GLclampx = int;
///
alias GLchar = char;
///
alias GLuintptr = size_t;
///
alias GLvoid = void;
///
alias GLeglImageOES = void*;
///
alias GLcharARB = char;
///
alias GLhandleARB = uint;
///
alias GLhalfARB = ushort;
///
alias Glfixed = GLint;

///
struct _cl_context;
///
struct _cl_event;

///
alias GLDEBUGPROC = extern(C) void function(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const(GLchar)* message, void* userParam);
///
alias GLDEBUGPROCARB = extern(C) void function(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const(GLchar)* message, void* userParam);
///
alias GLDEBUGPROCKHR = extern(C) void function(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const(GLchar)* message, void* userParam);

///
alias GLintptrARB = ptrdiff_t;
///
alias GLsizeiptrARB = ptrdiff_t;
///
alias GLint64EXT = int64_t;
///
alias GLuint64EXT = uint64_t;

///
alias GLDEBUGPROCAMD = extern(C) void function(GLuint id, GLenum category, GLenum severity, GLsizei length, const(GLchar)* message, void* userParam);
///
alias GLhalfNV = ushort;
///
alias GLvdpauSurfaceNV = GLintptr;

///
struct GLUnurbs;
///
struct GLUquadric;
///
struct GLUtesselator;
///
alias _GLUfuncptr = extern(C) void function();

struct OpenGL_Version {
	OGLIntroducedIn from;
	alias from this;
}

struct OpenGL_Extension {
	string name;
	alias name this;
}

enum OGLIntroducedIn : ushort {
	Unknown,
	V1P0 = 10,
	V1P1 = 11,
	V1P2 = 12,
	V1P3 = 13,
	V1P4 = 14,
	V1P5 = 15,
	V2P0 = 25,
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

struct Bitmaskable {}