USE db_University_basic;

#1.Can you please list all the courses that belong to the Comp. Sci. department and have 3 credits?

#Answer: 3 rows returned
SELECT title FROM course WHERE credits = 3 and dept_name = 'comp. Sci.';

#2. Can you please list all the students who were instructed by Einstein; make sure there are not
#duplicities
SELECT * FROM instructor;
SELECT * FROM student;
SELECT * FROM  takes;
SELECT * from teaches;

#Answer: 1 row return
SELECT student.name AS s_name 
FROM instructor, student, takes, teaches
WHERE instructor.ID = teaches.ID AND student.ID = takes.ID 
AND takes.course_id = teaches.course_id 
AND takes.sec_id = teaches.sec_id
AND takes.semester_id = teaches.semester
AND takes.year = teaches.year
AND instructor.name = 'Einstein';


#3. Can you please list the names of the all the faculty getting the highest salary within the whole
#university? (Retrieve aside of their names, their departments names and buildings)

#Answer: 1 row returned
SELECT instructor.*, building FROM instructor,department 
WHERE instructor.dept_name = department.dept_name   
AND salary = (SELECT max(salary) from instructor);


#4. Can you please list the names of all the instructors along with the titles of the courses that they
#teach?
select * from instructor;
select * from course;
select * from teaches;

#Answer: 16 rows returned
SELECT distinct title, name FROM teaches T right join instructor I on T.id=I.id 
LEFT JOIN course C on T.course_id=C.course_id;

#5. Can you please list the names of instructors with salary amounts between $90K and $100K?

#Answer:3 rows returned
SELECT name, salary FROM instructor WHERE salary between 90000 and 100000;

#6. Can you please list what courses were taught in the fall of 2009?
select * from course;
select * from section;

#Answer: 3 rows returned
SELECT title, semester, year FROM course, section
WHERE course.course_id = section.course_id
AND semester = 'Fall'AND year = 2009;

#7. Can you please list all the courses taught in the spring of 2010?

#Answer: 6 rows returned
SELECT distinct title, semester, year FROM course, section
WHERE course.course_id = section.course_id
AND semester = 'Spring' AND year = 2010; 

#8. Can you please list all the courses taught in the fall of 2009 or in the spring of 2010.

select * from section;
SELECT * FROM course;

#Answer: 8 rows returned
CREATE TEMPORARY TABLE tbl_f
SELECT title AS F_title, semester, year FROM
(SELECT course_id, title FROM course) AS a INNER JOIN
(SELECT course_id, semester, year FROM section) AS b ON a.course_id = b.course_id
WHERE semester = 'Fall' AND year = 2009;
CREATE TEMPORARY TABLE tbl_s
SELECT title AS S_title, semester, year FROM
(SELECT course_id, title FROM course) AS c INNER JOIN
(SELECT course_id, semester, year FROM section) AS d ON c.course_id = d.course_id
WHERE semester = 'Spring' AND year = 2010;

SELECT F_title AS title_all FROM tbl_f 
UNION SELECT
S_title FROM tbl_s;

#9. List the all the courses taught in the fall of 2009 and in the spring of 2010.

#Answer: 1 row returned
SELECT F_title AS title FROM tbl_f AS e INNER JOIN tbl_s AS f
ON e.F_title = f.S_title;

#10. List all the faculty along with their salary and department of the faculty who tough a course in
#2009
select * from instructor;
select * from teaches;

#Answer: 5 rows returned
SELECT distinct name, salary, dept_name, year
FROM instructor, teaches
WHERE instructor.ID = teaches.ID
AND year = 2009;

#11. Find the average salary of instructors in the Computer Science department.

#Answer:77333.333333
SELECT avg(salary) AS avg_salary_CS FROM instructor WHERE dept_name = 'Comp. Sci.';

#12. For each department, please find the maximum enrollment, across all sections, in autumn 2009
SELECT * FROM takes;
SELECT * FROM course;

#Answer: 2 rows returned
CREATE TEMPORARY TABLE tbl_o
SELECT sec_id, COUNT(ID) AS enrollment,dept_name FROM takes, course WHERE takes.course_id = course.course_id
AND takes.semester_id = 'Fall' AND year = 2009
GROUP BY dept_name, sec_id;

SELECT MAX(enrollment), sec_id, dept_name
FROM tbl_o GROUP BY dept_name, sec_id;


#13. Get a table displaying a list of all the students with their ID, the name, the name of the department
#and the total number of credits along with the courses they have already taken?

#(Lexy failed one course, so she took that course twice. Snow has 0 credit, so null. Since she is a student, 
#I still listed her in the list, even she did not take any course. )

#Answer: 23 rows returned
CREATE TEMPORARY TABLE tbl_X
select title, course_id from course;

CREATE TEMPORARY TABLE tbl_y
SELECT student.ID, student.name, student.dept_name, student.tot_cred,
takes.course_id
FROM student LEFT JOIN takes ON student.ID = takes. ID;

SELECT tbl_y.*, tbl_x.title FROM tbl_y LEFT JOIN tbl_x ON tbl_x.course_id = tbl_y.course_id;

  
#14. Display a list of students in the Comp. Sci. department, along with the course sections, that they
#have taken in the spring of 2009. Make sure all courses taught in the spring are displayed even if
#no student from the Comp. Sci. department has taken it.

#Anwser: 10 rows returned

SELECT B.*,  A.name AS CS_stu FROM
 (SELECT A.name, B.ID, B.course_id, B.sec_id FROM (SELECT * FROM student WHERE dept_name = 'Comp. Sci.') AS A
 INNER JOIN 
   (SELECT ID, course_id, sec_id FROM takes WHERE
   semester_id = 'spring' AND year = 2009) AS B
   ON A.ID = B.ID
 ) AS A
RIGHT JOIN
 (SELECT A.title, B.* FROM course AS A
 INNER JOIN 
   (SELECT course_id, sec_id, semester, year FROM section
   WHERE semester = 'spring') AS B
   ON A.course_id = B.course_id
 ) AS B
ON A.course_id  =  B.course_id AND A.sec_id = B.sec_id;





















