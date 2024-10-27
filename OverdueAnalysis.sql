CREATE OR ALTER FUNCTION fn_CalculateOverdueDays (@LoanID INT)
RETURNS INT AS
BEGIN
	declare @overDue INT
	declare @dueDate DATE = (SELECT DueDate FROM Loans WHERE LoanID = @LoanID)
	declare @returnedDate DATE = (SELECT DateReturned FROM Loans WHERE LoanID = @LoanID)
	declare @now DATE = (SELECT CURRENT_TIMESTAMP)
	IF (@returnedDate IS NULL) 
		IF (@dueDate >= @now) SET @overDue = 0
		ELSE 
		BEGIN
			SET @overdue = DATEDIFF(DAY, @dueDate, @now)
		END
	ELSE
	BEGIN
		SET @overDue = DATEDIFF(DAY, @dueDate, @returnedDate)
	END
	RETURN @overDue
END
GO

-- Get loans overdue
WITH LoansOverDuesCTE AS (
	SELECT *, dbo.fn_CalculateOverdueDays(LoanID) AS Overdue FROM Loans
)

, BorrowersOverDueCTE AS (
	SELECT Borrowers.BorrowerID, FirstName, LAStName, BookID, Overdue 
		FROM Borrowers JOIN 
		(SELECT * FROM LoansOverDuesCTE WHERE Overdue > 30) AS LoansOverdues
		on Borrowers.BorrowerID = LoansOverdues.BorrowerID
)

, BooksAndBorrowersOverdueCTE AS (
	SELECT BorrowerID, FirstName, LastName, Books.BookID, Title, Author, Overdue
		FROM Books JOIN 
		(SELECT * FROM BorrowersOverDueCTE) AS BorrowersOverdue
		on Books.BookID = BorrowersOverdue.BookID
)

SELECT * FROM BooksAndBorrowersOverdueCTE
GO