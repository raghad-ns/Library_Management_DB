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
  [ID] INT IDENTITY PRIMARY KEY,
  [Title] VARCHAR(50),
  [Author] VARCHAR(50),
  [ISBN] VARCHAR(13),
  [Genre] VARCHAR(20),
  [ShelfLocation] VARCHAR(30),
  [CurrentStatus] ENUM('AVAILABLE', 'BORROWED') 
  --CHECK (CurrentStatus IN ('available', 'borrowed')),
);

CREATE TABLE [Loans] (
  [ID] INT IDENTITY PRIMARY KEY,
  [BookID] INT,
  [BorrowerID] INT,
  [DateBorrowed] DATETIME DEFAULT SYSDATETIME(),
  [DueDate] DATETIME,
  [DateReturned] DATETIME,
  CONSTRAINT [FK_Borrowers.ID]
    FOREIGN KEY ([BorrowerID])
      REFERENCES [Borrowers]([ID]),
  CONSTRAINT [FK_Borrowers.BookID]
    FOREIGN KEY ([BookID])
      REFERENCES [Books]([ID])
);

CREATE TABLE AuditLog (
	LogID INT IDENTITY PRIMARY KEY,
	BookID INT, 
	StatusChange VARCHAR(10),
	ChangeDate DATE,
	CHECK (StatusChange IN ('AVAILABLE', 'BORROWED')),
)


-- Creating indeces
CREATE  INDEX IX_Borrowers_Email ON Borrowers (Email);
CREATE UNIQUE INDEX IX_ReturnedDate_DueDate ON Loans (DateReturned, DueDate);