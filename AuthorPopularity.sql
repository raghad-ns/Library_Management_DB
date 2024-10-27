
WITH BooksLoansCountCTE AS 
(
	SELECT DISTINCT BookID , COUNT(LoanID) OVER (PARTITION BY BookID) AS BookLoansCount 
		FROM Loans
)

, AuthorsBooksPopularityCTE AS 
(
	SELECT Author, SUM(BookLoansCount) over(PARTITION BY Author) AS AuthorBooksPopularity
		FROM Books JOIN (SELECT * FROM BooksLoansCountCTE) AS BooksLoansCounts 
		ON Books.BookID = BooksLoansCounts.BookID
)


SELECT *, DENSE_RANK() OVER (ORDER BY AuthorBooksPopularity DESC) AS AuthorRank FROM AuthorsBooksPopularityCTE
