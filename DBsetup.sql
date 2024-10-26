CREATE DATABASE LibraryManagement;

Use LibraryManagement

CREATE TABLE [Borrowers] (
  [BorrowerID] int,
  [FirstName] varchar(50),
  [LastName] varchar(50),
  [Email] varchar(30),
  [DateOfBirth] Date,
  [MembershipData] varchar(50),
  PRIMARY KEY ([BorrowerID])
);

CREATE TABLE [Books] (
  [BookID] int,
  [Title] varchar(50),
  [Author] varchar(50),
  [ISBN] varchar(13),
  [Genere] varchar(20),
  [ShelfLocation] varchar(30),
  [CurrentStatus] varchar(10) 
  CHECK (CurrentStatus IN ('available', 'borrowed')),
  PRIMARY KEY ([BookID])
);

CREATE TABLE [Loans] (
  [LoanID] int,
  [BookID] int,
  [BorrowerID] int,
  [DateBorrowed] Date,
  [DueDate] Date,
  [DateReturned] Date,
  PRIMARY KEY ([LoanID]),
  CONSTRAINT [FK_Borrowers.BorrowerID]
    FOREIGN KEY ([BorrowerID])
      REFERENCES [Borrowers]([BorrowerID]),
  CONSTRAINT [FK_Borrowers.BookID]
    FOREIGN KEY ([BookID])
      REFERENCES [Books]([BookID])
);

