use LibraryManagement
GO

SELECT Borrowers.ID, FirstName, LastName, Email, DateOfBirth, MembershipDate 
	FROM Borrowers 
	JOIN (
		SELECT BorrowerID,
			COUNT(BorrowerID) AS LoanCount, 
			COUNT(DateReturned) AS ReturnDates
		FROM Loans
		GROUP BY BorrowerID
		HAVING COUNT(BorrowerID) >= 2 and COUNT(DateReturned) = 0
	) AS borrows 
	ON 
	Borrowers.ID = borrows.BorrowerID
