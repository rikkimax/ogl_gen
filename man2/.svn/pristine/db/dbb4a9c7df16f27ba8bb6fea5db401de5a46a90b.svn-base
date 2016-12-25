#!gmake

# XSLT processor - other possibilities like Saxon exist
XSLT	= xsltproc

# Location of locally customized stylesheet, which imports
# the Docbook modular stylesheets, and the specific
# stylesheet to convert Docbook+MathML => XSL-FO.

# At present, the XSL-FO stylesheets do *not* handle MathML.
# Getting math output is a significant toolchain issue.

DB2XHTML = /usr/share/sgml/docbook/xsl-stylesheets/fo/docbook.xsl

# Path to the APache FOP processor
# Download the current version 0.92beta from
#   http://xmlgraphics.apache.org/fop/
FOP = /path/to/fop-0.92beta/fop

.SUFFIXES: .gl .xml .html .xhtml .ck.xhtml .tex .pdf .3G .tar .tar.gz
.PHONY: man html pdf tex

%.fo: ../%.xml
	$(XSLT) --xinclude -o $@ $(DB2XHTML) $<

%.pdf: %.fo
	$(FOP) -fo $< -pdf $@

# ARB Ecosystem man pages
ARBFO = \
    glBlendEquationSeparate.fo \
    glStencilFuncSeparate.fo \
    glStencilMaskSeparate.fo \
    glStencilOpSeparate.fo

# SuperBible GL 1.5 man pages
SUPERBIBLEFO = \
    glBeginQuery.fo \
    glBindBuffer.fo \
    glBufferData.fo \
    glBufferSubData.fo \
    glDeleteBuffers.fo \
    glDeleteQueries.fo \
    glGenBuffers.fo \
    glGenQueries.fo \
    glGetBufferParameteriv.fo \
    glGetBufferPointerv.fo \
    glGetBufferSubData.fo \
    glGetQueryiv.fo \
    glGetQueryObject.fo \
    glIsBuffer.fo \
    glIsQuery.fo \
    glMapBuffer.fo

# 3Dlabs GL 2.0 man pages
3DLABSFO = \
    glAttachShader.fo \
    glBindAttribLocation.fo \
    glCompileShader.fo \
    glCreateProgram.fo \
    glCreateShader.fo \
    glDeleteProgram.fo \
    glDeleteShader.fo \
    glDetachShader.fo \
    glDrawBuffers.fo \
    glEnableVertexAttribArray.fo \
    glGetActiveAttrib.fo \
    glGetActiveUniform.fo \
    glGetAttachedShaders.fo \
    glGetAttribLocation.fo \
    glGetProgramInfoLog.fo \
    glGetProgram.fo \
    glGetShaderInfoLog.fo \
    glGetShaderSource.fo \
    glGetShader.fo \
    glGetUniformLocation.fo \
    glGetUniform.fo \
    glGetVertexAttribPointerv.fo \
    glGetVertexAttrib.fo \
    glIsProgram.fo \
    glIsShader.fo \
    glLinkProgram.fo \
    glShaderSource.fo \
    glUniform.fo \
    glUseProgram.fo \
    glValidateProgram.fo \
    glVertexAttribPointer.fo \
    glVertexAttrib.fo

