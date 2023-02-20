USE master;
GO

if DB_ID('efzDemo') is not null
alter database efzDemo set single_user with rollback immediate;
go

-- Wenn Datenbank schon existiert löschen
DROP DATABASE IF EXISTS efzDemo;
GO

-- Kreieren der Datenbank efzDemo
CREATE DATABASE efzDemo;
GO

-- Wechseln des Kontexts auf efzDemo
USE efzDemo;
GO

-- Wenn Tabelle bereits existiert, lösche Sie
DROP TABLE IF EXISTS dbo.Demo;
GO

-- Tabelle dbo.Demo erstellen
CREATE TABLE dbo.Demo (
    ID			int				NOT NULL IDENTITY(1,1),
    Vorname		varchar(255)	NOT NULL,
    Nachname	varchar(255)	NOT NULL,
    Person_ID	int				NOT NULL,
);
GO

-- Deklarieren von Variablen
DECLARE @Vorname varchar(255) = 'Alexander';
DECLARE @Nachname varchar(255) = 'Ernst';
DECLARE @Person_ID int = 1;

-- Merge Statement welches Variablen in Tabelle einfügt
MERGE dbo.Demo AS tgt
	USING (SELECT @Vorname, @Nachname, @Person_ID) AS src
		  (Vorname, Nachmame, Person_ID)
	ON (tgt.Person_ID = src.Person_ID)
	WHEN NOT MATCHED THEN
		INSERT (Vorname, Nachname, Person_ID)
		VALUES (src.Vorname, src.Nachmame, Person_ID);
	GO

-- Procedure welche aus setzbaren Variablen besteht und Merge Statements hat die beim Aufruf von der Procedure ausgeführt werden
-- Hier kann man auch mehrere MERGE Statements angeben
CREATE OR ALTER PROCEDURE dbo.usp_Demo
(
	@Vorname		varchar(255)
	, @Nachname		varchar(255)
	, @Person_ID	int
)
AS
MERGE dbo.Demo AS tgt
	USING (SELECT @Vorname, @Nachname, @Person_ID) AS src
		  (Vorname, Nachmame, Person_ID)
	ON (tgt.Person_ID = src.Person_ID)
	WHEN NOT MATCHED THEN
		INSERT (Vorname, Nachname, Person_ID)
		VALUES (src.Vorname, src.Nachmame, Person_ID);
	GO

-- Deklarieren von Variablen
DECLARE @Vorname	varchar(255) = 'Max';
DECLARE @Nachname	varchar(255) = 'Mustermann';
DECLARE @Person_ID	int = 2;

-- Ausführen (Executen) der Procedure
-- Oft würden wir diese Procedure jetzt durch C# aufrufen und dort Werte übergeben, dies ist jetzt nur zu demonstrationszwecken
EXEC dbo.usp_Demo
	@Vorname = @Vorname
	, @Nachname = @Nachname
	, @Person_ID = @Person_ID
GO

SELECT * FROM dbo.Demo;
GO
