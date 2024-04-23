/**
 ** Course: DBMS-2006 (248228) Database Management Systems 2
 ** Name: Ming Wang
 ** Challenge 1 - DML Review
 ** Date: 2024-01-19
 **/

USE Challenge1;
Go

-- 1. List all salesreps whose average sales are below the overall average sales.
SELECT 
    S.EMPL_NUM, 
    S.NAME, 
    AVG(O.AMOUNT) AS AvgSales
FROM 
    SALESREPS S
LEFT JOIN 
    ORDERS O ON S.EMPL_NUM = O.REP
GROUP BY 
    S.EMPL_NUM, 
    S.NAME
HAVING 
    AVG(O.AMOUNT) < (SELECT AVG(AMOUNT) FROM ORDERS)


-- 2. Lists employees and their supervisor’s, please include the following columns in the resultSet: 
-- Employee Name, EMPL_NUM, AGE, TITLE, Manager-Name, Manager-ID, Managers Title 
-- (please note this is a subset of columns available with the salesreps table).
SELECT 
    E.NAME AS Employee_Name,
    E.EMPL_NUM,
    E.AGE,
    E.TITLE AS Employee_Title,
    M.NAME AS Manager_Name,
    M.EMPL_NUM AS Manager_ID,
    M.TITLE AS Manager_Title
FROM 
    SALESREPS E
LEFT JOIN 
    SALESREPS M ON E.MANAGER = M.EMPL_NUM


-- 3.Update customer Chen Associates to Boyce and Codd Associates. 
-- The DB might throw an error, fix this using whatever method you think appropriate. 
-- Be sure to include the code on how you fixed this. Do not shorten the name of the company.

-- Alter the table to increase the length
ALTER TABLE CUSTOMERS
ALTER COLUMN COMPANY VARCHAR(50);

-- Update
UPDATE CUSTOMERS
SET COMPANY = 'Boyce and Codd Associates'
WHERE COMPANY = 'Chen Associates';

SELECT * FROM CUSTOMERS;


-- 4. Show all products that fall within a given price range. Pick any price range you wish.
--  Find products priced between $100 and $500
SELECT *
FROM PRODUCTS
WHERE PRICE BETWEEN 100 AND 500;


-- 5. Show the number of salesreps based in each city (include cities with NULL values).
SELECT 
    O.CITY, 
    COUNT(S.EMPL_NUM) AS NumberOfSalesReps
FROM 
    OFFICES O
LEFT JOIN 
    SALESREPS S ON O.OFFICE = S.REP_OFFICE
GROUP BY 
    O.CITY
