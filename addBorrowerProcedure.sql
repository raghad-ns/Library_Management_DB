CREATE PROCEDURE sp_AddNewBorrower (@FirstName VARCHAR(50), @LastName VARCHAR(50), @Email VARCHAR(30), @DateOfBirth DATE, @MembershipDate DATE)
AS
BEGIN
	-- Check if the email already exists
    IF EXISTS (SELECT 1 FROM Borrowers WHERE Email = @Email)
    BEGIN
        PRINT 'Email already exists!';
        RETURN; -- Exit the procedure if the email exists
    END
		INSERT INTO Borrowers(FirstName, LastName, Email, DateOfBirth, MembershipDate)
		VALUES(@FirstName, @LastName, @Email, @DateOfBirth, @MembershipDate)
		SELECT ID FROM Borrowers WHERE Email = @Email
END

EXEC sp_AddNewBorrower 'Raghad', 'Salem', 'raghad@gmail.com', '2002-05-15', '2023-10-01';
