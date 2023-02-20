-- =============================================
-- Create database template
-- ctrl + shift + m
-- =============================================
USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'BankDB'
)
DROP DATABASE BankDB
GO

CREATE DATABASE BankDB
GO

USE BankDB
GO

IF OBJECT_ID('dbo.Konto', 'U') IS NOT NULL
  DROP TABLE dbo.Konto
GO

CREATE TABLE dbo.Konto
(
	KtoNR int NOT NULL, 
	Saldo decimal(10,2) NOT NULL, 
    CONSTRAINT PK_Konto PRIMARY KEY (KtoNR)
)
GO

INSERT INTO dbo.Konto (KtoNR, Saldo)
VALUES (1000, 5000), (2000, 1000)
GO

-- Indexierung
CREATE INDEX IX_Konto_Saldo ON dbo.Konto (Saldo);

-- Geldüberweisung
-- =============================================
USE BankDB
GO

-- Beide Befehle sind Atomar/Unteilbar
-- Anderer User kann nicht zwischen den beiden Befehlen einsteigen bevor commit oder rollback ausgeführt wird
-- READ_COMMITED ist die Normale Isolationsstufe, jemand anderes kann zwischen den beiden Befehlen nicht einsteigen
-- Wir könnten auch READ_UNCOMMITED wählen, dann kann jemand anderes zwischen den beiden Befehlen einsteigen
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
-- Kriegt immer die gleichen Daten in einer Transaktion
-- Exklusive Lock (niemand anders hat Zugriff) gibt es nur für Änderungen, nicht für Lesen, für Lesen gibt es Shared Lock
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
GO
-- Höhere Isolationsstufe
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO
-- Transaktionen haben Probleme mit DeadLocks, blockierte Daten (verklemmungen).

begin transaction
UPDATE dbo.Konto 
	SET Saldo = Saldo - 500 
	WHERE KtoNR = 1000;
GO
UPDATE dbo.Konto 
	SET Saldo = Saldo + 500 
	WHERE KtoNR = 2000;
GO
commit

select * from dbo.Konto;
GO