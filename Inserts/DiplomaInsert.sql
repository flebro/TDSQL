USE ANOPB_DB
GO

BULK INSERT InterestCatalog
FROM
	N'C:\Users\IEUser\Documents\GitHub\TDSQL\Sujet\02 - Interets.csv'
WITH
(	
	FIELDTERMINATOR = ';'
	,ROWTERMINATOR = '\n'
	,CODEPAGE = 65001
	,FIRSTROW = 2
)
GO
