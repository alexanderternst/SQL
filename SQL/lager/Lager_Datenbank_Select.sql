USE efzLager;
GO

SELECT * FROM lager.Waehrung ORDER BY Waehrungs_ID;
GO
SELECT * FROM lager.Lieferant;
GO
SELECT * FROM lager.Artikel WHERE Artikel_ID = 225;
GO
SELECT * FROM dbo.ArtikelImport WHERE EnglishProductName = 'Long-Sleeve Logo Jersey, L';
GO

-- Cross Join: Wenn man nichts zum verbinden hatt
-- Inner Join Wenn es etwas zum verbinden gibt, deshalb braucht ein Inner Join auch ein ON
-- Beispiel Cross Join
SELECT DISTINCT Artikel.Artikel_ID, Waehrung.Waehrungs_ID, COALESCE(PriceUSD, 0) AS PriceUSD, COALESCE(PriceEUR, 0) AS PriceEUR
FROM dbo.ArtikelImport
CROSS JOIN lager.Waehrung -- Hier benutzen wir einen Cross Join da wir in der Tabelle Währung mit nichts vergleichen können
INNER JOIN lager.Artikel -- Hier verwenden wir einen Inner Join da wir uns hier mit der Quelltabelle verbinden wollen
ON Artikel.Artikel = EnglishProductName
		WHERE PriceUSD > 0 AND PriceEUR > 0 -- Dies ist noch ein zusatz das keine Preise mit NULL resprektive 0 angezeigt werden

-- Artikel Mountain Tire Tube in lager.Artikel und dbo.ArtikelImport anzeigen
SELECT * FROM lager.Artikel WHERE Artikel = 'Mountain Tire Tube'
SELECT * FROM dbo.ArtikelImport WHERE EnglishProductName = 'Mountain Tire Tube'

-- Aktualisieren der Farbe = Red und des Mindestbestands = 1000 für Artikel Mountain Tire Tube in Tabelle dbo.ArtikelImport
UPDATE dbo.ArtikelImport
SET Color = 'Red', SafetyStockLevel = 1000
WHERE EnglishProductName = 'Mountain Tire Tube'

-- Aufruf Start Procedure
EXEC lager.usp_UpsertArtikel;
GO

-- Anzeige von aller Merkmale von Artikel MountainTireTube mit der Unterkategorie und der Kategorie
SELECT Artikel.*, Unterkategorie.Unterkategorie, Kategorie.Kategorie
FROM lager.Artikel
INNER JOIN lager.Unterkategorie
ON Artikel.Unterkategorie_ID = Unterkategorie.Unterkategorie_ID
INNER JOIN lager.Kategorie
ON Unterkategorie.Kategorie_ID = Kategorie.Kategorie_ID
WHERE Artikel = 'Mountain Tire Tube';
GO

-- Artikel Mountain Tire Tube von Unterkategorie Tires and Tubes in Unterkategorie Brakes verschieben
UPDATE dbo.ArtikelImport
SET EnglishProductSubcategoryName = 'Brakes'
WHERE EnglishProductName = 'Mountain Tire Tube';
GO

-- Artikel Mountain Tire Tube von Unterkategorie Brakes in Unterkategorie Tires and Tubes verschieben
UPDATE dbo.ArtikelImport
SET EnglishProductSubcategoryName = 'Tires and Tubes'
WHERE EnglishProductName = 'Mountain Tire Tube';
GO

-- Alle Artikel wo Kategorie Fehlt
SELECT Artikel.*, Unterkategorie.Unterkategorie, Kategorie.Kategorie
FROM lager.Artikel
INNER JOIN lager.Unterkategorie
ON Artikel.Unterkategorie_ID = Unterkategorie.Unterkategorie_ID
INNER JOIN lager.Kategorie
ON Unterkategorie.Kategorie_ID = Kategorie.Kategorie_ID
WHERE Kategorie = 'Kategorie Fehlt';
GO

-- Alle Artikel (nur ArtikelName) wo Kategorie fehlt
-- Sortiert nach Artikel aufsteigend
SELECT Artikel.Artikel
FROM lager.Artikel
INNER JOIN lager.Unterkategorie
ON Artikel.Unterkategorie_ID = Unterkategorie.Unterkategorie_ID
INNER JOIN lager.Kategorie
ON Unterkategorie.Kategorie_ID = Kategorie.Kategorie_ID
WHERE Kategorie = 'Kategorie Fehlt'
ORDER BY Artikel.Artikel ASC;
GO

-- Alle Artikel die mit Lock Nut beginnen werden einer Unterkategorie der Kategorie Accessories zugeteilt
SELECT * FROM lager.Unterkategorie
INNER JOIN lager.Kategorie
ON Unterkategorie.Kategorie_ID = Kategorie.Kategorie_ID
WHERE Kategorie.Kategorie = 'Accessories';
GO

-- Neue Unterkategorie Kleinmaterial in Kategorie Accessories zufügen
SELECT * FROM dbo.ArtikelImport
WHERE EnglishProductName like 'Lock Nut%' OR EnglishProductCategoryName = 'Accessories'

UPDATE dbo.ArtikelImport
SET EnglishProductCategoryName = 'Accessories', EnglishProductSubcategoryName = 'Kleinmaterial'
WHERE EnglishProductName like 'Lock Nut%';
GO

-- Überprüfen ob alle Artikel welche im Namen Lock Nut beginnen der Unterkategorie Kleinmaterial, Kategorie Zubehör zugeteilt sind
SELECT Artikel.Artikel, Unterkategorie.Unterkategorie, Kategorie.Kategorie
FROM lager.Artikel
INNER JOIN lager.Unterkategorie
ON Artikel.Unterkategorie_ID = Unterkategorie.Unterkategorie_ID
INNER JOIN lager.Kategorie
ON Unterkategorie.Kategorie_ID = Kategorie.Kategorie_ID
WHERE Artikel.Artikel like 'Lock Nut%';
GO


