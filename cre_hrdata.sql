DROP TABLE regions CASCADE CONSTRAINTS PURGE;
DROP TABLE locations CASCADE CONSTRAINTS PURGE;
DROP TABLE departments CASCADE CONSTRAINTS PURGE;
DROP TABLE jobs CASCADE CONSTRAINTS PURGE;
DROP TABLE employees CASCADE CONSTRAINTS PURGE;
DROP TABLE job_history CASCADE CONSTRAINTS PURGE;
DROP TABLE job_grades CASCADE CONSTRAINTS PURGE;
DROP TABLE countries CASCADE CONSTRAINTS PURGE;

REM ********************************************************************
REM Create the REGIONS table to hold region information for locations
REM HR.LOCATIONS table has a foreign key to this table.

Prompt ******  Creating REGIONS table ....

CREATE TABLE regions
    ( region_id      NUMBER 
       CONSTRAINT  region_id_nn NOT NULL 
       CONSTRAINT reg_id_pk PRIMARY KEY
     , region_name    VARCHAR2(25) 
    );

REM ********************************************************************
REM Create the COUNTRIES table to hold country information for customers
REM and company locations. 
REM OE.CUSTOMERS table and HR.LOCATIONS have a foreign key to this table.

Prompt ******  Creating COUNTRIES table ....

CREATE TABLE countries 
    ( country_id      CHAR(2) 
       CONSTRAINT  country_id_nn NOT NULL 
    , country_name    VARCHAR2(40) 
    , region_id       NUMBER 
    , CONSTRAINT     country_c_id_pk 
        	     PRIMARY KEY (country_id) 
    ) 
    ORGANIZATION INDEX; 

ALTER TABLE countries
ADD ( CONSTRAINT countr_reg_fk
        	 FOREIGN KEY (region_id)
          	  REFERENCES regions(region_id) 
    ) ;

REM ********************************************************************
REM Create the LOCATIONS table to hold address information for company departments.
REM HR.DEPARTMENTS has a foreign key to this table.

Prompt ******  Creating LOCATIONS table ....

CREATE TABLE locations
    ( location_id    NUMBER(4) CONSTRAINT loc_id_pk PRIMARY KEY
    , street_address VARCHAR2(40)
    , postal_code    VARCHAR2(12)
    , city       VARCHAR2(30)
	CONSTRAINT     loc_city_nn  NOT NULL
    , state_province VARCHAR2(25)
    , country_id     CHAR(2)  CONSTRAINT loc_c_id_fk REFERENCES countries(country_id)
    ) ;

REM ********************************************************************
REM Create the DEPARTMENTS table to hold company department information.
REM HR.EMPLOYEES and HR.JOB_HISTORY have a foreign key to this table.

Prompt ******  Creating DEPARTMENTS table ....

CREATE TABLE departments
    ( department_id    NUMBER(4) CONSTRAINT dept_id_pk PRIMARY KEY
    , department_name  VARCHAR2(30)
	CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       NUMBER(6)
    , location_id      NUMBER(4) CONSTRAINT dept_loc_fk REFERENCES locations (location_id)
    ) ;


REM ********************************************************************
REM Create the JOBS table to hold the different names of job roles within the company.
REM HR.EMPLOYEES has a foreign key to this table.

Prompt ******  Creating JOBS table ....

CREATE TABLE jobs
    ( job_id         VARCHAR2(10) CONSTRAINT job_id_pk PRIMARY KEY
    , job_title      VARCHAR2(35)
	CONSTRAINT     job_title_nn  NOT NULL
    , min_salary     NUMBER(6)
    , max_salary     NUMBER(6)
    ) ;

REM ********************************************************************
REM Create the EMPLOYEES table to hold the employee personnel 
REM information for the company.
REM HR.EMPLOYEES has a self referencing foreign key to this table.

Prompt ******  Creating EMPLOYEES table ....

CREATE TABLE employees
    ( employee_id    NUMBER(6) CONSTRAINT     emp_emp_id_pk PRIMARY KEY
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25)
	 CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR2(25)
	CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE
	CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR2(10)
	CONSTRAINT     emp_job_nn  NOT NULL
             CONSTRAINT     emp_job_fk REFERENCES jobs (job_id)
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6) 
    , department_id  NUMBER(4) CONSTRAINT     emp_dept_fk REFERENCES departments
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;

REM ********************************************************************
REM Create the JOB_HISTORY table to hold the history of jobs that 
REM employees have held in the past.
REM HR.JOBS, HR_DEPARTMENTS, and HR.EMPLOYEES have a foreign key to this table.

Prompt ******  Creating JOB_HISTORY table ....

