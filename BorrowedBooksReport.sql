CREATE PROCEDURE sp_BorrowedBooksReport @StartDate DATE, @EndDate DATE
AS BEGIN
	SELECT BookID, Title, Author, Genere, Borrowers.BorrowerID, FirstName, LastName, DateBorrowed
		FROM (
			SELECT Books.BookID, Title, Author, Genere, BorrowerID, DateBorrowed 
			FROM Books JOIN Loans 
			ON Books.BookID = Loans.BookID
		) AS BorrowedBooks JOIN Borrowers
		ON BorrowedBooks.BorrowerID = Borrowers.BorrowerID
END

EXEC sp_BorrowedBooksReport '2020-01-01', '2023-01-01'