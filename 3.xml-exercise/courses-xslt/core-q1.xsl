<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Question 1: Return a list of department titles.  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='/Course_Catalog/Department'>
    <Title>
      <xsl:value-of select='Title'/>
    </Title>
  </xsl:template>
</xsl:stylesheet>
