IF EXISTS (SELECT TOP(1) 1 FROM sys.views WHERE name = 'V_Correspondances')
BEGIN
	DROP VIEW V_Correspondances
END
GO

CREATE VIEW V_Correspondances
AS
WITH Distances AS (
	 SELECT St.Id AS Student_Id
		, Sch.Id AS School_Id
		, ROUND(geography::Point(St.Latitude, St.Longitude, 4326).STDistance(geography::Point(Sch.Latitude, Sch.Longitude, 4326)) / 1000, 0) AS Distance_KM
	 FROM Student AS St, School AS Sch
), Correspondance_Diploma AS (
	SELECT St.Id AS Student_Id
		, Dip.Id AS Diploma_Id
		, SUM(ISNULL(CASE WHEN StInt.Grade IS NULL OR StInt.Grade < DipInt.Grade THEN StInt.Grade ELSE DipInt.Grade END, 0)) AS Correspondance
	FROM Student AS St
	CROSS JOIN Diploma AS Dip
	LEFT JOIN DiplomaInterest AS DipInt ON Dip.Id = DipInt.Diploma_Id
	LEFT JOIN StudentInterest AS StInt ON St.Id = StInt.Student_Id AND DipInt.InterestCatalog_Id = StInt.InterestCatalog_Id
	GROUP BY St.Id, Dip.Id
)
SELECT Student.Id, Student.Code, School_Id, School_Name, School_Type, School_Code
	, School_Address1, School_Address2, School_Address3, School_Address4, School_Mail
	, Distance_KM, Diploma_Id, Diploma_Code, Correspondance, ScoreTotal
FROM Student
CROSS APPLY (
	SELECT TOP 10 St.id AS Student_Id
		, Tea.id AS Teaching_Id
		, Tea.School_Id AS School_Id
		, School.[Name] AS School_Name
		, School.[Type] AS School_Type
		, School.Code AS School_Code
		, School.Address1 AS School_Address1
		, School.Address2 AS School_Address2
		, School.Address3 AS School_Address3
		, School.Address4 AS School_Address4
		, School.Mail AS School_Mail
		, Distances.Distance_KM AS Distance_KM
		, Diploma.Id AS Diploma_Id
		, Diploma.Code AS Diploma_Code
		, Correspondance_Diploma.Correspondance
		, Correspondance_Diploma.Correspondance + dbo.KmToScore(Distances.Distance_KM) AS ScoreTotal
	FROM Student AS St
	CROSS JOIN Teaching Tea
	LEFT JOIN Distances ON St.Id = Distances.Student_Id AND Tea.School_Id = Distances.School_Id
	LEFT JOIN Correspondance_Diploma ON St.Id = Correspondance_Diploma.Student_Id AND Tea.Diploma_Id = Correspondance_Diploma.Diploma_Id
	INNER JOIN School ON Tea.School_Id = School.Id
	INNER JOIN Diploma ON Tea.Diploma_Id = Diploma.Id
	WHERE St.Id = Student.Id
	ORDER BY  Correspondance_Diploma.Correspondance + dbo.KmToScore(Distances.Distance_KM) DESC
) Totaux
GO