-- a. Insert at least three students, two courses, and two advisors
INSERT INTO Advisors (advisor_name, advisor_email) VALUES
('Dr. Alice Smith', 'alice.smith@university.edu'),
('Dr. Bob Jones', 'bob.jones@university.edu');

INSERT INTO Instructors (instructor_name, instructor_email) VALUES
('Prof. Charlie Brown', 'charlie.brown@university.edu'),
('Prof. Diana Prince', 'diana.prince@university.edu');

INSERT INTO Students (student_id, student_name, department, advisor_name) VALUES
(101, 'John Doe', 'Computer Science', 'Dr. Alice Smith'),
(102, 'Jane Doe', 'Computer Science', 'Dr. Alice Smith'),
(103, 'Sam Wilson', 'Data Science', 'Dr. Bob Jones');

INSERT INTO Courses (course_code, course_name, instructor_name) VALUES
('CS101', 'Intro to CS', 'Prof. Charlie Brown'),
('CS202', 'Data Structures', 'Prof. Diana Prince');

-- b. Update the email address of one instructor via primary key
UPDATE Instructors 
SET instructor_email = 'charlie.b.new@university.edu' 
WHERE instructor_name = 'Prof. Charlie Brown';

-- c. Delete all enrollment records for students whose marks_obtained is below 35
DELETE FROM Enrollments 
WHERE marks_obtained < 35.00;

-- d. Write a DELETE statement without a WHERE clause that removes all rows from StudentRecords
-- [Explanation]: DELETE is safer for transaction-controlled bulk removal because it is a DML statement 
-- that respects BEGIN/ROLLBACK in major databases. TRUNCATE is a DDL statement that implicitly commits 
-- pending operations in MySQL and cannot be undone. Thus, DELETE provides full transactional safety.
DELETE FROM Enrollments;

-- a. Retrieve student_name and course_name for specific course codes
SELECT s.student_name, c.course_name 
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_code = c.course_code
WHERE e.course_code IN ('CS101', 'CS202', 'CS303');

-- b. Retrieve students whose marks are between 60 and 85 with non-null advisor emails
SELECT s.student_name 
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Advisors a ON s.advisor_name = a.advisor_name
WHERE e.marks_obtained BETWEEN 60 AND 85 
  AND a.advisor_email IS NOT NULL;

-- c. Average, minimum, and maximum marks by department where average > 55
SELECT s.department, 
       AVG(e.marks_obtained) AS avg_marks, 
       MIN(e.marks_obtained) AS min_marks, 
       MAX(e.marks_obtained) AS max_marks
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
GROUP BY s.department
HAVING AVG(e.marks_obtained) > 55;

-- d. INNER JOIN and LEFT JOIN variations
-- Query 1 (INNER JOIN)
SELECT s.student_name, c.course_name, e.marks_obtained
FROM Enrollments e
INNER JOIN Students s ON e.student_id = s.student_id
INNER JOIN Courses c ON e.course_code = c.course_code;

-- Query 2 (LEFT JOIN for un-enrolled students)
SELECT s.student_name, c.course_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
LEFT JOIN Courses c ON e.course_code = c.course_code;

-- e. Correlated subquery for higher than department average
SELECT s.student_name, e.marks_obtained
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
WHERE e.marks_obtained > (
    SELECT AVG(e2.marks_obtained)
    FROM Enrollments e2
    JOIN Students s2 ON e2.student_id = s2.student_id
    WHERE s2.department = s.department
);

-- f. Students in 2024 enrollments but NOT in 2025 enrollments
SELECT student_id FROM Enrollments WHERE enrollment_year = 2024
EXCEPT
SELECT student_id FROM Enrollments WHERE enrollment_year = 2025;

-- g. Correlated subquery for second-highest marks in each department
SELECT s.student_name, e.marks_obtained
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
WHERE e.marks_obtained = (
    SELECT MAX(e2.marks_obtained)
    FROM Enrollments e2
    JOIN Students s2 ON e2.student_id = s2.student_id
    WHERE s2.department = s.department
      AND e2.marks_obtained < (
          SELECT MAX(e3.marks_obtained)
          FROM Enrollments e3
          JOIN Students s3 ON e3.student_id = s3.student_id
          WHERE s3.department = s.department
      )
);

-- h. Window function ranking comparison
SELECT s.student_name, s.department, e.marks_obtained,
       ROW_NUMBER() OVER(PARTITION BY s.department ORDER BY e.marks_obtained DESC) AS row_num,
       RANK() OVER(PARTITION BY s.department ORDER BY e.marks_obtained DESC) AS rnk,
       DENSE_RANK() OVER(PARTITION BY s.department ORDER BY e.marks_obtained DESC) AS dense_rnk
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id;

BEGIN TRANSACTION;
DELETE FROM Enrollments WHERE student_id = 101 AND course_code = 'CS101';
INSERT INTO Enrollments (student_id, course_code, enrollment_year) VALUES (101, 'CS404', 2026);
COMMIT; -- Will roll back automatically if constraints fail in compliant engines
