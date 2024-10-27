
with BooksLoansCountCTE as 
(
	select distinct BookID , Count(LoanID) over (partition by BookID) as BookLoansCount 
	from Loans
)

, AuthorsBooksPopularityCTE as 
(
	select Author, SUM(BookLoansCount) over(partition by Author) as AuthorBooksPopularity
	from Books join (select * from BooksLoansCountCTE) as BooksLoansCounts 
	on Books.BookID = BooksLoansCounts.BookID
)


select *, DENSE_RANK() over (order by AuthorBooksPopularity desc) as AuthorRank from AuthorsBooksPopularityCTE
