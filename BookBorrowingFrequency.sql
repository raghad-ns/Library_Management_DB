create function fn_BookBorrowingFrequency(@bookId int)
returns int 
as
begin
	declare @frequency int;
	select @frequency = count(LoanID) from Loans where BookID = @bookId ;

	return @frequency;
end

select dbo.fn_BookBorrowingFrequency(5) as BorrowingFrequency