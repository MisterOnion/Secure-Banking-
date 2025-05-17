Use [Secure Banking]
-- Create Table
CREATE TABLE Role
(
	RoleID INTEGER PRIMARY KEY,
	Role_Name VARCHAR(100) NOT NULL,
);

CREATE TABLE [User]
(
	UserID INT PRIMARY KEY IDENTITY(100,1),
    User_Name NVARCHAR(255),
    User_Email NVARCHAR(255) UNIQUE NOT NULL,
    User_Password NVARCHAR(255) NOT NULL,
    RoleID INT,
	Status VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT FK_Role FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);

CREATE TABLE Audit_Log (
    LogID INT PRIMARY KEY IDENTITY(300,1),
    UserID INT,
	User_Name VARCHAR(255),
	Role_Name VARCHAR(100),
    Action_Type VARCHAR(255),
    Action_Date DATETIME,
	Status VARCHAR(100),
	Message VARCHAR(255),
    CONSTRAINT FK_UserAudit FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

CREATE TABLE Account
(
	AccountID INTEGER NOT NULL PRIMARY KEY IDENTITY(200,1), 
	UserID INTEGER NOT NULL, 
	Acc_Number VARCHAR(100) NOT NULL, 
	Acc_Balance DECIMAL(18, 2), 
	CONSTRAINT FK_User FOREIGN KEY (UserID) REFERENCES [User](UserID),
);

CREATE TABLE AccountTransfer (
    TransferID INT PRIMARY KEY IDENTITY(400,1),
    SenderAccountID INT,
    ReceiverAccountID INT,
    AmountTransferred DECIMAL(18,2),
	AmountReceived DECIMAL(18,2),
	Deposit DECIMAL(18, 2),
	Withdrawal DECIMAL(18, 2),
    Action_Date DATETIME,
    CONSTRAINT FK_Sender FOREIGN KEY (SenderAccountID) REFERENCES Account(AccountID),
    CONSTRAINT FK_Receiver FOREIGN KEY (ReceiverAccountID) REFERENCES Account(AccountID)
);

-- need to insert this data first then can use role-based
INSERT INTO Role (RoleID, Role_Name) VALUES
(1, 'Admin'),
(2, 'User'),
(3, 'Manager');

/*
-- Drop tables
USE [Secure Banking]
ALTER TABLE Audit_Log DROP CONSTRAINT FK_UserAudit;
ALTER TABLE Account DROP CONSTRAINT FK_User;
ALTER TABLE AccountTransfer DROP CONSTRAINT FK_Sender;
ALTER TABLE AccountTransfer DROP CONSTRAINT FK_Receiver;
ALTER TABLE [User] DROP CONSTRAINT FK_Role;

DROP TABLE Audit_Log;
DROP TABLE AccountTransfer;
DROP TABLE Account;
DROP TABLE [User];
DROP TABLE Role;
*/

Select * from role
use [Secure Banking]
select * from [User]
select * from AccountTransfer
select * from Account
select * from Role
select * from Audit_Log

-- Row-level security (sort of)
CREATE FUNCTION dbo.GetRoleFilter (@RoleID INT)
RETURNS TABLE
AS 
RETURN (
    SELECT 
        CASE
            WHEN @RoleID = 1 THEN 
                'U.UserID, U.User_Name, U.User_Email, U.Status, R.Role_Name, A.Acc_Number'
            WHEN @RoleID = 3 THEN 
                'U.UserID, U.User_Name, U.User_Email, R.Role_Name'
            ELSE 
                'U.UserID, U.User_Name'
        END AS AllowedColumns
);


