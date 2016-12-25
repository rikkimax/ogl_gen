#!/usr/bin/python3
#
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

import io, os, re, string, sys;

if __name__ == '__main__':
    if (len(sys.argv) != 4):
        print('Usage:', sys.argv[0], ' gendir srcdir indexfile', file=sys.stderr)
        exit(1)
    else:
        gendir = sys.argv[1]
        srcdir = sys.argv[2]
        outfilename = sys.argv[3]
        # print(' gendir = ', gendir, ' srcdir = ', srcdir, 'outfilename = ', outfilename)
else:
    print('Unknown invocation mode', file=sys.stderr)
    exit(1)

# Docbook source and generated HTML file extensions
srcext = '.xml'
genext = '.xml'

# Global flag indicating whether to strip 'gl' prefix before alphabetizing
glPrefix = 1

# List of generated files
files = os.listdir(gendir)

# Add [file, alias] to dictionary[key]
def addkey(dict, file, key, alias):
    if (key in dict.keys()):
        value = dict[key]
        print('Key', key, '-> [', file, ',', alias, '] already exists in dictionary as [', value[0], ',', value[1], ']')
    else:
        dict[key] = [file, key]
        # print('Adding key', key, 'to dictionary as [', file, ',', alias, ']')

# Create list of entry point names to be indexed.
# Unlike the old Perl script, this proceeds as follows:
# - Each .xhtml page with a parent .xml page gets an
#   index entry for its base name.
# - Additionally, each <function> tag inside a <funcdef>
#   in the parent page gets an aliased index entry.
# - Each .xhtml page *without* a parent is reported but
#   not indexed.
# - Each collision in index terms is reported.
# - Index terms are keys in a dictionary whose entries
#   are [ pagename, alias ] where pagename is the
#   base name of the indexed page and alias is 1 if
#   this index isn't the same as pagename.

pageIndex = {}
for file in files:
    # print('Processing file', file)
    (entrypoint,ext) = os.path.splitext(file)
    if (ext == genext):
        parent = srcdir + '/' + entrypoint + srcext
        if (os.path.exists(parent)):
            addkey(pageIndex, file, entrypoint, 0)
            # Search parent file for <function> tags inside <funcdef> tags
            # This doesn't search for <varname> inside <fieldsynopsis>, because
            #   those aren't on the same line and it's hard.
            fp = open(parent)
            for line in fp.readlines():
                # Look for <function> tag contents and add as aliases
                # Don't add the same key twice
                for m in re.finditer(r"<funcdef>.*<function>(.*)</function>.*</funcdef>", line):
                    funcname = m.group(1)
                    if (funcname != entrypoint):
                        addkey(pageIndex, file, funcname, 1)
            fp.close()
        else:
            print('No parent page for', file, ', will not be indexed')

# Determine which letters are in the table of contents.
# This may require stripping the 'gl' prefix from each key containing it,
#   depending on the global flag glPrefix.
# toc is a dictionary of key letters

# Sort key for sorting a list of strings
# This cheats a bit by ignoring the gl prefix
def sortKey(key):
    if (glPrefix and len(key) > 2 and key[0:2] == 'gl'):
        return key[2:]
    else:
        return key

# Return the keys in a dictionary sorted by name
def sortedKeys(dict):
    list = [key for key in dict.keys()]
    list.sort(key = sortKey)
    return list

# Keys is the sorted list of page indexes
keys = sortedKeys(pageIndex)

# print('Sorted list of page indexes:\n', keys)

toc = {}
for key in keys:
    if (glPrefix and len(key) > 2 and key[0:2] == 'gl'):
        c = key[2]
    else:
        c = key[0]
    toc[c] = 1

# Letters is the sorted list of letter prefixes for keys.
letters = sortedKeys(toc)

# print('Sorted list of index letters:\n', letters)

# Some utility functions for generating the navigation table
def printHeader(fp):
    print('<html>',
          '<head>',
          '    <link rel="stylesheet" type="text/css" href="opengl-man.css" />',
          '    <title>OpenGL Documentation</title>',
          '</head>',
          '<body>',
          '<a name="top"></a>',
          '<center><h1>OpenGL 4 Reference Pages</h1></center>',
          '<br/><br/>\n',
          sep='\n', file=fp)

def printFooter(fp):
    print('</body>\n</html>\n', file=fp)

# Add a nav table entry. key = link name,
# keyval = [file for link target, alias]
def addTable(key, keyval, fp):
    file = keyval[0]
    alias = keyval[1]

    # (strippedname,ext) = os.path.splitext(file)

    print('        <tr><td><a target="pagedisp" href="', file, '">',
          key,
          '</a></td></tr>',
          sep='', file=fp)

def beginTable(letter, fp):
    print('    <a name="' + letter + '"></a><br/><br/>',
          '    <table width="200" class="sample">',
          '        <th>' + letter + '</th>',
          sep='\n', file=fp)

def endTable(opentable, fp):
    if (opentable == 0):
        return
    print('        <tr><td align="right"><a href="#top">Top</a></td></tr>',
          '    </table>',
          sep='\n', file=fp)

# Generate the navigation tables
fp = open(outfilename, 'w')
printHeader(fp)

# First the letter index
print('<center>\n<div id="container">', file=fp)
for letter in letters:
    print('    <b><a href="#', letter, '" style="text-decoration:none">', letter, '</a></b> &nbsp;', sep='', file=fp)
print('</div>\n</center>', file=fp)

# Print links for sorted keys in each letter section
curletter = ''
opentable = 0

for key in keys:
    if (glPrefix and len(key) > 2 and key[0:2] == 'gl'):
        c = key[2]
    else:
        c = key[0]

    if (c != curletter):
        endTable(opentable, fp)
        # Start a new subtable for this letter
        beginTable(c, fp)
        opentable = 1
        curletter = c
    addTable(key, pageIndex[key], fp)
endTable(opentable, fp)

printFooter(fp)
fp.close()
