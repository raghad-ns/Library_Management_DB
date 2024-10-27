CREATE PROCEDURE sp_BorrowedBooksReport @StartDate DATE, @EndDate DATE
AS BEGIN
	WITH BorrowedBooksCTE AS (
		SELECT Books.BookID, Title, Author, Genere, BorrowerID, DateBorrowed 
			FROM Books JOIN Loans 
			ON Books.BookID = Loans.BookID
	)
	SELECT BookID, Title, Author, Genere, Borrowers.BorrowerID, FirstName, LastName, DateBorrowed
		FROM BorrowedBooksCTE JOIN Borrowers
		ON BorrowedBooksCTE.BorrowerID = Borrowers.BorrowerID
END

EXEC sp_BorrowedBooksReport '2020-01-01', '2023-01-01'