CREATE TABLE job_history
    ( employee_id   NUMBER(6)
	 CONSTRAINT    jhist_employee_nn  NOT NULL
    , start_date    DATE
	CONSTRAINT    jhist_start_date_nn  NOT NULL
    , end_date      DATE
	CONSTRAINT    jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR2(10)
	CONSTRAINT    jhist_job_nn  NOT NULL
    , department_id NUMBER(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    ) ;

CREATE UNIQUE INDEX jhist_emp_id_st_date_pk 
ON job_history (employee_id, start_date) ;

ALTER TABLE job_history
ADD ( CONSTRAINT jhist_emp_id_st_date_pk
      PRIMARY KEY (employee_id, start_date)
    , CONSTRAINT     jhist_job_fk
                     FOREIGN KEY (job_id)
                     REFERENCES jobs
    , CONSTRAINT     jhist_dept_fk
                     FOREIGN KEY (department_id)
                     REFERENCES departments
    ) ;

CREATE TABLE job_grades
(grade_level VARCHAR2(3),
 lowest_sal  NUMBER,
 highest_sal NUMBER);

Insert into REGIONS (REGION_ID,REGION_NAME) values (1,'Europe');
Insert into REGIONS (REGION_ID,REGION_NAME) values (2,'Americas');
Insert into REGIONS (REGION_ID,REGION_NAME) values (3,'Asia');
Insert into REGIONS (REGION_ID,REGION_NAME) values (4,'Middle East and Africa');

Insert into COUNTRIES (COUNTRY_ID,COUNTRY_NAME,REGION_ID) values ('CA','Canada',2);
Insert into COUNTRIES (COUNTRY_ID,COUNTRY_NAME,REGION_ID) values ('DE','Germany',1);
Insert into COUNTRIES (COUNTRY_ID,COUNTRY_NAME,REGION_ID) values ('UK','United Kingdom',1);
Insert into COUNTRIES (COUNTRY_ID,COUNTRY_NAME,REGION_ID) values ('US','United States of America',2);

Insert into LOCATIONS (LOCATION_ID,STREET_ADDRESS,POSTAL_CODE,CITY,STATE_PROVINCE,COUNTRY_ID) 
values (1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US');
Insert into LOCATIONS (LOCATION_ID,STREET_ADDRESS,POSTAL_CODE,CITY,STATE_PROVINCE,COUNTRY_ID) 
values (1500,'2011 Interiors Blvd','99236','South San Francisco','California','US');
Insert into LOCATIONS (LOCATION_ID,STREET_ADDRESS,POSTAL_CODE,CITY,STATE_PROVINCE,COUNTRY_ID) 
values (1700,'2004 Charade Rd','98199','Seattle','Washington','US');
Insert into LOCATIONS (LOCATION_ID,STREET_ADDRESS,POSTAL_CODE,CITY,STATE_PROVINCE,COUNTRY_ID) 
values (1800,'460 Bloor St. W.','ON M5S 1X8','Toronto','Ontario','CA');
Insert into LOCATIONS (LOCATION_ID,STREET_ADDRESS,POSTAL_CODE,CITY,STATE_PROVINCE,COUNTRY_ID) 
values (2500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK');

Insert into DEPARTMENTS (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values (10,'Administration',200,1700);
Insert into DEPARTMENTS (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values (20,'Marketing',201,1800);
Insert into DEPARTMENTS (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values (50,'Shipping',124,1500);
Insert into DEPARTMENTS (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values (60,'IT',103,1400);
Insert into DEPARTMENTS (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values (80,'Sales',149,2500);
Insert into DEPARTMENTS (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values (90,'Executive',100,1700);
Insert into DEPARTMENTS (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values (110,'Accounting',205,1700);
Insert into DEPARTMENTS (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values (190,'Contracting',null,1700);

Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AD_PRES','President',20000,40000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AD_VP','Administration Vice President',15000,30000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AD_ASST','Administration Assistant',3000,6000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AC_MGR','Accounting Manager',8200,16000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AC_ACCOUNT','Public Accountant',4200,9000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('SA_MAN','Sales Manager',10000,20000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('SA_REP','Sales Representative',6000,12000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('ST_MAN','Stock Manager',5500,8500);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('ST_CLERK','Stock Clerk',2000,5000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('IT_PROG','Programmer',4000,10000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('MK_MAN','Marketing Manager',9000,15000);
Insert into JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('MK_REP','Marketing Representative',4000,9000);

Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (100,'Steven','King','SKING','515.123.4567',to_date('02/06/17','RR/MM/DD'),'AD_PRES',24000,null,null,90);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (101,'Neena','Kochhar','NKOCHHAR','515.123.4568',to_date('04/09/21','RR/MM/DD'),'AD_VP',17000,null,100,90);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (102,'Lex','De Haan','LDEHAAN','515.123.4569',to_date('08/01/13','RR/MM/DD'),'AD_VP',17000,null,100,90);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (103,'Alexander','Hunold','AHUNOLD','590.423.4567',to_date('05/01/03','RR/MM/DD'),'IT_PROG',9000,null,102,60);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (104,'Bruce','Ernst','BERNST','590.423.4568',to_date('06/05/21','RR/MM/DD'),'IT_PROG',6000,null,103,60);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (107,'Diana','Lorentz','DLORENTZ','590.423.5567',to_date('14/02/07','RR/MM/DD'),'IT_PROG',4200,null,103,60);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (124,'Kevin','Mourgos','KMOURGOS','650.123.5234',to_date('14/11/16','RR/MM/DD'),'ST_MAN',5800,null,100,50);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (141,'Trenna','Rajs','TRAJS','650.121.8009',to_date('10/10/17','RR/MM/DD'),'ST_CLERK',3500,null,124,50);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (142,'Curtis','Davies','CDAVIES','650.121.2994',to_date('12/01/29','RR/MM/DD'),'ST_CLERK',3100,null,124,50);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (143,'Randall','Matos','RMATOS','650.121.2874',to_date('13/03/15','RR/MM/DD'),'ST_CLERK',2600,null,124,50);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (144,'Peter','Vargas','PVARGAS','650.121.2004',to_date('13/07/09','RR/MM/DD'),'ST_CLERK',2500,null,124,50);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (149,'Eleni','Zlotkey','EZLOTKEY','011.44.1344.429018',to_date('15/01/29','RR/MM/DD'),'SA_MAN',10500,0.2,100,80);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (174,'Ellen','Abel','EABEL','011.44.1644.429267',to_date('11/05/11','RR/MM/DD'),'SA_REP',11000,0.3,149,80);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (176,'Jonathon','Taylor','JTAYLOR','011.44.1644.429265',to_date('13/03/24','RR/MM/DD'),'SA_REP',8600,0.2,149,80);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (178,'Kimberely','Grant','KGRANT','011.44.1644.429263',to_date('14/05/24','RR/MM/DD'),'SA_REP',7000,0.15,149,null);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (200,'Jennifer','Whalen','JWHALEN','515.123.4444',to_date('02/09/17','RR/MM/DD'),'AD_ASST',4400,null,101,10);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (201,'Michael','Hartstein','MHARTSTE','515.123.5555',to_date('11/02/17','RR/MM/DD'),'MK_MAN',13000,null,100,20);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (202,'Pat','Fay','PFAY','603.123.6666',to_date('12/08/17','RR/MM/DD'),'MK_REP',6000,null,201,20);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (205,'Shelley','Higgins','SHIGGINS','515.123.8080',to_date('09/06/07','RR/MM/DD'),'AC_MGR',12000,null,101,110);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (206,'William','Gietz','WGIETZ','515.123.8181',to_date('09/06/07','RR/MM/DD'),'AC_ACCOUNT',8300,null,205,110);

Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (102,to_date('08/01/13','RR/MM/DD'),to_date('13/07/24','RR/MM/DD'),'IT_PROG',60);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (101,to_date('04/09/21','RR/MM/DD'),to_date('08/10/27','RR/MM/DD'),'AC_ACCOUNT',110);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (101,to_date('08/10/28','RR/MM/DD'),to_date('12/03/15','RR/MM/DD'),'AC_MGR',110);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (201,to_date('11/02/17','RR/MM/DD'),to_date('14/12/19','RR/MM/DD'),'MK_REP',20);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (114,to_date('13/03/24','RR/MM/DD'),to_date('14/12/31','RR/MM/DD'),'ST_CLERK',50);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (122,to_date('14/01/01','RR/MM/DD'),to_date('14/12/31','RR/MM/DD'),'ST_CLERK',50);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (200,to_date('02/09/17','RR/MM/DD'),to_date('08/06/17','RR/MM/DD'),'AD_ASST',90);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (176,to_date('13/03/24','RR/MM/DD'),to_date('13/12/31','RR/MM/DD'),'SA_REP',80);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (176,to_date('14/01/01','RR/MM/DD'),to_date('14/12/31','RR/MM/DD'),'SA_MAN',80);
Insert into JOB_HISTORY (EMPLOYEE_ID,START_DATE,END_DATE,JOB_ID,DEPARTMENT_ID) values (200,to_date('09/07/01','RR/MM/DD'),to_date('13/12/31','RR/MM/DD'),'AC_ACCOUNT',90);

Insert into JOB_GRADES (GRADE_LEVEL,LOWEST_SAL,HIGHEST_SAL) values ('A',1000,2999);
Insert into JOB_GRADES (GRADE_LEVEL,LOWEST_SAL,HIGHEST_SAL) values ('B',3000,5999);
Insert into JOB_GRADES (GRADE_LEVEL,LOWEST_SAL,HIGHEST_SAL) values ('C',6000,9999);
Insert into JOB_GRADES (GRADE_LEVEL,LOWEST_SAL,HIGHEST_SAL) values ('D',10000,14999);
Insert into JOB_GRADES (GRADE_LEVEL,LOWEST_SAL,HIGHEST_SAL) values ('E',15000,24999);
Insert into JOB_GRADES (GRADE_LEVEL,LOWEST_SAL,HIGHEST_SAL) values ('F',25000,40000);

COMMIT;

ALTER TABLE departments
ADD ( CONSTRAINT dept_mgr_fk
      		 FOREIGN KEY (manager_id)
      		  REFERENCES employees (employee_id)
    ) ;

REM ********************************************************************
REM Create the EMPL_DEMO table

DROP TABLE empl_demo PURGE;

CREATE TABLE empl_demo
AS
SELECT * FROM employees
WHERE 1=2;

INSERT INTO empl_demo VALUES 
        ( 100
        , 'Steven'
        , 'King'
        , 'SKING'
        , '515.123.4567'
        , TO_DATE('17-06-1987', 'dd-mm-yyyy')
        , 'AD_PRES'
        , 24000
        , NULL
        , NULL
        , 90
        );

INSERT INTO empl_demo VALUES 
        ( 101
        , 'Neena'
        , 'Kochhar'
        , 'NKOCHHAR'
        , '515.123.4568'
        , TO_DATE('21-09-1989', 'dd-mm-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO empl_demo VALUES 
        ( 102
        , 'Lex'
        , 'De Haan'
        , 'LDEHAAN'
        , '515.123.4569'
        , TO_DATE('13-01-1993', 'dd-mm-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO empl_demo VALUES 
        ( 103
        , 'Alexander'
        , 'Hunold'
        , 'AHUNOLD'
        , '590.423.4567'
        , TO_DATE('03-01-1990', 'dd-mm-yyyy')
        , 'IT_PROG'
        , 9000
        , NULL
        , 102
        , 60
        );

INSERT INTO empl_demo VALUES 
        ( 104
        , 'Bruce'
        , 'Ernst'
        , 'BERNST'
        , '590.423.4568'
        , TO_DATE('21-05-1991', 'dd-mm-yyyy')
        , 'IT_PROG'
        , 6000
        , NULL
        , 103
        , 60
        );

INSERT INTO empl_demo VALUES 
        ( 105
        , 'David'
        , 'Austin'
        , 'DAUSTIN'
        , '590.423.4569'
        , TO_DATE('25-06-1997', 'dd-mm-yyyy')
        , 'IT_PROG'
        , 4800
        , NULL
        , 103
        , 60
        );

INSERT INTO empl_demo VALUES 
        ( 106
        , 'Valli'
        , 'Pataballa'
        , 'VPATABAL'
        , '590.423.4560'
        , TO_DATE('05-02-1998', 'dd-mm-yyyy')
        , 'IT_PROG'
        , 4800
        , NULL
        , 103
        , 60
        );

INSERT INTO empl_demo VALUES 
        ( 107
        , 'Diana'
        , 'Lorentz'
        , 'DLORENTZ'
        , '590.423.5567'
        , TO_DATE('07-02-1999', 'dd-mm-yyyy')
        , 'IT_PROG'
        , 4200
        , NULL
        , 103
        , 60
        );

INSERT INTO empl_demo VALUES 
        ( 108
        , 'Nancy'
        , 'Greenberg'
        , 'NGREENBE'
        , '515.124.4569'
        , TO_DATE('17-08-1994', 'dd-mm-yyyy')
        , 'FI_MGR'
        , 12000
        , NULL
        , 101
        , 100
        );

INSERT INTO empl_demo VALUES 
        ( 109
        , 'Daniel'
        , 'Faviet'
        , 'DFAVIET'
        , '515.124.4169'
        , TO_DATE('16-08-1994', 'dd-mm-yyyy')
        , 'FI_ACCOUNT'
        , 9000
        , NULL
        , 108
        , 100
        );

INSERT INTO empl_demo VALUES 
        ( 110
        , 'John'
        , 'Chen'
        , 'JCHEN'
        , '515.124.4269'
        , TO_DATE('28-09-1997', 'dd-mm-yyyy')
        , 'FI_ACCOUNT'
        , 8200
        , NULL
        , 108
        , 100
        );

INSERT INTO empl_demo VALUES 
        ( 111
        , 'Ismael'
        , 'Sciarra'
        , 'ISCIARRA'
        , '515.124.4369'
        , TO_DATE('30-09-1997', 'dd-mm-yyyy')
        , 'FI_ACCOUNT'
        , 7700
        , NULL
        , 108
        , 100
        );

INSERT INTO empl_demo VALUES 
        ( 112
        , 'Jose Manuel'
        , 'Urman'
        , 'JMURMAN'
        , '515.124.4469'
        , TO_DATE('07-03-1998', 'dd-mm-yyyy')
        , 'FI_ACCOUNT'
        , 7800
        , NULL
        , 108
        , 100
        );

INSERT INTO empl_demo VALUES 
        ( 113
        , 'Luis'
        , 'Popp'
        , 'LPOPP'
        , '515.124.4567'
        , TO_DATE('07-12-1999', 'dd-mm-yyyy')
        , 'FI_ACCOUNT'
        , 6900
        , NULL
        , 108
        , 100
        );

INSERT INTO empl_demo VALUES 
        ( 114
        , 'Den'
        , 'Raphaely'
        , 'DRAPHEAL'
        , '515.127.4561'
        , TO_DATE('07-12-1994', 'dd-mm-yyyy')
        , 'PU_MAN'
        , 11000
        , NULL
        , 100
        , 30
        );

INSERT INTO empl_demo VALUES 
        ( 115
        , 'Alexander'
        , 'Khoo'
        , 'AKHOO'
        , '515.127.4562'
        , TO_DATE('18-05-1995', 'dd-mm-yyyy')
        , 'PU_CLERK'
        , 3100
        , NULL
        , 114
        , 30
        );

INSERT INTO empl_demo VALUES 
        ( 116
        , 'Shelli'
        , 'Baida'
        , 'SBAIDA'
        , '515.127.4563'
        , TO_DATE('24-12-1997', 'dd-mm-yyyy')
        , 'PU_CLERK'
        , 2900
        , NULL
        , 114
        , 30
        );

INSERT INTO empl_demo VALUES 
        ( 117
        , 'Sigal'
        , 'Tobias'
        , 'STOBIAS'
        , '515.127.4564'
        , TO_DATE('24-07-1997', 'dd-mm-yyyy')
        , 'PU_CLERK'
        , 2800
        , NULL
        , 114
        , 30
        );

INSERT INTO empl_demo VALUES 
        ( 118
        , 'Guy'
        , 'Himuro'
        , 'GHIMURO'
        , '515.127.4565'
        , TO_DATE('15-11-1998', 'dd-mm-yyyy')
        , 'PU_CLERK'
        , 2600
        , NULL
        , 114
        , 30
        );

INSERT INTO empl_demo VALUES 
        ( 119
        , 'Karen'
        , 'Colmenares'
        , 'KCOLMENA'
        , '515.127.4566'
        , TO_DATE('10-08-1999', 'dd-mm-yyyy')
        , 'PU_CLERK'
        , 2500
        , NULL
        , 114
        , 30
        );

INSERT INTO empl_demo VALUES 
        ( 120
        , 'Matthew'
        , 'Weiss'
        , 'MWEISS'
        , '650.123.1234'
        , TO_DATE('18-07-1996', 'dd-mm-yyyy')
        , 'ST_MAN'
        , 8000
        , NULL
        , 100
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 121
        , 'Adam'
        , 'Fripp'
        , 'AFRIPP'
        , '650.123.2234'
        , TO_DATE('10-04-1997', 'dd-mm-yyyy')
        , 'ST_MAN'
        , 8200
        , NULL
        , 100
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 122
        , 'Payam'
        , 'Kaufling'
        , 'PKAUFLIN'
        , '650.123.3234'
        , TO_DATE('01-05-1995', 'dd-mm-yyyy')
        , 'ST_MAN'
        , 7900
        , NULL
        , 100
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 123
        , 'Shanta'
        , 'Vollman'
        , 'SVOLLMAN'
        , '650.123.4234'
        , TO_DATE('10-10-1997', 'dd-mm-yyyy')
        , 'ST_MAN'
        , 6500
        , NULL
        , 100
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 124
        , 'Kevin'
        , 'Mourgos'
        , 'KMOURGOS'
        , '650.123.5234'
        , TO_DATE('16-11-1999', 'dd-mm-yyyy')
        , 'ST_MAN'
        , 5800
        , NULL
        , 100
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 125
        , 'Julia'
        , 'Nayer'
        , 'JNAYER'
        , '650.124.1214'
        , TO_DATE('16-07-1997', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 3200
        , NULL
        , 120
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 126
        , 'Irene'
        , 'Mikkilineni'
        , 'IMIKKILI'
        , '650.124.1224'
        , TO_DATE('28-09-1998', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2700
        , NULL
        , 120
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 127
        , 'James'
        , 'Landry'
        , 'JLANDRY'
        , '650.124.1334'
        , TO_DATE('14-01-1999', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2400
        , NULL
        , 120
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 128
        , 'Steven'
        , 'Markle'
        , 'SMARKLE'
        , '650.124.1434'
        , TO_DATE('08-03-2000', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2200
        , NULL
        , 120
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 129
        , 'Laura'
        , 'Bissot'
        , 'LBISSOT'
        , '650.124.5234'
        , TO_DATE('20-08-1997', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 3300
        , NULL
        , 121
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 130
        , 'Mozhe'
        , 'Atkinson'
        , 'MATKINSO'
        , '650.124.6234'
        , TO_DATE('30-10-1997', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2800
        , NULL
        , 121
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 131
        , 'James'
        , 'Marlow'
        , 'JAMRLOW'
        , '650.124.7234'
        , TO_DATE('16-02-1997', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2500
        , NULL
        , 121
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 132
        , 'TJ'
        , 'Olson'
        , 'TJOLSON'
        , '650.124.8234'
        , TO_DATE('10-04-1999', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2100
        , NULL
        , 121
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 133
        , 'Jason'
        , 'Mallin'
        , 'JMALLIN'
        , '650.127.1934'
        , TO_DATE('14-06-1996', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 3300
        , NULL
        , 122
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 134
        , 'Michael'
        , 'Rogers'
        , 'MROGERS'
        , '650.127.1834'
        , TO_DATE('26-08-1998', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2900
        , NULL
        , 122
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 135
        , 'Ki'
        , 'Gee'
        , 'KGEE'
        , '650.127.1734'
        , TO_DATE('12-12-1999', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2400
        , NULL
        , 122
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 136
        , 'Hazel'
        , 'Philtanker'
        , 'HPHILTAN'
        , '650.127.1634'
        , TO_DATE('06-02-2000', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2200
        , NULL
        , 122
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 137
        , 'Renske'
        , 'Ladwig'
        , 'RLADWIG'
        , '650.121.1234'
        , TO_DATE('14-07-1995', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 3600
        , NULL
        , 123
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 138
        , 'Stephen'
        , 'Stiles'
        , 'SSTILES'
        , '650.121.2034'
        , TO_DATE('26-10-1997', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 3200
        , NULL
        , 123
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 139
        , 'John'
        , 'Seo'
        , 'JSEO'
        , '650.121.2019'
        , TO_DATE('12-02-1998', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2700
        , NULL
        , 123
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 140
        , 'Joshua'
        , 'Patel'
        , 'JPATEL'
        , '650.121.1834'
        , TO_DATE('06-04-1998', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2500
        , NULL
        , 123
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 141
        , 'Trenna'
        , 'Rajs'
        , 'TRAJS'
        , '650.121.8009'
        , TO_DATE('17-10-1995', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 3500
        , NULL
        , 124
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 142
        , 'Curtis'
        , 'Davies'
        , 'CDAVIES'
        , '650.121.2994'
        , TO_DATE('29-01-1997', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 3100
        , NULL
        , 124
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 143
        , 'Randall'
        , 'Matos'
        , 'RMATOS'
        , '650.121.2874'
        , TO_DATE('15-03-1998', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 144
        , 'Peter'
        , 'Vargas'
        , 'PVARGAS'
        , '650.121.2004'
        , TO_DATE('09-07-1998', 'dd-mm-yyyy')
        , 'ST_CLERK'
        , 2500
        , NULL
        , 124
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 145
        , 'John'
        , 'Russell'
        , 'JRUSSEL'
        , '011.44.1344.429268'
        , TO_DATE('01-10-1996', 'dd-mm-yyyy')
        , 'SA_MAN'
        , 14000
        , .4
        , 100
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 146
        , 'Karen'
        , 'Partners'
        , 'KPARTNER'
        , '011.44.1344.467268'
        , TO_DATE('05-01-1997', 'dd-mm-yyyy')
        , 'SA_MAN'
        , 13500
        , .3
        , 100
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 147
        , 'Alberto'
        , 'Errazuriz'
        , 'AERRAZUR'
        , '011.44.1344.429278'
        , TO_DATE('10-03-1997', 'dd-mm-yyyy')
        , 'SA_MAN'
        , 12000
        , .3
        , 100
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 148
        , 'Gerald'
        , 'Cambrault'
        , 'GCAMBRAU'
        , '011.44.1344.619268'
        , TO_DATE('15-10-1999', 'dd-mm-yyyy')
        , 'SA_MAN'
        , 11000
        , .3
        , 100
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 149
        , 'Eleni'
        , 'Zlotkey'
        , 'EZLOTKEY'
        , '011.44.1344.429018'
        , TO_DATE('29-01-2000', 'dd-mm-yyyy')
        , 'SA_MAN'
        , 10500
        , .2
        , 100
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 150
        , 'Peter'
        , 'Tucker'
        , 'PTUCKER'
        , '011.44.1344.129268'
        , TO_DATE('30-01-1997', 'dd-mm-yyyy')
        , 'SA_REP'
        , 10000
        , .3
        , 145
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 151
        , 'David'
        , 'Bernstein'
        , 'DBERNSTE'
        , '011.44.1344.345268'
        , TO_DATE('24-03-1997', 'dd-mm-yyyy')
        , 'SA_REP'
        , 9500
        , .25
        , 145
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 152
        , 'Peter'
        , 'Hall'
        , 'PHALL'
        , '011.44.1344.478968'
        , TO_DATE('20-08-1997', 'dd-mm-yyyy')
        , 'SA_REP'
        , 9000
        , .25
        , 145
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 153
        , 'Christopher'
        , 'Olsen'
        , 'COLSEN'
        , '011.44.1344.498718'
        , TO_DATE('30-03-1998', 'dd-mm-yyyy')
        , 'SA_REP'
        , 8000
        , .2
        , 145
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 154
        , 'Nanette'
        , 'Cambrault'
        , 'NCAMBRAU'
        , '011.44.1344.987668'
        , TO_DATE('09-12-1998', 'dd-mm-yyyy')
        , 'SA_REP'
        , 7500
        , .2
        , 145
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 155
        , 'Oliver'
        , 'Tuvault'
        , 'OTUVAULT'
        , '011.44.1344.486508'
        , TO_DATE('23-11-1999', 'dd-mm-yyyy')
        , 'SA_REP'
        , 7000
        , .15
        , 145
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 156
        , 'jeanette'
        , 'King'
        , 'JKING'
        , '011.44.1345.429268'
        , TO_DATE('30-01-1996', 'dd-mm-yyyy')
        , 'SA_REP'
        , 10000
        , .35
        , 146
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 157
        , 'Patrick'
        , 'Sully'
        , 'PSULLY'
        , '011.44.1345.929268'
        , TO_DATE('04-03-1996', 'dd-mm-yyyy')
        , 'SA_REP'
        , 9500
        , .35
        , 146
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 158
        , 'Allan'
        , 'McEwen'
        , 'AMCEWEN'
        , '011.44.1345.829268'
        , TO_DATE('01-08-1996', 'dd-mm-yyyy')
        , 'SA_REP'
        , 9000
        , .35
        , 146
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 159
        , 'Lindsey'
        , 'Smith'
        , 'LSMITH'
        , '011.44.1345.729268'
        , TO_DATE('10-03-1997', 'dd-mm-yyyy')
        , 'SA_REP'
        , 8000
        , .3
        , 146
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 160
        , 'Louise'
        , 'Doran'
        , 'LDORAN'
        , '011.44.1345.629268'
        , TO_DATE('15-12-1997', 'dd-mm-yyyy')
        , 'SA_REP'
        , 7500
        , .3
        , 146
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 161
        , 'Sarath'
        , 'Sewall'
        , 'SSEWALL'
        , '011.44.1345.529268'
        , TO_DATE('03-11-1998', 'dd-mm-yyyy')
        , 'SA_REP'
        , 7000
        , .25
        , 146
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 162
        , 'Clara'
        , 'Vishney'
        , 'CVISHNEY'
        , '011.44.1346.129268'
        , TO_DATE('11-11-1997', 'dd-mm-yyyy')
        , 'SA_REP'
        , 10500
        , .25
        , 147
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 163
        , 'Danielle'
        , 'Greene'
        , 'DGREENE'
        , '011.44.1346.229268'
        , TO_DATE('19-03-1999', 'dd-mm-yyyy')
        , 'SA_REP'
        , 9500
        , .15
        , 147
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 164
        , 'Mattea'
        , 'Marvins'
        , 'MMARVINS'
        , '011.44.1346.329268'
        , TO_DATE('24-01-2000', 'dd-mm-yyyy')
        , 'SA_REP'
        , 7200
        , .10
        , 147
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 165
        , 'David'
        , 'Lee'
        , 'DLEE'
        , '011.44.1346.529268'
        , TO_DATE('23-02-2000', 'dd-mm-yyyy')
        , 'SA_REP'
        , 6800
        , .1
        , 147
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 166
        , 'Sundar'
        , 'Ande'
        , 'SANDE'
        , '011.44.1346.629268'
        , TO_DATE('24-03-2000', 'dd-mm-yyyy')
        , 'SA_REP'
        , 6400
        , .10
        , 147
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 167
        , 'Amit'
        , 'Banda'
        , 'ABANDA'
        , '011.44.1346.729268'
        , TO_DATE('21-04-2000', 'dd-mm-yyyy')
        , 'SA_REP'
        , 6200
        , .10
        , 147
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 168
        , 'Lisa'
        , 'Ozer'
        , 'LOZER'
        , '011.44.1343.929268'
        , TO_DATE('11-03-1997', 'dd-mm-yyyy')
        , 'SA_REP'
        , 11500
        , .25
        , 148
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 169  
        , 'Harrison'
        , 'Bloom'
        , 'HBLOOM'
        , '011.44.1343.829268'
        , TO_DATE('23-03-1998', 'dd-mm-yyyy')
        , 'SA_REP'
        , 10000
        , .20
        , 148
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 170
        , 'Tayler'
        , 'Fox'
        , 'TFOX'
        , '011.44.1343.729268'
        , TO_DATE('24-01-1998', 'dd-mm-yyyy')
        , 'SA_REP'
        , 9600
        , .20
        , 148
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 171
        , 'William'
        , 'Smith'
        , 'WSMITH'
        , '011.44.1343.629268'
        , TO_DATE('23-02-1999', 'dd-mm-yyyy')
        , 'SA_REP'
        , 7400
        , .15
        , 148
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 172
        , 'Elizabeth'
        , 'Bates'
        , 'EBATES'
        , '011.44.1343.529268'
        , TO_DATE('24-03-1999', 'dd-mm-yyyy')
        , 'SA_REP'
        , 7300
        , .15
        , 148
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 173
        , 'Sundita'
        , 'Kumar'
        , 'SKUMAR'
        , '011.44.1343.329268'
        , TO_DATE('21-04-2000', 'dd-mm-yyyy')
        , 'SA_REP'
        , 6100
        , .10
        , 148
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 174
        , 'Ellen'
        , 'Abel'
        , 'EABEL'
        , '011.44.1644.429267'
        , TO_DATE('11-05-1996', 'dd-mm-yyyy')
        , 'SA_REP'
        , 11000
        , .30
        , 149
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 175
        , 'Alyssa'
        , 'Hutton'
        , 'AHUTTON'
        , '011.44.1644.429266'
        , TO_DATE('19-03-1997', 'dd-mm-yyyy')
        , 'SA_REP'
        , 8800
        , .25
        , 149
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 176
        , 'Jonathon'
        , 'Taylor'
        , 'JTAYLOR'
        , '011.44.1644.429265'
        , TO_DATE('24-03-1998', 'dd-mm-yyyy')
        , 'SA_REP'
        , 8600
        , .20
        , 149
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 177
        , 'Jack'
        , 'Livingston'
        , 'JLIVINGS'
        , '011.44.1644.429264'
        , TO_DATE('23-04-1998', 'dd-mm-yyyy')
        , 'SA_REP'
        , 8400
        , .20
        , 149
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 178
        , 'Kimberely'
        , 'Grant'
        , 'KGRANT'
        , '011.44.1644.429263'
        , TO_DATE('24-05-1999', 'dd-mm-yyyy')
        , 'SA_REP'
        , 7000
        , .15
        , 149
        , NULL
        );

INSERT INTO empl_demo VALUES 
        ( 179
        , 'Charles'
        , 'Johnson'
        , 'CJOHNSON'
        , '011.44.1644.429262'
        , TO_DATE('04-01-2000', 'dd-mm-yyyy')
        , 'SA_REP'
        , 6200
        , .10
        , 149
        , 80
        );

INSERT INTO empl_demo VALUES 
        ( 180
        , 'Winston'
        , 'Taylor'
        , 'WTAYLOR'
        , '650.507.9876'
        , TO_DATE('24-01-1998', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3200
        , NULL
        , 120
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 181
        , 'Jean'
        , 'Fleaur'
        , 'JFLEAUR'
        , '650.507.9877'
        , TO_DATE('23-02-1998', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3100
        , NULL
        , 120
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 182
        , 'Martha'
        , 'Sullivan'
        , 'MSULLIVA'
        , '650.507.9878'
        , TO_DATE('21-06-1999', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 2500
        , NULL
        , 120
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 183
        , 'Girard'
        , 'Geoni'
        , 'GGEONI'
        , '650.507.9879'
        , TO_DATE('03-02-2000', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 2800
        , NULL
        , 120
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 184
        , 'Nandita'
        , 'Sarchand'
        , 'NSARCHAN'
        , '650.509.1876'
        , TO_DATE('27-01-1996', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 4200
        , NULL
        , 121
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 185
        , 'Alexis'
        , 'Bull'
        , 'ABULL'
        , '650.509.2876'
        , TO_DATE('20-02-1997', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 4100
        , NULL
        , 121
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 186
        , 'Julia'
        , 'Dellinger'
        , 'JDELLING'
        , '650.509.3876'
        , TO_DATE('24-06-1998', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3400
        , NULL
        , 121
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 187
        , 'Anthony'
        , 'Cabrio'
        , 'ACABRIO'
        , '650.509.4876'
        , TO_DATE('07-02-1999', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3000
        , NULL
        , 121
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 188
        , 'Kelly'
        , 'Chung'
        , 'KCHUNG'
        , '650.505.1876'
        , TO_DATE('14-06-1997', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3800
        , NULL
        , 122
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 189
        , 'Jennifer'
        , 'Dilly'
        , 'JDILLY'
        , '650.505.2876'
        , TO_DATE('13-08-1997', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3600
        , NULL
        , 122
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 190
        , 'Timothy'
        , 'Gates'
        , 'TGATES'
        , '650.505.3876'
        , TO_DATE('11-07-1998', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 2900
        , NULL
        , 122
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 191
        , 'Randall'
        , 'Perkins'
        , 'RPERKINS'
        , '650.505.4876'
        , TO_DATE('19-12-1999', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 2500
        , NULL
        , 122
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 192
        , 'Sarah'
        , 'Bell'
        , 'SBELL'
        , '650.501.1876'
        , TO_DATE('04-02-1996', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 4000
        , NULL
        , 123
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 193
        , 'Britney'
        , 'Everett'
        , 'BEVERETT'
        , '650.501.2876'
        , TO_DATE('03-03-1997', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3900
        , NULL
        , 123
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 194
        , 'Samuel'
        , 'McCain'
        , 'SMCCAIN'
        , '650.501.3876'
        , TO_DATE('01-07-1998', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3200
        , NULL
        , 123
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 195
        , 'Vance'
        , 'Jones'
        , 'VJONES'
        , '650.501.4876'
        , TO_DATE('17-03-1999', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 2800
        , NULL
        , 123
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 196
        , 'Alana'
        , 'Walsh'
        , 'AWALSH'
        , '650.507.9811'
        , TO_DATE('24-04-1998', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3100
        , NULL
        , 124
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 197
        , 'Kevin'
        , 'Feeney'
        , 'KFEENEY'
        , '650.507.9822'
        , TO_DATE('23-05-1998', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 3000
        , NULL
        , 124
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 198
        , 'Donald'
        , 'OConnell'
        , 'DOCONNEL'
        , '650.507.9833'
        , TO_DATE('21-06-1999', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 199
        , 'Douglas'
        , 'Grant'
        , 'DGRANT'
        , '650.507.9844'
        , TO_DATE('13-01-2000', 'dd-mm-yyyy')
        , 'SH_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        );

INSERT INTO empl_demo VALUES 
        ( 200
        , 'Jennifer'
        , 'Whalen'
        , 'JWHALEN'
        , '515.123.4444'
        , TO_DATE('17-09-1987', 'dd-mm-yyyy')
        , 'AD_ASST'
        , 4400
        , NULL
        , 101
        , 10
        );

INSERT INTO empl_demo VALUES 
        ( 201
        , 'Michael'
        , 'Hartstein'
        , 'MHARTSTE'
        , '515.123.5555'
        , TO_DATE('17-02-1996', 'dd-mm-yyyy')
        , 'MK_MAN'
        , 13000
        , NULL
        , 100
        , 20
        );

INSERT INTO empl_demo VALUES 
        ( 202
        , 'Pat'
        , 'Fay'
        , 'PFAY'
        , '603.123.6666'
        , TO_DATE('17-08-1997', 'dd-mm-yyyy')
        , 'MK_REP'
        , 6000
        , NULL
        , 201
        , 20
        );

INSERT INTO empl_demo VALUES 
        ( 203
        , 'Susan'
        , 'Mavris'
        , 'SMAVRIS'
        , '515.123.7777'
        , TO_DATE('07-06-1994', 'dd-mm-yyyy')
        , 'HR_REP'
        , 6500
        , NULL
        , 101
        , 40
        );

INSERT INTO empl_demo VALUES 
        ( 204
        , 'Hermann'
        , 'Baer'
        , 'HBAER'
        , '515.123.8888'
        , TO_DATE('07-06-1994', 'dd-mm-yyyy')
        , 'PR_REP'
        , 10000
        , NULL
        , 101
        , 70
        );

INSERT INTO empl_demo VALUES 
        ( 205
        , 'Shelley'
        , 'Higgins'
        , 'SHIGGINS'
        , '515.123.8080'
        , TO_DATE('07-06-1994', 'dd-mm-yyyy')
        , 'AC_MGR'
        , 12000
        , NULL
        , 101
        , 110
        );

INSERT INTO empl_demo VALUES 
        ( 206
        , 'William'
        , 'Gietz'
        , 'WGIETZ'
        , '515.123.8181'
        , TO_DATE('07-06-1994', 'dd-mm-yyyy')
        , 'AC_ACCOUNT'
        , 8300
        , NULL
        , 205
        , 110
        );

COMMIT;

SELECT COUNT(*)  NUM_EMP FROM employees;
SELECT COUNT(*)  NUM_DEP FROM departments;
SELECT COUNT(*)  NUM_LOC FROM locations;
SELECT COUNT(*)  NUM_REG FROM regions;
SELECT COUNT(*)  NUM_CTR FROM countries;
SELECT COUNT(*)  NUM_JOB FROM jobs;
SELECT COUNT(*)  NUM_JH FROM job_history;


