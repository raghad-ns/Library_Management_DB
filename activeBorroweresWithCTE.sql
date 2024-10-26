use LibraryManagement
GO

-- CTE to return borrowers' ids that borrows more than 2 books and didn't return any
with 
borrowsStatistics as (
SELECT *, 
	COUNT(BorrowerID) OVER (PARTITION BY BorrowerID) AS LoanCount, 
	COUNT(DateReturned) OVER (PARTITION BY BorrowerID) AS ReturnDates
FROM Loans
)

,activeBorrows as(
SELECT *
FROM (select * from borrowsStatistics) as LoanCounts
WHERE LoanCount >= 2 and DateReturned is null and ReturnDates = 0
)

select Borrowers.BorrowerID, FirstName, LastName, Email, DateOfBirth, MembershipDate 
from Borrowers join activeBorrows as borrows on Borrowers.BorrowerID = borrows.BorrowerID
