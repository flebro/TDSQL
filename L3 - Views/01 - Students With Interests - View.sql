IF EXISTS (SELECT TOP(1) 1 FROM sys.views WHERE name = 'V_Student_WithAggregatedInterests')
BEGIN
	DROP VIEW V_Student_WithAggregatedInterests
END
GO

CREATE VIEW V_Student_WithAggregatedInterests
AS
SELECT S.[Id], S.[Lastname], S.[Firstname], S.[Birthdate], S.[CityOfBirth], S.[Code], S.[Address1], S.[Address2], S.[Address3], S.[Address4]
	, STRING_AGG(CONCAT(IC.[Label], ':', SI.[Grade]), ';') AS Interests
	FROM Student AS S
	LEFT JOIN StudentInterest AS SI ON S.Id = SI.Student_Id
	LEFT JOIN InterestCatalog AS IC on SI.InterestCatalog_Id = IC.Id
	GROUP BY  S.[Id], S.[Lastname], S.[Firstname], S.[Birthdate], S.[CityOfBirth], S.[Code], S.[Address1], S.[Address2], S.[Address3], S.[Address4]
GO
