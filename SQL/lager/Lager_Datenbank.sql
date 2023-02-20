/* 1. Vertabelo */
-- Ein Artikel hat einen Namen und einen Mindestbestand
-- Unser Unternehmen hat Lager an verschieden Standorten in der Schweiz
-- Ein Artikel wird kann in verschiedenen Lagerorten eingelagert sein,
-- wobei die Lagermenge pro Lagerort unterschiedlich sein kann
-- Ein Artikel wird von verschiedenen Lieferanten geliefert
-- Pro Lieferant haben wir unterschiedliche Einkaufspreise für den selben Artikel in verschiedenen Währungen
-- Ein Artikel hat einen Verkaufspreis für die Währungen EUR und CHF, wir planen, dass auch Verkaufspreise in USD gespeichert werden können

-- =============================================
-- Author: Alexander Ernst
-- Create date: 01.04.2022
-- Description:
-- Kreieren einer Datenbank, Eines Schemas und einer Tabelle mit FK/PK Constraints und Check/UNIQUE Constraints.
-- =============================================

/* 2. TSQL */
-- Implementieren Sie das physische Datenmodell in 	
-- Die PK’s von Währung, Lagerort, Lieferant und Artikel sind künstliche PK’s (IDENTITY (1,1))
-- Stellen Sie sicher dass die Währung, der Artikelname, Lagerort und der Lieferanten Name eindeutig 
-- Alle Tabellen sollen im Schema «lager» 
-- Erstellen Sie für das Schema «lager» eine eigene Datenbank mit dem Namen «efzLager
-- Stellen Sie sicher, dass für Mindestbestand und Lagermenge nur Werte eingetragen werden können die > 0 sind

-- Datenbank
-- Droppen der Datenbank falls Sie schon Existiert
USE master;
GO

if DB_ID('efzLager') is not null
alter database efzLager set single_user with rollback immediate;
go

DROP DATABASE IF EXISTS efzLager;
GO

-- Kreieren der Datenbank
CREATE DATABASE efzLager;
GO

-- Benutzen der Datenbank
USE efzLager;
GO

DROP SCHEMA IF EXISTS lager;
GO

-- Schema
CREATE SCHEMA lager;
GO

DROP TABLE IF EXISTS lager.Artikel;
GO
-- Tabelle: Artikel
CREATE TABLE lager.Artikel (
    Artikel_ID		int  NOT NULL IDENTITY(1, 1),
    Artikel			varchar(255)  NOT NULL,
    Mindestbestand	int CHECK (Mindestbestand>0) NOT NULL, --Check > 0
    CONSTRAINT Artikel_pk PRIMARY KEY  (Artikel_ID)
);
GO


DROP TABLE IF EXISTS lager.ArtikelLager;
GO
-- Tabelle: ArtikelLager
CREATE TABLE lager.ArtikelLager (
    Artikel_ID				int  NOT NULL,
    Lagerort_ID				int  NOT NULL,
    LagerMenge				int  CHECK (LagerMenge>0) NOT NULL, --Check > 0
    CONSTRAINT ArtikelLager_pk PRIMARY KEY  (Artikel_ID,Lagerort_ID)
);
GO


DROP TABLE IF EXISTS lager.Einkauf;
GO
-- Tabelle: Einkauf
CREATE TABLE lager.Einkauf (
    Artikel_ID			int  NOT NULL,
    Lieferant_ID		int  NOT NULL,
    Waehrungs_ID		int  NOT NULL,
    Einkaufspreis		decimal(10,5)  NOT NULL,
    CONSTRAINT Einkauf_pk PRIMARY KEY  (Artikel_ID,Lieferant_ID)
);
GO


DROP TABLE IF EXISTS lager.Lagerort;
GO
-- Tabelle: Lagerort
CREATE TABLE lager.Lagerort (
    Lagerort_ID		int  NOT NULL IDENTITY(1, 1),
    Lagerort		varchar(255)  NOT NULL,
    CONSTRAINT Lagerort_pk PRIMARY KEY  (Lagerort_ID)
);
GO


DROP TABLE IF EXISTS lager.Lieferant;
GO
-- Tabelle: Lieferant
CREATE TABLE lager.Lieferant (
    Lieferant_ID	int  NOT NULL IDENTITY(1, 1),
    Lieferant		varchar(255)  NOT NULL,
    CONSTRAINT Lieferant_pk PRIMARY KEY  (Lieferant_ID)
);
GO


DROP TABLE IF EXISTS lager.Verkaufspreis;
GO
-- Tabelle: Verkaufspreis
CREATE TABLE lager.Verkaufspreis (
    Artikel_ID			int  NOT NULL,
    Waehrungs_ID		int  NOT NULL,
    Verkaufspreis		decimal(10,5)  NOT NULL,
    CONSTRAINT Verkaufspreis_pk PRIMARY KEY  (Waehrungs_ID,Artikel_ID)
);
GO


DROP TABLE IF EXISTS lager.Waehrung;
GO
-- Tabelle: Waehrung
CREATE TABLE lager.Waehrung (
    Waehrungs_ID	int  NOT NULL IDENTITY(1, 1),
    Waehrung		varchar(255)  NOT NULL,
    CONSTRAINT Waehrung_pk PRIMARY KEY  (Waehrungs_ID)
);
GO

