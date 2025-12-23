--Part 1 : 집합연산자
SELECT employee_id, job_id
FROM   employees
UNION
SELECT employee_id, job_id
FROM   job_history;

SELECT employee_id, job_id
FROM   employees
UNION ALL
SELECT employee_id, job_id
FROM   job_history
ORDER BY  employee_id;

SELECT employee_id, job_id
FROM   employees
INTERSECT
SELECT employee_id, job_id
FROM   job_history;

SELECT employee_id,job_id FROM employees
MINUS
SELECT employee_id,job_id FROM job_history;
SELECT employee_id,job_id FROM job_history
MINUS
SELECT employee_id,job_id FROM employees;

SELECT employee_id, job_id,salary
FROM   employees
UNION
SELECT employee_id, job_id,-1
FROM   job_history;

SELECT department_id, TO_NUMBER(null) AS location, hire_date
FROM   employees
UNION
SELECT department_id, location_id,  TO_DATE(null)
FROM   departments;

--Part 2 : 계층쿼리
SELECT  employee_id, last_name, manager_id
FROM    employees
START   WITH last_name = 'King'
CONNECT BY PRIOR employee_id = manager_id ;
SELECT  employee_id, last_name, manager_id
FROM    employees
START   WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id ;

SELECT  employee_id, last_name, manager_id
FROM    employees
START   WITH employee_id = 143
CONNECT BY PRIOR manager_id = employee_id;

SELECT  LEVEL, employee_id, last_name, manager_id
FROM    employees
START   WITH last_name = 'King'
CONNECT BY PRIOR employee_id = manager_id ;
SELECT  LEVEL, employee_id, last_name, manager_id
FROM    employees
START   WITH last_name = 'Kochhar'
CONNECT BY PRIOR employee_id = manager_id ;

SELECT LPAD(last_name, LENGTH(last_name)+(LEVEL*2)-2,'_')  AS org_chart
FROM   employees 
START WITH last_name='King' 
CONNECT BY PRIOR employee_id=manager_id; 

SELECT  CONNECT_BY_ROOT(employee_id) AS root, 
        employee_id, last_name, 
        SYS_CONNECT_BY_PATH(employee_id, '/') AS 경로
FROM    employees
START   WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id;


