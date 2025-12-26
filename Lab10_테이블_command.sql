--Part 1 : 테이블 생성
CREATE TABLE dept
	(deptno NUMBER(2),
	 dname 	VARCHAR2(14),
	 loc 	VARCHAR2(13));
DESCRIBE dept

CREATE TABLE 	dept80
  AS 
    SELECT  employee_id, last_name, 
            salary*12 ANNSAL, 
            hire_date
    FROM    employees
    WHERE   department_id = 80;

--Part 2 : 테이블 관리
ALTER TABLE dept80
ADD(job_id VARCHAR2(9));

ALTER TABLE	dept80
MODIFY (last_name VARCHAR2(30));

ALTER TABLE  dept80
DROP COLUMN  job_id; 

TRUNCATE TABLE dept80;

DROP TABLE dept80;
show recyclebin;
SELECT original_name, operation, droptime FROM 
recyclebin;
FLASHBACK TABLE dept80 TO BEFORE DROP;

--Part 3 : 제약조건
CREATE TABLE emp(
  	     emp_id     NUMBER(6)PRIMARY KEY,
    	     emp_name   VARCHAR2(20) NOT NULL,
  	     manager_id NUMBER(6),
  	     job             VARCHAR2(10) NOT NULL,
	     CONSTRAINT emp_job_uk UNIQUE(job));

DESCRIBE departments

CREATE TABLE emp3(
    employee_id    NUMBER(6)PRIMARY KEY,
    last_name      VARCHAR2(25) NOT NULL,
    salary         NUMBER(8,2),
    commission_pct NUMBER(2,2),
    hire_date      DATE 
                   CONSTRAINT emp3_hire_date_nn
                   NOT NULL,
    department_id  NUMBER(6));

CREATE TABLE emp4(
    employee_id      NUMBER(6)PRIMARY KEY,
    last_name        VARCHAR2(25) NOT NULL,
    email            VARCHAR2(25),
    salary           NUMBER(8,2),
    commission_pct   NUMBER(2,2),
    hire_date        DATE NOT NULL,
    CONSTRAINT emp4_email_uk UNIQUE(email));

CREATE TABLE   dept1(
    department_id        NUMBER(4),
    department_name      VARCHAR2(30) 
      CONSTRAINT dept1_name_nn NOT NULL,
    manager_id           NUMBER(6),
    location_id          NUMBER(4),
      CONSTRAINT dept1_id_pk PRIMARY KEY(department_id));

CREATE TABLE emp5(
    employee_id      NUMBER(6) PRIMARY KEY,
    last_name        VARCHAR2(25) NOT NULL,
    email            VARCHAR2(25),
    job_id           VARCHAR2(10) REFERENCES jobs(job_id), 
    salary           NUMBER(8,2),
    comm_pct   NUMBER(2,2),
    hire_date        DATE NOT NULL,
    dept_id    NUMBER(4),
    CONSTRAINT emp5_dept_fk FOREIGN KEY (dept_id)
      REFERENCES dept1(department_id));

ALTER TABLE emp
ADD CONSTRAINT  emp_manager_fk 
  FOREIGN KEY(manager_id) 
  REFERENCES emp1(emp_id);

ALTER TABLE      emp4
DROP CONSTRAINT emp4_email_uk;
ALTER TABLE	dept1
DROP PRIMARY KEY CASCADE;

SELECT constraint_name, constraint_type, search_condition, status
FROM	user_constraints
WHERE	table_name = 'EMPLOYEES';
SELECT constraint_name, column_name
FROM	user_cons_columns
WHERE	table_name = 'EMPLOYEES';

SELECT c.table_name, cc.column_name, c.constraint_name,    
       c.constraint_type, c.status 
FROM user_constraints c JOIN user_cons_columns cc
ON (c.constraint_name = cc.constraint_name)
WHERE c.table_name = 'EMPLOYEES';



