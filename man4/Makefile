# Copyright (c) 2013 The Khronos Group Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and/or associated documentation files (the
# "Materials"), to deal in the Materials without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Materials, and to
# permit persons to whom the Materials are furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Materials.
#
# THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# MATERIALS OR THE USE OR OTHER DEALINGS IN THE MATERIALS.

LDIRT := $(wildcard gl*.xml)

COMMONPREF = standard
include $(ROOT)/usr/include/make/commondefs

SUBDIRS = \
	html \
	$(NULL)

default $(ALLTARGS): $(_FORCE)
	$(SUBDIRS_MAKERULE)

distoss:
	$(MAKE) $(COMMONPREF)$@
	$(SUBDIRS_MAKERULE)

include $(COMMONRULES)

XIFILES = baseformattable.xml \
	  compressedformattable.xml \
	  internalformattable.xml \
	  texboformattable.xml \
	  apifunchead.xml \
	  apiversion.xml \
	  funchead.xml \
	  varhead.xml \
	  version.xml

# Docbook 5 Relax-NG with XInclude schema URLs and local filenames
DB5XIRNCURL = http://docbook.org/xml/5.0/rng/docbookxi.rnc
DB5XIRNC    = /usr/share/xml/docbook/schema/rng/5.0/docbookxi.rnc

XML = $(filter-out $(XIFILES),$(wildcard *.xml))
validate:
	jing -c $(DB5XIRNC) $(XML)
