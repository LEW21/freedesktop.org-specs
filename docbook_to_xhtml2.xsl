<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

	xmlns="http://www.w3.org/2002/06/xhtml2/"
>
	<xsl:output method="xml" indent="yes"
		doctype-public="-//W3C//DTD XHTML 2.0//EN"
		doctype-system="http://www.w3.org/MarkUp/DTD/xhtml2.dtd"
	/>

	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="literal"/>

	<xsl:template match="@id">
		<xsl:attribute name="xml:id"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>

	<xsl:template match="/">
		<html xmlns="http://www.w3.org/2002/06/xhtml2/" xml:lang="en">
			<head>
				<xsl:apply-templates select="node()" mode="head"/>
			</head>
			<body>
				<xsl:apply-templates select="node()"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="articleinfo" mode="head">
		<title><xsl:value-of select="title"/></title>
	</xsl:template>

	<xsl:template match="text()" mode="head"/>

	<xsl:template match="title">
		<h><xsl:value-of select="."/></h>
	</xsl:template>

	<xsl:template match="sect1">
		<section>
			<xsl:apply-templates select="node()"/>
		</section>
	</xsl:template>

	<xsl:template match="sect2">
		<section>
			<xsl:apply-templates select="node()"/>
		</section>
	</xsl:template>

	<xsl:template match="sect3">
		<section>
			<xsl:apply-templates select="node()"/>
		</section>
	</xsl:template>

	<xsl:template match="para">
		<p>
			<xsl:apply-templates select="node()"/>
		</p>
	</xsl:template>

	<xsl:template match="segmentedlist[title]">
		<section>
			<h><xsl:value-of select="title"/></h>
			<dl>
				<xsl:apply-templates select="node()" mode="dl"/>
			</dl>
		</section>
	</xsl:template>

	<xsl:template match="segmentedlist[not(title)]">
		<dl>
			<xsl:apply-templates select="node()" mode="dl"/>
		</dl>
	</xsl:template>

	<xsl:template match="title" mode="dl"/>

	<xsl:template match="seglistitem" mode="dl">
		<di>
			<dt><xsl:apply-templates select="seg[1]/node()"/></dt>
			<dd><xsl:apply-templates select="seg[position() > 1]/node()"/></dd>
		</di>
	</xsl:template>

	<xsl:template match="segtitle" mode="dl"/>

	<xsl:template match="itemizedlist">
		<ul>
			<xsl:apply-templates select="node()"/>
		</ul>
	</xsl:template>

	<xsl:template match="listitem">
		<li>
			<xsl:apply-templates select="node()"/>
		</li>
	</xsl:template>

	<xsl:template match="listitem[count(para) = 1]">
		<li>
			<xsl:apply-templates select="para/node()"/>
		</li>
	</xsl:template>

	<xsl:template match="table[title]">
		<section>
			<h><xsl:value-of select="title"/></h>
			<table>
				<xsl:apply-templates select="node()" mode="table"/>
			</table>
		</section>
	</xsl:template>

	<xsl:template match="table[not(title)]">
		<table>
			<xsl:apply-templates select="node()" mode="table"/>
		</table>
	</xsl:template>

	<xsl:template match="informaltable[title]">
		<section>
			<h><xsl:value-of select="title"/></h>
			<table>
				<xsl:apply-templates select="node()" mode="table"/>
			</table>
		</section>
	</xsl:template>

	<xsl:template match="informaltable[not(title)]">
		<table>
			<xsl:apply-templates select="node()" mode="table"/>
		</table>
	</xsl:template>

	<xsl:template match="title" mode="table"/>

	<xsl:template match="thead" mode="table">
		<thead>
			<xsl:apply-templates select="node()" mode="table"/>
		</thead>
	</xsl:template>

	<xsl:template match="tbody" mode="table">
		<tbody>
			<xsl:apply-templates select="node()" mode="table"/>
		</tbody>
	</xsl:template>

	<xsl:template match="tfoot" mode="table">
		<tfoot>
			<xsl:apply-templates select="node()" mode="table"/>
		</tfoot>
	</xsl:template>

	<xsl:template match="row" mode="table">
		<tr>
			<xsl:apply-templates select="node()" mode="table-row"/>
		</tr>
	</xsl:template>

	<xsl:template match="entry" mode="table-row">
		<td>
			<xsl:apply-templates select="node()"/>
		</td>
	</xsl:template>

	<xsl:template match="xref">
		<xsl:variable name="id" select="@linkend"/>
		<a>
			<xsl:attribute name="href">#<xsl:value-of select="$id"/></xsl:attribute>
			<xsl:text>[</xsl:text><xsl:value-of select="//*[@id = $id]/@xreflabel"/><xsl:text>]</xsl:text>
		</a>
	</xsl:template>

	<xsl:template match="ulink">
		<a>
			<xsl:attribute name="href">#<xsl:value-of select="@url"/></xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>

	<xsl:template match="literal">
		<var>
			<xsl:apply-templates select="node()"/>
		</var>
	</xsl:template>

	<xsl:template match="function">
		<var>
			<xsl:apply-templates select="node()"/>
		</var>
	</xsl:template>

	<xsl:template match="parameter">
		<var>
			<xsl:apply-templates select="node()"/>
		</var>
	</xsl:template>

	<xsl:template match="emphasis">
		<em>
			<xsl:apply-templates select="node()"/>
		</em>
	</xsl:template>

	<xsl:template match="replaceable">
		<samp>
			<xsl:apply-templates select="node()"/>
		</samp>
	</xsl:template>

	<xsl:template match="funcprototype">
		<code class="funcdef">
			<xsl:value-of select="funcdef"/>
			<xsl:text> (</xsl:text>
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="name() = 'funcdef'"/>
					<xsl:when test="name() = 'varargs'">...</xsl:when>
					<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
				</xsl:choose>
				<xsl:if test="name() != 'funcdef'"><xsl:if test="position() != last()">, </xsl:if></xsl:if>
			</xsl:for-each>
			<xsl:text>)</xsl:text>
		</code>
	</xsl:template>

	<xsl:template match="note[count(para) = 1]">
		<p class="note">
			<strong>Note:</strong>
			<xsl:apply-templates select="para/node()"/>
		</p>
	</xsl:template>

	<xsl:template match="note[count(para) != 1]">
		<div class="note">
			<strong>Note:</strong>
			<xsl:apply-templates select="node()"/>
		</div>
	</xsl:template>

	<xsl:template match="sgmltag">
		<code>
			<xsl:text>&lt;</xsl:text>
			<xsl:if test="@class = 'endtag'">/</xsl:if>
			<xsl:apply-templates select="node()"/>
			<xsl:if test="@class = 'emptytag'">/</xsl:if>
			<xsl:text>&gt;</xsl:text>
		</code>
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
</xsl:stylesheet>
