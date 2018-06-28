USE ANOPB_DB
GO

CREATE TABLE ##RawDiplomaData
(
	[Code]				NVARCHAR(4000)	NULL
	,[Titre]			NVARCHAR(4000)	NULL
	,[Option]			NVARCHAR(4000)	NULL
	,[CI1]				TINYINT			NULL
	,[Note1]			TINYINT			NULL
	,[CI2]				TINYINT			NULL
	,[Note2]			TINYINT			NULL
	,[CI3]				TINYINT			NULL
	,[Note3]			TINYINT			NULL
)
 
BULK INSERT ##RawDiplomaData
FROM
	N'C:\Users\IEUser\Documents\GitHub\TDSQL\Sujet\03 - Diplomes.csv'
WITH
(	
	FIELDTERMINATOR = ';'
	,ROWTERMINATOR = '\n'
	,CODEPAGE = 65001
	,FIRSTROW = 2
)
GO

INSERT INTO Diploma (Code, Label, Minor)
	SELECT Code, Titre, [Option] FROM ##RawDiplomaData
GO

INSERT INTO DiplomaInterest (Diploma_Id, InterestCatalog_Id, Grade)
	SELECT D.Id, RawData.CI1, RawData.[Note1] 
	FROM Diploma AS D, ##RawDiplomaData AS RawData
	WHERE D.Code = RawData.Code
GO

INSERT INTO DiplomaInterest (Diploma_Id, InterestCatalog_Id, Grade)
	SELECT D.Id, RawData.CI2, RawData.[Note2] 
	FROM Diploma AS D, ##RawDiplomaData AS RawData
	WHERE D.Code = RawData.Code
GO

INSERT INTO DiplomaInterest (Diploma_Id, InterestCatalog_Id, Grade)
	SELECT D.Id, RawData.CI3, RawData.[Note3] 
	FROM Diploma AS D, ##RawDiplomaData AS RawData
	WHERE D.Code = RawData.Code
GO

DROP TABLE ##RawDiplomaData
GO
