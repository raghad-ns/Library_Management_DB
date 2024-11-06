CREATE PROCEDURE sp_BorrowerOverdueBooks
AS
BEGIN
    -- Create the temporary table
    CREATE TABLE #BorrowersExceedTheOverdueDate (
        BorrowerID	INT,
		FirstName VARCHAR(30),
		LastName VARCHAR(30),
		LoanID	INT,
    );

	DECLARE @now DATETIME = SYSDATETIME()

    -- Insert data into the temporary table
    INSERT INTO #BorrowersExceedTheOverdueDate (BorrowerID, FirstName, LastName, LoanID)
    SELECT Borrowers.BorrowerID, FirstName, LastName, LoanID 
		FROM Borrowers JOIN Loans ON Borrowers.BorrowerID = Loans.BorrowerID
		WHERE (DateReturned IS NULL AND @now > DueDate) OR (DateReturned > DueDate);

    SELECT BorrowerID, FirstName, LastName, Title AS BookTitle, Author, Genere
		FROM #BorrowersExceedTheOverdueDate JOIN (
			SELECT LoanID, Books.BookID, Title, Author, Genere 
			FROM Loans JOIN Books ON Loans.BookID = Books.BookID
		) AS BooksBorrowed
		ON #BorrowersExceedTheOverdueDate.LoanID = BooksBorrowed.LoanID
	
END;

EXEC sp_BorrowerOverdueBooks
