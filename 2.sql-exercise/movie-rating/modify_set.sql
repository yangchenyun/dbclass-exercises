-- dbext:type=SQLITE:dbname=movie_rating.db

-- Question 1
-- Add the reviewer Roger Ebert to your database, with an rID of 209.
insert into Reviewer(rID, name)
  values (209, 'Roger Ebert');

-- Reviewer
-- Movie

-- Question 2
-- Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.
insert into Rating
  select Rating.rID, Movie.mID, 5 as stars, null as ratingDate
  from Rating, Movie, Reviewer
  where Rating.rID = Reviewer.rID
  and Reviewer.name = 'James Cameron';

-- Question 3
-- For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)
update Movie
set year = year + 25
where mID in (
  select Movie.mId
  from Movie, Rating
  where Movie.mID = Rating.mID
  group by Movie.mID
  having avg(stars) >= 4
)
;

-- Question 4
-- Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
delete from Rating
where mID in (
  select distinct Rating.mID
  from Movie, Rating
  where Movie.mID = Rating.mID
  and (Movie.year > 2000 or Movie.year < 1970)
)
and stars < 4
;
