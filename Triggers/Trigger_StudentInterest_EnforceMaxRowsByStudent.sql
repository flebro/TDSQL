--====================================
--  Trigger Pour vérifier qu'il n'y a que n interets par etudiant
--====================================
USE ANOPB_DB
GO

CREATE TRIGGER TR_StundentInterest_EnforceMaxRowsByStudent ON StudentInterest 
	FOR INSERT
AS 
BEGIN
	DECLARE @maxInterestCount TINYINT = 5
	IF (SELECT COUNT(*) FROM StudentInterest WHERE Student_Id = (SELECT Student_Id FROM INSERTED)) <= @maxInterestCount
		ROLLBACK TRANSACTION
END
GO


