CREATE DATABASE LibraryManagement;

USE LibraryManagement

CREATE TABLE [Borrowers] (
  [BorrowerID] int IDENTITY PRIMARY KEY,
  [FirstName] varchar(50),
  [LastName] varchar(50),
  [Email] varchar(30),
  [DateOfBirth] Date,
  [MembershipDate] Date,
);

CREATE TABLE [Books] (
  [BookID] int IDENTITY PRIMARY KEY,
  [Title] varchar(50),
  [Author] varchar(50),
  [ISBN] varchar(13),
  [Genere] varchar(20),
  [ShelfLocation] varchar(30),
  [CurrentStatus] varchar(10) 
  CHECK (CurrentStatus IN ('available', 'borrowed')),
);

CREATE TABLE [Loans] (
  [LoanID] int IDENTITY PRIMARY KEY,
  [BookID] int,
  [BorrowerID] int,
  [DateBorrowed] Date,
  [DueDate] Date,
  [DateReturned] Date,
  CONSTRAINT [FK_Borrowers.BorrowerID]
    FOREIGN KEY ([BorrowerID])
      REFERENCES [Borrowers]([BorrowerID]),
  CONSTRAINT [FK_Borrowers.BookID]
    FOREIGN KEY ([BookID])
      REFERENCES [Books]([BookID])
);


-- Creating indeces
CREATE  INDEX IX_Borrowers_Email ON Borrowers (Email);
CREATE INDEX IX_ReturnedDate_DueDate ON Loans (DateReturned, DueDate);