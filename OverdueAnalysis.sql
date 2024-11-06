CREATE OR ALTER FUNCTION fn_CalculateoverDueDays (@LoanID INT, @dueDate DATETIME, @returnedDate DATETIME)
RETURNS INT AS
BEGIN
	declare @overDue INT
	declare @now DATETIME = SYSDATETIME()
	IF (@returnedDate IS NULL) 
		IF (@dueDate >= @now) SET @overDue = 0
		ELSE 
		BEGIN
			SET @overDue = DATEDIFF(DAY, @dueDate, @now)
		END
	ELSE
	BEGIN
		SET @overDue = DATEDIFF(DAY, @dueDate, @returnedDate)
	END
	RETURN @overDue
END
GO

DECLARE @overDueThreshold INT = 30;

-- Get loans overDue
WITH LoansOverDuesCTE AS (
	SELECT Borrowers.BorrowerID, Books.BookID, LoanID, DueDate, DateReturned, dbo.fn_CalculateOverDueDays(LoanID, DueDate, DateReturned) AS overDue 
	FROM Loans 
	JOIN Borrowers ON Loans.BorrowerID = Borrowers.BorrowerID
	JOIN Books ON Books.BookID = Loans.BookID
	WHERE dbo.fn_CalculateOverDueDays(LoanID, DueDate, DateReturned) > @overDueThreshold
)

, BorrowersoverDueCTE AS (
	SELECT Borrowers.BorrowerID, FirstName, LAStName, BookID, overDue 
		FROM Borrowers JOIN 
		(SELECT BorrowerID, BookID, overDue FROM LoansoverDuesCTE ) AS LoansoverDues
		on Borrowers.BorrowerID = LoansoverDues.BorrowerID
)

SELECT BorrowerID, FirstName, LastName, Books.BookID, Title, Author, overDue
	FROM Books JOIN 
	(SELECT * FROM BorrowersoverDueCTE) AS BorrowersoverDue
	on Books.BookID = BorrowersoverDue.BookID
GO
