USE LibraryManagement;

-- Seed books table
CREATE OR ALTER PROCEDURE sp_seed_books
AS
BEGIN
DECLARE @counter INT = 1;
DECLARE @recordsNumber INT = 1000

WHILE @counter <= @recordsNumber
BEGIN
    INSERT INTO Books (Title, Author, ISBN, Genre, ShelfLocation, CurrentStatus)
    VALUES (
        CONCAT('Title ', @counter),
        CONCAT('Author ', @counter),
        RIGHT('0000000000000' + CAST(@counter AS VARCHAR(13)), 13),  -- Generates unique ISBNs
        CASE WHEN @counter % 4 = 0 THEN 'Fiction' ELSE 'Non-Fiction' END,
        CONCAT('Shelf-', @counter % 10),
        CASE WHEN @counter % 2 = 0 THEN 'AVAILABLE' ELSE 'BORROWED' END
    );

    SET @counter = @counter + 1;
END;
END

EXEC sp_seed_books;
GO

-- Seed borrowers table
CREATE OR ALTER PROCEDURE sp_seed_borrowers
AS BEGIN
DECLARE @counter INT = 1;
DECLARE @recordsNumber INT = 1000
DECLARE @daysInAYear INT = 365
DECLARE @daysInAMonth INT = 30

WHILE @counter <= @recordsNumber
BEGIN
    INSERT INTO Borrowers (FirstName, LastName, Email, DateOfBirth, MembershipDate)
    VALUES (
        CONCAT('FirstName', @counter),
        CONCAT('LastName', @counter),
        CONCAT('user', @counter, '@example.com'),
        DATEADD(DAY, -(@counter * @daysInAMonth % @daysInAYear), '2000-01-01'),  -- Distributes dates of birth within a range
        DATEADD(DAY, -(@counter * @daysInAMonth % @daysInAYear), '2024-01-01')
    );

    SET @counter = @counter + 1;
END;
END

EXEC sp_seed_borrowers
GO

-- Seed loans table
CREATE PROCEDURE sp_seed_loans
AS BEGIN 
DECLARE @counter INT = 1;
DECLARE @recordsNumber INT = 1000
DECLARE @daysInAYear INT = 365

WHILE @counter <= @recordsNumber
BEGIN
    DECLARE @BookID INT = FLOOR(RAND() * @recordsNumber + 1);       -- Random BookID between 1 and @recordsNumber
    DECLARE @BorrowerID INT = FLOOR(RAND() * @recordsNumber + 1);   -- Random BorrowerID between 1 and @recordsNumber
    DECLARE @DateBorrowed DATE = DATEADD(DAY, -FLOOR(RAND() * @daysInAYear), GETDATE());  -- Random date within the past year
    DECLARE @DueDate DATE = DATEADD(DAY, 14, @DateBorrowed);  -- 2 weeks after DateBorrowed
    DECLARE @DateReturned DATE = CASE 
                                   WHEN RAND() < 0.7 AND @counter < 900 THEN DATEADD(DAY, FLOOR(RAND() * 14), @DueDate) 
                                   ELSE NULL 
                                 END;  -- 70% chance of a return date within 2 weeks after DueDate

    INSERT INTO Loans (BookID, ID, DateBorrowed, [DueDate], DateReturned)
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

EXEC sp_seed_loans
GO
