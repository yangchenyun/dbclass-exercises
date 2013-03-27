-- dbext:type=SQLITE:dbname=social.db

-- Question 1
-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete from Highschooler
where grade == 12;

-- Question 2
-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from Likes
where ID1 in (
  select ID1 from (
    select L1.ID1, L1.ID2
    from Friend, Likes L1
    where Friend.ID1 = L1.ID1
    and Friend.ID2 = L1.ID2
    except
    select L1.ID1, L1.ID2
    from Likes L1, Likes L2
    where L1.ID1 = L2.ID2
    and L1.ID2 = L2.ID1
  )
)
;

-- Question 3
-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.
insert into Friend
  select F1.ID1, F2.ID2
  from Friend F1, Friend F2
  where F1.ID2 = F2.ID1
  -- friends with oneself
  and F1.ID1 <> F2.ID2
  -- already exist friendship
  except 
  select * from Friend
;
