<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Create an HTML table with one-pixel border that lists all CS department courses with enrollment greater than 200. Each row should contain three cells: the course number in italics, course title in bold, and enrollment. Sort the rows alphabetically by course title. No header is needed. (Note: For formatting, just use "table border=1", and "<b>" and "<i>" tags for bold and italics respectively. To specify quotes within an already-quoted XPath expression, use &quot;.)  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='//Department[@Code = "CS"]'>
    <table border='1'>
      <xsl:for-each select='Course[@Enrollment > 200]'>
        <xsl:sort select='data(Title)'/>
        <tr>
          <td><i><xsl:value-of select='data(@Number)'/></i></td>
          <td><b><xsl:value-of select='Title'/> </b></td>
          <td><xsl:value-of select='data(@Enrollment)'/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match='text()' />
</xsl:stylesheet>
