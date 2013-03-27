(: Core Set :)

(: Question 1 :)

(: Return all Title elements (of both departments and courses). :)
let $catalog := doc('courses.xml')
return $catalog//Title

(: Question 2 :)

(: Return last names of all department chairs. :)
let $catalog := doc('courses.xml')
return $catalog/Course_Catalog/Department/Chair//Last_Name

(: Question 3 :)

(: Return titles of courses with enrollment greater than 500 . :)
let $catalog := doc('courses.xml')
return $catalog//Course[@Enrollment > 500]/Title

(: Question 4 :)

(: Return titles of departments that have some course that takes "CS106B" as a prerequisite. :)
let $catalog := doc('courses.xml')
return $catalog/Course_Catalog/Department[Course//Prereq = "CS106B"]/Title

(: Question 5 :)

(: Return last names of all professors or lecturers who use a middle initial. Don't :)
(: worry about eliminating duplicates. :)
let $catalog := doc('courses.xml')
return $catalog//Middle_Initial/parent::*/Last_Name

(: Question 6 :)

(: Return the count of courses that have a cross-listed course (i.e., that have "Cross-listed" :)
(: in their description). :)
let $catalog := doc('courses.xml')
return count($catalog//Course[contains(Description, "Cross-listed")])

(: Question 7 :)

(: Return the average enrollment of all courses in the CS department. :)
let $catalog := doc('courses.xml')
return sum($catalog//Department[@Code = "CS"]/Course/@Enrollment) div count($catalog//Department[@Code = "CS"]/Course)

(: Question 8 :)

(: Return last names of instructors teaching at least one course that has "system" :)
(: in its description and enrollment greater than 100. :)
let $catalog := doc('courses.xml')
return $catalog//Course[contains(Description, "system") and @Enrollment > 100]/Instructors//Last_Name
