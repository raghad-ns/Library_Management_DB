create or alter function fn_CalculateOverdueDays (@LoanID int)
returns int as
begin
	declare @overDue int
	declare @dueDate Date = (select DueDate from Loans where LoanID = @LoanID)
	declare @returnedDate Date = (select DateReturned from Loans where LoanID = @LoanID)
	declare @now Date = (SELECT CURRENT_TIMESTAMP)
	if (@returnedDate is null) 
		if (@dueDate >= @now) set @overDue = 0
		else 
		begin
			set @overdue = DATEDIFF(DAY, @dueDate, @now)
		end
	else
	begin
		set @overDue = DATEDIFF(DAY, @dueDate, @returnedDate)
	end
	return @overDue
end
GO

-- Get loans overdue
with LoansOverDuesCTE as (
	select *, dbo.fn_CalculateOverdueDays(LoanID) as Overdue from Loans
)

, BorrowersOverDueCTE as (
	select Borrowers.BorrowerID, FirstName, LastName, BookID, Overdue 
	from Borrowers join 
	(select * from LoansOverDuesCTE where Overdue > 30) as LoansOverdues
	on Borrowers.BorrowerID = LoansOverdues.BorrowerID
)

, BooksAndBorrowersOverdueCTE as (
	select BorrowerID, FirstName, LastName, Books.BookID, Title, Author, Overdue
	from Books join 
	(select * from BorrowersOverDueCTE) as BorrowersOverdue
	on Books.BookID = BorrowersOverdue.BookID
)

select * from BooksAndBorrowersOverdueCTE
GO