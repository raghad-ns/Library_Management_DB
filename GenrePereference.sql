CREATE FUNCTION fn_getAgeGroup (@DOB DATE) 
RETURNS INT
BEGIN
	DECLARE @now DATE = (SELECT CURRENT_TIMESTAMP)
	DECLARE @age INT = DATEDIFF(YEAR, @DOB, @now)
	RETURN @age / 10

END


WITH BooksLoansCountCTE AS 
(
	SELECT  BookID , Count(ID) OVER (PARTITION BY BookID) AS BookLoansCount 
	FROM Loans
)

, BorrowedBooksCTE AS (
	SELECT BookID, Genre, Loans.BorrowerID 
		FROM Loans JOIN Books 
		ON Loans.BookID = Books.ID
)

, BooksBorrowersCTE AS (
	SELECT BookID, Genre, BorrowerID, DateOfBirth 
		FROM BorrowedBooksCTE JOIN Borrowers 
		ON BorrowedBooksCTE.BorrowerID = Borrowers.ID
)

, AgeGroupsCTE AS (
	SELECT *, dbo.fn_getAgeGroup(DateOfBirth) AS AgeGroup FROM BooksBorrowersCTE
)

, GenreBorrowingFrequency AS (
	SELECT Genre, AgeGroup, COUNT(Genre) OVER (PARTITION BY AgeGroup) AS Frequency 
		FROM AgeGroupsCTE
) 

SELECT distinct AgeGroup, Genre AS PreferedGenre, Frequency AS BorrwingFrequency, 
	RANK() OVER (PARTITION BY AgeGroup order BY Frequency desc) AS GenreRank
	FROM GenreBorrowingFrequency
