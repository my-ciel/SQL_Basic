--Part 1 : 단일행 함수
SELECT LOWER('SQL Course'), UPPER('SQL Course'),
       INITCAP('SQL Course')
FROM   dual;
SELECT 'The job id for '||UPPER(last_name)||' is '||LOWER(job_id) AS "EMPLOYEE DETAILS"
FROM   employees;
SELECT employee_id, last_name, department_id
FROM   employees
WHERE  last_name = 'higgins';
SELECT employee_id, last_name, department_id
FROM   employees
WHERE  LOWER(last_name) = 'higgins';
SELECT employee_id, UPPER(last_name), department_id
FROM   employees
WHERE  last_name = INITCAP('Higgins');

SELECT CONCAT('Hello', 'World') FROM dual;
SELECT SUBSTR('HelloWorld',1,5) FROM dual;
SELECT LENGTH('HelloWorld'), LENGTHB('HelloWorld') FROM dual;
SELECT INSTR('HelloWorld', 'l') FROM dual;
SELECT RPAD(last_name, 15,'*'), LPAD(salary,10,'*')FROM employees;
SELECT TRIM('H'FROM 'HelloWorld') FROM dual;
SELECT TRIM('w' FROM 'window'),
       TRIM(LEADING 'w' FROM 'window'),
       TRIM(TRAILING 'w' FROM 'window')
FROM dual; 
SELECT TRIM('0' FROM '0001234567890000000')
FROM dual; 
SELECT TRIM('ab' FROM 'ababxxxyyyabababab')
FROM dual; 
SELECT RTRIM('ababxxxababyyyabababab', 'ab'),               
       LTRIM('ababxxxababyyyabababab', 'ab')
FROM dual; 
SELECT RTRIM(LTRIM('ababxxxababyyyabababab', 'ab'), 'ab')
FROM dual; 
SELECT employee_id, CONCAT(first_name, last_name) NAME, 
       job_id, LENGTH (last_name), 
       INSTR(last_name, 'a') "Contains 'a'?"
FROM   employees
WHERE  SUBSTR(job_id, 4) = 'REP';
SELECT employee_id, CONCAT(first_name, last_name) NAME,
          LENGTH (last_name), INSTR(last_name, 'a') "Contains 'a'?"
FROM   employees
WHERE  SUBSTR(last_name, -1, 1) = 'n';
SELECT employee_id, last_name, 
       CONCAT(email,'@oracle.com') AS "Email Address"
FROM employees;

SELECT ROUND(45.923,2), ROUND(45.923,0),ROUND(45.923,-1)
FROM   DUAL;
SELECT  TRUNC(45.923,2), TRUNC(45.923),TRUNC(45.923,-2)
FROM   DUAL;
SELECT last_name, salary, MOD(salary, 5000)
FROM   employees
WHERE  job_id = 'SA_REP';
SELECT CEIL(4.457), CEIL(-4.457), FLOOR(4.457), FLOOR(-4.457)
FROM dual; 

SELECT last_name, hire_date
FROM   employees;
SELECT sysdate 
FROM dual;
SELECT current_date 
FROM dual;
SELECT systimestamp 
FROM dual;
SELECT current_timestamp 
FROM dual;
SELECT last_name, (SYSDATE-hire_date)/7 AS WEEKS
FROM   employees
WHERE  department_id = 90;
SELECT employee_id, hire_date,
          TRUNC(MONTHS_BETWEEN (SYSDATE, hire_date)) 근무기간,
          ADD_MONTHS (hire_date, 6) 직무능력검사일,
          NEXT_DAY (hire_date, 2) 교육시작일, 
          LAST_DAY(hire_date)+10 첫급여일
FROM   employees;
SELECT EXTRACT(year FROM sysdate) 
FROM dual;
SELECT last_name, hire_date, 
       EXTRACT (MONTH FROM hire_date) AS 입사일
FROM employees;
SELECT ROUND(sysdate, 'YEAR'), ROUND(sysdate, 'MONTH'),
       ROUND(sysdate, 'DD'), ROUND(sysdate, 'D')
FROM dual;
SELECT TRUNC(sysdate, 'YEAR'), TRUNC(sysdate, 'MONTH'),
       TRUNC(sysdate, 'DD'), TRUNC(sysdate, 'D')
FROM dual;

SELECT last_name,
       TO_CHAR(hire_date, 'DD MM YYYY') AS HIREDATE
FROM   employees;
SELECT TO_CHAR(sysdate, 'YYYY MM DD HH24:MI:SS')
FROM   dual;

SELECT employee_id, last_name, 
       TO_CHAR(salary, '$999,999') SALARY
FROM   employees;
SELECT employee_id, last_name, 
       TO_CHAR(salary, 'L999,999') SALARY
FROM   employees;
SELECT employee_id, last_name, 
       TO_CHAR(salary, '$999,999.00') SALARY1,
       TO_CHAR(salary, '$099,999.00') SALARY2
FROM   employees;
ALTER SESSION SET nls_territory='Japan';
SELECT employee_id, last_name, TO_CHAR(salary, 'L99,999') SALARY
FROM   employees;
ALTER SESSION SET nls_territory='Korea';

