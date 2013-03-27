-- dbext:type=SQLITE:dbname=movie_rating.db

-- Question 1
-- find the titles of all movies directed by steven spielberg
select title
from Movie
where director='Steven Spielberg';

-- Question 2
-- Find all years that have a movie that received a rating of 4 or 5, 
-- and sort them in increasing order. 

select distinct year
from Movie, Rating
where Rating.mID = Movie.mID and stars >= 4
order by YEar;

-- Question 3
-- Find the titles of all movies that have no ratings.
select title
from Movie
where mID not in (select mID 
                  from Rating)
;

-- Question 4
-- Some reviewers didn't provide a date with their rating. 
-- Find the names of all reviewers who have ratings with a NULL value for the date. 
select distinct name
from Reviewer, Rating
where Reviewer.rID = Rating.rID and ratingDate is NULL;

-- Question 5

-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
select name, title, stars, ratingDate
from Movie, Rating, Reviewer
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
order by name, title, stars;

-- Question 6
-- For all cases where the same reviewer rated the same movie twice and 
-- gave it a higher rating the second time, return the reviewer's name and the title of the movie.

select name, title
from Movie, Reviewer, (select R1.rID, R1.mID
  from Rating R1, Rating R2
  where R1.rID = R2.rID 
  and R1.mID = R2.mID
  and R1.stars < R2.stars
  and R1.ratingDate < R2.ratingDate) C
where Movie.mID = C.mID
and Reviewer.rID = C.rID;

-- Question 7
-- For each movie that has at least one rating, 
-- find the highest number of stars that movie received. 
-- Return the movie title and number of stars. Sort by movie title. 
select title, stars
from Movie, ( select Movie.mID, stars
              from Movie, Rating
              where Movie.mID = Rating.mID
              except
              select R1.mID, R1.stars
              from Rating R1, Rating R2
              where R1.mID = R2.mID
              and R1.stars < R2.stars) Stars
where Movie.mID = Stars.mID
order by title;

-- Question 8
-- List movie titles and average ratings, 
-- from highest-rated to lowest-rated. 
-- If two or more movies have the same average rating, list them in alphabetical order. 
select title, stars
from Movie, ( select mID, avg(stars) as stars
              from Rating
              group by mID ) AvgRating
where Movie.mID = AvgRating.mID
order by stars DESC, title;

-- Question 9
-- Find the names of all reviewers who have contributed three or more ratings. 
-- (As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from Reviewer, ( select rID, count(stars) as count
                 from Rating
                 group by rID ) RateCount
where Reviewer.rID = RateCount.rID
and RateCount.count >= 3;

-- challenging solution
select name
from Reviewer, (
  select distinct R1.rID
  from Rating R1, Rating R2, Rating R3
  where R1.rID = R2.rID and (R1.mID <> R2.mID or R1.ratingDate <> R2.ratingDate)
  and R1.rID = R3.rID and (R1.mID <> R3.mID or R1.ratingDate <> R3.ratingDate)
  and R3.rID = R2.rID and (R3.mID <> R2.mID or R3.ratingDate <> R2.ratingDate)
) ActiveUser
where Reviewer.rID = ActiveUser.rID
;