# SGI OpenGL 1.4 man pages
SGIGLFO = \
    glAccum.fo \
    glActiveTexture.fo \
    glAlphaFunc.fo \
    glAreTexturesResident.fo \
    glArrayElement.fo \
    glBegin.fo \
    glBindTexture.fo \
    glBitmap.fo \
    glBlendColor.fo \
    glBlendEquation.fo \
    glBlendFuncSeparate.fo \
    glBlendFunc.fo \
    glCallLists.fo \
    glCallList.fo \
    glClearAccum.fo \
    glClearColor.fo \
    glClearDepth.fo \
    glClearIndex.fo \
    glClearStencil.fo \
    glClear.fo \
    glClientActiveTexture.fo \
    glClipPlane.fo \
    glColorMask.fo \
    glColorMaterial.fo \
    glColorPointer.fo \
    glColorSubTable.fo \
    glColorTableParameter.fo \
    glColorTable.fo \
    glColor.fo \
    glCompressedTexImage1D.fo \
    glCompressedTexImage2D.fo \
    glCompressedTexImage3D.fo \
    glCompressedTexSubImage1D.fo \
    glCompressedTexSubImage2D.fo \
    glCompressedTexSubImage3D.fo \
    glConvolutionFilter1D.fo \
    glConvolutionFilter2D.fo \
    glConvolutionParameter.fo \
    glCopyColorSubTable.fo \
    glCopyColorTable.fo \
    glCopyConvolutionFilter1D.fo \
    glCopyConvolutionFilter2D.fo \
    glCopyPixels.fo \
    glCopyTexImage1D.fo \
    glCopyTexImage2D.fo \
    glCopyTexSubImage1D.fo \
    glCopyTexSubImage2D.fo \
    glCopyTexSubImage3D.fo \
    glCullFace.fo \
    glDeleteLists.fo \
    glDeleteTextures.fo \
    glDepthFunc.fo \
    glDepthMask.fo \
    glDepthRange.fo \
    glDrawArrays.fo \
    glDrawBuffer.fo \
    glDrawElements.fo \
    glDrawPixels.fo \
    glDrawRangeElements.fo \
    glEdgeFlagPointer.fo \
    glEdgeFlag.fo \
    glEnableClientState.fo \
    glEnable.fo \
    glEvalCoord.fo \
    glEvalMesh.fo \
    glEvalPoint.fo \
    glFeedbackBuffer.fo \
    glFinish.fo \
    glFlush.fo \
    glFogCoordPointer.fo \
    glFogCoord.fo \
    glFog.fo \
    glFrontFace.fo \
    glFrustum.fo \
    glGenLists.fo \
    glGenTextures.fo \
    glGetClipPlane.fo \
    glGetColorTableParameter.fo \
    glGetColorTable.fo \
    glGetCompressedTexImage.fo \
    glGetConvolutionFilter.fo \
    glGetConvolutionParameter.fo \
    glGetError.fo \
    glGetHistogramParameter.fo \
    glGetHistogram.fo \
    glGetLight.fo \
    glGetMap.fo \
    glGetMaterial.fo \
    glGetMinmaxParameter.fo \
    glGetMinmax.fo \
    glGetPixelMap.fo \
    glGetPointerv.fo \
    glGetPolygonStipple.fo \
    glGetSeparableFilter.fo \
    glGetString.fo \
    glGetTexEnv.fo \
    glGetTexGen.fo \
    glGetTexImage.fo \
    glGetTexLevelParameter.fo \
    glGetTexParameter.fo \
    glGet.fo \
    glHint.fo \
    glHistogram.fo \
    glIndexMask.fo \
    glIndexPointer.fo \
    glIndex.fo \
    glInitNames.fo \
    glInterleavedArrays.fo \
    glIsEnabled.fo \
    glIsList.fo \
    glIsTexture.fo \
    glLightModel.fo \
    glLight.fo \
    glLineStipple.fo \
    glLineWidth.fo \
    glListBase.fo \
    glLoadIdentity.fo \
    glLoadMatrix.fo \
    glLoadName.fo \
    glLoadTransposeMatrix.fo \
    glLogicOp.fo \
    glMap1.fo \
    glMap2.fo \
    glMapGrid.fo \
    glMaterial.fo \
    glMatrixMode.fo \
    glMinmax.fo \
    glMultiDrawArrays.fo \
    glMultiDrawElements.fo \
    glMultiTexCoord.fo \
    glMultMatrix.fo \
    glMultTransposeMatrix.fo \
    glNewList.fo \
    glNormalPointer.fo \
    glNormal.fo \
    glOrtho.fo \
    glPassThrough.fo \
    glPixelMap.fo \
    glPixelStore.fo \
    glPixelTransfer.fo \
    glPixelZoom.fo \
    glPointParameter.fo \
    glPointSize.fo \
    glPolygonMode.fo \
    glPolygonOffset.fo \
    glPolygonStipple.fo \
    glPrioritizeTextures.fo \
    glPushAttrib.fo \
    glPushClientAttrib.fo \
    glPushMatrix.fo \
    glPushName.fo \
    glRasterPos.fo \
    glReadBuffer.fo \
    glReadPixels.fo \
    glRect.fo \
    glRenderMode.fo \
    glResetHistogram.fo \
    glResetMinmax.fo \
    glRotate.fo \
    glSampleCoverage.fo \
    glScale.fo \
    glScissor.fo \
    glSecondaryColorPointer.fo \
    glSecondaryColor.fo \
    glSelectBuffer.fo \
    glSeparableFilter2D.fo \
    glShadeModel.fo \
    glStencilFunc.fo \
    glStencilMask.fo \
    glStencilOp.fo \
    glTexCoordPointer.fo \
    glTexCoord.fo \
    glTexEnv.fo \
    glTexGen.fo \
    glTexImage1D.fo \
    glTexImage2D.fo \
    glTexImage3D.fo \
    glTexParameter.fo \
    glTexSubImage1D.fo \
    glTexSubImage2D.fo \
    glTexSubImage3D.fo \
    glTranslate.fo \
    glVertexPointer.fo \
    glVertex.fo \
    glViewport.fo \
    glWindowPos.fo

