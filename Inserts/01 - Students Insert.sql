USE ANOPB_DB
GO

CREATE TABLE ##RawStudentData
(
	[Code]				NVARCHAR(4000)	NULL
	,[Nom]				NVARCHAR(4000)	NULL
	,[Prenom]			NVARCHAR(4000)	NULL
	,[DateNaissance]	DATE			NULL
	,[VilleNaissance]	NVARCHAR(4000)	NULL
	,[Adresse1]			NVARCHAR(4000)	NULL
	,[Adresse2]			NVARCHAR(4000)	NULL
	,[Adresse3]			NVARCHAR(4000)	NULL
	,[Adresse4]			NVARCHAR(4000)	NULL
	,[Latitude]			DECIMAL(18, 15)	NULL
	,[Longitude]		DECIMAL(18, 15)	NULL
)

BULK INSERT ##RawStudentData
FROM
	N'C:\Users\IEUser\Documents\GitHub\TDSQL\Sujet\01 - Etudiants.csv'
WITH
(	
	FIELDTERMINATOR = ';'
	,ROWTERMINATOR = '\n'
	,CODEPAGE = 65001
	,FIRSTROW = 2
)
GO

INSERT INTO Student (Code, Firstname, Lastname, Birthdate, CityOfBirth, Address1, Address2, Address3, Address4, Latitude, Longitude)
	SELECT Code, Prenom, Nom, DateNaissance, VilleNaissance, Adresse1, Adresse2, Adresse3, Adresse4, Latitude, Longitude FROM ##RawStudentData
GO

DROP TABLE ##RawStudentData
GO
