<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- copy all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="document" name="start-width">
        <xsl:call-template name="recursive">
            <xsl:with-param name="node-set" select="//line"/>
            <xsl:with-param name="height" select="0" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="recursive">
        <xsl:param name="node-set"/>
        <xsl:param name="height"/>

        <xsl:variable name="font-size">
            <xsl:choose>
                <xsl:when test="not(../../@font-size)">
                    <xsl:value-of select="/document/@font-size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="../../@font-size"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$node-set[2]">
                <xsl:call-template name="recursive">
                    <xsl:with-param name="node-set" select="$node-set[position() != 1]" />
                    <xsl:with-param name="height" select="$height + $node-set[1]/@position*$font-size" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:attribute name="height">
                        <xsl:value-of select="$height + $font-size"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>