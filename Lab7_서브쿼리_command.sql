-- Part 1 : 기본 서브쿼리
SELECT last_name
FROM   employees
WHERE  salary >
               (SELECT salary
                FROM   employees
                WHERE  last_name = 'Abel');

SELECT last_name, job_id, salary
FROM   employees
WHERE  job_id =  
                (SELECT job_id
                 FROM   employees
                 WHERE  employee_id = 141)
AND    salary >
                (SELECT salary
                 FROM   employees
                 WHERE  employee_id = 143);

SELECT last_name, job_id, salary
FROM   employees
WHERE  salary = 
                (SELECT MIN(salary)
                 FROM   employees);

SELECT   department_id, MIN(salary)
FROM     employees
GROUP BY department_id
HAVING   MIN(salary) >
                       (SELECT MIN(salary)
                        FROM   employees
                        WHERE  department_id = 50);

SELECT employee_id, last_name
FROM   employees
WHERE  salary =
                (SELECT   MIN(salary)
                 FROM     employees
                 GROUP BY department_id);

SELECT last_name, manager_id
FROM   employees
WHERE  manager_id =
                (SELECT job_id
                 FROM   employees
                 WHERE  last_name = 'Haas');

SELECT employee_id, last_name, job_id, salary
FROM   employees
WHERE  salary < ANY
                    (SELECT salary
                     FROM   employees
                     WHERE  job_id = 'IT_PROG')
AND    job_id <> 'IT_PROG';

SELECT employee_id, last_name, job_id, salary
FROM   employees
WHERE  salary < ALL
                    (SELECT salary
                     FROM   employees
                     WHERE  job_id = 'IT_PROG')
AND    job_id <> 'IT_PROG';

SELECT emp.last_name
    FROM   employees emp
    WHERE  emp.employee_id  IN
                              (SELECT mgr.manager_id
                               FROM   employees mgr);

SELECT emp.last_name
FROM   employees emp
WHERE  emp.employee_id NOT IN
                             (SELECT mgr.manager_id
                              FROM   employees mgr);

SELECT last_name FROM employees
    WHERE  employee_id NOT IN
                            (SELECT manager_id 
                             FROM   employees 
                             WHERE  manager_id IS NOT NULL);

SELECT employee_id, manager_id, department_id
FROM empl_demo
WHERE (manager_id, department_id) IN
			   (SELECT manager_id, department_id
				FROM empl_demo
				WHERE first_name = 'John')
AND first_name <> 'John';

SELECT employee_id, manager_id, department_id
FROM empl_demo
WHERE manager_id IN
			(SELECT manager_id 
			   FROM empl_demo
			   WHERE first_name = 'John')
AND department_id IN
			(SELECT department_id
			   FROM empl_demo
			   WHERE first_name = 'John') 
AND first_name <> 'John';

SELECT employee_id, last_name,
       CASE WHEN department_id = (SELECT department_id 
                                  FROM departments
                                  WHERE location_id = 1800)    
       THEN 'Canada' ELSE 'USA' END AS location
FROM   employees;   

SELECT d.department_id, d.department_name, 
          (SELECT MAX(salary) FROM employees
           WHERE department_id = d.department_id) AS 최고급여
FROM departments d;

SELECT last_name, salary, department_id
FROM   employees outer
WHERE  salary > (SELECT AVG(salary)
                 FROM   employees
                 WHERE  department_id = outer.department_id) ;

SELECT employee_id, last_name, job_id, department_id
FROM   employees outer
WHERE  EXISTS ( SELECT 'X'
                 FROM   employees
                 WHERE  manager_id = outer.employee_id);
SELECT employee_id,last_name,job_id,department_id
FROM   employees 
WHERE  employee_id IN (SELECT manager_id
                       FROM   employees
                       WHERE  manager_id IS NOT NULL);

SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (SELECT 'X'
                  FROM   employees
                  WHERE  department_id = d.department_id);

SELECT  a.last_name, a.salary, a.department_id, b.salavg
FROM    employees a JOIN  (SELECT   department_id, 
                           TRUNC(AVG(salary)) salavg
                           FROM     employees
                           GROUP BY department_id) b
ON      (a.department_id = b.department_id)
WHERE   a.salary > b.salavg;

SELECT ROWNUM as RANK, last_name, salary 
FROM  (SELECT last_name,salary FROM employees
       ORDER BY salary DESC)
WHERE ROWNUM <= 3;
SELECT ROWNUM as SENIOR,E.last_name, E.hire_date
FROM  (SELECT last_name,hire_date FROM employees
       ORDER BY hire_date)E
WHERE rownum <= 4;

WITH 
dept_costs  AS (
   SELECT  d.department_name, SUM(e.salary) AS dept_total
   FROM    employees e JOIN departments d
   ON      (e.department_id = d.department_id)
   GROUP BY d.department_name),
avg_cost    AS (
   SELECT SUM(dept_total)/COUNT(*) AS dept_avg
   FROM   dept_costs)
SELECT * 
FROM   dept_costs 
WHERE  dept_total >
        (SELECT dept_avg 
         FROM avg_cost)
ORDER BY department_name;




