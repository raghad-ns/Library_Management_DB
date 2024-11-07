WITH AuthorsBooksPopularityCTE AS 
(
	SELECT DISTINCT Author, COUNT(Loans.ID) AS AuthorBooksPopularity
		FROM Books JOIN Loans 
		ON Books.ID = Loans.BookID
		GROUP BY Author
)

SELECT *, DENSE_RANK() OVER (ORDER BY AuthorBooksPopularity DESC) AS AuthorRank FROM AuthorsBooksPopularityCTE
