
--Display a list of students who have enrolled in both "Tin học đại cương and "Mạng máy tính".
select * from student s JOIN enrollment e ON (s.student_id = e.student_id)
						JOIN subject sj ON (e.subject_id = sj.subject_id)
WHERE sj.name = 'Tin học đại cương'
	and exists (select student_id from enrollment e1, subject sj1
											where e1.subject_id = sj1.subject_id 
											and e1.student_id = s.student_id
						 					and name = 'Mạng máy tính');
-- Display subjects that have never been registered by any students
select * from subject
where subject_id NOT IN (SELECT subject_id from enrollment );



--Show the list of students who enrolled in 'Cơ sở dữ liệu' in semesters = '20172'). 
--This list contains student id, student name, midterm score, final exam score and subject score. 
-- Subject score is calculated by the weighted average of midterm score and final exam score : 
--subject score = midterm score * (1-percentage_final_exam/100)  + final score *percentage_final_exam/100.
Select s.student_id,s.first_name ||' '|| s.last_name as full_name,e.midterm_score,e.final_score, 
midterm_score * (100.0 - percentage_final_exam)/100.0 + final_score * percentage_final_exam/100.0 
as subject_score
from student s JOIN enrollment e on (s.student_id = e.student_id) 
				JOIN subject sj on (e.subject_id = sj.subject_id)
WHERE e.semester = '20172' and sj.name = 'Cơ sở dữ liệu'
ORDER BY subject_score DESC

--Display students who failed the subject 'Cơ sở dữ liệu' in semesters = '20172'. 
--Note: a student failed a subject if his midterm score or his final exam score is below 3 ; or his subject score is below 4.

Select s.student_id,s.first_name ||' '|| s.last_name as full_name,e.midterm_score,e.final_score, 
midterm_score * (100.0 - percentage_final_exam)/100.0 + final_score * percentage_final_exam/100.0 
as subject_score
from student s JOIN enrollment e on (s.student_id = e.student_id) 
				JOIN subject sj on (e.subject_id = sj.subject_id)
WHERE e.semester = '20172' and sj.name = 'Cơ sở dữ liệu'
and (final_score < 3) or (midterm_score < 3) or (midterm_score * (100.0 - percentage_final_exam)/100.0 + final_score * percentage_final_exam/100.0  < 4)
ORDER BY subject_score DESC;
--List of all students with their class name, monitor name.

Select s.first_name || ' '|| s.last_name as full_name,m.first_name || ' '|| m.last_name as monitor_name, clazz.name as clazz
from student s, clazz , student m
WHERE s.clazz_id = clazz.clazz_id
and clazz.monitor_id = m.student_id

	
--Display class name and number of students corresponding in each class. Sort the result
select c.name, count(s.student_id) as number_student
from student s right join clazz c on (s.clazz_id = c.clazz_id)
group by c.clazz_id
order by number_student desc;
--Display the lowest, highest and average scores on the mid-term test of "Mạng máy tính" in semester '20172'.
Select min(midterm_score),max(midterm_score), avg(midterm_score)
from subject s, enrollment e 
WHERE s.subject_id = e.subject_id and
e.semester = '20172' and s.name = 'Mạng máy tính'
--. Give number of subjects that each lecturer can teach. List must contain: lecturer id, lecturer's fullname, number of subjects
SELECT l.lecturer_id, l.first_name ||' '|| l.last_name as full_name,
count(l.lecturer_id) as number_subject
from lecturer l right join teaching t on (l.lecturer_id = t.lecturer_id)
group by l.lecturer_id
order by number_subject desc;

--List of students who obtained the highest score in subject whose id is 'IT3080', in the semester '20172'.
with tmp as (Select s.student_id, s.first_name ||' '|| s.last_name as full_name,
midterm_score * (100.0 - percentage_final_exam)/100.0 + final_score * percentage_final_exam/100.0 
as subject_score
from enrollment e join subject using(subject_id)
where semester = '20172' and subject_id = 'IT3080')

select s.*, subject_score
from tmp join student s using(student_id)
where subject_score = select max (subject_score) from tmp;


