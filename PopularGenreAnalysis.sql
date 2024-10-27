
WITH loansOfMonth AS (
    SELECT *
        FROM Loans
        WHERE MONTH(DateBorrowed) = 11 AND YEAR(DateBorrowed) = 
)

-- SELECT Genere from Books join loansOfMonth 
SELECT DISTINCT Genere
    FROM Books JOIN loansOfMonth AS monthLoans 
    ON Books.BookID = monthLoans.BookID