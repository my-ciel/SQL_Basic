-- Part 1 : SELECT 문의 기본 형식
SELECT *
FROM   departments;
SELECT department_id, location_id
FROM   departments;

SELECT last_name, salary, salary + 300
FROM   employees;
SELECT last_name, salary, 12*salary+100
FROM   employees;
SELECT last_name, salary, 12*(salary+100)
FROM   employees;

SELECT last_name, job_id, salary, commission_pct
FROM   employees;
SELECT last_name, 12*salary*commission_pct
FROM   employees;


SELECT last_name AS name, commission_pct comm
FROM   employees;
SELECT last_name "Name", salary*12 "Annual Salary"
FROM   employees;
SELECT	last_name||job_id AS "Employees"
FROM 	employees;
SELECT first_name||'  '||last_name||' : '|| job_id  AS "Employees"
FROM 	employees;
SELECT last_name || '''s Salary : '|| salary AS "Salary Report " 
FROM employees;
SELECT last_name ||  q'['s Salary : ]'|| salary AS "Salary Report " 
FROM employees;

SELECT department_id
FROM   employees;
SELECT DISTINCT department_id
FROM   employees;

SELECT DISTINCT department_id, job_id
FROM employees;
SELECT UNIQUE department_id, job_id
FROM employees;

--Part 2 : 데이터의 제한
SELECT employee_id, last_name, job_id, department_id
FROM   employees
WHERE  department_id = 90 ;
SELECT last_name, job_id, department_id
FROM   employees
WHERE  last_name = 'Whalen';
SELECT last_name, job_id, hire_date
FROM   employees
WHERE  hire_date = '14/11/16';

SELECT last_name, salary
FROM   employees
WHERE  salary <= 3000;
SELECT employee_id, last_name, job_id, hire_date
FROM employees
WHERE hire_date >= '10/01/01';

SELECT last_name, salary
FROM   employees
WHERE  salary BETWEEN 2500 AND 3500;
SELECT employee_id, last_name, salary, manager_id
FROM   employees
WHERE  manager_id IN (100, 101, 201);
SELECT employee_id, manager_id, department_id
FROM   employees
WHERE  last_name IN ('Hartstein', 'Vargas');
SELECT	first_name
FROM 	employees
WHERE	first_name LIKE 'S%';
SELECT last_name
FROM   employees
WHERE  last_name LIKE '_o%';
SELECT employee_id, last_name, job_id
FROM   employees
WHERE  job_id LIKE '%SA\_%' ESCAPE '\';
SELECT last_name, manager_id
FROM   employees
WHERE  manager_id IS NULL;
SELECT last_name, job_id, commission_pct
FROM   employees
WHERE  commission_pct IS NULL;

SELECT employee_id, last_name, job_id, salary
FROM   employees
WHERE  salary >=10000
AND    job_id LIKE '%MAN%';
SELECT employee_id, last_name, job_id, salary
FROM   employees
WHERE  salary >= 10000
OR     job_id LIKE '%MAN%';
SELECT last_name, job_id
FROM   employees
WHERE  job_id 
NOT IN ('IT_PROG', 'ST_CLERK', 'SA_REP');

SELECT last_name, job_id, salary
FROM   employees
WHERE  job_id = 'SA_REP'
OR     job_id = 'AD_PRES'
AND    salary > 15000;
SELECT last_name, job_id, salary
FROM   employees
WHERE  (job_id = 'SA_REP'
OR     job_id = 'AD_PRES')
AND    salary > 15000;

--Part 3 : 데이터의 정렬
SELECT   last_name, job_id, department_id, hire_date
FROM     employees
ORDER BY hire_date ;
SELECT   last_name, job_id, department_id, hire_date
FROM     employees
ORDER BY hire_date DESC ;
SELECT employee_id, last_name, salary*12 annsal
FROM   employees
ORDER BY annsal;
SELECT last_name, department_id, salary
FROM   employees
ORDER BY department_id, salary DESC;
SELECT last_name, department_id, salary
FROM   employees
ORDER BY 2, 3 DESC;




