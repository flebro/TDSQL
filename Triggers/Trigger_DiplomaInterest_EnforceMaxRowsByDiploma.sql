--====================================
--  Trigger Pour vérifier qu'il n'y a que n intérets par diplôme
--====================================
USE ANOPB_DB
GO

IF EXISTS(
  SELECT *
    FROM sys.triggers
   WHERE name = N'TR_DiplomaInterest_EnforceMaxRowsByDiploma'
     AND parent_class_desc = N'DiplomaInterest'
)
	DROP TRIGGER TR_DiplomaInterest_EnforceMaxRowsByDiploma ON DATABASE
GO

CREATE TRIGGER TR_DiplomaInterest_EnforceMaxRowsByDiploma ON DiplomaInterest 
	FOR INSERT
AS 
BEGIN
	DECLARE @maxInterestCount TINYINT = 3
	IF (SELECT COUNT(*) FROM DiplomaInterest WHERE Diploma_Id = (SELECT Diploma_Id FROM INSERTED)) <= @maxInterestCount
		ROLLBACK TRANSACTION
END
GO


