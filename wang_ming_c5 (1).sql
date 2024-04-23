/**
 ** Course: DBMS-2006 (248228) Database Management Systems 2
 ** Name: Ming Wang
 ** Challenge 5 – Users and Roles
 ** Date: 2024-03-17
 **/

USE JR_Movie;
GO

/********** Q1 **********/

-- Create Login

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'JenniferGarnet')
BEGIN
    CREATE LOGIN JenniferGarnet WITH PASSWORD = 'mingwang';
END;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'PhilBlat')
BEGIN
    CREATE LOGIN PhilBlat WITH PASSWORD = 'mingwang';
END;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'RhondaSeymore')
BEGIN
    CREATE LOGIN RhondaSeymore WITH PASSWORD = 'mingwang';
END;
GO

-- Create Users
-- JenniferGarnet
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'jGarnet')
BEGIN
    CREATE USER jGarnet FOR LOGIN JenniferGarnet;
END
ELSE
BEGIN
    ALTER USER jGarnet WITH LOGIN = JenniferGarnet;
END;
GO

-- PhilBlat
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'pBlat')
BEGIN
    CREATE USER pBlat FOR LOGIN PhilBlat;
END
ELSE
BEGIN
    ALTER USER pBlat WITH LOGIN = PhilBlat;
END;
GO

-- RhondaSeymore
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rSeymore')
BEGIN
    CREATE USER rSeymore FOR LOGIN RhondaSeymore;
END
ELSE
BEGIN
    ALTER USER rSeymore WITH LOGIN = RhondaSeymore;
END;
GO

/********** Q2 **********/
CREATE ROLE receptionist_role;
GO

/********** Q3 **********/
GRANT SELECT ON dbo.CUSTOMER TO receptionist_role;
GRANT SELECT ON dbo.RENTALAGREEMENT TO receptionist_role;
GRANT SELECT ON dbo.MOVIERENTED TO receptionist_role;
GRANT SELECT ON dbo.MOVIE TO receptionist_role;
GO

/********** Q4 **********/
-- Give Jennifer Garnet the receptionist role
ALTER ROLE receptionist_role ADD MEMBER jGarnet;
GO

/********** Q5 **********/
-- Create salesperson_role
CREATE ROLE salesperson_role;
GO

/********** Q6 **********/
-- Grant SELECT permission
GRANT SELECT ON dbo.CUSTOMER TO salesperson_role;
GRANT SELECT ON dbo.RENTALAGREEMENT TO salesperson_role;
GRANT SELECT ON dbo.MOVIERENTED TO salesperson_role;
GRANT SELECT ON dbo.MOVIE TO salesperson_role;

-- Grant INSERT permission on specified tables
GRANT INSERT ON dbo.RENTALAGREEMENT TO salesperson_role;
GRANT INSERT ON dbo.MOVIERENTED TO salesperson_role;
GO

/********** Q7 **********/
-- Assign salesperson_role to pBlat user
ALTER ROLE salesperson_role ADD MEMBER pBlat;
GO

/********** Q8 **********/
-- Create salesmanager_role
CREATE ROLE salesmanager_role;
GO

/********** Q9 **********/
-- Grant full permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CUSTOMER TO salesmanager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.RENTALAGREEMENT TO salesmanager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MOVIERENTED TO salesmanager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MOVIE TO salesmanager_role;
GO

/********** Q10 **********/
-- Assign salesperson_role to rSeymore user
ALTER ROLE salesperson_role ADD MEMBER rSeymore;

-- Assign salesmanager_role to rSeymore user
ALTER ROLE salesmanager_role ADD MEMBER rSeymore;
GO

/********** Q11 - Test Permissions **********/

/********** Impersonate Jennifer Garnet **********/
EXECUTE AS USER = 'jGarnet';
GO

-- SELECT (success expected)
SELECT * FROM dbo.CUSTOMER;

-- INSERT (failure expected)
INSERT INTO dbo.CUSTOMER (CUSTID, FNAME, LNAME) VALUES (24, 'Jennifer', 'Garnet');

-- UPDATE (failure expected)
UPDATE dbo.CUSTOMER SET FNAME = 'Ming' WHERE CUSTID = 1; 

-- DELETE (failure expected)
DELETE FROM dbo.CUSTOMER WHERE CUSTID = 1;
REVERT;


/********** Impersonate Phil Blat **********/
EXECUTE AS USER = 'pBlat';
GO

-- SELECT (success expected)
SELECT * FROM dbo.MOVIE; 

-- INSERT into RentalAgreement (success expected)
INSERT INTO dbo.RENTALAGREEMENT (AGREEMENTID, CUSTID, AGREEMENTDATE, MOVIECOUNT, DURATIONID) 
VALUES (99566, 261, GETDATE(), 1, 1);

-- UPDATE (failure expected)
UPDATE dbo.MOVIE SET NAME = 'New Title' WHERE MOVIEID = 1;

-- DELETE (failure expected)
DELETE FROM dbo.MOVIE WHERE MOVIEID = 1;
REVERT;


/********** Impersonate Rhonda Seymore **********/
EXECUTE AS USER = 'rSeymore';
GO

-- SELECT (success expected)
SELECT * FROM dbo.RENTALAGREEMENT; 

-- INSERT into Customer (success expected)
INSERT INTO dbo.RENTALAGREEMENT (AGREEMENTID, CUSTID, AGREEMENTDATE, MOVIECOUNT, DURATIONID) 
VALUES (99570, 261, GETDATE(), 1, 1);

-- UPDATE (success expected)
UPDATE dbo.CUSTOMER SET FNAME = 'Phil' WHERE CUSTID = 24; 

-- DELETE (success expected)
DELETE FROM dbo.MOVIERENTED WHERE MOVIEID = 123456;
REVERT;