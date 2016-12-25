#!gmake

# XSLT processor - other possibilities like Saxon exist
XSLT	= xsltproc --nonet
SED	= sed

# Location of locally customized stylesheet, which imports
# the Docbook modular stylesheets, and specifically the
# stylesheet to convert Docbook+MathML => XHTML+MathML
DB2XHTML = opengl-man.xsl

PREPROCESSOR = preproc.sed

.SUFFIXES: .gl .xml .html .xhtml .ck.xhtml .tex .pdf .3G .tar .tar.gz
.PHONY: man html pdf tex

%.xml: ../%.xml $(DB2XHTML) $(PREPROCESSOR)
	$(XSLT) --xinclude -o $@ $(DB2XHTML) $<
	$(SED) -i -f $(PREPROCESSOR) $@

GL_ARB_draw_indirect_entries = \
    glDrawArraysIndirect.xml \
    glDrawElementsIndirect.xml

GL_ARB_shader_subroutine_entries = \
    glGetActiveSubroutineName.xml \
    glGetActiveSubroutineUniform.xml \
    glGetActiveSubroutineUniformName.xml \
    glGetProgramStage.xml \
    glGetSubroutineIndex.xml \
    glGetSubroutineUniformLocation.xml \
    glGetUniformSubroutine.xml \
    glUniformSubroutines.xml

GL_ARB_tessellation_shader_entries = \
    glPatchParameter.xml

GL_ARB_transform_feedback2_entries = \
    glBindTransformFeedback.xml \
    glDeleteTransformFeedbacks.xml \
    glGenTransformFeedbacks.xml \
    glIsTransformFeedback.xml \
    glPauseTransformFeedback.xml \
    glResumeTransformFeedback.xml \
    glDrawTransformFeedback.xml

GL_ARB_transform_feedback3_entries = \
    glDrawTransformFeedbackStream.xml \
    glBeginQueryIndexed.xml \
    glGetQueryIndexed.xml

GL_ARB_viewport_array_entries = \
    glDepthRangeArray.xml \
    glDepthRangeIndexed.xml \
    glScissorArray.xml \
    glScissorIndexed.xml \
    glViewportArray.xml \
    glViewportIndexed.xml

GL_ARB_get_program_binary_entries = \
    glGetProgramBinary.xml \
    glProgramBinary.xml \
    glProgramParameter.xml

GL_ARB_ES2_compatibility_entries = \
    glReleaseShaderCompiler.xml \
    glShaderBinary.xml \
    glGetShaderPrecisionFormat.xml

GL_ARB_separate_shader_objects_entries = \
    glUseProgramStages.xml \
    glActiveShaderProgram.xml \
    glCreateShaderProgram.xml \
    glBindProgramPipeline.xml \
    glGenProgramPipelines.xml \
    glDeleteProgramPipelines.xml \
    glIsProgramPipeline.xml \
    glGetProgramPipeline.xml \
    glValidateProgramPipeline.xml \
    glGetProgramPipelineInfoLog.xml \
    glProgramUniform.xml

GL_ARB_sample_shading_entries = \
    glMinSampleShading.xml

GL_ARB_base_instance_entries = \
    glDrawArraysInstancedBaseInstance.xml \
    glDrawElementsInstancedBaseInstance.xml \
    glDrawElementsInstancedBaseVertexBaseInstance.xml

GL_EXT_texture_storage_entries = \
    glTexStorage1D.xml \
    glTexStorage2D.xml \
    glTexStorage3D.xml

GL_ARB_internal_format_query_entries = \
    glGetInternalformat.xml

GL_ARB_transform_feedback_instanced_entries = \
    glDrawTransformFeedbackInstanced.xml \
    glDrawTransformFeedbackStreamInstanced.xml

GL_ARB_shader_atomic_counters_entries = \
    glGetActiveAtomicCounterBufferiv.xml

