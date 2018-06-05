USE ANOPB_DB
GO

CREATE TABLE ##RawSchoolData
(
	[Code]			NVARCHAR(4000)	NULL
	,[Nom]			NVARCHAR(4000)	NULL
	,[Type]			NVARCHAR(4000)	NULL
	,[Adresse1]		NVARCHAR(4000)	NULL
	,[Adresse2]		NVARCHAR(4000)	NULL
	,[Adresse3]		NVARCHAR(4000)	NULL
	,[Adresse4]		NVARCHAR(4000)	NULL
	,[Latitude]		DECIMAL(18, 15)	NULL
	,[Longitude]	DECIMAL(18, 15)	NULL
	,[EMail]		NVARCHAR(4000)	NULL
	,[CodeDiplome]  NVARCHAR(4000)	NULL
	,[Capacite]		SMALLINT	NULL

)
 
BULK INSERT ##RawSchoolData
FROM
	N'C:\Users\IEUser\Documents\GitHub\TDSQL\Sujet\04 - Ecoles.csv'
WITH
(	
	FIELDTERMINATOR = ';'
	,ROWTERMINATOR = '\n'
	,CODEPAGE = 65001
	,FIRSTROW = 2
)
GO

INSERT INTO School ([Name], Code, Mail, [Type], Address1, Address2, Address3, Address4, Latitude, Longitude)
	SELECT DISTINCT Nom, Code, EMail, [Type], [Adresse1], [Adresse2], [Adresse3], [Adresse4], Latitude, Longitude  FROM ##RawSchoolData
GO

INSERT INTO Teaching(School_Id, Diploma_Id, Capacity)
	SELECT DISTINCT S.Id, D.Id, RawData.Capacite 
	FROM Diploma AS D, School AS S, ##RawSchoolData AS RawData
	WHERE D.Code = RawData.CodeDiplome AND RawData.Code = S.Code
GO

DROP TABLE ##RawSchoolData
GO
