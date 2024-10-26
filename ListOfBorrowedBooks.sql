
select Books.BookID, Title, Author from Books join Loans on Books.BookID = Loans.BookID
GO