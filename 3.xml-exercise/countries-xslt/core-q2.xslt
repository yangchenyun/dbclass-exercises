<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Find all country names containing the string "stan"; return each one within a "Stan" element. (Note: To specify quotes within an already-quoted XPath expression, use &quot;.)  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='country[contains(@name, "stan")]'>
    <Stan>
      <xsl:value-of select='data(@name)'/>
    </Stan>
  </xsl:template>

  <xsl:template match='text()' />
</xsl:stylesheet>
