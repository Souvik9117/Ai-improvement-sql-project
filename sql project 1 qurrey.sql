create database dbproject;
use dbproject;
create table College(
college_id int primary key,
college_name varchar(150),
city varchar(150),
adoption_year int,
ai_platform varchar(100));
select * from College;
-- - 1. List all colleges that adopted AI in 2024.
SELECT 
    college_name
FROM
    College
WHERE
    adoption_year = 2024;
    create table Students(
student_id int primary key,
student_name varchar(150),
college_id int,
department varchar(50),
year_of_study int,
gender varchar(10),
foreign key(college_id) references College(college_id));
-- 2. Find the number of students in each department. 
SELECT 
    department, COUNT(student_id)
FROM
    Students
GROUP BY department;
-- add table edtech and performance in a different way unlike 1st two.
SELECT 
    *
FROM
    performance;
SELECT 
    *
FROM
    edtech_usage;
-- 3. Show the average GPA before and after AI adoption for each college.
SELECT 
    c.college_name,
    AVG(p.gpa_before_ai) AS gpa_before_ai,
    AVG(p.gpa_after_ai) AS gpa_after_ai
FROM
    College c
        JOIN
    Students s ON c.college_id = s.college_id
        JOIN
    performance p ON s.student_id = p.student_id
GROUP BY c.college_name;
 -- 4. Identify the top 10 students with the highest “hours_spent” on EdTech platforms.
SELECT 
    s.student_name,
    s.student_id,
    SUM(e.hours_spent) AS total_hour
FROM
edtech_usage e  
    JOIN
    Students s
    ON e.student_id = s.student_id
GROUP BY s.student_id,s.student_name
ORDER BY Total_hour DESC
LIMIT 10;
-- 5. Show the correlation pattern: students who accepted more AI recommendations vs. change in GPA.
SELECT ed.student_id,
    sum(ed.ai_recommendations_accepted),
    (p.gpa_after_ai - p.gpa_before_ai) AS gpa_change
FROM Student s
        JOIN
    edtech_usage ed ON s.student_id = ed.student_id
        JOIN
    performance p ON s.student_id = p.student_id
    group by ed.student_id,p.gpa_after_ai , p.gpa_before_ai
    order by sum(ed.ai_recommendations_accepted) desc;
--    6  Compare attendance improvement:-- o Calculate “attendance_after_ai – attendance_before_ai” for each student.
SELECT 
    s.student_id,
    s.student_name,
    (p.attendance_after_ai - p.attendance_before_ai) AS Attendance_imporvement
FROM
    Students s
        JOIN
    performance p ON p.student_id = s.student_id;
--     7. Find which AI platform (LearnAI, SmartTutor, MindEd) resulted in the highest average GPA improvement.
SELECT c.ai_platform,
avg(p.gpa_after_ai-p.gpa_before_ai)as avg_gpa_improvement
from Student s join College c on s.college_id= c.college_id
join performance p on s.student_id=p.student_id
group by c.ai_platform
order by avg_gpa_improvement desc
limit 1;
-- 8. Check whether increased usage hours lead to better quiz performance:o Group by student, calculate total hours and total quizzes, and compare.
SELECT 
    s.student_id,
    SUM(ed.hours_spent) AS total_hours_spent,
    SUM(ed.quizzes_taken) As total_quizzes,
    (SUM(ed.hours_spent) - SUM(ed.quizzes_taken)) AS Compare
FROM
    College c
        JOIN
    Students s ON s.college_id = c.college_id
        JOIN
    edtech_usage ed ON s.student_id = ed.student_id
GROUP BY s.student_id
ORDER BY total_hours_spent ASC;
-- Identify departments most benefited from AI adoption (highest GPA improvement grouped by department).-- 
SELECT 
    s.department,
    Avg(p.gpa_after_ai - p.gpa_before_ai) AS GPA_improvement
FROM
    Students s 
        JOIN
    performance p ON p.student_id = s.student_id
GROUP BY department
ORDER BY GPA_improvement DESC
limit 1;
-- 10. Determine if first-year students or final-year students gained the most improvement.
SELECT 
    s.year_of_study,
    AVG(gpa_after_ai - gpa_before_ai) AS GPA_improvement
FROM
    performance p
        JOIN
    Students s ON p.student_id = s.student_id
where year_of_study in (1,4)
GROUP BY s.year_of_study
ORDER BY GPA_improvement DESC;
