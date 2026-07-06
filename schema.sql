-- Create Instructors Table
CREATE TABLE Instructors (
    instructor_name VARCHAR(100) PRIMARY KEY,
    instructor_email VARCHAR(255) UNIQUE NOT NULL
);

-- Create Advisors Table
CREATE TABLE Advisors (
    advisor_name VARCHAR(100) PRIMARY KEY,
    advisor_email VARCHAR(255) UNIQUE NOT NULL
);

-- Create Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    advisor_name VARCHAR(100),
    FOREIGN KEY (advisor_name) REFERENCES Advisors(advisor_name) ON UPDATE CASCADE
);

-- Create Courses Table
CREATE TABLE Courses (
    course_code VARCHAR(20) PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    instructor_name VARCHAR(100),
    FOREIGN KEY (instructor_name) REFERENCES Instructors(instructor_name) ON UPDATE CASCADE
);

-- Create Enrollments Table
CREATE TABLE Enrollments (
    student_id INT,
    course_code VARCHAR(20),
    enrollment_year INT DEFAULT 2026,
    marks_obtained DECIMAL(5,2),
    PRIMARY KEY (student_id, course_code),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_code) REFERENCES Courses(course_code) ON DELETE CASCADE
);
