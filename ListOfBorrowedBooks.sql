USE LibraryManagement
GO

SELECT DISTINCT Books.ID, Title, Author FROM Books JOIN Loans ON Books.ID = Loans.BookID
GO