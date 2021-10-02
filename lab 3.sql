/*   1   */
SELECT * FROM course WHERE credits > 3;

SELECT * FROM classroom Where building = 'Watson' or building = 'Packard';

SELECT * FROM course WHERE dept_name = 'Comp. Sci.';

SELECT * FROM section WHERE semester = 'Fall';

SELECT * FROM student WHERE tot_cred > 45 and tot_cred < 90;

SELECT * FROM student WHERE name like '%a' or name like '%e' or name like '%i' or name like '%u' or name like '%o';

SELECT * FROM prereq WHERE prereq_id = 'CS-101';

/*   2   */

/*a*/
SELECT department.dept_name, avg(instructor.salary) as avg_salary from department, instructor
WHERE department.dept_name = instructor.dept_name
GROUP BY department.dept_name
ORDER BY avg(instructor.salary) asc;

/*b*/
SELECT building, count(*)
FROM department, course WHERE department.dept_name = course.dept_name
GROUP BY building
ORDER BY count(*) desc limit 1;

/*c*/
SELECT * FROM (
                  select course.dept_name, count(*) as cnt
                  from course,
                       department
                  WHERE course.dept_name = department.dept_name
                  group by course.dept_name
              ) as result
WHERE cnt <= 1;


/*d*/
SELECT * FROM (
                  select student.id, name, course.dept_name, count(course.dept_name) as cnt
                  from student,
                       course,
                       takes
                  where student.id = takes.id
                    and takes.course_id = course.course_id
                  group by student.id, name, course.dept_name
              ) as result
WHERE cnt > 3;

/*e*/
SELECT * FROM instructor WHERE dept_name = 'Biology' or dept_name = 'Music' or dept_name = 'Philosophy';


/*f*/
SELECT * FROM (
                  (select instructor.id, instructor.name, instructor.dept_name
                   from teaches,
                        instructor
                   where teaches.id = instructor.id
                     and teaches.year = 2018)

                  except

                  (select instructor.id, instructor.name, instructor.dept_name
                   from teaches,
                        instructor
                   where teaches.id = instructor.id
                     and teaches.year = 2017)
              ) as result;

/*   3   */

/*a*/
SELECT * FROM (
                  select *
                  from student,
                       takes
                  WHERE student.id = takes.id
              )
                as result
WHERE dept_name = 'Comp. Sci.' and (grade = 'A' or grade = 'A-')
ORDER BY name;

/*b*/

SELECT result.name FROM (
                  select instructor.name, student.name as sname, grade
                  from advisor,
                       instructor,
                       student,
                       takes
                  where instructor.id = advisor.i_id
                    and student.id = advisor.s_id
                    and student.id = takes.id
              ) as result
WHERE grade not in ('A', 'A-', 'B', 'B+')
group by  result.name
;

SELECT * FROM (
                  select instructor.name, student.name as sname, grade
                  from advisor,
                       instructor,
                       student,
                       takes
                  where instructor.id = advisor.i_id
                    and student.id = advisor.s_id
                    and student.id = takes.id
              ) as result
WHERE grade not in ('A', 'A-', 'B', 'B+')
;

/*c*/

SELECT * FROM (
                  (select student.dept_name
                   from student,
                        takes
                   where student.id = takes.id
                     and grade not in ('F', 'C-', 'C', 'C+'))

                  except

                  (select student.dept_name
                   from student,
                        takes
                   where student.id = takes.id
                     and grade in ('F', 'C-', 'C', 'C+'))
              ) as result;

/*d*/
SELECT * FROM (
                  (select name
                   from instructor,
                        teaches,
                        takes
                   where instructor.id = teaches.id
                     and takes.course_id = teaches.course_id
                     and grade not in ('A'))

                  except

                  (select name
                   from instructor,
                        teaches,
                        takes
                   where instructor.id = teaches.id
                     and takes.course_id = teaches.course_id
                     and grade in ('A'))
              ) as result;


/*e*/

SELECT * FROM (
                  select course_id, day, end_hr, end_min
                  from section,
                       time_slot
                  where section.time_slot_id = time_slot.time_slot_id
              ) as result
WHERE end_hr < 13;
