<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cdf="http://checklists.nist.gov/xccdf/1.1" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="cdf">

<!-- This transform expects a stringparam "profile" specifying a particular
     XCCDF profile.  It will add references (as defined below) to all Rules
     included in the profile. -->

<xsl:include href="constants.xslt"/>

  <xsl:template match="cdf:Rule">
	<xsl:copy>
	<!-- deal with the fact that references must stand after some other nodes -->
	<xsl:apply-templates select="@*" />
	<xsl:apply-templates select="cdf:title"/>
	<xsl:apply-templates select="cdf:description"/>
	<xsl:apply-templates select="cdf:warning"/>

	<xsl:if test="not(cdf:reference[@href=$disa-cciuri])"> 
		<xsl:variable name="rule_id" select="@id"/>
<!-- this can be uncommented when oscap xccdf resolve passes check-content through -->
<!--		<xsl:for-each select="/cdf:Benchmark/cdf:Profile[@id=$profile]/cdf:select">
			<xsl:if test="@idref=$rule_id"> -->
			  <!-- this block is designed to add a reference to CCI 366 to Rules in a STIG Profile as a default -->
	          <xsl:element name="reference" namespace="http://checklists.nist.gov/xccdf/1.1">
		          <xsl:attribute name="href"><xsl:value-of select="$disa-cciuri"/></xsl:attribute>
		          <xsl:text>366</xsl:text>
	          </xsl:element>
<!--			</xsl:if>
		</xsl:for-each> -->
	</xsl:if> 
	
	<xsl:apply-templates select="node()[not(self::cdf:title|self::cdf:description|self::cdf:warning)]"/>
	</xsl:copy>
  </xsl:template>




  <!-- copy everything else through to final output -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
