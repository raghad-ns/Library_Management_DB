CREATE FUNCTION fn_CalculateOverdueFees (@LoanID INT)
RETURNS INT AS
BEGIN
	DECLARE @fees INT
	DECLARE @dueDate DATE = (SELECT DueDate FROM Loans WHERE LoanID = @LoanID)
	DECLARE @returnedDate DATE = (SELECT DateReturned FROM Loans WHERE LoanID = @LoanID)
	DECLARE @now DATE = (SELECT CURRENT_TIMESTAMP)
	IF (@returnedDate IS NULL) 
		IF (@dueDate >= @now) SET @fees = 0
		ELSE 
		BEGIN
			DECLARE @overdue INT = DATEDIFF(DAY, @dueDate, @now)
			IF (@overdue > 30) SET @fees = 30 + 2 * (@overdue - 30)
			ELSE SET @fees = @overdue 
		END
	ELSE
	BEGIN
		DECLARE @overdueForReturnedBook INT = DATEDIFF(DAY, @dueDate, @returnedDate)
		IF (@overdueForReturnedBook > 30) SET @fees = 30 + 2 * (@overdueForReturnedBook - 30)
		ELSE SET @fees = @overdueForReturnedBook 
	END
	RETURN @fees
END


SELECT LoanID, dbo.fn_CalculateOverdueFees(1) AS OverDue FROM Loans
