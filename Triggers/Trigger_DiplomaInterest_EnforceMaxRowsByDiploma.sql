--====================================
--  Trigger Pour vérifier qu'il n'y a que n intérets par diplôme
--====================================
USE ANOPB_DB
GO

IF EXISTS (SELECT TOP(1) 1 FROM sys.triggers WHERE name = 'TR_DiplomaInterest_EnforceMaxRowsByDiploma')
BEGIN
	DROP TRIGGER TR_DiplomaInterest_EnforceMaxRowsByDiploma
END
GO

CREATE TRIGGER TR_DiplomaInterest_EnforceMaxRowsByDiploma ON DiplomaInterest 
	AFTER INSERT, UPDATE   
AS
BEGIN
	DECLARE @maxAuthorizedInterestCount TINYINT = 3
	DECLARE @maxDiplomaInterestCount INT
	SELECT TOP 1 @maxDiplomaInterestCount = COUNT(InterestCatalog_Id)
	FROM DiplomaInterest
	GROUP BY Diploma_Id
	ORDER BY COUNT(InterestCatalog_Id) DESC

	IF (@maxDiplomaInterestCount > @maxAuthorizedInterestCount)
	BEGIN
		RAISERROR (N'Too much interest by diploma', 1, 1);  
		ROLLBACK TRANSACTION
	END
END
GO