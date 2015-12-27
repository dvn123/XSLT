<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	xmlns="http://www.w3.org/2000/svg">
    <xsl:template match="document">
        <xsl:variable name="width"><xsl:value-of select="/document/@width"/></xsl:variable>
        <xsl:variable name="height"><xsl:value-of select="/document/@height"/></xsl:variable>
        <svg>
            <xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
            <rect style="fill:none;stroke-width:1;stroke:rgb(0,0,0);">
                <xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
                <xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
            </rect>
            <xsl:apply-templates select="node()"/>
        </svg>
    </xsl:template>

    <xsl:template match="paragraph">
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

        <g>
            <xsl:attribute name="font-family"><xsl:value-of select="'monospace'" /></xsl:attribute>
            <xsl:attribute name="style"><xsl:value-of select="concat('font-size:', $font-size)" /></xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </g>
    </xsl:template>

    <xsl:template match="paragraph/line">
        <xsl:variable name="font-size">
            <xsl:choose>
                <xsl:when test="not(../@font-size)">
                    <xsl:value-of select="/document/@font-size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="../@font-size"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <text>
            <!--<xsl:variable name="d"><xsl:value-of select="@position"/></xsl:variable>
            <xsl:for-each select="*">
                <c><xsl:value-of select="$d"/></c>
            </xsl:for-each>-->
            <xsl:call-template name="recursive">
                <xsl:with-param name="node-set" select="*"/>
                <xsl:with-param name="font-size" select="$font-size" />
                <xsl:with-param name="ratio" select="@ratio" />
                <xsl:with-param name="line-n" select="@position" />
            </xsl:call-template>
        </text>
    </xsl:template>


    <xsl:template name="recursive">
        <xsl:param name="node-set"/>
        <xsl:param name="font-size"/>
        <xsl:param name="current-x" select="0" />
        <xsl:param name="ratio" />
        <xsl:param name="spaces-width" select="0" />
        <xsl:param name="line-n"/>

        <xsl:choose>
            <xsl:when test="name($node-set[1]) = 'box'">
                <tspan>
                    <xsl:attribute name="x">
                        <xsl:value-of select="$current-x + $spaces-width"/>
                    </xsl:attribute>
                    <xsl:attribute name="y">
                        <xsl:value-of select="$line-n * $font-size"/>
                    </xsl:attribute>
                    <xsl:attribute name="y2">
                        <xsl:value-of select="$line-n"/>
                    </xsl:attribute>
                    <xsl:attribute name="textLength">
                        <xsl:value-of select="$node-set[1]/@width"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space($node-set[1])" />
                </tspan>
                <xsl:variable name="next-x">
                    <xsl:value-of select="$current-x + $node-set[1]/@width" />
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="$node-set[2]/@position">
                        <xsl:call-template name="recursive">
                            <xsl:with-param name="node-set" select="$node-set[position() != 1]"/>
                            <xsl:with-param name="ratio" select="$ratio" />
                            <xsl:with-param name="font-size" select="$font-size" />
                            <xsl:with-param name="current-x" select="$next-x" />
                            <xsl:with-param name="spaces-width" select="0" />
                            <xsl:with-param name="line-n" select="$line-n"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>

            </xsl:when>
            <xsl:when test="name($node-set[1]) = 'glue'">
                <xsl:variable name="spaces-widthv">
                    <xsl:choose>
                        <xsl:when test="$ratio > 0">
                            <xsl:value-of select="$node-set[1]/@width + $ratio*$node-set[1]/@stretchability" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$node-set[1]/@width + $ratio*$node-set[1]/@shrinkability" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="$node-set[2]/@position">
                        <xsl:call-template name="recursive">
                            <xsl:with-param name="node-set" select="$node-set[position() != 1]"/>
                            <xsl:with-param name="ratio" select="$ratio" />
                            <xsl:with-param name="font-size" select="$font-size" />
                            <xsl:with-param name="current-x" select="$current-x" />
                            <xsl:with-param name="spaces-width" select="$spaces-widthv" />
                            <xsl:with-param name="line-n" select="$line-n"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>