GL_ARB_shader_image_load_store_entries = \
    glBindImageTexture.xml \
    glMemoryBarrier.xml

# START OF OPENGL 4.3 EXTENSIONS

# GL_ARB_arrays_of_arrays has no new entry points
GL_ARB_arrays_of_arrays_entries =

GL_ARB_multi_draw_indirect_entries = \
    glMultiDrawArraysIndirect.xml \
    glMultiDrawElementsIndirect.xml

# ES3_compatibility does not have any new entry points
GL_ARB_ES3_compatibility_enries =

GL_ARB_clear_buffer_object_entries = \
    glClearBufferData.xml \
    glClearBufferSubData.xml

GL_ARB_compute_shader_entries = \
    glDispatchCompute.xml \
    glDispatchComputeIndirect.xml

GL_ARB_copy_image_entries = \
    glCopyImageSubData.xml

GL_ARB_debug_group_entries = \
    glPushDebugGroup.xml \
    glPopDebugGroup.xml

GL_ARB_debug_label_entries = \
    glObjectLabel.xml \
    glObjectPtrLabel.xml \
    glGetObjectLabel.xml \
    glGetObjectPtrLabel.xml

# GL_ARB_debug_output2 has no new entry points
GL_ARB_debug_output2_entries =

GL_ARB_debug_output_entries = \
    glDebugMessageControl.xml \
    glDebugMessageInsert.xml \
    glDebugMessageCallback.xml \
    glGetDebugMessageLog.xml
# Add glGetPointerv to glGet.xml

# GL_ARB_explicit_uniform_location has no new entry points
GL_ARB_explicit_uniform_location_entries =

# GL_ARB_fragment_layer_viewport has no new entry points
GL_ARB_fragment_layer_viewport_entries =

GL_ARB_framebuffer_no_attachments_entries = \
    glFramebufferParameteri.xml \
    glGetFramebufferParameter.xml

# GL_ARB_internalformat_query2 adds glGetInternalFormati64v to glGetInternalFormativ
GL_ARB_internalformat_query2_entries =

GL_ARB_invalidate_subdata_entries = \
    glInvalidateTexSubImage.xml \
    glInvalidateTexImage.xml \
    glInvalidateBufferSubData.xml \
    glInvalidateBufferData.xml \
    glInvalidateFramebuffer.xml \
    glInvalidateSubFramebuffer.xml

GL_ARB_program_interface_query_entries = \
    glGetProgramInterface.xml \
    glGetProgramResourceIndex.xml \
    glGetProgramResourceName.xml \
    glGetProgramResource.xml \
    glGetProgramResourceLocation.xml \
    glGetProgramResourceLocationIndex.xml

# GL_ARB_robust_buffer_access_behavior does not define any new entry points
GL_ARB_robust_buffer_access_behavior_entries =

# GL_ARB_shader_image_size does not define any new entry points
GL_ARB_shader_image_size_entries =

GL_ARB_shader_storage_buffer_object_entries = \
    glShaderStorageBlockBinding.xml

# GL_ARB_stencil_texturing does not define any new entry points
GL_ARB_stencil_texturing_entries =

GL_ARB_texture_buffer_range_entries = \
    glTexBufferRange.xml

# GL_ARB_texture_query_levels does not define any new entry points
GL_ARB_texture_query_levels =

GL_ARB_texture_storage_multisample_entries = \
    glTexStorage2DMultisample.xml \
    glTexStorage3DMultisample.xml

GL_ARB_texture_view_entries = \
    glTextureView.xml

GL_ARB_vertex_attrib_binding_entries = \
    glVertexAttribBinding.xml \
    glVertexAttribFormat.xml \
    glVertexBindingDivisor.xml \
    glBindVertexBuffer.xml

GL_ARB_buffer_storage_entries = \
    glBufferStorage.xml

GL_ARB_clear_texture_entries = \
    glClearTexImage.xml \
    glClearTexSubImage.xml

