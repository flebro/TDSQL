USE [master]
GO
/****** Object:  Database [ANOPB_DB]    Script Date: 28/06/2018 08:41:02 ******/
CREATE DATABASE [ANOPB_DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ANOPB_DB_dat', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\ANOPB_DB_dat2.mdf' , SIZE = 65536KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ANOPB_DB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\ANOPB_DB_log2.ldf' , SIZE = 65536KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [ANOPB_DB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ANOPB_DB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ANOPB_DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ANOPB_DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ANOPB_DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ANOPB_DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ANOPB_DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ANOPB_DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ANOPB_DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ANOPB_DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ANOPB_DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ANOPB_DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ANOPB_DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ANOPB_DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ANOPB_DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ANOPB_DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ANOPB_DB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ANOPB_DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ANOPB_DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ANOPB_DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ANOPB_DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ANOPB_DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ANOPB_DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ANOPB_DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ANOPB_DB] SET RECOVERY FULL 
GO
ALTER DATABASE [ANOPB_DB] SET  MULTI_USER 
GO
ALTER DATABASE [ANOPB_DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ANOPB_DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ANOPB_DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ANOPB_DB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ANOPB_DB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ANOPB_DB', N'ON'
GO
ALTER DATABASE [ANOPB_DB] SET QUERY_STORE = OFF
GO
USE [ANOPB_DB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [ANOPB_DB]
GO
/****** Object:  FullTextCatalog [FC_Teaching_Aggregated]    Script Date: 28/06/2018 08:41:03 ******/
CREATE FULLTEXT CATALOG [FC_Teaching_Aggregated] WITH ACCENT_SENSITIVITY = OFF
GO
/****** Object:  UserDefinedFunction [dbo].[KmToScore]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[KmToScore](@distanceKm INT)
RETURNS TINYINT
AS BEGIN
	RETURN CASE
		WHEN @distanceKm < 50		THEN 5
		WHEN @distanceKm < 100	THEN 4
		WHEN @distanceKm < 250	THEN 3
		WHEN @distanceKm < 500	THEN 2
		WHEN @distanceKm < 750	THEN 1
		ELSE						 0		END
END
GO
/****** Object:  Table [dbo].[InterestCatalog]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterestCatalog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Label] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_InterestCatalog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentInterest]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentInterest](
	[Student_Id] [bigint] NOT NULL,
	[InterestCatalog_Id] [bigint] NOT NULL,
	[Grade] [tinyint] NOT NULL,
 CONSTRAINT [PK_StudentInterest] PRIMARY KEY CLUSTERED 
(
	[Student_Id] ASC,
	[InterestCatalog_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Lastname] [nvarchar](200) NOT NULL,
	[Firstname] [nvarchar](200) NOT NULL,
	[Birthdate] [date] NOT NULL,
	[CityOfBirth] [nvarchar](200) NOT NULL,
	[Mail] [nvarchar](100) NULL,
	[Address1] [nvarchar](200) NOT NULL,
	[Address2] [nchar](200) NULL,
	[Address3] [nchar](200) NULL,
	[Address4] [nchar](200) NULL,
	[Latitude] [decimal](18, 15) NOT NULL,
	[Longitude] [decimal](18, 15) NOT NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_Student_Code] UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_Student_WithAggregatedInterests]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_Student_WithAggregatedInterests]
AS
SELECT S.[Id], S.[Lastname], S.[Firstname], S.[Birthdate], S.[CityOfBirth], S.[Code], S.[Address1], S.[Address2], S.[Address3], S.[Address4]
	, STRING_AGG(CONCAT(IC.[Label], ':', SI.[Grade]), ';') AS Interests
	FROM Student AS S
	LEFT JOIN StudentInterest AS SI ON S.Id = SI.Student_Id
	LEFT JOIN InterestCatalog AS IC on SI.InterestCatalog_Id = IC.Id
	GROUP BY  S.[Id], S.[Lastname], S.[Firstname], S.[Birthdate], S.[CityOfBirth], S.[Code], S.[Address1], S.[Address2], S.[Address3], S.[Address4]
GO
/****** Object:  Table [dbo].[Teaching]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teaching](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[School_Id] [bigint] NOT NULL,
	[Diploma_Id] [bigint] NOT NULL,
	[Capacity] [smallint] NOT NULL,
 CONSTRAINT [PK_SchoolDiploma_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Diploma]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Diploma](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[Label] [nvarchar](100) NOT NULL,
	[Minor] [nvarchar](100) NULL,
 CONSTRAINT [PK_Diploma] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_Diploma_Code] UNIQUE NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[School]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[School](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[Mail] [nvarchar](100) NULL,
	[Type] [nchar](100) NULL,
	[Address1] [nvarchar](200) NOT NULL,
	[Address2] [nchar](200) NULL,
	[Address3] [nchar](200) NULL,
	[Address4] [nchar](200) NULL,
	[Latitude] [decimal](18, 15) NOT NULL,
	[Longitude] [decimal](18, 15) NOT NULL,
 CONSTRAINT [PK_School] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_Teaching_Aggregated]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_Teaching_Aggregated] WITH SCHEMABINDING
AS
	SELECT
		Tea.Id AS Teaching_Id
		,LOWER(CONCAT(Sch.[Name], ' ', Sch.[Type], ' ', Sch.Code, ' ', Sch.Address1, ' ', Sch.Address2, ' ', Sch.Address3, ' ', Sch.Address4, ' ', Dip.Label, ' ', Dip.Minor)) AS AggregatedInfo
	FROM dbo.Teaching AS Tea
	INNER JOIN dbo.School AS Sch ON Tea.School_Id = Sch.Id
	INNER JOIN dbo.Diploma AS Dip ON Tea.Diploma_Id = Dip.Id
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
/****** Object:  Index [IX_V_Teaching_Aggregated_Id]    Script Date: 28/06/2018 08:41:03 ******/
CREATE UNIQUE CLUSTERED INDEX [IX_V_Teaching_Aggregated_Id] ON [dbo].[V_Teaching_Aggregated]
(
	[Teaching_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_StudentsWithAggregatedInterests]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_StudentsWithAggregatedInterests]
AS
SELECT S.[Id], S.[Lastname], S.[Firstname], S.[Birthdate], S.[CityOfBirth], S.[Code], S.[Address1], S.[Address2], S.[Address3], S.[Address4]
	, STRING_AGG(CONCAT(IC.[Label], ':', SI.[Grade]), ';') AS Interests
	FROM Student AS S
	LEFT JOIN StudentInterest AS SI ON S.Id = SI.Student_Id
	LEFT JOIN InterestCatalog AS IC on SI.InterestCatalog_Id = IC.Id
	GROUP BY  S.[Id], S.[Lastname], S.[Firstname], S.[Birthdate], S.[CityOfBirth], S.[Code], S.[Address1], S.[Address2], S.[Address3], S.[Address4]
GO
/****** Object:  View [dbo].[V_SchoolsFull]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_SchoolsFull]
AS
SELECT Sch.[Id] AS School_Id, Sch.[Name], Sch.[Type], Sch.[Code] AS School_Code, Sch.[Address1], Sch.[Address2], Sch.[Address3], Sch.[Address4], Sch.[Mail]
	, D.[Id] AS Diploma_ID, D.[Label], D.[Minor], D.[Code] AS Diploma_Code, T.[Capacity]
	FROM School AS Sch
	LEFT JOIN Teaching AS T ON Sch.[Id] = T.[School_Id]
	LEFT JOIN Diploma AS D ON T.[Diploma_Id] = D.[Id]
GO
/****** Object:  Table [dbo].[DiplomaInterest]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiplomaInterest](
	[Diploma_Id] [bigint] NOT NULL,
	[InterestCatalog_Id] [bigint] NOT NULL,
	[Grade] [tinyint] NOT NULL,
 CONSTRAINT [PK_DiplomaInterest] PRIMARY KEY CLUSTERED 
(
	[Diploma_Id] ASC,
	[InterestCatalog_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_Correspondances]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_Correspondances]
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
	SELECT TOP 5 St.id AS Student_Id
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
/****** Object:  Table [dbo].[Enrolment]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrolment](
	[Student_Id] [bigint] NOT NULL,
	[Teaching_Id] [bigint] NOT NULL,
	[Accepted] [bit] NOT NULL,
	[Reviewed] [bit] NOT NULL,
 CONSTRAINT [PK_Enrolment] PRIMARY KEY CLUSTERED 
(
	[Student_Id] ASC,
	[Teaching_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Teaching_Diploma_Id]    Script Date: 28/06/2018 08:41:03 ******/
CREATE NONCLUSTERED INDEX [IX_Teaching_Diploma_Id] ON [dbo].[Teaching]
(
	[Diploma_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Teaching_School_Id]    Script Date: 28/06/2018 08:41:03 ******/
CREATE NONCLUSTERED INDEX [IX_Teaching_School_Id] ON [dbo].[Teaching]
(
	[School_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Enrolment] ADD  CONSTRAINT [DF_Enrolment_Accepted]  DEFAULT ((0)) FOR [Accepted]
GO
ALTER TABLE [dbo].[Enrolment] ADD  CONSTRAINT [DF_Enrolment_Reviewed]  DEFAULT ((0)) FOR [Reviewed]
GO
ALTER TABLE [dbo].[DiplomaInterest]  WITH CHECK ADD  CONSTRAINT [FK_DiplomaInterest_Diploma] FOREIGN KEY([Diploma_Id])
REFERENCES [dbo].[Diploma] ([Id])
GO
ALTER TABLE [dbo].[DiplomaInterest] CHECK CONSTRAINT [FK_DiplomaInterest_Diploma]
GO
ALTER TABLE [dbo].[DiplomaInterest]  WITH CHECK ADD  CONSTRAINT [FK_DiplomaInterest_InterestCatalog] FOREIGN KEY([InterestCatalog_Id])
REFERENCES [dbo].[InterestCatalog] ([Id])
GO
ALTER TABLE [dbo].[DiplomaInterest] CHECK CONSTRAINT [FK_DiplomaInterest_InterestCatalog]
GO
ALTER TABLE [dbo].[Enrolment]  WITH CHECK ADD  CONSTRAINT [FK_Enrolment_Student] FOREIGN KEY([Student_Id])
REFERENCES [dbo].[Student] ([Id])
GO
ALTER TABLE [dbo].[Enrolment] CHECK CONSTRAINT [FK_Enrolment_Student]
GO
ALTER TABLE [dbo].[Enrolment]  WITH CHECK ADD  CONSTRAINT [FK_Enrolment_Teaching] FOREIGN KEY([Teaching_Id])
REFERENCES [dbo].[Teaching] ([Id])
GO
ALTER TABLE [dbo].[Enrolment] CHECK CONSTRAINT [FK_Enrolment_Teaching]
GO
ALTER TABLE [dbo].[StudentInterest]  WITH CHECK ADD  CONSTRAINT [FK_StudentInterest_InterestCatalog] FOREIGN KEY([InterestCatalog_Id])
REFERENCES [dbo].[InterestCatalog] ([Id])
GO
ALTER TABLE [dbo].[StudentInterest] CHECK CONSTRAINT [FK_StudentInterest_InterestCatalog]
GO
ALTER TABLE [dbo].[StudentInterest]  WITH CHECK ADD  CONSTRAINT [FK_StudentInterest_Student] FOREIGN KEY([Student_Id])
REFERENCES [dbo].[Student] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StudentInterest] CHECK CONSTRAINT [FK_StudentInterest_Student]
GO
ALTER TABLE [dbo].[Teaching]  WITH CHECK ADD  CONSTRAINT [FK_Teaching_Diploma] FOREIGN KEY([Diploma_Id])
REFERENCES [dbo].[Diploma] ([Id])
GO
ALTER TABLE [dbo].[Teaching] CHECK CONSTRAINT [FK_Teaching_Diploma]
GO
ALTER TABLE [dbo].[Teaching]  WITH CHECK ADD  CONSTRAINT [FK_Teaching_School] FOREIGN KEY([School_Id])
REFERENCES [dbo].[School] ([Id])
GO
ALTER TABLE [dbo].[Teaching] CHECK CONSTRAINT [FK_Teaching_School]
GO
ALTER TABLE [dbo].[DiplomaInterest]  WITH CHECK ADD  CONSTRAINT [CK_DiplomaInterest_Grade_Range] CHECK  (([Grade]>=(1) AND [Grade]<=(5)))
GO
ALTER TABLE [dbo].[DiplomaInterest] CHECK CONSTRAINT [CK_DiplomaInterest_Grade_Range]
GO
ALTER TABLE [dbo].[StudentInterest]  WITH CHECK ADD  CONSTRAINT [CK_StudentInterest_Grade_Range] CHECK  (([Grade]>=(1) AND [Grade]<=(5)))
GO
ALTER TABLE [dbo].[StudentInterest] CHECK CONSTRAINT [CK_StudentInterest_Grade_Range]
GO
/****** Object:  StoredProcedure [dbo].[P_SearchSchool]    Script Date: 28/06/2018 08:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_SearchSchool] @SearchString AS NVARCHAR(4000)
AS
BEGIN
	SELECT 
			@SearchString = STRING_AGG('"' + TRIM(value) + '*"', ' AND ')
	FROM 
		STRING_SPLIT(LOWER(@SearchString), ' ') 
	WHERE 
		value <> ''

	SELECT 
		SchoolView.*
	FROM 
		V_School_Full AS SchoolView
	INNER JOIN V_Teaching_Aggregated AS FTC ON SchoolView.Teaching_Id = FTC.Teaching_Id
	WHERE 
		CONTAINS(FTC.AggregatedInfo, @SearchString)
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Limite les données possibles pour la note d''intérêt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'StudentInterest', @level2type=N'CONSTRAINT',@level2name=N'CK_StudentInterest_Grade_Range'
GO
USE [master]
GO
ALTER DATABASE [ANOPB_DB] SET  READ_WRITE 
GO

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



