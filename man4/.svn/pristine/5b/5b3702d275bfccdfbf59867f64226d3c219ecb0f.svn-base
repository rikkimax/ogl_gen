#!/bin/sh
# Usage: conv.sh srcfile-name
# System copy @ rev 7660
xsl=/usr/share/xml/docbook/stylesheet/docbook5/db4-upgrade.xsl
# Sourceforge HEAD copy @ rev 9783
xsl=rev9783.db4-upgrade.xsl
# Updated with patch from docbook-apps
xsl=db4-upgrade.xsl
echo "Using XSL $xsl"
for arg in $* ; do
    src=$arg
    if test ! -f $file ; then
	echo "No such source file $src, skipping"
	continue
    fi
    dst=`basename $src`
    if test -f $dst ; then
	echo "Destination file $dst already exists, skipping"
	continue
    fi
    cp DOCTYPE.txt $dst
    sed -e 's/&/AMPER/g' < $src | \
	xsltproc $xsl - | \
	sed -e 's/AMPER/\&/g' \
	    >> $dst
done