-- Erweitern der Tabelle Artikel
ALTER TABLE lager.Artikel
ADD Unterkategorie_ID INT NOT NULL,
Farbe varchar(255) NOT NULL;	--FK1																				n
GO

DROP TABLE IF EXISTS lager.Unterkategorie;
GO
-- Tabelle Unterkategorie (Prüfung Teil 2)
CREATE TABLE lager.Unterkategorie
(
	Unterkategorie_ID	INT IDENTITY(1,1) NOT NULL PRIMARY KEY --PK1
	, Unterkategorie	varchar(255) NOT NULL
	, Kategorie_ID		int NOT NULL --FK2
);
GO

DROP TABLE IF EXISTS lager.Kategorie;
GO
-- Tabelle Kategorie (Prüfung Teil 2)
CREATE TABLE lager.Kategorie
(
	Kategorie		varchar(255) NOT NULL
	, Kategorie_ID	int IDENTITY(1,1) NOT NULL PRIMARY KEY --PK2
);
GO

-- foreign keys
-- Reference: ArtikelLager_Artikel (Tabelle: ArtikelLager)
ALTER TABLE lager.ArtikelLager ADD CONSTRAINT ArtikelLager_Artikel
    FOREIGN KEY (Artikel_ID)
    REFERENCES lager.Artikel (Artikel_ID);
GO

-- Reference: ArtikelLager_Lagerort (Tabelle: ArtikelLager)
ALTER TABLE lager.ArtikelLager ADD CONSTRAINT ArtikelLager_Lagerort
    FOREIGN KEY (Lagerort_ID)
    REFERENCES lager.Lagerort (Lagerort_ID);
GO

-- Reference: Einkauf_Artikel (Tabelle: Einkauf)
ALTER TABLE lager.Einkauf ADD CONSTRAINT Einkauf_Artikel
    FOREIGN KEY (Artikel_ID)
    REFERENCES lager.Artikel (Artikel_ID);
GO

-- Reference: Einkauf_Lieferant (Tabelle: Einkauf)
ALTER TABLE lager.Einkauf ADD CONSTRAINT Einkauf_Lieferant
    FOREIGN KEY (Lieferant_ID)
    REFERENCES lager.Lieferant (Lieferant_ID);
GO

-- Reference: Einkauf_Waehrung (Tabelle: Einkauf)
ALTER TABLE lager.Einkauf ADD CONSTRAINT Einkauf_Waehrung
    FOREIGN KEY (Waehrungs_ID)
    REFERENCES lager.Waehrung (Waehrungs_ID);
GO

-- Reference: Verkaufspreis_Artikel (Tabelle: Verkaufspreis)
ALTER TABLE lager.Verkaufspreis ADD CONSTRAINT Verkaufspreis_Artikel
    FOREIGN KEY (Artikel_ID)
    REFERENCES lager.Artikel (Artikel_ID);
GO

-- Reference: Verkaufspreis_Waehrung (Tabelle: Verkaufspreis)
ALTER TABLE lager.Verkaufspreis ADD CONSTRAINT Verkaufspreis_Waehrung
    FOREIGN KEY (Waehrungs_ID)
    REFERENCES lager.Waehrung (Waehrungs_ID);
GO

-- Reference: Artikel_Unterkategorie (Tabelle: Unterkategorie) Prüfung Teil 2
ALTER TABLE lager.Artikel ADD CONSTRAINT Artikel_Unterkategorie --Hier Referenzieren wir die Tabelle mit dem FK
    FOREIGN KEY (Unterkategorie_ID) -- und wählen den FK aus
    REFERENCES lager.Unterkategorie (Unterkategorie_ID); -- Hier fügen wir den PK von der anderen Tabelle hinzu
GO

-- Reference: Unterkategorie_Kategorie (Tabelle: Kategorie) Prüfung Teil 2
ALTER TABLE lager.Unterkategorie ADD CONSTRAINT Unterkategorie_Kategorie
    FOREIGN KEY (Kategorie_ID)
    REFERENCES lager.Kategorie (Kategorie_ID);
GO

-- Unique Constraints
ALTER TABLE lager.Waehrung
ADD CONSTRAINT UNQ_Waehrung UNIQUE (Waehrung);
GO

ALTER TABLE lager.Artikel
ADD CONSTRAINT UNQ_Artikel UNIQUE (Artikel);
GO

ALTER TABLE lager.Lagerort
ADD CONSTRAINT UNQ_Lagerort UNIQUE (Lagerort);
GO

ALTER TABLE lager.Lieferant
ADD CONSTRAINT UNQ_Lieferant UNIQUE (Lieferant);
GO

-- Unique Constraints für Kategorie // Auf Namen

ALTER TABLE lager.Kategorie
ADD CONSTRAINT UNQ_Kategorie UNIQUE (Kategorie);
GO

ALTER TABLE lager.Unterkategorie
ADD CONSTRAINT UNQ_Unterkategorie UNIQUE (Unterkategorie);
GO
