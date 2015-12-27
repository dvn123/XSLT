<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- copy all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="paragraph" name="branch-start">
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
            <content>
                <xsl:apply-templates select="@*|node()"/>
            </content>
            <branches>
                <!-- Branches that start the paragraph -->
                <xsl:for-each select="./*[not(self::box)]">
                    <xsl:variable name="line-ele-width">
                        <xsl:choose>
                            <xsl:when test="not(@width)">
                                <xsl:value-of select="sum(preceding-sibling::glue/@width) + sum(preceding-sibling::box/@width)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="sum(preceding-sibling::glue/@width) + sum(preceding-sibling::box/@width) + @width"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="line-stretch">
                        <xsl:choose>
                            <xsl:when test="not(@stretchability)">
                                <xsl:value-of select="sum(preceding-sibling::glue/@stretchability)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="sum(preceding-sibling::glue/@stretchability) + @stretchability"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="line-shrink">
                        <xsl:choose>
                            <xsl:when test="not(@shrinkability)">
                                <xsl:value-of select="sum(preceding-sibling::glue/@shrinkability)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="sum(preceding-sibling::glue/@shrinkability) + @shrinkability"/>
                            </xsl:otherwise>
                        </xsl:choose>
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


                    <xsl:if test="$ratio > -400 and 400 > $ratio">
                        <branch>
                            <xsl:attribute name="line-width">
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
                            </xsl:attribute>
                            <xsl:attribute name="cost">
                                <xsl:value-of select="100*((($ratio >= 0)*$ratio - not($ratio >= 0)*$ratio)*$ratio*$ratio) + 0.5"/>
                            </xsl:attribute>
                            <xsl:attribute name="ratio">
                                <xsl:value-of select="$ratio"/>
                            </xsl:attribute>
                            <xsl:attribute name="previous">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="end">
                                <xsl:value-of select="@position"/>
                            </xsl:attribute>
                        </branch>
                    </xsl:if>
                </xsl:for-each>

                <xsl:for-each select="./*[not(self::box)]">
                    <xsl:variable name="end"><xsl:value-of select="@position"/></xsl:variable>
                    <!--<xsl:for-each select="following-sibling::glue|following-sibling::penalty">
                        <c><xsl:value-of select="@position"/></c>
                    </xsl:for-each>-->
                    <xsl:call-template name="recursive" >
                        <xsl:with-param name="line-width" select="$line-width"/>
                        <xsl:with-param name="previous" select="$end"/>
                        <xsl:with-param name="node-set" select="following-sibling::glue|following-sibling::penalty|following-sibling::box"/>
                    </xsl:call-template>
                </xsl:for-each>
            </branches>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="recursive">
        <xsl:param name="node-set"/>
        <xsl:param name="line-width" />
        <xsl:param name="previous" />
        <xsl:param name="init" select="true()"/>
        <xsl:param name="line-ele-width" select="0"/>
        <xsl:param name="line-stretch" select="0"/>
        <xsl:param name="line-shrink" select="0"/>


        <!-- if node is glue (only glue has width) and it's the start of a line ignore it -->
                <xsl:variable name="line-ele-width-cur">
                    <xsl:choose>
                        <xsl:when test="not($node-set[1]/@width)">
                            <xsl:value-of select="$line-ele-width"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$line-ele-width + $node-set[1]/@width"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="line-stretch-cur">
                    <xsl:choose>
                        <xsl:when test="not($node-set[1]/@stretchability)">
                            <xsl:value-of select="$line-stretch"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$line-stretch + $node-set[1]/@stretchability"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="line-shrink-cur">
                    <xsl:choose>
                        <xsl:when test="not($node-set[1]/@shrinkability)">
                            <xsl:value-of select="$line-shrink"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$line-shrink + $node-set[1]/@shrinkability"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="ratio">
                    <xsl:choose>
                        <xsl:when test="$line-ele-width-cur = $line-width">
                            <xsl:value-of select="0"/>
                        </xsl:when>
                        <xsl:when test="$line-ele-width-cur > $line-width">
                            <xsl:value-of select="($line-width - $line-ele-width-cur) div $line-shrink-cur"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="($line-width - $line-ele-width-cur) div $line-stretch-cur"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="pos">
                    <xsl:value-of select="$node-set[1]/@position"/>
                </xsl:variable>

                <!--<c>
                    <xsl:attribute name="previous">
                        <xsl:value-of select="$previous"/>
                    </xsl:attribute>
                    <xsl:attribute name="position">
                        <xsl:value-of select="$node-set[1]/@position"/>
                    </xsl:attribute>
                    <xsl:attribute name="line-ele-width">
                        <xsl:value-of select="$line-ele-width"/>
                    </xsl:attribute>
                    <xsl:attribute name="line-stretch">
                        <xsl:value-of select="$line-stretch"/>
                    </xsl:attribute>
                    <xsl:attribute name="line-shrink">
                        <xsl:value-of select="$line-shrink"/>
                    </xsl:attribute>
                    <xsl:attribute name="line-ele-width">
                        <xsl:value-of select="$line-ele-width"/>
                    </xsl:attribute>
                    <xsl:attribute name="ratio">
                        <xsl:value-of select="$ratio"/>
                    </xsl:attribute>
                    <xsl:value-of select="$line-width"/>
                </c>-->
                <xsl:variable name="pen"><xsl:value-of select="$node-set[1]/@break"/></xsl:variable>

                <xsl:choose>
                    <xsl:when test="$ratio > -4 and 4 > $ratio and $pen != 'prohibited'">
                        <branch>
                            <xsl:attribute name="line-width">
                                <xsl:value-of select="$line-width"/>
                            </xsl:attribute>
                            <xsl:attribute name="line-ele-width">
                                <xsl:value-of select="$line-ele-width"/>
                            </xsl:attribute>
                            <xsl:attribute name="line-shrink">
                                <xsl:value-of select="$line-shrink-cur"/>
                            </xsl:attribute>
                            <xsl:attribute name="line-stretch">
                                <xsl:value-of select="$line-stretch-cur"/>
                            </xsl:attribute>
                            <xsl:attribute name="cost">
                                <xsl:choose>
                                    <xsl:when test="$node-set[1]/@penalty">
                                        <xsl:value-of select="$node-set[1]/@penalty"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="100*((($ratio >= 0)*$ratio - not($ratio >= 0)*$ratio)*$ratio*$ratio) + 0.5"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="ratio">
                                <xsl:value-of select="$ratio"/>
                            </xsl:attribute>
                            <xsl:attribute name="previous">
                                <xsl:value-of select="$previous"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="$node-set[1]/@position"></xsl:when>
                            </xsl:choose>
                            <xsl:attribute name="end">
                                <xsl:value-of select="$node-set[1]/@position"/>
                            </xsl:attribute>
                        </branch><xsl:text>&#xa;</xsl:text>
                        <!--<xsl:if test="substring-after($explored, $node-set[1]/@position) = ''">
                            <xsl:call-template name="recursive" >
                                <xsl:with-param name="line-width" select="$line-width"/>
                                <xsl:with-param name="explored" select="$explored + ':' + $node-set[1]/@position + ':'" />
                                <xsl:with-param name="previous" select="$node-set[1]/@position"/>
                                <xsl:with-param name="node-set" select="../../content/glue[@position > $node-set[1]/@position]|../../content/penalty[@position > $node-set[1]/@position]"/>
                            </xsl:call-template>
                        </xsl:if>-->
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$ratio > -4 and $node-set[2]/@position">
                        <xsl:call-template name="recursive">
                            <xsl:with-param name="node-set" select="$node-set[position() != 1]"/>
                            <xsl:with-param name="init" select="false()" />
                            <xsl:with-param name="previous" select="$previous"/>
                            <xsl:with-param name="line-width" select="$line-width"/>
                            <xsl:with-param name="line-ele-width" select="$line-ele-width-cur"/>
                            <xsl:with-param name="line-stretch" select="$line-stretch-cur"/>
                            <xsl:with-param name="line-shrink" select="$line-shrink-cur"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>


    </xsl:template>
</xsl:stylesheet>