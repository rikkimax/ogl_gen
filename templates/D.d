import std.traits : Unqual;

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
alias GLsizei = uint;
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
alias GLint64 = int64_t;
///
alias GLuint64 = uint64_t;

///
struct _cl_context;
///
struct _cl_event;

///
alias GLDEBUGPROC = void function(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar* message, const void* userParam);
///
alias GLDEBUGPROCARB = void function(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar* message, const void* userParam);
///
alias GLDEBUGPROCKHR = void function(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar* message, const void* userParam);

///
alias GLint64EXT = int64_t;
///
alias GLuint64EXT = uint64_t;

///
alias GLDEBUGPROCAMD = void function(GLuint id, GLenum category, GLenum severity, GLsizei length, const GLchar* message, const void* userParam);
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
alias _GLUfuncptr = void function();

struct OpenGL_Version {
	OGLIntroducedIn from;
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

struct Bitmaskable {}

/**
 * Implement IEEE 754 half-precision binary floating point format binary16.
 *
 * This a 16 bit type, and consists of a sign bit, a 5 bit exponent, and a
 * 10 bit significand.
 * All operations on GLhalf are CTFE'able.
 *
 * The half precision floating point type.
 *
 * The only operations are:
 * $(UL
 * $(LI explicit conversion of float to GLhalf)
 * $(LI implicit conversion of GLhalf to float)
 * )
 * It operates in an analogous manner to shorts, which are converted to ints
 * before performing any operations, and explicitly cast back to shorts.
 * The half float is considered essentially a storage type, not a computation type.
 *
 * Example:
 * ---
    GLhalf h = hf!27.2f;
    GLhalf j = cast(GLhalf)( hf!3.5f + hf!5 );
    GLhalf f = GLhalf(0.0f);
 * ---
 * Bugs:
 *      The only rounding mode currently supported is Round To Nearest.
 *      The exceptions OVERFLOW, UNDERFLOW and INEXACT are not thrown.
 *
 * References:
 *      $(WEB en.wikipedia.org/wiki/Half-precision_floating-point_format, Wikipedia)
 * Copyright: Copyright Digital Mars 2012-2014
 * License:   $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   $(WEB digitalmars.com, Walter Bright)
 * Source:    $(SARGONSRC src/sargon/_halffloat.d)
 * Macros:
 *   WIKI=Phobos/StdHalffloat
 */
	
struct GLhalf {
	
	/* Provide implicit conversion of GLhalf to float
     */
	
	@property float toFloat() { return shortToFloat(s); }
	alias toFloat this;
	
	/* Done as a template in order to prevent implicit conversion
     * of argument to float.
     */
	
	this(T : float)(T f)
	{
		static assert(is(T == float));
		s = floatToShort(f);
	}
	
	/* These are done as properties to avoid
     * circular reference problems.
     */
	
	///
	static @property GLhalf min_normal() { GLhalf hf = void; hf.s = 0x0400; return hf; }
	unittest { assert(min_normal == hf!0x1p-14); }
	
	///
	static @property GLhalf max()        { GLhalf hf = void; hf.s = 0x7BFF; return hf; }
	unittest { assert(max == hf!0x1.FFCp+15); }
	
	///
	static @property GLhalf nan()        { GLhalf hf = void; hf.s = EXPMASK | 1; return hf; }
	unittest { assert(nan != hf!(float.nan)); }
	
	///
	static @property GLhalf infinity()   { GLhalf hf = void; hf.s = EXPMASK; return hf; }
	unittest { assert(infinity == hf!(float.infinity)); }
	
	///
	static @property GLhalf epsilon()    { GLhalf hf = void; hf.s = 0x1400; return hf; }
	unittest { assert(epsilon == hf!0x1p-10); }
	
