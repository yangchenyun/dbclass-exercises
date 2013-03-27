-- dbext:type=SQLITE:dbname=social.db

-- Question 1
-- For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Likes L1, Likes L2, Highschooler H1, Highschooler H2, Highschooler H3
where L1.ID2 = L2.ID1
and L2.ID2 <> L1.ID1
and L1.ID1 = H1.ID and L1.ID2 = H2.ID and L2.ID2 = H3.ID
;
        
-- Question 2
-- Find those students for whom all of their friends are in different grades from themselves.  Return the students' names and grades.

select name, grade
from Highschooler, (
  select ID1 from Friend
  except
  -- students have friends with same grade
  select distinct Friend.ID1
  from Friend, Highschooler H1, Highschooler H2
  where Friend.ID1 = H1.ID and Friend.ID2 = H2.ID
  and H1.grade = H2.grade
) as Sample
where Highschooler.ID = Sample.ID1
;
        
-- Question 3
-- For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, (
  select ID1, ID2
  from Likes
  where ID2 not in (select ID1 from Likes)
) as sL
where H1.ID = sL.ID1
and H2.ID = sL.ID2
;
