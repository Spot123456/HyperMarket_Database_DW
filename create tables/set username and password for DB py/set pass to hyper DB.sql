select distinct f_name + ' ' + l_name
from staff


SELECT name FROM sys.databases;

-- select database and set user name and password 
USE hypermarketDB;
SELECT name 
FROM sys.database_principals 
WHERE type = 'S' AND name = 'hyper_DB';

USE hypermarketDB;
ALTER USER hyper_DB WITH LOGIN = hyper_DB;

USE hypermarketDB;
EXEC sp_addrolemember 'db_owner', 'hyper_DB';  -- Assigns db_owner role

ALTER LOGIN hyper_DB WITH PASSWORD = '12345';
