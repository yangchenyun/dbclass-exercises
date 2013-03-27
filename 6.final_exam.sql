/* Questions 10 */
--  R(A) = { (1) }
--  S(B) = { (2), (2), (3) }

create trigger First
  after insert on R
  for each row
  update S set B = 3 where B = New.A
;

create trigger Second
  after update on S
  for each row
  update R set A = A+1
;

insert into R values (2)
/* ->   */
update S set B = 3 where B = 2
/* S(B) = { (3), (3), (3) } */
/* ->   */
/* there are two tuples updated */
update R set A = A+1
/* R(A) = { (2), (3) } */
update R set A = A+1
/* R(A) = { (3), (4) } */

/* Questions 11 */
--  T(A) = { (1), (1), (2), (3) }

/* to make the two triggers no difference,  */
/* the row-level trigger should be executed only once */

create trigger RowLevel
  after update on T
  for each row
  insert into T values (0)

create trigger StatementLevel
  after update on T
  insert into T values (0)

/* Question 12 - 14 */
--  Bid(item,price)

/* S1, S2, S3, and S4 within the transactions each execute atomically. 
meaning: update is atomic. */
/* T1 - Always Serializable */
  /* S1: update Bid set price = price + 5 */
  /* S2: insert into Bid values (desktop,30) */
/* T2 */
  /* S3: select sum(price) as s from Bid */
  /* S4: select max(price) as m from Bid */

/* T2 - Serializable */
--  T1, T2: s = 70, m = 30
--  T2, T1: s = 30, m = 20

/* T2 - Read Committed */
--  T1, T2: s = 70, m = 30
--  T2, T1: s = 30, m = 20
--  S3, T1, S4: s = 30, m = 30

/* T2 - Read Un-Committed */
--  T1, T2: s = 70, m = 30
--  T2, T1: s = 30, m = 20
--  S3, T1, S4: s = 30, m = 30
--  S3(10, 20), S1(15, 25), S4(25), S2: s = 30, m = 25
--  S1(15, 25), S3(40), S4(25), S2: s = 40, m = 25
--  S1(15, 25), S3(40), S2(15, 25, 30), S4(30): s = 40, m = 30

/* Question 15 - updatable view */
/* cannot, aggregation is used */
create view V as select person, avg(score) from Rating group by person
/* cannot, involved in two relations */
create view V as select Movie.title, director, person, score from Movie, Rating where Movie.title = Rating.title
/* cannot, select distinct is used instead of select */
create view V as select distinct(director) from Movie

create view V as select title, director from Movie where title in (select title from Rating where score > 3)

/* Question 18 */
/* G(n1,n2,label) */
/* a directed edge from node n1 to node n2 with the given label */
/* n1 -> n2 */

/* the length of (i.e., the number of edges in) the longest path  */
/* in the graph that contains red edges only. */
with recursive
  Path(n1, n2, length) as 
  (
    /* The first round path available */
    select (n1, n2, 1) from G where label = 'red'
    union
    select P.n1, G.n2, P.length + 1
    from Path P, G
    where P.n2 = G.n1
    and G.label = 'red'
  )

/* Question 19 */
create view FlightRollup
   select origin, destination, airline, sum(price) as p from Flight
   group by origin, destination, airline with rollup;

--  ROLLUP
--  origin, destination, airline
--  value, value, value
--  value, value, null
--  value, null, null *
--  null, null, null

--  CUBE
--  origin, destination, airline
--  value, value, value *
--  value, value, null
--  value, null, value
--  null, value, value
--  value, null, null *
--  null, value, null
--  null, null, value
--  null, null, null
