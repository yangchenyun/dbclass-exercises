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
--  Write an instead-of trigger that enables updates to the title attribute of view LateRating. 
--  Policy: Updates to attribute title in LateRating should update Movie.title for the corresponding movie. (You may assume attribute mID is a key for table Movie.) Make sure the mID attribute of view LateRating has not also been updated -- if it has been updated, don't make any changes. Don't worry about updates to stars or ratingDate.

create trigger LateRatingTitleUpdate
instead of update of title on LateRating
for each row
begin
  update Movie
  set title = New.title
  where mID = New.mID;
end;

--  Question 2
--  Write an instead-of trigger that enables updates to the stars attribute of view LateRating. 
--  Policy: Updates to attribute stars in LateRating should update Rating.stars for the corresponding movie rating. (You may assume attributes [mID,ratingDate] together are a key for table Rating.) Make sure the mID and ratingDate attributes of view LateRating have not also been updated -- if either one has been updated, don't make any changes. Don't worry about updates to title.

create trigger LateRatingStarUpdate
instead of update of stars on LateRating
for each row
begin
  update Rating
  set stars = New.stars
  where mID = New.mID
  and New.mID = Old.mID
  and New.ratingDate = Old.ratingDate
  and ratingDate > '2011-01-20';
end;

--  Question 3
--  Write an instead-of trigger that enables updates to the mID attribute of view LateRating. 
--  Policy: Updates to attribute mID in LateRating should update Movie.mID and Rating.mID for the corresponding movie. Update all Rating tuples with the old mID, not just the ones contributing to the view. Don't worry about updates to title, stars, or ratingDate.
create trigger LateRatingIDUpdate
instead of update of mID on LateRating
for each row
begin
  update Movie
  set mID = New.mID
  where mID = Old.mID;

  update Rating
  set mID = New.mID
  where mID = Old.mID;
end;

--  Question 4
--  Write an instead-of trigger that enables deletions from view HighlyRated. 

create trigger HighlyRatedDelete
instead of delete on HighlyRated
for each row
begin
  delete from Rating
  where mID = Old.mID
  and stars > 3;
end;

--  Question 5
--  Write an instead-of trigger that enables deletions from view HighlyRated. 

create trigger HighlyRatedDeleteUpdate
instead of delete on HighlyRated
for each row
begin
  update Rating
  set stars = 3
  where mID = Old.mID
  and stars > 3;
end;
