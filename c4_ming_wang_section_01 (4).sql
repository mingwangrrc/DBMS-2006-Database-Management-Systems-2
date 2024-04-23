/**
 ** Course: DBMS-2006 (248228) Database Management Systems 2
 ** Name: Ming Wang
 ** Challenge 4 - Procs&Functions
 ** Date: 2024-02-09
 **/

 
USE JR_Movie;
GO

-- 1. Create a procedure called usp_AddOne that requires two parameters
CREATE OR ALTER PROCEDURE usp_AddOne (
    @InputParam INT,
    @OutputParam INT OUTPUT
)
AS
BEGIN
    SET @OutputParam = @InputParam + 1
END;
GO

-- Write an Anonymous Block to Call the Procedure
DECLARE @Result INT, @TestInput INT = 2;
BEGIN
	EXEC usp_AddOne @TestInput, 
	@Result OUTPUT;
	PRINT @Result; --should be 3
END 
GO

-- Exercise 2: Create and call a Scalar function
CREATE OR ALTER FUNCTION ufn_ConcatenateTwoString( 
    @FirstString NCHAR(25),
    @SecondString NCHAR(25)
)
RETURNS NVARCHAR(51)
AS
BEGIN
    RETURN RTRIM(@FirstString) + ' ' + RTRIM(@SecondString)
END;
GO

-- Test the Function in an Anonymous Block
DECLARE @FirstName NCHAR(25) = 'Ming',
        @LastName NCHAR(25) = 'Wang',
        @FullName NVARCHAR(51)
BEGIN
	SET @FullName = dbo.ufn_ConcatenateTwoString(@FirstName, @LastName)
	PRINT @FullName
END
GO

-- Exercise 3: Create and call a Table function
CREATE OR ALTER FUNCTION ufn_GetMovieRating_Ming_Wang(
    @MovieName NCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
   SELECT Name, r.RatingId, Description
    FROM Movie m
	     JOIN Rating r ON m.RatingId=r.RatingId
    WHERE LOWER(Name) = LOWER(RTRIM(LTRIM(@MovieName)))
);
GO

-- Test the Function with a SELECT Statement
SELECT * FROM ufn_GetMovieRating_Ming_Wang('ROCKY')
SELECT * FROM ufn_GetMovieRating_Ming_Wang('rocky')
SELECT * FROM ufn_GetMovieRating_Ming_Wang('rOCky')
