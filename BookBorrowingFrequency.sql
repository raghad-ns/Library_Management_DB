CREATE FUNCTION fn_BookBorrowingFrequency(@bookId INT)
RETURNS INT 
AS
BEGIN
	declare @frequency INT;
	SELECT @frequency = COUNT(Loans.ID) FROM Loans WHERE BookID = @bookId ;

	return @frequency;
END

SELECT dbo.fn_BookBorrowingFrequency(5) AS BorrowingFrequency