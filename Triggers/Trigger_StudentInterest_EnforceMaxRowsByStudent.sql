--====================================
--  Trigger Pour vérifier qu'il n'y a que n interets par etudiant
--====================================
USE ANOPB_DB
GO

IF EXISTS (SELECT TOP(1) 1 FROM sys.triggers WHERE name = 'TR_StundentInterest_EnforceMaxRowsByStudent')
BEGIN
	DROP TRIGGER TR_StundentInterest_EnforceMaxRowsByStudent
END
GO

CREATE TRIGGER TR_StundentInterest_EnforceMaxRowsByStudent ON StudentInterest 
	AFTER INSERT, UPDATE   
AS
BEGIN
	DECLARE @maxAuthorizedInterestCount TINYINT = 5
	DECLARE @maxStudentInterestCount INT
	SELECT TOP 1 @maxStudentInterestCount = COUNT(InterestCatalog_Id)
	FROM StudentInterest
	GROUP BY Student_Id
	ORDER BY COUNT(InterestCatalog_Id) DESC

	IF (@maxStudentInterestCount > @maxAuthorizedInterestCount)
	BEGIN
		RAISERROR (N'Too much interest by student', 1, 1);  
		ROLLBACK TRANSACTION
	END
END
GO


