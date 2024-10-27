
SELECT Books.BookID, Title, Author FROM Books JOIN Loans ON Books.BookID = Loans.BookID
GO