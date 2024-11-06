CREATE DATABASE LibraryManagement;

USE LibraryManagement

CREATE TABLE [Borrowers] (
  [ID] INT IDENTITY PRIMARY KEY,
  [FirstName] VARCHAR(50),
  [LastName] VARCHAR(50),
  [Email] VARCHAR(30),
  [DateOfBirth] Date,
  [MembershipDate] Date,
);

CREATE TABLE [Books] (
  [BookID] INT IDENTITY PRIMARY KEY,
  [Title] VARCHAR(50),
  [Author] VARCHAR(50),
  [ISBN] VARCHAR(13),
  [Genre] VARCHAR(20),
  [ShelfLocation] VARCHAR(30),
  [CurrentStatus] VARCHAR(10) 
  CHECK (CurrentStatus IN ('available', 'borrowed')),
);

CREATE TABLE [Loans] (
  [LoanID] INT IDENTITY PRIMARY KEY,
  [BookID] INT,
  [ID] INT,
  [DateBorrowed] DATETIME DEFAULT SYSDATETIME(),
  [DueDate] DATETIME,
  [DateReturned] DATETIME,
  CONSTRAINT [FK_Borrowers.ID]
    FOREIGN KEY ([ID])
      REFERENCES [Borrowers]([ID]),
  CONSTRAINT [FK_Borrowers.BookID]
    FOREIGN KEY ([BookID])
      REFERENCES [Books]([BookID])
);

CREATE TABLE AuditLog (
	LogID INT IDENTITY PRIMARY KEY,
	BookID INT, 
	StatusChange VARCHAR(10),
	ChangeDate DATE,
	CHECK (StatusChange IN ('available', 'borrowed')),
)


-- Creating indeces
CREATE  INDEX IX_Borrowers_Email ON Borrowers (Email);
CREATE UNIQUE INDEX IX_ReturnedDate_DueDate ON Loans (DateReturned, DueDate);