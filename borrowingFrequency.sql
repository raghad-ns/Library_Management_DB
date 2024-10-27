WITH BorrowersFrequencies AS (
    SELECT BorrowerID, 
        COUNT(LoanID) OVER (PARTITION BY Loans.BorrowerID) AS BorrowingFrequency
        FROM Loans
)

SELECT DISTINCT Borrowers.BorrowerID, FirstName, LastName, BorrowingFrequency, 
DENSE_RANK() OVER (ORDER BY BorrowingFrequency DESC) AS BorrowerRank
FROM Borrowers LEFT JOIN BorrowersFrequencies AS Frequencies ON Borrowers.BorrowerID = Frequencies.BorrowerID
ORDER BY BorrowerRank 
