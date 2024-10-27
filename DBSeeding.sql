USE LibraryManagement;

-- Seed books table
CREATE PROCEDURE p_seed_books
AS
BEGIN
DECLARE @counter INT = 1;

WHILE @counter <= 1000
BEGIN
    INSERT INTO Books (Title, Author, ISBN, Genere, ShelfLocation, CurrentStatus)
    VALUES (
        CONCAT('Title ', @counter),
        CONCAT('Author ', @counter),
        RIGHT('0000000000000' + CAST(@counter AS VARCHAR(13)), 13),  -- Generates unique ISBNs
        CASE WHEN @counter % 4 = 0 THEN 'Fiction' ELSE 'Non-Fiction' END,
        CONCAT('Shelf-', @counter % 10),
        CASE WHEN @counter % 2 = 0 THEN 'available' ELSE 'borrowed' END
    );

    SET @counter = @counter + 1;
END;
END

EXEC p_seed_books;
GO

-- Seed borrowers table
CREATE PROCEDURE p_seed_borrowers
AS BEGIN
DECLARE @counter INT = 1;

WHILE @counter <= 1000
BEGIN
    INSERT INTO Borrowers (FirstName, LastName, Email, DateOfBirth, MembershipDate)
    VALUES (
        CONCAT('FirstName', @counter),
        CONCAT('LastName', @counter),
        CONCAT('user', @counter, '@example.com'),
        DATEADD(DAY, -(@counter * 30 % 365), '2000-01-01'),  -- Distributes dates of birth within a range
        DATEADD(DAY, -(@counter * 30 % 365), '2024-01-01')
    );

    SET @counter = @counter + 1;
END;
END

EXEC p_seed_borrowers
GO

-- Seed loans table
CREATE PROCEDURE p_seed_loans
AS BEGIN 
DECLARE @counter INT = 1;

WHILE @counter <= 1000
BEGIN
    DECLARE @BookID INT = FLOOR(RAND() * 1000 + 1);       -- Random BookID between 1 and 1000
    DECLARE @BorrowerID INT = FLOOR(RAND() * 1000 + 1);   -- Random BorrowerID between 1 and 1000
    DECLARE @DateBorrowed DATE = DATEADD(DAY, -FLOOR(RAND() * 365), GETDATE());  -- Random date within the past year
    DECLARE @DueDate DATE = DATEADD(DAY, 14, @DateBorrowed);  -- 2 weeks after DateBorrowed
    DECLARE @DateReturned DATE = CASE 
                                   WHEN RAND() < 0.7 AND @counter < 900 THEN DATEADD(DAY, FLOOR(RAND() * 14), @DueDate) 
                                   ELSE NULL 
                                 END;  -- 70% chance of a return date within 2 weeks after DueDate

    INSERT INTO Loans (BookID, BorrowerID, DateBorrowed, [DueDate], DateReturned)
    VALUES (
        @BookID,
        @BorrowerID,
        @DateBorrowed,
        @DueDate,
        @DateReturned
    );

    SET @counter = @counter + 1;
END;
END

EXEC p_seed_loans
GO
