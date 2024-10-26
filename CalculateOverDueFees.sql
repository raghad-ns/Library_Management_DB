create function fn_CalculateOverdueFees (@LoanID int)
returns int as
begin
	declare @fees int
	declare @dueDate Date = (select DueDate from Loans where LoanID = @LoanID)
	declare @returnedDate Date = (select DateReturned from Loans where LoanID = @LoanID)
	declare @now Date = (SELECT CURRENT_TIMESTAMP)
	if (@returnedDate is null) 
		if (@dueDate >= @now) set @fees = 0
		else 
		begin
			declare @overdue int = DATEDIFF(DAY, @dueDate, @now)
			if (@overdue > 30) set @fees = 30 + 2 * (@overdue - 30)
			else set @fees = @overdue 
		end
	else
	begin
		declare @overdueForReturnedBook int = DATEDIFF(DAY, @dueDate, @returnedDate)
		if (@overdueForReturnedBook > 30) set @fees = 30 + 2 * (@overdueForReturnedBook - 30)
		else set @fees = @overdueForReturnedBook 
	end
	return @fees
end


select LoanID, dbo.fn_CalculateOverdueFees(1) as OverDue from Loans
