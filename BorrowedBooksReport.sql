CREATE OR ALTER PROCEDURE sp_BorrowedBooksReport @StartDate DATE, @EndDate DATE
AS BEGIN
	SELECT BookID, Title, Author, Genre, BorrowerID, FirstName, LastName, DateBorrowed
		FROM (
			SELECT BookID, Title, Author, Genre, BorrowerID, DateBorrowed 
			FROM Books JOIN Loans 
			ON Books.ID = Loans.BookID
		) AS BorrowedBooks JOIN Borrowers
		ON BorrowedBooks.BorrowerID = Borrowers.ID
END

EXEC sp_BorrowedBooksReport '2020-01-01', '2023-01-01'