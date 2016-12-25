<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:ng="http://docbook.org/docbook-ng"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                exclude-result-prefixes="db ng exsl"
                version='1.0'>
    
    <!-- strip out the declaration from each file so that they can be -->
    <!-- concatenated together into a single file -->

    <xsl:output method="xml" omit-xml-declaration="yes"/>
    
    <!-- It is important to use indent="no" here, otherwise verbatim -->
    <!-- environments get broken by indented tags...at least when the -->
    <!-- callout extension is used...at least with some processors -->

    <xsl:output method="xml" indent="no"/>

    <!-- the identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- replace the mml construct infinity with the unicode equivalent -->
    <xsl:template match="mml:infinity">
        <mml:mn>&#x221e;</mml:mn>
    </xsl:template>
    
    <!-- Strip out the section with the copyright as all copyrights -->
    <!-- are at the front of the document  -->
    <xsl:template match="id('Copyright')">
    </xsl:template>

</xsl:stylesheet>