	enum dig =        3;        ///
	enum mant_dig =   11;       ///
	enum max_10_exp = 5;        ///
	enum max_exp =    16;       ///
	enum min_10_exp = -5;       ///
	enum min_exp =    -14;      ///
	
private:
	ushort s = EXPMASK | 1;     // .init is GLhalf.nan
}

/********************
 * User defined literal for Half Float.
 * Example:
 * ---
 * auto h = hf!1.3f;
 * ---
 */

template hf(float v)
{
	enum hf = GLhalf(v);
}

private {
	// Half float values
	enum SIGNMASK  = 0x8000;
	enum EXPMASK   = 0x7C00;
	enum MANTMASK  = 0x03FF;
	enum HIDDENBIT = 0x0400;
	
	// float values
	enum FSIGNMASK  = 0x80000000;
	enum FEXPMASK   = 0x7F800000;
	enum FMANTMASK  = 0x007FFFFF;
	enum FHIDDENBIT = 0x00800000;
	
	// Rounding mode
	enum ROUND { TONEAREST, UPWARD, DOWNWARD, TOZERO };
	enum ROUNDMODE = ROUND.TONEAREST;
	
	ushort floatToShort(float f)
	{
		/* If the target CPU has a conversion instruction, this code could be
	     * replaced with inline asm or a compiler intrinsic, but leave this
	     * as the CTFE path so CTFE can work on it.
	     */
		
		/* The code currently does not set INEXACT, UNDERFLOW, or OVERFLOW,
	     * but is marked where those would go.
	     */
		
		uint s = *cast(uint*)&f;
		
		ushort u = (s & FSIGNMASK) ? SIGNMASK : 0;
		int exp = s & FEXPMASK;
		if (exp == FEXPMASK)  // if nan or infinity
		{
			if ((s & FMANTMASK) == 0)       // if infinity
			{
				u |= EXPMASK;
			}
			else                            // else nan
			{
				u |= EXPMASK | 1;
			}
			return u;
		}
		
		uint significand = s & FMANTMASK;
		
		if (exp == 0)                       // if subnormal or zero
		{
			if (significand == 0)           // if zero
				return u;
			
			/* A subnormal float is going to give us a zero result anyway,
	         * so just set UNDERFLOW and INEXACT and return +-0.
	         */
			return u;
		}
		else                                // else normal
		{
			// normalize exponent and remove bias
			exp = (exp >> 23) - 127;
			significand |= FHIDDENBIT;
		}
		
		exp += 15;                          // bias the exponent
		
		bool guard = false;                 // guard bit
		bool sticky = false;                // sticky bit
		
		uint shift = 13;                    // lop off rightmost 13 bits
		if (exp <= 0)                       // if subnormal
		{   shift += -exp + 1;              // more bits to lop off
			exp = 0;
		}
		if (shift > 23)
		{
			// Set UNDERFLOW, INEXACT, return +-0
			return u;
		}
		
		//printf("exp = x%x significand = x%x\n", exp, significand);
		
		// Lop off rightmost 13 bits, but save guard and sticky bits
		guard = (significand & (1 << (shift - 1))) != 0;
		sticky = (significand & ((1 << (shift - 1)) - 1)) != 0;
		significand >>= shift;
		
		//printf("guard = %d, sticky = %d\n", guard, sticky);
		//printf("significand = x%x\n", significand);
		
		if (guard || sticky)
		{
			// Lost some bits, so set INEXACT and round the result
			switch (ROUNDMODE)
			{
				case ROUND.TONEAREST:
					if (guard && (sticky || (significand & 1)))
						++significand;
					break;
					
				case ROUND.UPWARD:
					if (!(s & FSIGNMASK))
						++significand;
					break;
					
				case ROUND.DOWNWARD:
					if (s & FSIGNMASK)
						++significand;
					break;
					
				case ROUND.TOZERO:
					break;
					
				default:
					assert(0);
			}
			if (exp == 0)                           // if subnormal
			{
				if (significand & HIDDENBIT)        // and not a subnormal no more
					++exp;
			}
			else if (significand & (HIDDENBIT << 1))
			{
				significand >>= 1;
				++exp;
			}
		}
		
		if (exp > 30)
		{   // Set OVERFLOW and INEXACT, return +-infinity
			return u | EXPMASK;
		}
		
		/* Add exponent and significand into result.
	     */
		
		u |= exp << 10;                             // exponent
		u |= (significand & ~HIDDENBIT);            // significand
		
		return u;
	}
	
	unittest
	{
		static struct S { ushort u; float f; }
		
		static S[] tests =
		[
			{ 0x3C00,  1.0f },
			{ 0x3C01,  1.0009765625f },
			{ 0xC000, -2.0f },
			{ 0x7BFF,  65504.0f },
			{ 0x0400,  6.10352e-5f },
			{ 0x03FF,  6.09756e-5f },
			{ 0x0001,  5.9604644775e-8f },
			{ 0x0000,  0.0f },
			{ 0x8000, -0.0f },
			{ 0x7C00,  float.infinity },
			{ 0xFC00, -float.infinity },
			{ 0x3555,  0.333252f },
			{ 0x7C01,  float.nan },
			{ 0xFC01, -float.nan },
			{ 0x0000,  1.0e-8f },
			{ 0x8000, -1.0e-8f },
			{ 0x7C00,  1.0e31f },
			{ 0xFC00, -1.0e31f },
			{ 0x0000,  1.0e-37f / 10.0f },  // subnormal float
			{ 0x8000, -1.0e-37f / 10.0f },
			{ 0x6800,  0x1002p-1 }, // guard
			{ 0x6801,  0x1003p-1 }, // guard && sticky
			{ 0x6802,  0x1006p-1 }, // guard && (significand & 1)
			{ 0x6802,  0x1007p-1 }, // guard && sticky && (significand & 1)
			{ 0x0400,  0x1FFFp-27 }, // round up subnormal to normal
			{ 0x0800,  0x3FFFp-27 }, // lose bit, add one to exp
			//{ , },
		];
		
		foreach (i, s; tests)
		{
			ushort u = floatToShort(s.f);
			if (u != s.u)
			{
				printf("[%d] %g %04x expected %04x\n", i, s.f, u, s.u);
				assert(0);
			}
		}
	}
	
	float shortToFloat(ushort s)
	{
		/* If the target CPU has a conversion instruction, this code could be
	     * replaced with inline asm or a compiler intrinsic, but leave this
	     * as the CTFE path so CTFE can work on it.
	     */
		/* This one is fairly easy because there are no possible errors
	     * and no necessary rounding.
	     */
		
		int exp = s & EXPMASK;
		if (exp == EXPMASK)  // if nan or infinity
		{
			float f;
			if ((s & MANTMASK) == 0)        // if infinity
			{
				f = float.infinity;
			}
			else                            // else nan
			{
				f = float.nan;
			}
			return (s & SIGNMASK) ? -f : f;
		}
		
		uint significand = s & MANTMASK;
		
		if (exp == 0)                       // if subnormal or zero
		{
			if (significand == 0)           // if zero
				return (s & SIGNMASK) ? -0.0f : 0.0f;
			
			// Normalize by shifting until the hidden bit is 1
			while (!(significand & HIDDENBIT))
			{
				significand <<= 1;
				--exp;
			}
			significand &= ~HIDDENBIT;      // hidden bit is, well, hidden
			exp -= 14;
		}
		else                                // else normal
		{
			// normalize exponent and remove bias
			exp = (exp >> 10) - 15;
		}
		
		/* Assemble sign, exponent, and significand into float.
	     * Don't have to deal with overflow, inexact, or subnormal
	     * because the range of floats is big enough.
	     */
		
		assert(-126 <= exp && exp <= 127);  // just to be sure
		
		//printf("exp = %d, significand = x%x\n", exp, significand);
		
		uint u = (s & SIGNMASK) << 16;      // sign bit
		u |= (exp + 127) << 23;             // bias the exponent and shift into position
		u |= significand << (23 - 10);
		
		return *cast(float*)&u;
	}
	
	unittest
	{
		static struct S { ushort u; float f; }
		
		static S[] tests =
		[
			{ 0x3C00,  1.0f },
			{ 0xC000, -2.0f },
			{ 0x7BFF,  65504f },
			{ 0x0000,  0.0f },
			{ 0x8000, -0.0f },
			{ 0x7C00,  float.infinity},
			{ 0xFC00,  -float.infinity},
			//{ , },
		];
		
		foreach (i, s; tests)
		{
			float f = shortToFloat(s.u);
			if (f != s.f)
			{
				printf("[%d] %04x %g expected %g\n", i, s.u, f, s.f);
				assert(0);
			}
		}
	}
	
	
	version (unittest) import std.stdio;
	
	unittest
	{
		GLhalf h = hf!27.2;
		GLhalf j = cast(GLhalf)( hf!3.5 + hf!5 );
		GLhalf f = GLhalf(0.0f);
		
		float k = j + h;
		
		f.s = 0x1400;
		writeln("1.0009765625 ", 1.0f + f);
		assert(f == GLhalf.epsilon);
		
		f.s = 0x0400;
		writeln("6.10352e-5 ", cast(float)f);
		assert(f == GLhalf.min_normal);
		
		f.s = 0x03FF;
		writeln("6.09756e-5 ", cast(float)f);
		
		f.s = 1;
		writefln("5.96046e-8 %.10e", cast(float)f);
		
		f.s = 0;
		writeln("0 ", cast(float)f);
		assert(f == 0.0f);
		
		f.s = 0x8000;
		writeln("-0 ", cast(float)f);
		assert(f == -0.0f);
		
		f.s = 0x3555;
		writeln("0.33325 ", cast(float)f);
		
		f = GLhalf.nan();
		assert(f.s == 0x7C01);
		float fl = f;
		writefln("%x", *cast(uint*)&fl);
		assert(*cast(uint*)&fl == 0x7FC0_0000);
	}
}