-- dbext:type=SQLITE:dbname=movie_rating.db

-- Question 1
-- Find the names of all reviewers who rated Gone with the Wind.
select distinct name
from Reviewer, Movie, Rating
where Reviewer.rID = Rating.rID 
and Rating.mID = Movie.mID
and title = 'Gone with the Wind';
        
-- Question 2
-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
select distinct name, title, stars
from Reviewer, Movie, Rating
where Reviewer.rID = Rating.rID 
and Rating.mID = Movie.mID
and name = director;
        
-- Question 3
-- Return all reviewer names and movie names together in a single list, alphabetized.  (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
select name
from ( 
  select name
  from Reviewer
  union
  select title as name
  from Movie
) as Name
order by name
;
        
-- Question 4
-- Find the titles of all movies not reviewed by Chris Jackson.
select distinct title
from Movie
except
select distinct title
from Reviewer, Movie, Rating
where Reviewer.rID = Rating.rID 
and Rating.mID = Movie.mID
and name = 'Chris Jackson';
        
-- Question 5
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
select distinct name1, name2
from ( select R1.rID, Re1.name as name1, R2.rID, Re2.name as name2, R1.mID
from Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
where R1.mID = R2.mID
and R1.rID = Re1.rID
and R2.rID = Re2.rID
and Re1.name <> Re2.name
order by Re1.name ) as Pair
where name1 < name2
;

-- Question 6
-- For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
select name, title, stars
from Reviewer, Movie, Rating
where stars is ( select min(stars) from Rating)
and Reviewer.rID = Rating.rID 
and Rating.mID = Movie.mID
;
