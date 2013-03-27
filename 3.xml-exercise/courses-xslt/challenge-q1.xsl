<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- Create a summarized version of the EE part of the course catalog. For each course in EE, return a Course element, with its Number and Title as attributes, its Description as a subelement, and the last name of each instructor as an Instructor subelement. Discard all information about department titles, chairs, enrollment, and prerequisites, as well as all courses in departments other than EE. (Note: To specify quotes within an already-quoted XPath expression, use &quot;.)  -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match='//Department[@Code = "EE"]/Course'>
    <Course
      Number='{data(@Number)}'
      Title='{Title}'
      > 
      <xsl:copy-of select='Description' />
      <xsl:for-each select='Instructors/*'>
        <Instructor><xsl:value-of select='Last_Name'/></Instructor>
      </xsl:for-each>
    </Course>
  </xsl:template>

  <!-- all templates will be applied so make the selection carefully -->

  <xsl:template match='text()' />
</xsl:stylesheet>
