<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- copy all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="branch" name="branch-algorithm">
        <xsl:for-each select="following-sibling::glue|following-sibling::penalty">

        </xsl:for-each>
    </xsl:template>

    <xsl:template match="glue|penalty" name="branch-start">
        <xsl:variable name="line-width">
            <xsl:choose>
                <xsl:when test="not(@line-width)">
                    <xsl:value-of select="/document/@line-width"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@line-width"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>

        <xsl:variable name="line-ele-width">
            <xsl:value-of select="sum(preceding-sibling::glue/@width) + sum(preceding-sibling::box/@width) + @width"/>
        </xsl:variable>
        <xsl:variable name="line-stretch">
            <xsl:value-of select="sum(preceding-sibling::glue/@stretchability) + @stretchability"/>
        </xsl:variable>
        <xsl:variable name="line-shrink">
            <xsl:value-of select="sum(preceding-sibling::glue/@shrinkability) + @shrinkability"/>
        </xsl:variable>
        <xsl:variable name="ratio">
            <xsl:choose>
                <xsl:when test="$line-ele-width = $line-width">
                    <xsl:value-of select="0"/>
                </xsl:when>
                <xsl:when test="$line-ele-width > $line-width">
                    <xsl:value-of select="($line-width - $line-ele-width) div $line-shrink"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="($line-width - $line-ele-width) div $line-stretch"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$ratio > -1 and 1 > $ratio">
            <branch>
                <!--<xsl:attribute name="line-width">
                    <xsl:value-of select="$line-width"/>
                </xsl:attribute>
                <xsl:attribute name="line-ele-width">
                    <xsl:value-of select="$line-ele-width"/>
                </xsl:attribute>
                <xsl:attribute name="line-shrink">
                    <xsl:value-of select="$line-shrink"/>
                </xsl:attribute>
                <xsl:attribute name="line-stretch">
                    <xsl:value-of select="$line-stretch"/>
                </xsl:attribute>-->
                <xsl:attribute name="costs">
                    <xsl:value-of select="100*(($ratio >= 0)*$ratio - not($ratio >= 0)*$ratio) + 0.5"/>
                </xsl:attribute>
                <xsl:attribute name="ratio">
                    <xsl:value-of select="$ratio"/>
                </xsl:attribute>
                <xsl:attribute name="previous">
                    <xsl:value-of select="0"/>
                </xsl:attribute>
                <xsl:attribute name="end">
                    <xsl:value-of select="position()"/>
                </xsl:attribute>
            </branch>
            <!--<xsl:if test="(count(following-sibling::glue) + count(following-sibling::box)) > 2">
                <xsl:call-template name="branch" />
            </xsl:if>-->
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>