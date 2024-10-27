CREATE FUNCTION fn_getAgeGroup (@DOB DATE) 
RETURNS INT
BEGIN
	DECLARE @now DATE = (SELECT CURRENT_TIMESTAMP)
	DECLARE @age INT = DATEDIFF(YEAR, @DOB, @now)
	RETURN @age / 10

END


WITH BooksLoansCountCTE AS 
(
	SELECT  BookID , Count(LoanID) OVER (PARTITION BY BookID) AS BookLoansCount 
	FROM Loans
)

, BorrowedBooksCTE AS (
	SELECT Books.BookID, Genere, Loans.BorrowerID 
		FROM Loans JOIN Books 
		ON Loans.BookID = Books.BookID
)

, BooksBorrowersCTE AS (
	SELECT BookID, Genere, Borrowers.BorrowerID, DateOfBirth 
		FROM BorrowedBooksCTE JOIN Borrowers 
		ON BorrowedBooksCTE.BorrowerID = Borrowers.BorrowerID
)

, AgeGroupsCTE AS (
	SELECT *, dbo.fn_getAgeGroup(DateOfBirth) AS AgeGroup FROM BooksBorrowersCTE
)

, GenreBorrowingFrequency AS (
	SELECT Genere, AgeGroup, COUNT(Genere) OVER (PARTITION BY AgeGroup) AS Frequency 
		FROM AgeGroupsCTE
) 

SELECT distinct AgeGroup, Genere AS PreferedGenre, Frequency AS BorrwingFrequency, 
	RANK() OVER (PARTITION BY AgeGroup order BY Frequency desc) AS GenreRank
	FROM GenreBorrowingFrequency
