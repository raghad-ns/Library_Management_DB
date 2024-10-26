
with loansOfMonth as (
SELECT *
FROM Loans
WHERE MONTH(DateBorrowed) = 11 AND YEAR(DateBorrowed) = 2023)

-- select Genere from Books join loansOfMonth 
SELECT distinct Genere
FROM Books join loansOfMonth as  monthLoans on Books.BookID = monthLoans.BookID