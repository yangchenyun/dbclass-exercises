<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Remove from the data all countries with area greater than 40,000 and all countries with no cities listed. Otherwise the structure of the data should be the same.  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='/'>
    <countries>
    <xsl:for-each select="countries/country">
      <!-- use 'and' to compose compound conditions and not() to negate test -->
      <xsl:if test='count(city) > 0 and not(@area > 40000)' >
        <xsl:copy-of select='.' />
      </xsl:if>
    </xsl:for-each>
    </countries>
  </xsl:template>

  <xsl:template match='text()' />
</xsl:stylesheet>
