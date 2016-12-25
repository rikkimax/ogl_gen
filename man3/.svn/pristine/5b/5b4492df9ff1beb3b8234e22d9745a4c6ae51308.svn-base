#!gmake

# XSLT processor - other possibilities like Saxon exist
XSLT	= xsltproc --nonet
SED	= sed

# Location of locally customized stylesheet, which imports
# the Docbook modular stylesheets, and specifically the
# stylesheet to convert Docbook+MathML => XHTML+MathML
DB2XHTML = opengl-man.xsl

.SUFFIXES: .gl .xml .html .xhtml .ck.xhtml .tex .pdf .3G .tar .tar.gz
.PHONY: man html pdf tex

%.xml: ../%.xml opengl-man.xsl
	$(XSLT) --xinclude -o $@.tmp $(DB2XHTML) $<
	$(SED) 's/<?xml-stylesheet/<!-- saved from url=(0013)about:internet -->\n<?xml-stylesheet/g' $@.tmp | \
	    $(SED) 's#http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd#xhtml1-transitional.dtd#g' | \
	    $(SED) 's#</title># - OpenGL 3.3 Reference Pages</title>#g' > $@
	$(RM) $@.tmp

ALLXML = \
    glActiveTexture.xml \
    glAttachShader.xml \
    glBeginConditionalRender.xml \
    glBeginQuery.xml \
    glBeginTransformFeedback.xml \
    glBindAttribLocation.xml \
    glBindBuffer.xml \
    glBindBufferBase.xml \
    glBindBufferRange.xml \
    glBindFragDataLocation.xml \
    glBindFragDataLocationIndexed.xml \
    glBindFramebuffer.xml \
    glBindRenderbuffer.xml \
    glBindSampler.xml \
    glBindTexture.xml \
    glBindVertexArray.xml \
    glBlendColor.xml \
    glBlendEquation.xml \
    glBlendEquationSeparate.xml \
    glBlendFunc.xml \
    glBlendFuncSeparate.xml \
    glBlitFramebuffer.xml \
    glBufferData.xml \
    glBufferSubData.xml \
    glCheckFramebufferStatus.xml \
    glClampColor.xml \
    glClear.xml \
    glClearColor.xml \
    glClearBuffer.xml \
    glClearDepth.xml \
    glClearStencil.xml \
    glClientWaitSync.xml \
    glColorMask.xml \
    glCompileShader.xml \
    glCompressedTexImage1D.xml \
    glCompressedTexImage2D.xml \
    glCompressedTexImage3D.xml \
    glCompressedTexSubImage1D.xml \
    glCompressedTexSubImage2D.xml \
    glCompressedTexSubImage3D.xml \
    glCopyBufferSubData.xml \
    glCopyTexImage1D.xml \
    glCopyTexImage2D.xml \
    glCopyTexSubImage1D.xml \
    glCopyTexSubImage2D.xml \
    glCopyTexSubImage3D.xml \
    glCreateProgram.xml \
    glCreateShader.xml \
    glCullFace.xml \
    glDeleteBuffers.xml \
    glDeleteFramebuffers.xml \
    glDeleteProgram.xml \
    glDeleteQueries.xml \
    glDeleteRenderbuffers.xml \
    glDeleteSamplers.xml \
    glDeleteShader.xml \
    glDeleteSync.xml \
    glDeleteTextures.xml \
    glDeleteVertexArrays.xml \
    glDepthFunc.xml \
    glDepthMask.xml \
    glDepthRange.xml \
    glDetachShader.xml \
    glDisableVertexAttribArray.xml \
    glDrawArrays.xml \
    glDrawArraysInstanced.xml \
    glDrawBuffer.xml \
    glDrawBuffers.xml \
    glDrawElements.xml \
    glDrawElementsBaseVertex.xml \
    glDrawElementsInstanced.xml \
    glDrawElementsInstancedBaseVertex.xml \
    glDrawRangeElements.xml \
    glDrawRangeElementsBaseVertex.xml \
    glEnable.xml \
    glEnablei.xml \
    glEnableVertexAttribArray.xml \
    glEndQuery.xml \
    glFenceSync.xml \
    glFinish.xml \
    glFlush.xml \
    glFlushMappedBufferRange.xml \
    glFramebufferRenderbuffer.xml \
    glFramebufferTexture.xml \
    glFramebufferTexture1D.xml \
    glFramebufferTexture2D.xml \
    glFramebufferTexture3D.xml \
    glFramebufferTextureLayer.xml \
    glFrontFace.xml \
    glGenBuffers.xml \
    glGenerateMipmap.xml \
    glGenFramebuffers.xml \
    glGenQueries.xml \
    glGenRenderbuffers.xml \
    glGenSamplers.xml \
    glGenTextures.xml \
    glGenVertexArrays.xml \
    glGet.xml \
    glGetActiveAttrib.xml \
    glGetActiveUniform.xml \
    glGetActiveUniformBlock.xml \
    glGetActiveUniformBlockName.xml \
    glGetActiveUniformName.xml \
    glGetActiveUniformsiv.xml \
    glGetAttachedShaders.xml \
    glGetAttribLocation.xml \
    glGetBufferParameter.xml \
    glGetBufferPointerv.xml \
    glGetBufferSubData.xml \
    glGetCompressedTexImage.xml \
    glGetError.xml \
    glGetFragDataIndex.xml \
    glGetFragDataLocation.xml \
    glGetFramebufferAttachmentParameter.xml \
    glGetMultisample.xml \
    glGetProgram.xml \
    glGetProgramInfoLog.xml \
    glGetQueryObject.xml \
    glGetQueryiv.xml \
    glGetRenderbufferParameter.xml \
    glGetSamplerParameter.xml \
    glGetShader.xml \
    glGetShaderInfoLog.xml \
    glGetShaderSource.xml \
    glGetString.xml \
    glGetSync.xml \
    glGetTexImage.xml \
    glGetTexLevelParameter.xml \
    glGetTexParameter.xml \
    glGetTransformFeedbackVarying.xml \
    glGetUniform.xml \
    glGetUniformBlockIndex.xml \
    glGetUniformIndices.xml \
    glGetUniformLocation.xml \
    glGetVertexAttrib.xml \
    glGetVertexAttribPointerv.xml \
    glHint.xml \
    glIsBuffer.xml \
    glIsEnabled.xml \
    glIsFramebuffer.xml \
    glIsProgram.xml \
    glIsRenderbuffer.xml \
    glIsQuery.xml \
    glIsSampler.xml \
    glIsShader.xml \
    glIsSync.xml \
    glIsTexture.xml \
    glIsVertexArray.xml \
    glLineWidth.xml \
    glLinkProgram.xml \
    glLogicOp.xml \
    glMapBuffer.xml \
    glMapBufferRange.xml \
    glMultiDrawArrays.xml \
    glMultiDrawElements.xml \
    glMultiDrawElementsBaseVertex.xml \
    glPixelStore.xml \
    glPointParameter.xml \
    glPointSize.xml \
    glPolygonMode.xml \
    glPolygonOffset.xml \
    glPrimitiveRestartIndex.xml \
    glProvokingVertex.xml \
    glQueryCounter.xml \
    glReadBuffer.xml \
    glReadPixels.xml \
    glRenderbufferStorage.xml \
    glRenderbufferStorageMultisample.xml \
    glSampleCoverage.xml \
    glSampleMaski.xml \
    glSamplerParameter.xml \
    glScissor.xml \
    glShaderSource.xml \
    glStencilFunc.xml \
    glStencilFuncSeparate.xml \
    glStencilMask.xml \
    glStencilMaskSeparate.xml \
    glStencilOp.xml \
    glStencilOpSeparate.xml \
    glTexBuffer.xml \
    glTexImage1D.xml \
    glTexImage2D.xml \
    glTexImage2DMultisample.xml \
    glTexImage3D.xml \
    glTexImage3DMultisample.xml \
    glTexParameter.xml \
    glTexSubImage1D.xml \
    glTexSubImage2D.xml \
    glTexSubImage3D.xml \
    glTransformFeedbackVaryings.xml \
    glUniform.xml \
    glUniformBlockBinding.xml \
    glUnmapBuffer.xml \
    glUseProgram.xml \
    glValidateProgram.xml \
    glVertexAttrib.xml \
    glVertexAttribDivisor.xml \
    glVertexAttribPointer.xml \
    glViewport.xml \
    glWaitSync.xml

XML    = $(ALLXML)

default: $(XML)

clean:
	$(RM) $(TEX_FILES) *.log *.aux *.toc *.dvi *.out

clobber: clean
	$(RM) $(XML) $(PDF_FILES)
