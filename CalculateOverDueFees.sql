CREATE OR ALTER FUNCTION fn_CalculateOverdueFees (@LoanID INT)
RETURNS INT AS
BEGIN
	DECLARE @fees INT
	DECLARE @dueDate DATE = (SELECT DueDate FROM Loans WHERE ID = @LoanID)
	DECLARE @returnedDate DATE = (SELECT DateReturned FROM Loans WHERE ID = @LoanID)
	DECLARE @now DATE = SYSDATETIME()
	DECLARE @daysThreshold INT = 30
	IF (@returnedDate IS NULL) 
		IF (@dueDate >= @now) SET @fees = 0
		ELSE 
		BEGIN
			DECLARE @overdue INT = DATEDIFF(DAY, @dueDate, @now)
			IF (@overdue > @daysThreshold) SET @fees = @daysThreshold + 2 * (@overdue - @daysThreshold)
			ELSE SET @fees = @overdue 
		END
	ELSE
	BEGIN
		DECLARE @overdueForReturnedBook INT = DATEDIFF(DAY, @dueDate, @returnedDate)
		IF (@overdueForReturnedBook > @daysThreshold) SET @fees = @daysThreshold + 2 * (@overdueForReturnedBook - @daysThreshold)
		ELSE SET @fees = @overdueForReturnedBook 
	END
	RETURN @fees
END


SELECT ID, dbo.fn_CalculateOverdueFees(1) AS OverDue FROM Loans
