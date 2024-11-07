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
	SELECT BorrowerID, BookID, Loans.ID, DueDate, DateReturned, dbo.fn_CalculateOverDueDays(Loans.ID, DueDate, DateReturned) AS overDue 
	FROM Loans 
	JOIN Borrowers ON Loans.BorrowerID = Borrowers.ID
	JOIN Books ON Books.ID = Loans.BookID
	WHERE dbo.fn_CalculateOverDueDays(Loans.ID, DueDate, DateReturned) > @overDueThreshold
)

, BorrowersoverDueCTE AS (
	SELECT BorrowerID, FirstName, LAStName, BookID, overDue 
		FROM Borrowers JOIN 
		(SELECT BorrowerID, BookID, overDue FROM LoansoverDuesCTE ) AS LoansoverDues
		on Borrowers.ID = LoansoverDues.BorrowerID
)

SELECT BorrowerID, FirstName, LastName, BookID, Title, Author, overDue
	FROM Books JOIN 
	(SELECT * FROM BorrowersoverDueCTE) AS BorrowersoverDue
	on Books.ID = BorrowersoverDue.BookID
GO
