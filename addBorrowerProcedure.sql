create procedure sp_AddNewBorrower (@FirstName varchar(50), @LastName varchar(50), @Email varchar(30), @DateOfBirth Date, @MembershipDate Date)
as
begin
	-- Check if the email already exists
    IF EXISTS (SELECT 1 FROM Borrowers WHERE Email = @Email)
    BEGIN
        PRINT 'Email already exists!';
        RETURN; -- Exit the procedure if the email exists
    END
		insert into Borrowers(FirstName, LastName, Email, DateOfBirth, MembershipDate)
		values(@FirstName, @LastName, @Email, @DateOfBirth, @MembershipDate)
		select BorrowerID from Borrowers where Email = @Email
end

exec sp_AddNewBorrower 'Raghad', 'Salem', 'raghad@gmail.com', '2002-05-15', '2023-10-01';
