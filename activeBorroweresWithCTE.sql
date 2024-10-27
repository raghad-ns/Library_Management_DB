use LibraryManagement
GO

-- CTE to return borrowers' ids that borrows more than 2 books and didn't return any
WITH 
borrowsStatistics as (
	SELECT *, 
		COUNT(BorrowerID) OVER (PARTITION BY BorrowerID) AS LoanCount, 
		COUNT(DateReturned) OVER (PARTITION BY BorrowerID) AS ReturnDates
	FROM Loans
)

, activeBorrows AS(
	SELECT *
	FROM (SELECT * FROM borrowsStatistics) as LoanCounts
	WHERE LoanCount >= 2 and DateReturned is null and ReturnDates = 0
)

SELECT Borrowers.BorrowerID, FirstName, LastName, Email, DateOfBirth, MembershipDate 
	FROM Borrowers JOIN activeBorrows AS borrows ON Borrowers.BorrowerID = borrows.BorrowerID
