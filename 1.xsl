<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- copy all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="paragraph[@align='ragged']/text()|paragraph[not(@align) and /document[@align = 'ragged']]/text()" name="tokenizeragged">
        <xsl:param name="text" select="normalize-space(.)"/>
        <xsl:param name="separator" select="' '"/>
        <xsl:variable name="font-size">
            <xsl:choose>
                <xsl:when test="not(@font-size)">
                    <xsl:value-of select="/document/@font-size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@font-size"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not(contains($text, $separator))">
                <box>
                    <xsl:attribute name="width">
                        <xsl:value-of select="string-length(normalize-space($text))*$font-size*0.5"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space($text)"/>
                    <glue width="0" stretchability="18" shrinkability="0"/>
                    <penalty penalty="-Infinity" break="required"/>
                </box>
            </xsl:when>
            <xsl:otherwise>
                <box>
                    <xsl:attribute name="width">
                        <xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))*$font-size*0.5"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-before($text, $separator))"/>
                </box>
                <glue stretchability="0" shrinkability="18" width="0"/>
                <penalty penalty="0" break="optional"/>
                <glue stretchability="-36" shrinkability="0" width="12"/>
                <xsl:call-template name="tokenizeragged">
                    <xsl:with-param name="text" select="substring-after($text, $separator)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="paragraph[@align='centered']/text()|paragraph[not(@align) and /document[@align = 'centered']]/text()" name="tokenizecentered-start">
        <xsl:param name="text" select="normalize-space(.)"/>
        <glue stretchability="0" shrinkability="18" width="0"/>
        <xsl:call-template name="tokenizecentered">
            <xsl:with-param name="text" select="$text"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="tokenizecentered">
        <xsl:param name="text" select="normalize-space(.)"/>
        <xsl:param name="separator" select="' '"/>
        <xsl:variable name="font-size">
            <xsl:choose>
                <xsl:when test="not(@font-size)">
                    <xsl:value-of select="/document/@font-size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@font-size"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not(contains($text, $separator))">
                <box>
                    <xsl:attribute name="width">
                        <xsl:value-of select="string-length(normalize-space($text))*$font-size*0.5"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space($text)"/>
                </box>
                <glue width="0" stretchability="18" shrinkability="0"/>
                <penalty penalty="-Infinity" break="required"/>
            </xsl:when>
            <xsl:otherwise>
                <box>
                    <xsl:attribute name="width">
                        <xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))*$font-size*0.5"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-before($text, $separator))"/>
                </box>
                <glue stretchability="0" shrinkability="18" width="0"/>
                <penalty penalty="0" break="optional"/>
                <glue stretchability="-36" shrinkability="0" width="12"/>
                <box width="0"/>
                <penalty penalty="Infinity" break="prohibited"/>
                <glue width="0" stretchability="18" shrinkability="0"/>
                <xsl:call-template name="tokenizecentered">
                    <xsl:with-param name="text" select="substring-after($text, $separator)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="paragraph[@align='justified']/text()|paragraph[not(@align) and /document[@align = 'justified']]/text()" name="tokenizejustified-start">
        <xsl:param name="text" select="."/>
        <!-- <glue stretchability="0" shrinkability="0" width="0"/> -->
        <xsl:call-template name="tokenizejustified">
            <xsl:with-param name="text" select="normalize-space($text)"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="paragraph[@align='justified']/text()|paragraph[not(@align) and /document[@align = 'justified']]/text()" name="tokenizejustified">
        <xsl:param name="text" select="normalize-space(.)"/>
        <xsl:param name="separator" select="' '"/>
        <xsl:variable name="font-size">
            <xsl:choose>
                <xsl:when test="not(@font-size)">
                    <xsl:value-of select="/document/@font-size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@font-size"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not(contains($text, $separator))">
                <box>
                    <xsl:attribute name="width">
                        <xsl:value-of select="string-length(normalize-space($text))*$font-size*0.5"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space($text)"/>
                </box>
                <penalty penalty="Infinity" break="prohibited"/>
                <glue stretchability="Infinity" shrinkability="0" width="0"/>
                <penalty penalty="-Infinity" break="required"/>
            </xsl:when>
            <xsl:otherwise>
                <box>
                    <xsl:attribute name="width">
                        <xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))*$font-size*0.5"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(substring-before($text, $separator))"/>
                </box>
                <glue stretchability="18" shrinkability="0">
                    <xsl:attribute name="width">
                        <xsl:value-of select="/document/@font-size*0.5"/>
                    </xsl:attribute>
                </glue>
                <xsl:call-template name="tokenizejustified">
                    <xsl:with-param name="text" select="substring-after($text, $separator)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>