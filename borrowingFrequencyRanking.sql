WITH BorrowersFrequencies AS (
    SELECT ID, 
        COUNT(LoanID) OVER (PARTITION BY Loans.ID) AS BorrowingFrequency
        FROM Loans
)

SELECT DISTINCT Borrowers.ID, FirstName, LastName, BorrowingFrequency, 
DENSE_RANK() OVER (ORDER BY BorrowingFrequency DESC) AS BorrowerRank
FROM Borrowers LEFT JOIN BorrowersFrequencies AS Frequencies ON Borrowers.ID = Frequencies.ID
ORDER BY BorrowerRank 
