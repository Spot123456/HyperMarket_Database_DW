
-- this for backup 
-- Backup hypermarketDB
BACKUP DATABASE hypermarketDB -- this u DB 
TO DISK = 'put u path ^_^';


-- for restoring use this 
-- Restore hypermarketDB
RESTORE DATABASE hypermarketDB_Copy
FROM DISK = 'mkanaha b3d al download '
WITH MOVE 'hypermarketDB' TO 'al mkan al gdeeeeeed',
     MOVE 'hypermarketDB_log' TO 'al mkan al gdeeeeeed';


