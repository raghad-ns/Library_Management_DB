create function fn_getAgeGroup (@DOB Date) 
returns int
begin
	DECLARE @now Date = (SELECT CURRENT_TIMESTAMP)
	DECLARE @age int = DATEDIFF(YEAR, @DOB, @now)
	return @age / 10

end


with BooksLoansCountCTE as 
(
	select  BookID , Count(LoanID) over (partition by BookID) as BookLoansCount 
	from Loans
)

, BorrowedBooksCTE as (
select Books.BookID, Genere, Loans.BorrowerID from Loans join Books on Loans.BookID = Books.BookID
)

, BooksBorrowersCTE as (
	select BookID, Genere, Borrowers.BorrowerID, DateOfBirth from BorrowedBooksCTE join Borrowers on BorrowedBooksCTE.BorrowerID = Borrowers.BorrowerID
)

, AgeGroupsCTE as (
	select *, dbo.fn_getAgeGroup(DateOfBirth) as AgeGroup from BooksBorrowersCTE
)
, GenreBorrowingFrequency as (
select Genere, AgeGroup, COUNT(Genere) over (PARTITION BY AgeGroup) as Frequency from AgeGroupsCTE
) 

select distinct AgeGroup, Genere as PreferedGenre, Frequency as BorrwingFrequency, 
RANK() over (partition by AgeGroup order by Frequency desc) as GenreRank
from GenreBorrowingFrequency
