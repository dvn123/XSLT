<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- copy all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//line" name="start">
        <xsl:variable name="s">
            <xsl:number count="line" format="1" level="any" />
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="position">
                <xsl:value-of select="$s"/>
            </xsl:attribute>

            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="document" name="start-width">


        <xsl:call-template name="recursive">
            <xsl:with-param name="node-set" select="//paragraph"/>
            <xsl:with-param name="max-width" select="@line-width" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="recursive">
        <xsl:param name="node-set"/>
        <xsl:param name="max-width"/>

        <xsl:choose>
            <xsl:when test="$node-set[2]">
                <xsl:choose>
                    <xsl:when test="$max-width > @width">
                        <xsl:call-template name="recursive">
                            <xsl:with-param name="node-set" select="$node-set[position() != 1]" />
                            <xsl:with-param name="max-width" select="$max-width" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="recursive">
                            <xsl:with-param name="node-set" select="$node-set[position() != 1]" />
                            <xsl:with-param name="max-width" select="@width" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$max-width > @width">
                        <xsl:copy>
                            <xsl:attribute name="width">
                                <xsl:value-of select="$max-width + 100"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="@*|node()"/>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:attribute name="width">
                                <xsl:value-of select="@width + 100"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="@*|node()"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>