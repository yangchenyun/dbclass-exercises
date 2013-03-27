<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Delete from the data all courses with enrollment greater than 60, or with no enrollment listed. Otherwise the structure of the data should be the same.  -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='@*|node()'>
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match='Course[@Enrollment &gt; 60]' />
  <xsl:template match='Course[count(@Enrollment) &lt; 1]' />

</xsl:stylesheet>
