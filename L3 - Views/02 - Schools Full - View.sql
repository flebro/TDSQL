IF EXISTS (SELECT TOP(1) 1 FROM sys.views WHERE name = 'V_School_Full')
BEGIN
	DROP VIEW V_School_Full
END
GO

CREATE VIEW V_School_Full WITH SCHEMABINDING
AS
SELECT Sch.[Id] AS School_Id, Sch.[Name], Sch.[Type], Sch.[Code] AS School_Code, Sch.[Address1], Sch.[Address2], Sch.[Address3], Sch.[Address4], Sch.[Mail]
	, D.[Id] AS Diploma_ID, D.[Label], D.[Minor], D.[Code] AS Diploma_Code, T.[Capacity], T.[Id] AS Teaching_Id
	FROM School AS Sch
	LEFT JOIN Teaching AS T ON Sch.[Id] = T.[School_Id]
	LEFT JOIN Diploma AS D ON T.[Diploma_Id] = D.[Id]
GO