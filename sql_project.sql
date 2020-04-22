/* SQL mini project

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.*/


/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost !=0

/*Answer:
name
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court*/

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( name ) AS "Free facilities"
FROM `Facilities`
WHERE membercost =0

/*Answer:
Free facilities
4*/

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM `Facilities`
WHERE membercost !=0
AND (membercost < ( monthlymaintenance * 0.2 ))

/*Answer:
facid   name   		membercost   	monthlymaintenance
0       Tennis Court 1  5.0		200
1	Tennis Court 2	5.0		200
4	Massage Room 1	9.9		3000
5	Massage Room 2	9.9		3000
6	Squash Court	3.5		80
*/

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
FROM `Facilities`
WHERE facid
IN ( 1, 5 )

/*Answer:
facid	name		membercost	guestcost	initialoutlay	monthlymaintenance	
1	Tennis Court 2	5.0		25.0		8000		200
5	Massage Room 2	9.9		80.0		4000		3000
*/

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE
WHEN monthlymaintenance >100
THEN 'expensive'
ELSE 'cheap'
END AS cost
FROM `Facilities`

/*Answer:
name		monthlymaintenance	cost	
Tennis Court 1	200			expensive
Tennis Court 2	200			expensive
Badminton Court	50			cheap
Table Tennis	10			cheap
Massage Room 1	3000			expensive
Massage Room 2	3000			expensive
Squash Court	80			cheap
Snooker Table	15			cheap
Pool Table	15			cheap
*/

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname, joindate
FROM `Members`
WHERE joindate = (
SELECT MAX( joindate )
FROM `Members` )

/*Answer:
firstname	surname		joindate	
Darren		Smith		2012-09-26 18:08:45
*/

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT fac.name AS facility_name, CONCAT( mem.firstname, ' ', mem.surname ) AS member_name
FROM `Facilities` fac
JOIN `Bookings` book ON fac.facid = book.facid
JOIN `Members` mem ON book.memid = mem.memid
WHERE fac.name LIKE 'Tennis Court%'
AND mem.firstname != 'GUEST'
ORDER BY member_name, facility_name
LIMIT 0 , 30

/*Answer:
facility_name	member_name	
Tennis Court 1	Anne Baker
Tennis Court 2	Anne Baker
Tennis Court 1	Burton Tracy
Tennis Court 2	Burton Tracy
Tennis Court 1	Charles Owen
Tennis Court 2	Charles Owen
Tennis Court 2	Darren Smith
Tennis Court 1	David Farrell
Tennis Court 2	David Farrell
Tennis Court 1	David Jones
Tennis Court 2	David Jones
Tennis Court 1	David Pinker
Tennis Court 1	Douglas Jones
Tennis Court 1	Erica Crumpet
Tennis Court 1	Florence Bader
Tennis Court 2	Florence Bader
Tennis Court 1	Gerald Butters
Tennis Court 2	Gerald Butters
Tennis Court 2	Henrietta Rumney
Tennis Court 1	Jack Smith
Tennis Court 2	Jack Smith
Tennis Court 1	Janice Joplette
Tennis Court 2	Janice Joplette
Tennis Court 1	Jemima Farrell
Tennis Court 2	Jemima Farrell
Tennis Court 1	Joan Coplin
Tennis Court 1	John Hunt
Tennis Court 2	John Hunt
Tennis Court 1	Matthew Genting
Tennis Court 2	Millicent Purview
*/

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT fac.name AS facility_name, CONCAT( mem.firstname, ' ', mem.surname ) AS person_name,
CASE
WHEN book.memid >0
THEN fac.membercost * book.slots
ELSE fac.guestcost * book.slots
END AS cost
FROM `Facilities` fac
JOIN `Bookings` book ON fac.facid = book.facid
JOIN `Members` mem ON book.memid = mem.memid
WHERE DATE(book.starttime) ='2012-09-14'
HAVING cost >30
ORDER BY cost DESC

/*Answer
facility_name	person_name	cost	
Massage Room 2	GUEST GUEST	320.0
Massage Room 1	GUEST GUEST	160.0
Massage Room 1	GUEST GUEST	160.0
Massage Room 1	GUEST GUEST	160.0
Tennis Court 2	GUEST GUEST	150.0
Tennis Court 1	GUEST GUEST	75.0
Tennis Court 1	GUEST GUEST	75.0
Tennis Court 2	GUEST GUEST	75.0
Squash Court	GUEST GUEST	70.0
Massage Room 1	Jemima Farrell	39.6
Squash Court	GUEST GUEST	35.0
Squash Court	GUEST GUEST	35.0
*/

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT subq.facility_name, subq.person_name, subq.cost
FROM (

SELECT fac.name AS facility_name, CONCAT( mem.firstname, ' ', mem.surname ) AS person_name,
CASE
WHEN book.memid >0
THEN fac.membercost * book.slots
ELSE fac.guestcost * book.slots
END AS cost
FROM `Facilities` fac
JOIN `Bookings` book ON fac.facid = book.facid
JOIN `Members` mem ON book.memid = mem.memid
WHERE DATE(book.starttime) ='2012-09-14'
) AS subq
WHERE subq.cost >30
ORDER BY subq.cost DESC

/*Answer(same as in Q8):
facility_name	person_name	cost	
Massage Room 2	GUEST GUEST	320.0
Massage Room 1	GUEST GUEST	160.0
Massage Room 1	GUEST GUEST	160.0
Massage Room 1	GUEST GUEST	160.0
Tennis Court 2	GUEST GUEST	150.0
Tennis Court 2	GUEST GUEST	75.0
Tennis Court 1	GUEST GUEST	75.0
Tennis Court 1	GUEST GUEST	75.0
Squash Court	GUEST GUEST	70.0
Massage Room 1	Jemima Farrell	39.6
Squash Court	GUEST GUEST	35.0
Squash Court	GUEST GUEST	35.0
*/

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT subq.facility_name, SUM( subq.cost ) AS total_revenue
FROM (

SELECT fac.name AS facility_name,
CASE
WHEN book.memid >0
THEN fac.membercost * book.slots
ELSE fac.guestcost * book.slots
END AS cost
FROM `Facilities` fac
JOIN `Bookings` book ON fac.facid = book.facid
JOIN `Members` mem ON book.memid = mem.memid
) AS subq
GROUP BY subq.facility_name
HAVING total_revenue <1000
ORDER BY 2 DESC

/*Answer:
facility_name	total_revenue	
Pool Table	270.0
Snooker Table	240.0
Table Tennis	180.0
*/