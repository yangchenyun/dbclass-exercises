(: # Extra Set :)

(: Question 1 :)
(: Return the names of all countries with population greater than 100 million. :)
let $countries := doc('countries.xml')/countries/country
for $c in $countries
  where $c/data(@population) > 100000000
  return $c/data(@name)

(: Question 2 :)
(: Return the names of all countries where a city in that country contains more than :)
(: one-third of the country's population. :)
let $countries := doc('countries.xml')/countries/country
for $c in $countries
  for $city in $c/city
    where $city/population * 3 > $c/data(@population) 
    return $c/data(@name)

(: Question 3 :)
(: Return the population density of Qatar. Note: Since the "/" operator has its own :)
(: meaning in XPath and XQuery, the division operator is "div". To compute population :)
(: density use "(@population div @area)". :)
let $countries := doc('countries.xml')/countries/country
return $countries[@name = 'Qatar']/(@population div @area)

(: Question 4 :)
(: Return the names of all countries whose population is less than one thousandth that :)
(: of some city (in any country). :)
let $countries := doc('countries.xml')/countries/country,
  $cities := $countries/city
for $c in $countries
  where some $city in $cities satisfies $c/@population < $city/population div 1000
  return $c/data(@name)

(: Question 5 :)
(: Return all city names that appear more than once, i.e., there is more than one city :)
(: with that name in the data. Return only one instance of each such city name. (Hint: :)
(: You might want to use the "preceding" and/or "following" navigation axes for this :)
(: query, which were not covered in the video or our demo script; they match any preceding :)
(: or following node, not just siblings.) :)
let $countries := doc('countries.xml')/countries/country,
  $cities := $countries/city
for $city in $cities
  where $city/name = $city/preceding::city/name
  return $city/name

(: Question 6 :)
(: Return the names of all countries whose name textually contains a language spoken :)
(: in that country. For instance, Uzbek is spoken in Uzbekistan, so return Uzbekistan. :)
(: (Hint: You may want to use ".", which refers to the "current element" within an XPath :)
(: expression.) :)
let $countries := doc('countries.xml')/countries/country
 for $c in $countries
   where some $l in $c/language satisfies contains($c/@name, $l)
   return $c/data(@name)

(: Question 7 :)
(: Return the names of all countries in which people speak a language whose name textually :)
(: contains the name of the country. For instance, Japanese is spoken in Japan, so return :)
(: Japan. (Hint: You may want to use ".", which refers to the "current element" within :)
(: an XPath expression.) :)
let $countries := doc('countries.xml')/countries/country
for $c in $countries
  where some $l in $c/language satisfies contains($l, $c/@name)
  return $c/data(@name)

(: Question 8 :)
(: Return all languages spoken in a country whose name textually contains the language :)
(: name. For instance, German is spoken in Germany, so return German. (Hint: Depending :)
(: on your solution, may want to use data(.), which returns the text value of the "current :)
(: element" within an XPath expression.) :)
let $countries := doc('countries.xml')/countries/country,
  $languages := $countries/language
for $l in $languages
  where contains($l/parent::country/@name, $l)
  return $l/data(.)

(: Question 9 :)
(: Return all languages whose name textually contains the name of a country in which :)
(: the language is spoken. For instance, Icelandic is spoken in Iceland, so return Icelandic. :)
(: (Hint: Depending on your solution, may want to use data(.), which returns the text :)
(: value of the "current element" within an XPath expression.) :)
let $countries := doc('countries.xml')/countries/country,
  $languages := $countries/language
for $l in $languages
  where contains($l, $l/parent::country/@name)
  return $l/data(.)

(: Question 10 :)
(: Return the number of countries where Russian is spoken. :)
let $countries := doc('countries.xml')/countries/country
return count($countries[language = 'Russian'])

(: Question 11 :)
(: Return the names of all countries for which the data does not include any languages :)
(: or cities, but the country has more than 10 million people. :)
let $countries := doc('countries.xml')/countries/country
return $countries[count(language) = 0 and count(city) = 0 and @population > 10000000]/data(@name)

(: Question 12 :)
(: Return the name of the country that has the city with the highest population. (Hint: :)
(: You may need to explicitly cast population numbers as integers with xs:int() to get :)
(: the correct answer.) :)
let $countries := doc('countries.xml')/countries/country,
  $cities := $countries/city
for $c in $cities
  where $c/xs:int(population) = max($cities/xs:int(population))
  return $c/parent::country/data(@name)
