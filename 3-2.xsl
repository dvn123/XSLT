<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- copy all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="paragraph">

        <xsl:copy>
            <xsl:variable name="last" select="content/*[position() = last()]/@position" />
            <xsl:variable name="list" select="list/@l"/>


            <xsl:call-template name="recursive">
                <xsl:with-param name="list" select="$list"/>
                <xsl:with-param name="ele" select="concat('!n', $last, substring-after($list, concat('!n', $last)))" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>


    <xsl:template name="recursive">
        <xsl:param name="list"/>
        <xsl:param name="ele" />

        <!--<c>
            <xsl:attribute name="previous"><xsl:value-of select="@previous"/></xsl:attribute>
            <xsl:attribute name="end"><xsl:value-of select="@end"/></xsl:attribute>
            <xsl:attribute name="c"><xsl:value-of select="count(../branch[@previous = $node-set[1]/@end])"/></xsl:attribute>
        </c>-->
        <xsl:variable name="n" select="number(substring-before(substring-after($ele, '!n'), '::'))"/>
        <xsl:variable name="p" select="number(substring-before(substring-after($ele, 'p'), '   '))"/>
        <xsl:variable name="ll" select="//branch[@previous = $p and @end = $n]/@ratio"/>



        <xsl:choose>
            <xsl:when test="$p != 0">
                <xsl:call-template name="recursive">
                    <xsl:with-param name="ele" select="concat(substring-before(concat('!n', $p, substring-after($list, concat('!n', $p))), '   '), '   ')"/>
                    <xsl:with-param name="list" select="$list"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        <line>
            <xsl:attribute name="ratio">
                <xsl:value-of select="branches/branch[@previous = $p and @end = $n]/@ratio"/>
            </xsl:attribute>
            <xsl:for-each select="content/*[@position >= $p and $n >= @position]">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:for-each>
        </line>
    </xsl:template>
</xsl:stylesheet>