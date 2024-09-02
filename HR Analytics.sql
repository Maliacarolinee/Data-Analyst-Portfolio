-- I created two tables: employees and employee_details. The employees table captures information about employees, such as 
-- job titles, departments, and years at the company. The employee_details table holds additional information, including hire status, 
-- experience, age, and gender. The employee_id field is used to link the two tables.

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    job_title VARCHAR(100),
    department VARCHAR(100),
    years_at_company INT
);


CREATE TABLE employee_details (
    employee_id INT PRIMARY KEY,
    internal_hire ENUM('Yes', 'No'),
    experience INT,
    age INT,
    gender ENUM('Male', 'Female', 'Other'),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- I populated the tables with data to simulate a range of employee profiles. 
-- This data includes various job titles, departments, hire statuses, experience levels, ages, and genders. 

INSERT INTO employees (employee_id, job_title, department, years_at_company)
VALUES 
    (1, 'Software Engineer', 'Engineering', 5),
    (2, 'Marketing Specialist', 'Marketing', 3),
    (3, 'HR Manager', 'Human Resources', 7),
    (4, 'Data Analyst', 'Data Science', 2),
    (5, 'Sales Executive', 'Sales', 4),
    (6, 'Product Manager', 'Product', 6),
    (7, 'UX Designer', 'Design', 4),
    (8, 'Finance Analyst', 'Finance', 8),
    (9, 'Legal Counsel', 'Legal', 5),
    (10, 'Customer Support', 'Support', 3),
    (11, 'Business Analyst', 'Business Analysis', 9),
    (12, 'IT Specialist', 'IT', 7),
    (13, 'Content Writer', 'Content', 2),
    (14, 'Recruiter', 'Human Resources', 4),
    (15, 'Operations Manager', 'Operations', 6),
    (16, 'Graphic Designer', 'Design', 5),
    (17, 'Database Administrator', 'IT', 8),
    (18, 'Project Coordinator', 'Project Management', 3),
    (19, 'Sales Manager', 'Sales', 7),
    (20, 'Marketing Manager', 'Marketing', 6),
    (21, 'Web Developer', 'Engineering', 2),
    (22, 'Administrative Assistant', 'Administration', 5),
    (23, 'Research Scientist', 'Research', 9),
    (24, 'Product Designer', 'Design', 4),
    (25, 'Executive Assistant', 'Administration', 8);


INSERT INTO employee_details (employee_id, internal_hire, experience, age, gender)
VALUES 
    (1, 'Yes', 8, 30, 'Male'),
    (2, 'No', 5, 27, 'Female'),
    (3, 'Yes', 10, 35, 'Female'),
    (4, 'No', 3, 25, 'Male'),
    (5, 'Yes', 6, 28, 'Male'),
    (6, 'Yes', 9, 32, 'Female'),
    (7, 'No', 4, 29, 'Female'),
    (8, 'Yes', 11, 34, 'Male'),
    (9, 'No', 7, 40, 'Female'),
    (10, 'Yes', 3, 26, 'Male'),
    (11, 'No', 9, 31, 'Female'),
    (12, 'Yes', 8, 33, 'Male'),
    (13, 'No', 2, 24, 'Female'),
    (14, 'Yes', 5, 29, 'Male'),
    (15, 'No', 6, 32, 'Female'),
    (16, 'Yes', 7, 30, 'Male'),
    (17, 'No', 8, 36, 'Female'),
    (18, 'Yes', 3, 27, 'Male'),
    (19, 'No', 10, 33, 'Female'),
    (20, 'Yes', 6, 31, 'Male'),
    (21, 'No', 2, 25, 'Female'),
    (22, 'Yes', 5, 28, 'Male'),
    (23, 'No', 9, 35, 'Female'),
    (24, 'Yes', 4, 30, 'Male'),
    (25, 'No', 8, 34, 'Female');

-- Query to analyze employee data with various joins and aggregate functions

--  I used an INNER JOIN to combine data from the employees and employee_details tables based on employee_id. 
-- This join ensures that only employees with matching records in both tables are included.

SELECT 
    e.employee_id,
    e.job_title,
    e.department,
    e.years_at_company,
    ed.internal_hire,
    ed.experience,
    ed.age,
    ed.gender
FROM 
    employees e
INNER JOIN 
    employee_details ed
ON 
    e.employee_id = ed.employee_id
WHERE 
    e.years_at_company > 2  -- Filter employees with more than 2 years at the company
    AND ed.internal_hire = 'Yes';  -- Only consider internal hires

--  I used a LEFT JOIN to include all records from the employees table and the corresponding records from the employee_details table. 
SELECT 
    e.employee_id,
    e.job_title,
    e.department,
    e.years_at_company,
    COALESCE(ed.internal_hire, 'No Data') AS internal_hire,
    COALESCE(ed.experience, 'No Data') AS experience,
    COALESCE(ed.age, 'No Data') AS age,
    COALESCE(ed.gender, 'No Data') AS gender
FROM 
    employees e
LEFT JOIN 
    employee_details ed
ON 
    e.employee_id = ed.employee_id
WHERE 
    e.department = 'Engineering'  -- Focus on Engineering department
    OR e.department = 'Design';  -- Include Design department

--  Aggregate functions to summarize data
-- I applied aggregate functions (COUNT, AVG, MIN, MAX, and SUM) to the joined tables. 
SELECT 
    e.department,
    COUNT(e.employee_id) AS total_employees,
    AVG(ed.experience) AS avg_experience,
    MIN(ed.age) AS min_age,
    MAX(ed.age) AS max_age,
    SUM(CASE WHEN ed.internal_hire = 'Yes' THEN 1 ELSE 0 END) AS internal_hire_count
FROM 
    employees e
INNER JOIN 
    employee_details ed
ON 
    e.employee_id = ed.employee_id
GROUP BY 
    e.department
HAVING 
    COUNT(e.employee_id) > 5;  -- Only departments with more than 5 employees

-- I combined multiple conditions using WHERE and aggregated data by job title and department. 
SELECT 
    e.job_title,
    e.department,
    AVG(ed.experience) AS avg_experience,
    COUNT(CASE WHEN ed.gender = 'Female' THEN 1 ELSE NULL END) AS female_count,
    COUNT(CASE WHEN ed.internal_hire = 'No' THEN 1 ELSE NULL END) AS external_hire_count
FROM 
    employees e
INNER JOIN 
    employee_details ed
ON 
    e.employee_id = ed.employee_id
WHERE 
    e.years_at_company BETWEEN 3 AND 10  -- Employees with 3 to 10 years at the company
    AND (ed.age < 40 OR ed.internal_hire = 'Yes')  -- Age under 40 or internal hires
GROUP BY 
    e.job_title, e.department
ORDER BY 
    avg_experience DESC;  -- Order by average experience descending
