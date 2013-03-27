-- dbext:type=SQLITE:dbname=social.db

-- Question 1
-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
select name, grade
from Highschooler
where ID not in (
  select ID1 from Likes
  union
  select ID2 from Likes
)
order by grade, name
;

-- Question 2
-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3, Friend F1, Friend F2, (
  select * from Likes
  except
  -- A likes B and A/B are friends
  select Likes.ID1, Likes.ID2
  from Likes, Friend
  where Friend.ID1 = Likes.ID1 and Friend.ID2 = Likes.ID2
) as LikeNotFriend
where F1.ID1 = LikeNotFriend.ID1
and F2.ID1 = LikeNotFriend.ID2
-- has a shared friend
and F1.ID2 = F2.ID2
and H1.ID = LikeNotFriend.ID1
and H2.ID = LikeNotFriend.ID2
and H3.ID = F2.ID2
;

-- Question 3
-- Find the difference between the number of students in the school and the number of different first names.
select count(ID) - count(distinct name)
from Highschooler
;

-- Question 4
-- What is the average number of friends per student? (Your result should be just one number.)
select avg(count)
from (
  select count(ID2) as count
  from Friend
  group by ID1
) as FriendCount
;

-- Question 5
-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
select count(distinct F1.ID2) + count(distinct F2.ID2)
from Friend F1, Friend F2, Highschooler
where Highschooler.name = 'Cassandra'
and Highschooler.ID = F1.ID1
-- reach friends of friends
and F2.ID1 = F1.ID2
-- except herself
and F2.ID1 <> Highschooler.ID
and F2.ID2 <> Highschooler.ID
;

-- Question 6
-- Find the name and grade of the student(s) with the greatest number of friends.
select name, grade
from Highschooler, (
  select ID1 from Friend
  except
  -- student who has someone with more friends than them
  select distinct (FC1.ID1)
  from (
    select ID1, count(ID2) as FriendCount
    from Friend
    group by ID1
  ) as FC1,
  (
    select ID1, count(ID2) as FriendCount
    from Friend
    group by ID1
  ) as FC2
  where FC1.FriendCount < FC2.FriendCount
) as MaxFriend
where MaxFriend.ID1 = Highschooler.ID
;
