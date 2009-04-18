<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

	xmlns:x2="http://www.w3.org/2002/06/xhtml2/"
	exclude-result-prefixes="x2"

	xmlns="http://www.w3.org/1999/xhtml"
>
	<xsl:output method="xml" indent="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	/>

	<!-- BEGIN Links -->
	<xsl:template name="link">
		<xsl:param name="level" select="1"/>
		<xsl:param name="elementName" select="local-name()"/>

		<xsl:element name="{$elementName}">
			<xsl:apply-templates select="@*" mode="outputAttrs"/>
			<xsl:if test="@href">
				<xsl:attribute name="href">
					<xsl:value-of select="@href"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="child::node()">
				<xsl:with-param name="level" select="$level"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

<!-- WTF why it doesnt work?
	<xsl:template match="x2:link" mode="links">
		<xsl:call-template name="link"/>
	</xsl:template>

	<xsl:template match="x2:a" mode="links">
		<xsl:call-template name="link"/>
	</xsl:template>
-
	<xsl:template match="x2:span[@href]" mode="links">
		<xsl:call-template name="link">
			<xsl:with-param name="elementName" select="'a'"/>
		</xsl:call-template>
	</xsl:template>
-->

	<xsl:template match="x2:*[@href]" mode="links">
		<xsl:param name="level" select="1"/>

		<xsl:choose>
			<xsl:when test="local-name() = 'link'">
				<xsl:call-template name="link">
					<xsl:with-param name="level" select="$level"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="local-name() = 'a'">
				<xsl:call-template name="link">
					<xsl:with-param name="level" select="$level"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="local-name() = 'span'">
				<xsl:call-template name="link">
					<xsl:with-param name="elementName" select="'a'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="@href"/>
					</xsl:attribute>
					<xsl:apply-templates select="(.)" mode="objects">
						<xsl:with-param name="level" select="$level"/>
					</xsl:apply-templates>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="links">
		<xsl:param name="level" select="1"/>

		<xsl:apply-templates select="(.)" mode="objects">
			<xsl:with-param name="level" select="$level"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="@href|@hreflang" mode="outputAttrs"/>
	<!-- END Links -->

	<!-- BEGIN Objects -->
	<xsl:template name="image">
		<img>
			<xsl:apply-templates select="@*" mode="outputAttrs"/>
			<xsl:attribute name="alt"><xsl:value-of select="text()"/></xsl:attribute>
		</img>
	</xsl:template>

	<xsl:template match="object[@src]" mode="objects">
		<xsl:param name="level" select="1"/>

		<xsl:choose>
			<xsl:when test="@srctype and starts-with(@srctype, 'image') and (count(*) = 0)">
				<xsl:call-template name="image"/>
			</xsl:when>
			<xsl:otherwise>
				<object>
					<xsl:apply-templates select="@*" mode="outputAttrs"/>
					<xsl:attribute name="data"><xsl:value-of select="@src"/></xsl:attribute>
					<xsl:if test="@srctype">
						<xsl:attribute name="type"><xsl:value-of select="@srctype"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="node()">
						<xsl:with-param name="level" select="$level"/>
					</xsl:apply-templates>
				</object>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[@src]" mode="objects">
		<xsl:param name="level" select="1"/>

		<xsl:choose>
			<xsl:when test="@srctype and starts-with(@srctype, 'image') and (count(*) = 0)">
				<xsl:call-template name="image"/>
			</xsl:when>
			<xsl:otherwise>
				<object>
					<xsl:attribute name="data"><xsl:value-of select="@src"/></xsl:attribute>
					<xsl:if test="@srctype">
						<xsl:attribute name="type"><xsl:value-of select="@srctype"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="(.)" mode="outputElement">
						<xsl:with-param name="level" select="$level"/>
					</xsl:apply-templates>
				</object>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="objects">
		<xsl:param name="level" select="1"/>

		<xsl:apply-templates select="(.)" mode="outputElement">
			<xsl:with-param name="level" select="$level"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="@src|@srctype" mode="outputAttrs"/>
	<!-- END Objects -->

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*">
		<xsl:param name="level" select="1"/>

		<xsl:apply-templates select="(.)" mode="links">
			<xsl:with-param name="level" select="$level"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="x2:h" mode="outputElement">
		<xsl:param name="level" select="1"/>

		<xsl:element name="h{$level}">
			<xsl:apply-templates select="@*" mode="outputAttrs"/>
			<xsl:if test="@class">
				<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="node()">
				<xsl:with-param name="level" select="$level"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<xsl:template match="x2:section" mode="outputElement">
		<xsl:param name="level" select="1"/>

		<xsl:element name="div">
			<xsl:apply-templates select="@*" mode="outputAttrs"/>
			<xsl:attribute name="class">section l<xsl:value-of select="$level"/> <xsl:value-of select="@class"/></xsl:attribute>

			<xsl:apply-templates select="node()">
				<xsl:with-param name="level" select="$level + 1"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*" mode="outputElement">
		<xsl:param name="level" select="1"/>

		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="@*" mode="outputAttrs"/>
			<xsl:if test="@class">
				<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="node()">
				<xsl:with-param name="level" select="$level"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@xml:id" mode="outputAttrs">
		<xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>

	<xsl:template match="@class" mode="outputAttrs"/>

	<xsl:template match="@*" mode="outputAttrs">
		<xsl:copy-of select="."/>
	</xsl:template>

</xsl:stylesheet>

