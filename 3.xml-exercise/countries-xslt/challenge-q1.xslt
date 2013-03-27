<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Create a table using HTML constructs that lists all countries that have more than 3 languages. Each row should contain the country name in bold, population, area, and number of languages. Sort the rows in descending order of number of languages. No header is needed for the table, but use <table border="1"> to make it format nicely, should you choose to check your result in a browser. (Hint: You may find the data-type and order attributes of <xsl:sort> to be useful.)  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='/countries'>
    <html>
      <table border='1'>
        <xsl:for-each select='country[count(language) &gt; 3]'>
        <xsl:sort order='descending' select='count(language)'/>
          <tr>
            <td><b><xsl:value-of select='data(@name)'/></b></td>
            <td><xsl:value-of select='data(@population)'/></td>
            <td><xsl:value-of select='data(@area)'/></td>
            <td><xsl:value-of select='count(language)'/></td>
          </tr>
        </xsl:for-each>
      </table>
    </html>
  </xsl:template>

  <xsl:template match='text()' />
</xsl:stylesheet>
