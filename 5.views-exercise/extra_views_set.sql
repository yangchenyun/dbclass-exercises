-- dbext:type=SQLITE:dbname=movie_rating.db

create view LateRating as 
  select distinct R.mID, title, stars, ratingDate 
  from Rating R, Movie M 
  where R.mID = M.mID 
  and ratingDate > '2011-01-20' 
;

create view HighlyRated as 
  select mID, title 
  from Movie 
  where mID in (select mID from Rating where stars > 3) 
;

create view NoRating as 
  select mID, title 
  from Movie 
  where mID not in (select mID from Rating) 
;

--  Question 1
--  Write an instead-of trigger that enables deletions from view NoRating. 
--  Policy: Deletions from view NoRating should delete the corresponding movie from the Movie table.
create trigger deleteNoRating
instead of delete on NoRating
for each row
begin
  delete from Movie
  where Movie.mID = Old.mID;
end

--  Question 2
--  Write an instead-of trigger that enables deletions from view NoRating. 
--  Policy: Deletions from view NoRating should add a new rating for the deleted movie with rID = 201, stars = 1, and NULL ratingDate.
create trigger deleteNoRating
instead of delete on NoRating
for each row
begin
  insert into Rating values (201, Old.mID, 1, NULL);
end