SELECT employee_id, last_name, salary, job_id
FROM   employees
WHERE salary > TO_NUMBER('$8,000','$9,999');
SELECT employee_id, last_name, hire_date, department_id
FROM   employees
WHERE hire_date >= TO_DATE('01-01-2014','dd-mm-yyyy');

SELECT last_name, TO_CHAR(hire_date, 'yyyy/mm/dd')
FROM  employees
WHERE hire_date > TO_DATE('31-12-99', 'DD-MM-RR');
SELECT last_name, TO_CHAR(hire_date, 'yyyy/mm/dd')
FROM  employees
WHERE hire_date > TO_DATE('31-12-99', 'DD-MM-YY');

SELECT last_name, salary, NVL(commission_pct, 0),
   (salary*12) + (salary*12*commission_pct) AN_SAL
FROM employees;
SELECT last_name, salary, NVL(commission_pct, 0),
   (salary*12) + (salary*12*NVL(commission_pct, 0)) AN_SAL
FROM employees;
SELECT  last_name, salary, commission_pct, 
        (salary*12) + (salary*12*NVL(commission_pct, 0)) AS 연봉,
        NVL2(commission_pct,'COMM', 'NOCOMM') AS 비고
FROM   employees 
WHERE department_id IN (50, 80);
SELECT   last_name,
         COALESCE(commission_pct, salary, 10) comm
FROM     employees
ORDER BY commission_pct;

SELECT last_name,
       UPPER(CONCAT(SUBSTR (LAST_NAME, 1, 4), '_US'))
FROM employees
WHERE department_id = 60;
SELECT last_name,
       NVL(TO_CHAR(manager_id), 'No Manager')
FROM   employees
WHERE  manager_id IS NULL;
SELECT TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), '금요일'), 
               'YYYY-MM-DD DAY') AS "Next 6 Month to Review"
FROM employees
ORDER BY hire_date;

SELECT last_name, job_id, salary,
       CASE job_id WHEN 'IT_PROG'  THEN  1.10*salary
                   WHEN 'ST_CLERK' THEN  1.15*salary
                   WHEN 'SA_REP'   THEN  1.20*salary
       ELSE      salary END     "REVISED_SALARY"
FROM   employees;
SELECT last_name, job_id, salary,
       CASE WHEN salary > 9000 THEN  'A'
            WHEN salary BETWEEN 4000 AND 9000 THEN  'B'
            ELSE 'C' END AS "급여등급"
FROM   employees;
SELECT last_name, job_id, salary,
       DECODE(job_id, 'IT_PROG',  1.10*salary,
                      'ST_CLERK', 1.15*salary,
                      'SA_REP',   1.20*salary,
              salary) AS REVISED_SALARY
FROM   employees;

--Part 2 : 그룹함수
SELECT AVG(salary), MAX(salary),
       MIN(salary), SUM(salary)
FROM   employees
WHERE  job_id LIKE '%REP%';
SELECT MIN(hire_date), MAX(hire_date)
FROM	  employees;

SELECT COUNT(*)
FROM	  employees;
SELECT COUNT(last_name), COUNT(department_id), COUNT(commission_pct)
FROM   employees; 
SELECT COUNT(DISTINCT department_id)
FROM   employees;

SELECT AVG(commission_pct)
FROM   employees;
SELECT AVG(NVL(commission_pct, 0))
FROM   employees;

SELECT   AVG(salary)
FROM     employees
GROUP BY department_id ;
SELECT   department_id, AVG(salary)
FROM     employees
GROUP BY department_id 
ORDER BY AVG(salary);
SELECT   department_id dept_id, job_id, SUM(salary)
FROM     employees
GROUP BY department_id, job_id 
ORDER BY 1, 2;

SELECT department_id, COUNT(last_name)
FROM   employees;
SELECT   department_id, AVG(salary)
FROM     employees
WHERE    AVG(salary) > 8000
GROUP BY department_id;
SELECT   department_id, MAX(salary)
FROM     employees
GROUP BY department_id
HAVING   MAX(salary)>10000
ORDER BY 1,2 ;
SELECT   job_id, SUM(salary) PAYROLL
FROM     employees
WHERE    job_id NOT LIKE 'SA%'
GROUP BY job_id
HAVING   SUM(salary) > 13000
ORDER BY SUM(salary);

SELECT   MAX(AVG(salary))
FROM     employees
GROUP BY department_id;

SELECT   department_id, job_id, SUM(salary)
FROM     employees  
WHERE    department_id < 60
GROUP BY ROLLUP(department_id, job_id)
ORDER BY 1,2;
SELECT   department_id, job_id, SUM(salary)
FROM     employees  
WHERE    department_id < 60
GROUP BY CUBE (department_id, job_id)
ORDER BY 1,2 ;

SELECT   department_id DEPTID, job_id JOB, SUM(salary),
         GROUPING(department_id) GRP_DEPT,
         GROUPING(job_id) GRP_JOB
FROM     employees
WHERE    department_id < 50
GROUP BY ROLLUP(department_id, job_id)
ORDER BY 1, 2;

SELECT   department_id, job_id, 
         manager_id,avg(salary)
FROM     employees
GROUP BY GROUPING SETS((department_id,job_id), (job_id,manager_id));