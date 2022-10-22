USE [master];
EXEC sp_sqljdbc_xa_install
GO

CREATE DATABASE [keycloak-orbi];
GO

USE [keycloak-orbi];
GO
EXEC sp_sqljdbc_xa_install
CREATE LOGIN [keycloak-orbi] WITH PASSWORD = 'lolIusepasswords@';
GO

USE [master];
GO
sp_grantdbaccess 'keycloak-orbi', 'keycloak-orbi';
EXEC sp_addrolemember [SqlJDBCXAUser], 'keycloak-orbi'
GO

USE [keycloak-orbi]
GO
CREATE USER [keycloak-orbi] FOR LOGIN [keycloak-orbi]
EXEC sp_addrolemember N'db_owner', N'keycloak-orbi'
GO