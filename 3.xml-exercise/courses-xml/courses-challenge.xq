(: Challenging Set :)

(: Question 1 :)
(: Return the title of the course with the largest enrollment. :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  for $c in $courses
    where $c/@Enrollment = max($courses/@Enrollment)
    return $c/Title

(: Question 2 :)
(: Return course numbers of courses that have the same title as some other course. :)
(: (Hint: You might want to use the "preceding" and "following" navigation axes for :)
(: this query, which were not covered in the video or our demo script; they match any preceding or following node, not just siblings.) :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  for $c in $courses
    where $c/data(Title) = $c/following::*/data(Title) or
      $c/data(Title) = $c/preceding::*/data(Title)
    return $c/data(@Number)

(: Question 3 :)
(: Return the number (count) of courses that have no lecturers as instructors. :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  return count(
    for $c in $courses
      where count($c/Instructors/Lecturer) = 0
      return $c
  )

(: Question 4 :)
(: Return titles of courses taught by the chair of a department. For this question, :)
(: you may assume that all professors have distinct last names. :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  for $c in $courses
    where $c/Instructors/*/Last_Name = $c/parent::Department/Chair/Professor//Last_Name
    return $c/Title

(: Question 5 :)
(: Return titles of courses taught by a professor with the last name "Ng" but not by a professor with the last name "Thrun". :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  for $c2 in (
    for $c in $courses
      where every $name in $c//Professor/Last_Name satisfies $name != 'Thrun'
      return $c 
    )
  where $c2//Professor/Last_Name = 'Ng'
  return $c2/Title

(: Question 6 :)
(: Return course numbers of courses that have a course taught by Eric Roberts as a prerequisite. :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  for $c2 in $courses
  where $c2//data(Prereq) = (
  for $c in $courses
    let $firsts := $c//Instructors/*/First_Name,
        $lasts := $c//Instructors/*/Last_Name
    where $firsts = 'Eric' and $lasts = 'Roberts'
    return $c/data(@Number)
  )
  return $c2/data(@Number)

(: Question 7 :)
(: Create a summary of CS classes: List all CS department courses in order of enrollment. :)
(: For each course include only its Enrollment (as an attribute) and its Title (as a :)
(: subelement). :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Department[@Code = 'CS']/Course
return <Summary> 
  {
    for $c in $courses
      order by xs:int($c/@Enrollment)
      return <Course Enrollment = "{$c/data(@Enrollment)}">{$c/Title}</Course>
  }
  </Summary>

(: Question 8 :)
(: Return a "Professors" element that contains as subelements a listing of all professors :)
(: in all departments, sorted by last name with each professor appearing once. The "Professor" :)
(: subelements should have the same structure as in the original data. For this question, :)
(: you may assume that all professors have distinct last names. Watch out -- the presence/absence :)
(: of middle initials may require some special handling. :)
let $catalog := doc('courses.xml'),
  $professors := $catalog//Professor

let $distinct_prof := (
      $professors except (
        for $p in $professors
          where ($p/Last_Name = $p/following::*/Last_Name and $p/First_Name = $p/following::*/First_Name)
          return $p
      )
    )

return <Professors>
  {
    for $p in $distinct_prof
    order by $p/Last_Name
    return $p
  }
  </Professors>

(: Question 9 :)
(: Expanding on the previous question, create an inverted course listing: Return an :)
(: "Inverted_Course_Catalog" element that contains as subelements professors together :)
(: with the courses they teach, sorted by last name. You may still assume that all professors :)
(: have distinct last names. The "Professor" subelements should have the same structure :)
(: as in the original data, with an additional single "Courses" subelement under Professor, :)
(: containing a further "Course" subelement for each course number taught by that professor. :)
(: Professors who do not teach any courses should have no Courses subelement at all. :)
let $catalog := doc('courses.xml'),
  $professors := $catalog//Professor

let $distinct_prof := (
      $professors except (
        for $p in $professors
          where ($p/Last_Name = $p/following::*/Last_Name and $p/First_Name = $p/following::*/First_Name)
          return $p
      )
    )

let $courses := $catalog//Course
return <Inverted_Course_Catalog>
  {
    for $p in $distinct_prof
      order by $p/Last_Name
      return <Professor>
      { $p/* }
      {
        if ($courses//Professor = $p) 
        then (
          <Courses> {
            for $c in $courses
              where $c//Professor = $p
              return <Course> { $c/data(@Number) } </Course>
          }
          </Courses>
        )
        else (
          for $c in $courses
            where $c//Professor = $p
            return <Course> { $c/data(@Number) } </Course>
        )
      }
      </Professor>
  }
  </Inverted_Course_Catalog>
