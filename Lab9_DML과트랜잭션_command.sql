-- Part 1 : 데이터 조작어(DML)
INSERT INTO departments(department_id, department_name, manager_id, location_id)
VALUES (70, 'Public Relations', 100, 1700);
INSERT INTO departments
VALUES (70, 'Public Relations', 100, 1700);

INSERT INTO	departments (department_id, department_name)
VALUES (30, 'Purchasing');
INSERT INTO departments(department_id, department_name, location_id)
VALUES (40, 'Human Resource', 2500);
INSERT INTO	departments
VALUES (100, 'Finance', NULL, NULL);

INSERT INTO employees 
VALUES(113, ＇승현', ＇최', 'SHCHOI', '515.124.4567', SYSDATE,       
       'AC_ACCOUNT', 6900, NULL, 205, 10);

INSERT INTO employees
VALUES      (114, '다혜', '송', 
             'DHSONG', '515.127.4561',
              TO_DATE('02 03, 1999', 'MM DD, YYYY'),
             'AC_ACCOUNT', 11000, NULL, 100, 10);

CREATE TABLE  sales_reps(id, name, salary, comm, job_id, department_id)
AS 
SELECT employee_id, last_name, salary, commission_pct, 
       job_id, department_id 
FROM   employees
WHERE 1=2;

SELECT  * FROM sales_reps;

INSERT INTO sales_reps(id, name, salary, comm, job_id, department_id)
SELECT employee_id, last_name, salary, commission_pct, job_id, department_id
FROM   employees
WHERE  job_id LIKE '%REP%';

SELECT * FROM sales_reps;

UPDATE employees
SET    department_id = 70
WHERE  employee_id = 113;
UPDATE sales_reps
SET salary = 8000;

ROLLBACK;

UPDATE   employees
SET      job_id  = (SELECT  job_id 
                    FROM    employees 
                    WHERE   employee_id = 205), 
         salary  = (SELECT  salary 
                    FROM    employees 
                    WHERE   employee_id = 205) 
WHERE    employee_id    =  114;

UPDATE employees
SET    department_id = 55
WHERE  department_id = 110;

DELETE FROM departments
WHERE  department_name = 'Finance';
DELETE FROM sales_reps;

DELETE FROM employees
WHERE  department_id =
                       (SELECT department_id
                        FROM   departments
                        WHERE  department_name LIKE '%Public%');

DELETE FROM departments
WHERE department_id = 60;

--Part 2 : 트랜잭션(Transaction)
DELETE FROM employees
WHERE  employee_id = 206;
INSERT INTO departments 
VALUES (290, 'Corporate Tax', NULL, 1700);
COMMIT;

--자신의 정보로 변경하여 공용데이터베이스에서 실행
INSERT INTO std
VALUES('1234567','홍길동','01012345678','gdhong@gmail.com', '99/01/01', sysdate, 100);






