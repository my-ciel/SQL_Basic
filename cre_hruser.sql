REM =======================================================
REM cleanup section
REM =======================================================

DROP USER c##hr CASCADE;

REM =======================================================
REM create user
REM three separate commands, so the create user command 
REM will succeed regardless of the existence of the 
REM DEMO and TEMP tablespaces 
REM =======================================================

CREATE USER c##hr IDENTIFIED BY oracle;

ALTER USER c##hr DEFAULT TABLESPACE users
              QUOTA UNLIMITED ON users;

ALTER USER c##hr TEMPORARY TABLESPACE temp;

GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO c##hr;
GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE , UNLIMITED TABLESPACE TO c##hr;