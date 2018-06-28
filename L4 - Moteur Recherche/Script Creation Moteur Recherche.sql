IF EXISTS (SELECT TOP(1) 1 FROM sys.views WHERE name = 'V_Teaching_Aggregated')
BEGIN
	DROP VIEW V_Teaching_Aggregated
END
GO

CREATE VIEW V_Teaching_Aggregated WITH SCHEMABINDING
AS
	SELECT
		Tea.Id AS Teaching_Id
		,LOWER(CONCAT(Sch.[Name], ' ', Sch.[Type], ' ', Sch.Code, ' ', Sch.Address1, ' ', Sch.Address2, ' ', Sch.Address3, ' ', Sch.Address4, ' ', Dip.Label, ' ', Dip.Minor, ' ', Dip.Code)) AS AggregatedInfo
	FROM dbo.Teaching AS Tea
	INNER JOIN dbo.School AS Sch ON Tea.School_Id = Sch.Id
	INNER JOIN dbo.Diploma AS Dip ON Tea.Diploma_Id = Dip.Id
GO

CREATE UNIQUE CLUSTERED INDEX [IX_V_Teaching_Aggregated_Id] ON V_Teaching_Aggregated
(
	Teaching_Id ASC
)
GO

CREATE FULLTEXT CATALOG [FC_Teaching_Aggregated]
WITH ACCENT_SENSITIVITY = OFF
AUTHORIZATION [dbo];
GO

CREATE FULLTEXT INDEX ON [dbo].V_Teaching_Aggregated
(
	AggregatedInfo
)
KEY INDEX [IX_V_Teaching_Aggregated_Id]
ON [FC_Teaching_Aggregated]
WITH STOPLIST OFF;


IF EXISTS (SELECT TOP(1) 1 FROM sys.procedures AS t0 WHERE name = 'SearchSchool')
BEGIN
	DROP PROCEDURE SearchSchool
END
GO

CREATE PROCEDURE P_SearchSchool @SearchString AS NVARCHAR(4000)
AS
BEGIN
	-- D'abord on traite la chaîne saisie
	SELECT 
			@SearchString = STRING_AGG('"' + TRIM(value) + '*"', ' AND ')
	FROM 
		STRING_SPLIT(LOWER(@SearchString), ' ') 
	WHERE 
		value <> ''
	-- Puis on fait une recherche full texte
	SELECT 
		SchoolView.*
	FROM 
		V_School_Full AS SchoolView
	INNER JOIN V_Teaching_Aggregated AS FTC ON SchoolView.Teaching_Id = FTC.Teaching_Id
	WHERE 
		CONTAINS(FTC.AggregatedInfo, @SearchString)
END