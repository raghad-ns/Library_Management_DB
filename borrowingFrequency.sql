with BorrowersFrequencies 
as (
select BorrowerID, 
count(LoanID) over (partition by Loans.BorrowerID) as BorrowingFrequency
from Loans)

select distinct Borrowers.BorrowerID, FirstName, LastName, BorrowingFrequency, 
DENSE_RANK() over (order by BorrowingFrequency desc) as BorrowerRank
from Borrowers left join BorrowersFrequencies as Frequencies on Borrowers.BorrowerID = Frequencies.BorrowerID
order by BorrowerRank 
