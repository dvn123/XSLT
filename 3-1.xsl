<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- copy all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="branches">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>

        <xsl:call-template name="recursive">
            <xsl:with-param name="node-set" select="./branch"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="recursive">
        <xsl:param name="node-set"/>
        <xsl:param name="list" select="''"/>

        <!--<c>
            <xsl:attribute name="previous"><xsl:value-of select="@previous"/></xsl:attribute>
            <xsl:attribute name="end"><xsl:value-of select="@end"/></xsl:attribute>
            <xsl:attribute name="c"><xsl:value-of select="count(../branch[@previous = $node-set[1]/@end])"/></xsl:attribute>
        </c>-->

        <xsl:variable name="d" select="$node-set[1]/@previous"/>
        <xsl:variable name="d2" select="$node-set[1]/@end"/>

        <xsl:if test="$d = 36 and $d2 = 84">
            <!--<x></x>-->
        </xsl:if>

        <xsl:variable name="cur-best-path-to-node" select="format-number(substring-before(substring-after($list, concat('!n', $node-set[1]/@previous, '::')), ';'),'####.####')"/>
        <xsl:variable name="cur-best" select="format-number(substring-before(substring-after($list, concat('!n', $node-set[1]/@end, '::')), ';'), '####.####')"/>
        <xsl:choose>
            <xsl:when test="$node-set[2]/@cost">
                <xsl:choose>
                    <xsl:when test="$node-set[1]/@previous = 0">
                        <xsl:call-template name="recursive">
                            <xsl:with-param name="node-set" select="$node-set[position() != 1]"/>
                            <xsl:with-param name="list" select="concat(substring-before($list, concat($list, '!n', $node-set[1]/@end, '::')),
                                                                               concat($list, '!n', $node-set[1]/@end, '::', $node-set[1]/@cost, ';p', $node-set[1]/@previous ,'   '),
                                                                               substring-after(substring-after($list, concat($list, '!n', $node-set[1]/@end, '::')), '   '))"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Only nodes that have a path to them are useful -->
                        <xsl:choose>
                            <xsl:when test="$cur-best-path-to-node != 'NaN'">
                                <xsl:choose>
                                    <xsl:when test="$cur-best = 'NaN'">
                                        <xsl:call-template name="recursive">
                                            <xsl:with-param name="node-set" select="$node-set[position() != 1]"/>
                                            <xsl:with-param name="list" select="concat($list, '!n', $node-set[1]/@end, '::', $cur-best-path-to-node + $node-set[1]/@cost, ';p', $node-set[1]/@previous, '   ')"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="($cur-best > $cur-best-path-to-node + $node-set[1]/@cost)">
                                                <!--<xsl:variable name="e" select="$cur-best"/>
                                                <xsl:variable name="g" select="$cur-best-path-to-node"/>
                                                <xsl:variable name="g2" select="$cur-best-path-to-node + $node-set[1]/@cost"/>
                                                <xsl:variable name="f" select="concat(substring-before($list, concat('!n', $node-set[1]/@end, '::')),
                                                                               concat('!n', $node-set[1]/@end, '::', $cur-best-path-to-node + $node-set[1]/@cost, ';p', $node-set[1]/@previous, '   '),
                                                                               substring-after(substring-after($list, concat('!n', $node-set[1]/@end, '::')), '   '))"/>-->

                                                <xsl:call-template name="recursive">
                                                    <xsl:with-param name="node-set" select="$node-set[position() != 1]"/>
                                                    <xsl:with-param name="list" select="concat(substring-before($list, concat('!n', $node-set[1]/@end, '::')),
                                                                               concat('!n', $node-set[1]/@end, '::', $cur-best-path-to-node + $node-set[1]/@cost, ';p', $node-set[1]/@previous, '   '),
                                                                               substring-after(substring-after($list, concat('!n', $node-set[1]/@end, '::')), '   '))"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="recursive">
                                                    <xsl:with-param name="node-set" select="$node-set[position() != 1]"/>
                                                    <xsl:with-param name="list" select="$list"/>
                                                </xsl:call-template>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="recursive">
                                    <xsl:with-param name="node-set" select="$node-set[position() != 1]"/>
                                    <xsl:with-param name="list" select="$list"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <list>
                    <xsl:attribute name="l">
                        <xsl:value-of select="$list"/>
                    </xsl:attribute>
                </list>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>