# SGI GLU 1.3 man pages
SGIGLUFO = \
    gluBeginCurve.fo \
    gluBeginPolygon.fo \
    gluBeginSurface.fo \
    gluBeginTrim.fo \
    gluBuild1DMipmapLevels.fo \
    gluBuild1DMipmaps.fo \
    gluBuild2DMipmapLevels.fo \
    gluBuild2DMipmaps.fo \
    gluBuild3DMipmapLevels.fo \
    gluBuild3DMipmaps.fo \
    gluCheckExtension.fo \
    gluCylinder.fo \
    gluDeleteNurbsRenderer.fo \
    gluDeleteQuadric.fo \
    gluDeleteTess.fo \
    gluDisk.fo \
    gluErrorString.fo \
    gluGetNurbsProperty.fo \
    gluGetString.fo \
    gluGetTessProperty.fo \
    gluLoadSamplingMatrices.fo \
    gluLookAt.fo \
    gluNewNurbsRenderer.fo \
    gluNewQuadric.fo \
    gluNewTess.fo \
    gluNextContour.fo \
    gluNurbsCallbackDataEXT.fo \
    gluNurbsCallbackData.fo \
    gluNurbsCallback.fo \
    gluNurbsCurve.fo \
    gluNurbsProperty.fo \
    gluNurbsSurface.fo \
    gluOrtho2D.fo \
    gluPartialDisk.fo \
    gluPerspective.fo \
    gluPickMatrix.fo \
    gluProject.fo \
    gluPwlCurve.fo \
    gluQuadricCallback.fo \
    gluQuadricDrawStyle.fo \
    gluQuadricNormals.fo \
    gluQuadricOrientation.fo \
    gluQuadricTexture.fo \
    gluScaleImage.fo \
    gluSphere.fo \
    gluTessBeginContour.fo \
    gluTessBeginPolygon.fo \
    gluTessCallback.fo \
    gluTessEndPolygon.fo \
    gluTessNormal.fo \
    gluTessProperty.fo \
    gluTessVertex.fo \
    gluUnProject4.fo \
    gluUnProject.fo

# SGI GLX 1.4 man pages
SGIGLXFO = \
    glXChooseFBConfig.fo \
    glXChooseVisual.fo \
    glXCopyContext.fo \
    glXCreateContext.fo \
    glXCreateGLXPixmap.fo \
    glXCreateNewContext.fo \
    glXCreatePbuffer.fo \
    glXCreatePixmap.fo \
    glXCreateWindow.fo \
    glXDestroyContext.fo \
    glXDestroyGLXPixmap.fo \
    glXDestroyPbuffer.fo \
    glXDestroyPixmap.fo \
    glXDestroyWindow.fo \
    glXFreeContextEXT.fo \
    glXGetClientString.fo \
    glXGetConfig.fo \
    glXGetContextIDEXT.fo \
    glXGetCurrentContext.fo \
    glXGetCurrentDisplay.fo \
    glXGetCurrentDrawable.fo \
    glXGetCurrentReadDrawable.fo \
    glXGetFBConfigAttrib.fo \
    glXGetFBConfigs.fo \
    glXGetProcAddress.fo \
    glXGetSelectedEvent.fo \
    glXGetVisualFromFBConfig.fo \
    glXImportContextEXT.fo \
    glXIntro.fo \
    glXIsDirect.fo \
    glXMakeContextCurrent.fo \
    glXMakeCurrent.fo \
    glXQueryContextInfoEXT.fo \
    glXQueryContext.fo \
    glXQueryExtensionsString.fo \
    glXQueryExtension.fo \
    glXQueryServerString.fo \
    glXQueryVersion.fo \
    glXSelectEvent.fo \
    glXSwapBuffers.fo \
    glXUseXFont.fo \
    glXWaitGL.fo \
    glXWaitX.fo

# XML man page source and XSL-FO / PDF targets
GLFO   = $(SGIGLFO) $(3DLABSFO) $(SUPERBIBLEFO) $(ARBFO)
GLUFO  = $(SGIGLUFO)
GLXFO  = $(SGIGLXFO)
FO     = $(GLFO) $(GLUFO) $(GLXFO)
PDF    = $(FO:.fo=.pdf)

default: $(PDF)

clean:
	$(RM) $(TEX_FILES) *.log *.aux *.toc *.dvi *.out

clobber: clean
	$(RM) $(FO) $(PDF) $(PDF_FILES)
