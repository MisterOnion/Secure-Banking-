USE MASTER
GO
-- create master key with encryption
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';

-- backup created master key
BACKUP MASTER KEY
TO FILE = 'C:\SSMS Backup\keys\MasterKeyBackup.key'
ENCRYPTION BY PASSWORD = 'Pa$$w0rd';

-- create certificate
CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'TDECert';

-- backup certificate
BACKUP CERTIFICATE MyServerCert
TO FILE = 'C:\SSMS Backup\keys\MyServerCert.cer'
WITH PRIVATE KEY (
	FILE = 'C:\SSMS Backup\keys\MyServerCert.pvk',
	ENCRYPTION BY PASSWORD = 'Pa$$w0rd'
);

-- create database encryption key with AES 256, and encrypt it with server cert
USE [Secure Banking]
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyServerCert;
GO

-- enable encryption
ALTER DATABASE [Secure Banking]
SET ENCRYPTION ON;
GO

-- check if encryption is on ( 1 is on)
SELECT	
	name AS DatabaseName,
	is_encrypted AS EncryptionStatus
FROM sys.databases
WHERE name = 'Secure Banking';


USE MASTER
GO
-- Apply encryption to all backups
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'Pa$$w0rd';
CREATE CERTIFICATE BackupEncryptionCert WITH SUBJECT = 'Backup Encryption Certificate';

-- check for backup certificate 
SELECT name, subject, thumbprint
FROM sys.certificates
WHERE name = 'BackupEncryptionCert';

-- backup your backup certificate
BACKUP CERTIFICATE BackupEncryptionCert
TO FILE = 'C:\SSMS Backup\keys\BackupEncryptionCert.cer'
WITH PRIVATE KEY (
	FILE = 'C:\SSMS Backup\keys\BackupEncryptionCert.pvk',
	ENCRYPTION BY PASSWORD = 'Pa$$w0rd'
);
