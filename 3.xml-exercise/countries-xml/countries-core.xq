(: Core Set :)

(: Question 1 :)
(: Return the area of Mongolia. :)
(: Reminder: To return the value of an attribute attr, you must use data(@attr), :)
(: although just @attr may be used in comparisons. You will need to remember this :)
(: for some later questions as well. :)
let $countries := doc('countries.xml')/countries
return $countries/*[@name = 'Mongolia']/data(@area)

(: Question 2 :)
(: Return the names of all cities that have the same name as the country in which they are located. :)
let $countries := doc('countries.xml')/countries
return $countries//city[name = parent::country/data(@name)]/name

(: Question 3 :)
(: Return the average population of Russian-speaking countries. :)
let $countries := doc('countries.xml')/countries
return avg($countries//country[language = 'Russian']/data(@population))

(: Question 4 :)
(: Return the names of all countries where over 50% of the population speaks German. :)
(: (Hint: Depending on your solution, you may want to use ".", which refers to the "current # element" within an XPath expression.) :)
let $countries := doc('countries.xml')/countries
return $countries//language[data(.) = 'German' and @percentage > 50]/parent::country/data(@name)

(: Question 5 :)
(: Return the name of the country with the highest population. (Hint: You may need :)
(: to explicitly cast population numbers as integers with xs:int() to get the correct :)
(: answer.) :)
let $countries := doc('countries.xml')/countries
return $countries/*[@population =  max($countries/country/data(@population))]/data(@name)
