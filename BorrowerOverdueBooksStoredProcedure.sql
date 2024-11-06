CREATE OR ALTER PROCEDURE sp_BorrowerOverdueBooks
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
    SELECT Borrowers.ID, FirstName, LastName, Loans.ID 
		FROM Borrowers JOIN Loans ON Borrowers.ID = Loans.BorrowerID
		WHERE (DateReturned IS NULL AND @now > DueDate) OR (DateReturned > DueDate);

    SELECT BorrowerID, FirstName, LastName, Title AS BookTitle, Author, Genre
		FROM #BorrowersExceedTheOverdueDate JOIN (
			SELECT Loans.ID as LoanID, Books.ID as BookID, Title, Author, Genre 
			FROM Loans JOIN Books ON Loans.BookID = Books.ID
		) AS BooksBorrowed
		ON #BorrowersExceedTheOverdueDate.LoanID = BooksBorrowed.LoanID
	
END;

EXEC sp_BorrowerOverdueBooks
