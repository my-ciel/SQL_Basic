--Part 1 : 표준조인 
SELECT department_id, department_name,location_id, city
FROM   departments
NATURAL JOIN locations ;
SELECT employee_id, last_name, department_name
FROM   employees  JOIN departments 
USING (department_id) ;
SELECT employee_id, last_name, employees.department_id, location_id
FROM   employees  JOIN  departments 
ON     (employees.department_id = departments.department_id);

SELECT employees.employee_id, employees.last_name, departments.department_name
FROM   employees  JOIN departments 
ON     (employees.department_id = departments.department_id)
SELECT e.employee_id, e.last_name, d.department_name
FROM   employees e JOIN departments d 
ON     (e.department_id = d.department_id);

SELECT employee_id, city, department_name
FROM   employees e 
JOIN   departments d
ON     (d.department_id = e.department_)
JOIN   locations l
ON     (d.location_id = l.location_id);

SELECT e.employee_id, e.last_name, e.department_id, 
d.department_id, d.location_id
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
AND e.manager_id = 149 ;
SELECT e.employee_id, e.last_name, e.department_id, 
d.department_id, d.location_id
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
WHERE e.manager_id = 149 ;

SELECT worker.last_name emp, manager.last_name mgr
FROM employees worker JOIN employees manager
ON (worker.manager_id = manager.employee_id);

SELECT e.last_name, e.salary, j.grade_level
FROM employees e JOIN job_grades j
ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;

SELECT e.last_name, e.department_id, d.department_name
FROM   employees e LEFT OUTER JOIN departments d
ON   (e.department_id = d.department_id) ;
SELECT e.last_name, e.department_id, d.department_name
FROM   employees e RIGHT OUTER JOIN departments d
ON   (e.department_id = d.department_id) ;
SELECT e.last_name, e.department_id, d.department_name
FROM   employees e FULL OUTER JOIN departments d
ON   (e.department_id = d.department_id) ;

SELECT  last_name, city
FROM    employees NATURAL JOIN locations;
SELECT last_name, department_name
FROM   employees CROSS JOIN departments ;

--Part 2 : 오라클 조인
SELECT e.employee_id, e.last_name, e.department_id,
       d.department_name, d.location_id
FROM   employees e , departments d
WHERE  e.department_id = d.department_id
AND    e.department_id IN (50,60);
SELECT e.last_name, e.salary, j.grade_level
FROM employees e, job_grades j
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal;
SELECT e.employee_id, e.last_name, e.manager_id, 
          m.last_name as manager_name 
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

SELECT e.last_name, e.department_id, d.department_name
FROM   employees e, departments d
WHERE  e.department_id(+) = d.department_id ; 
SELECT e.last_name, e.department_id, d.department_name
FROM   employees e, departments d
WHERE  e.department_id = d.department_id (+) ; 
SELECT e.last_name, e.department_id, d.department_name
FROM   employees e, departments d
WHERE  e.department_id(+) = d.department_id
AND    e.department_id = d.department_id+);
SELECT e.last_name, e.department_id, d.department_name
FROM   employees e, departments d
WHERE  e.department_id(+) = d.department_id
UNION
SELECT e.last_name, e.department_id, d.department_name
FROM   employees e, departments d
WHERE  e.department_id = d.department_id(+);


