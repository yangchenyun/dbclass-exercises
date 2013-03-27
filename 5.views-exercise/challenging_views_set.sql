-- dbext:type=SQLITE:dbname=movie_rating.db

--  Question 1
--  Write a single instead-of trigger that enables simultaneous updates to attributes mID, title, and/or stars in view LateRating. Combine the view-update policies of the questions 1-3 in the core set, with the exception that mID may now be updated. Make sure the ratingDate attribute of view LateRating has not also been updated -- if it has been updated, don't make any changes.
create view LateRating as 
  select distinct R.mID, title, stars, ratingDate 
  from Rating R, Movie M 
  where R.mID = M.mID 
  and ratingDate > '2011-01-20' 
;

create trigger UpdateAllLateRating
instead of update on LateRating
for each row
when New.ratingDate = Old.ratingDate
begin
  --  update the title
  update Movie
  set title = New.title, mID = New.mID
  where mID = Old.mID;

  update Rating
  set mID = New.mID
  where mID = Old.mID;

  --  only update the stars belongs to the views
  update Rating
  set stars = New.stars
  --  mID has been updated
  where mID = New.mID
  --  [mID, ratingDate] forms a key
  and ratingDate = Old.ratingDate
  and ratingDate > '2011-01-20';
end


--  Question 2
--  Write an instead-of trigger that enables insertions into view HighlyRated. 
--  Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie table. (Otherwise, do nothing.) Insertions into view HighlyRated should add a new rating for the inserted movie with rID = 201, stars = 5, and NULL ratingDate.
create view HighlyRated as 
  select mID, title 
  from Movie 
  where mID in (select mID from Rating where stars > 3) 
;

create trigger InsertIntoHighlyRate
instead of insert on HighlyRated
for each row
when exists (select * from Movie where mID = New.mID and title = New.title)
begin
  insert into Rating values (201, New.mID, 5, null);
end

--  Question 3
--  Write an instead-of trigger that enables insertions into view NoRating. 
--  Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie table. (Otherwise, do nothing.) Insertions into view NoRating should delete all ratings for the corresponding movie.
create view NoRating as 
  select mID, title 
  from Movie 
  where mID not in (select mID from Rating) 
;

create trigger InsertIntoNoRating
instead of insert on NoRating
for each row
when exists (select * from Movie where mID = New.mID and title = New.title)
begin
  delete from Rating
  where mID = New.mID;
end
