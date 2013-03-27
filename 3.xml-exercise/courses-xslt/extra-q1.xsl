<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Return all courses with enrollment greater than 500. Retain the structure of Course elements from the original data.  -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='Course'>
    <xsl:if test='@Enrollment > 500'>
      <xsl:copy-of select='.'/>
    </xsl:if>
  </xsl:template>
  <xsl:template match='text()'/>
</xsl:stylesheet>
