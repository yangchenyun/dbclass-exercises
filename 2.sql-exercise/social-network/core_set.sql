-- dbext:type=SQLITE:dbname=social.db

-- Question 1
-- Find the names of all students who are friends with someone named Gabriel.
select H2.name
from Highschooler H1, Highschooler H2, Friend
where H1.ID = Friend.ID1
and H1.name = 'Gabriel'
and H2.ID = Friend.ID2;

-- Question 2
-- For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
select H1.name, H1.grade, H2.name, H2.grade
from Likes, Highschooler H1, Highschooler H2
where Likes.ID1 = H1.ID
and Likes.ID2 = H2.ID
and H1.grade >= (H2.grade + 2)
;

-- Question 3
-- For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, (
  select L1.ID1, L1.ID2
  from Likes L1, Likes L2
  where L1.ID2 = L2.ID1
  and L1.ID1 = L2.ID2
) as Pair
where H1.ID = Pair.ID1
and H2.ID = Pair.ID2
and H1.name < H2.name
;

-- Question 4
-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
select name, grade
from Highschooler, (
  select ID1 from Friend
  except
  select ID1
  from Friend, Highschooler H1, Highschooler H2
  where Friend.ID1 = H1.ID
  and Friend.ID2 = H2.ID
  and H1.grade <> H2.grade
) as SameGrade
where SameGrade.ID1 = Highschooler.ID
order by grade, name
;

-- Question 5
-- Find the name and grade of all students who are liked by more than one other student.  
select name, grade
from Highschooler, (
  select count(ID1) as count, ID2
  from Likes
  group by ID2
) as LikeCount
where Highschooler.ID = LikeCount.ID2
and count > 1
;
