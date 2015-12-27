<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- copy all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//glue|//penalty|//box" name="start">
        <xsl:variable name="s">
            <xsl:number count="//glue|//penalty|//box" format="1" />
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="position">
                <xsl:value-of select="$s"/>
            </xsl:attribute>

            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>