-- dbext:type=SQLITE:dbname=social.db

--  Question 1
--  Write a trigger that makes new students named 'Friendly' automatically like everyone else in their grade. That is, after the trigger runs, we should have ('Friendly', A) in the Likes table for every other Highschooler A in the same grade as 'Friendly'.

create trigger R1
after insert on Highschooler
for each row
when New.name = 'Friendly'
begin
  insert into Likes select New.ID, Highschooler.ID from  Highschooler where Highschooler.grade = New.grade and New.ID <> Highschooler.ID;
end
;

--  Question 2
--  Write one or more triggers to manage the grade attribute of new Highschoolers. If the inserted tuple has a value less than 9 or greater than 12, change the value to NULL. On the other hand, if the inserted tuple has a null value for grade, change it to 9.
create trigger R3
after insert on Highschooler
when New.grade is NULL
begin
  update Highschooler 
  set grade = 9
  where ID = New.ID;
end

|

create trigger R2
after insert on Highschooler
for each row
when New.grade < 9 or new.grade > 12
begin
  update Highschooler 
  set grade = null
  where Highschooler.ID = New.ID;
end

;

--  Question 3
--  Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12.
create trigger R4
after update of grade on Highschooler
for each row
when New.grade < 9 or new.grade > 12
begin
  delete from Highschooler
  where Highschooler.ID = New.ID;
end
;
