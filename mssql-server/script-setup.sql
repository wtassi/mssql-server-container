-- Acessa o banco master e cria o novo banco de dados
DECLARE @databasename nvarchar(50) = 'my-application'
DECLARE @username nvarchar(50) = 'myuser'
DECLARE @password nvarchar(50) = 'passUser1122@'

DECLARE @query NVARCHAR(max) = ''
SET @query = N'USE [master]; 
IF EXISTS (select 1 from sys.databases where name = ''{SERVERNAME}'')
BEGIN
	PRINT ''>> O Banco de dados {SERVERNAME} já existe''
END
ELSE BEGIN
	CREATE DATABASE [{SERVERNAME}]
END'
SET @query = REPLACE(@query, '{SERVERNAME}', @databasename)
EXEC (@query)

-- Acessa o banco de dados criado e cria o login
SET @query = N' 
IF EXISTS (SELECT 1 FROM sys.sysusers where name = ''{USERNAME}'')
BEGIN
	USE [master];
	DROP LOGIN [{USERNAME}];
	USE [{SERVERNAME}];
	DROP USER [{USERNAME}];

END
	USE [master];
	CREATE LOGIN [{USERNAME}] WITH PASSWORD=N''{PASSWORD}'', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;

	USE [{SERVERNAME}];
	CREATE USER [{USERNAME}] FOR LOGIN [{USERNAME}];
	ALTER ROLE [db_owner] ADD MEMBER [{USERNAME}];
'

SET @query = REPLACE(REPLACE(REPLACE(
				@query, '{SERVERNAME}', @databasename),
						'{USERNAME}', @username),
						'{PASSWORD}', @password)
EXEC (@query)
