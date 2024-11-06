
WITH loansOfMonthCTE AS (
    SELECT *
        FROM Loans
        WHERE MONTH(DateBorrowed) = 11 AND YEAR(DateBorrowed) = 2023
)

-- SELECT Genre from Books join loansOfMonth 
SELECT DISTINCT Genre
    FROM Books JOIN loansOfMonthCTE AS monthLoans 
    ON Books.ID = monthLoans.BookID