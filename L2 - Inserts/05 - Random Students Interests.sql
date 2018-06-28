DELETE FROM StudentInterest
GO

-- Cette requète génère, pour chaque étudiant, 5 id d'intérêt aléatoire et pour chacun un score généré aléatoirement de 1 à 5
INSERT INTO StudentInterest(Student_Id, InterestCatalog_Id, Grade)
SELECT s.Id, RndInt.Interest_Id, RndInt.Grade
FROM Student s
CROSS APPLY (
	SELECT TOP 5 s2.Id, ic.Id AS Interest_Id, Abs(Checksum(NewId())) % 5 +1  AS Grade, NewId() AS RndId
	FROM Student s2, InterestCatalog ic
	WHERE s2.Id = s.Id
	ORDER BY RndId
) RndInt
GO