WITH AuthorsBooksPopularityCTE AS 
(
	SELECT DISTINCT Author, COUNT(LoanID) AS AuthorBooksPopularity
		FROM Books JOIN Loans 
		ON Books.BookID = Loans.BookID
		GROUP BY Author
)

SELECT *, DENSE_RANK() OVER (ORDER BY AuthorBooksPopularity DESC) AS AuthorRank FROM AuthorsBooksPopularityCTE

