
CREATE PROCEDURE sp_UpdateBookStatus @BookID INT, @NewStatus VARCHAR(10), @ChangeDate DATE 

AS BEGIN
	INSERT INTO AuditLog VALUES (@BookID, @NewStatus, @ChangeDate)

	UPDATE Books
		SET CurrentStatus = @NewStatus
		WHERE BookID = @BookID;
END
GO

CREATE TRIGGER trg_AfterLoanInsert
ON Loans
AFTER INSERT, UPDATE 
AS
BEGIN
	DECLARE @BookID INT, 
	@NewStatus VARCHAR(10), 
	@now DATE = (SELECT CURRENT_TIMESTAMP);
    
    SELECT @BookID = BookID FROM inserted;
	SELECT @NewStatus = CurrentStatus FROM Books WHERE BookID = @BookID
	EXEC sp_UpdateBookStatus @BookID, @NewStatus, @now
END