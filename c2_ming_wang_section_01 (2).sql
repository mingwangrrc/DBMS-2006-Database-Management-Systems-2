/**
 ** Course: DBMS-2006 (248228) Database Management Systems 2
 ** Name: Ming Wang
 ** Challenge 2 - DDL
 ** Date: 2024-01-25
 **/

 -- Create Database
CREATE DATABASE Challenge2;
GO

-- Switch context to Challenge2
USE Challenge2;

-- Drop statements for clean-up
DROP TABLE IF EXISTS PerformsIn;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Actor;
GO

-- Actor table creation
CREATE TABLE Actor (
    ActorID INT PRIMARY KEY,
    FirstName NVARCHAR(255) NOT NULL,
    LastName NVARCHAR(255) NOT NULL,
    DOB DATE NOT NULL
);
GO

-- Movie table creation
CREATE TABLE Movie (
    MovieID INT PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Genre NVARCHAR(255) NOT NULL,
    YearRelease DATE NOT NULL
);
GO

-- PerformsIn table creation
CREATE TABLE PerformsIn (
    ActorID INT NOT NULL,
    MovieID INT NOT NULL,
    RoleType NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_PerformsIn_ActorID 
        FOREIGN KEY (ActorID) 
        REFERENCES Actor(ActorID),
    CONSTRAINT FK_PerformsIn_MovieID 
        FOREIGN KEY (MovieID) 
        REFERENCES Movie(MovieID)
);
GO

-- Non-clustered index creation for foreign keys in PerformsIn
CREATE NONCLUSTERED INDEX IDX_PerformsIn_ActorID ON PerformsIn(ActorID);
CREATE NONCLUSTERED INDEX IDX_PerformsIn_MovieID ON PerformsIn(MovieID);
GO

-- Display all records from Actor table
SELECT * FROM Actor;

-- Display all records from Movie table
SELECT * FROM Movie;

-- Display all records from PerformsIn table
SELECT * FROM PerformsIn;

-- Display structure of the Actor table
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Actor';

-- Display structure of the Movie table
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Movie';

-- Display structure of the PerformsIn table
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'PerformsIn';
