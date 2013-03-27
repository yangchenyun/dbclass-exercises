(: Extra Set :)

(: Question 1 :)
(: Return the course number of the course that is cross-listed as "LING180". :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  return $courses[contains(Description, 'LING180')]/data(@Number)

(: Question 2 :)
(: Return course numbers of courses taught by an instructor with first name "Daphne" :)
(: or "Julie". :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  for $c in $courses
    where $c/Instructors/child::*/First_Name = 'Daphne' 
    or $c/Instructors/child::*/First_Name = 'Julie' 
    return $c/data(@Number)

(: Question 3 :)
(: Return titles of courses that have both a lecturer and a professor as instructors. :)
(: Return each title only once. :)
let $catalog := doc('courses.xml'),
  $courses := $catalog//Course
  for $c in $courses
    where count($c//Professor) > 0
    and count($c//Lecturer) > 0
    return $c/Title
