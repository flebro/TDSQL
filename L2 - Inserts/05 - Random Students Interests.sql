DELETE FROM StudentInterest
GO

-- Cette requ�te g�n�re, pour chaque �tudiant, 5 id d'int�r�t al�atoire et pour chacun un score g�n�r� al�atoirement de 1 � 5
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