GL_ARB_multi_bind_entries = \
    glBindBuffersBase.xml \
    glBindBuffersRange.xml \
    glBindTextures.xml \
    glBindImageTextures.xml \
    glBindSamplers.xml \
    glBindVertexBuffers.xml

MODIFIEDFORGL4XML = \
    glClearDepth.xml \
    glCreateShader.xml \
    glDepthRange.xml \
    glDrawArrays.xml \
    glGetVertexAttrib.xml \
    glVertexAttrib.xml \
    glVertexAttribPointer.xml

GL4XML = \
    $(GL_ARB_draw_indirect_entries) \
    $(GL_ARB_shader_subroutine_entries) \
    $(GL_ARB_tessellation_shader_entries) \
    $(GL_ARB_transform_feedback2_entries) \
    $(GL_ARB_transform_feedback3_entries) \
    $(GL_ARB_sample_shading_entries)

GL41XML = \
    $(GL_ARB_viewport_array_entries) \
    $(GL_ARB_get_program_binary_entries) \
    $(GL_ARB_ES2_compatibility_entries) \
    $(GL_ARB_separate_shader_objects_entries)

GL42XML = \
    $(GL_ARB_base_instance_entries) \
    $(GL_EXT_texture_storage_entries) \
    $(GL_ARB_internal_format_query_entries) \
    $(GL_ARB_transform_feedback_instanced_entries) \
    $(GL_ARB_shader_atomic_counters_entries) \
    $(GL_ARB_shader_image_load_store_entries) \
    removedTypes.xml

GL43XML = \
    $(GL_ARB_multi_draw_indirect_entries) \
    $(GL_ARB_ES3_compatibility_enries) \
    $(GL_ARB_clear_buffer_object_entries) \
    $(GL_ARB_compute_shader_entries) \
    $(GL_ARB_copy_image_entries) \
    $(GL_ARB_invalidate_subdata_entries) \
    $(GL_ARB_texture_buffer_range_entries) \
    $(GL_ARB_texture_storage_multisample_entries) \
    $(GL_ARB_vertex_attrib_binding_entries) \
    $(GL_ARB_shader_storage_buffer_object_entries) \
    $(GL_ARB_debug_group_entries) \
    $(GL_ARB_debug_label_entries) \
    $(GL_ARB_framebuffer_no_attachments_entries) \
    $(GL_ARB_program_interface_query_entries) \
    $(GL_ARB_debug_output_entries) \
    $(GL_ARB_texture_view_entries)

GL44XML = \
    $(GL_ARB_buffer_storage_entries) \
    $(GL_ARB_clear_texture_entries) \
    $(GL_ARB_multi_bind_entries)

UNMODIFIEDXML = \
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
    glDetachShader.xml \
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
    glEnableVertexAttribArray.xml \
    glFenceSync.xml \
    glFinish.xml \
    glFlush.xml \
    glFlushMappedBufferRange.xml \
    glFramebufferRenderbuffer.xml \
    glFramebufferTexture.xml \
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
    glUseProgram.xml \
    glValidateProgram.xml \
    glVertexAttribDivisor.xml \
    glViewport.xml \
    glWaitSync.xml

MODIFIEDXML = \

XML    = $(GL4XML) $(GL41XML) $(GL42XML) $(GL43XML) $(GL44XML) $(MODIFIEDFORGL4XML) $(UNMODIFIEDXML)

default: $(XML) index.html

glTexImage1D.xml \
glTexImage2D.xml \
glTexImage3D.xml \
glTexStorage1D.xml \
glTexStorage2D.xml \
glTexStorage3D.xml \
    : ../internalformattable.xml ../baseformattable.xml ../compressedformattable.xml

glTexBuffer.xml glTexBufferRange.xml: ../texboformattable.xml

index.html: Makefile makeindex.py $(XML)
	./makeindex.py . .. $@

clean clobber: clean
	$(RM) $(XML) index.html
