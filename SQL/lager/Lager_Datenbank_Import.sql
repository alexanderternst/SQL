USE efzLager;
GO

CREATE OR ALTER PROCEDURE lager.usp_UpsertArtikel
AS
-- 1. Daten in Kategorie Importieren
MERGE lager.kategorie AS tgt -- Hier geben wir das Ziel von unserem Merge an
using (SELECT DISTINCT COALESCE(englishproductcategoryname, 'Kategorie Fehlt')
       FROM   dbo.artikelimport) AS src (kategorie) -- Hier geben wir die Quelle der Daten des Merges an, und definieren welche Variablen wir nachher übergeben wollen
ON ( tgt.kategorie = src.kategorie ) -- Dieses ON überprüft ob die Quelldaten gleich der Existierenden Daten sind. Das ON ist wie eine IF
WHEN NOT matched THEN -- Hier wird entschieden was wir machen wenn die Quelldaten in der Zieltabelle noch nicht existieren, hier wird meistens ein Insert gemacht
  INSERT(kategorie)
  VALUES(src.kategorie);
-- Meistens hätten wir hier auch noch ein WHEN MATCHED THEN welches dann alle Werte die wir NICHT für den vergleich verwenden aktualisiert
-- Hier brauchen wir aber kein WHEN MATCHED THEN da wir nur einen Wert haben und wenn dieser schon existiert müssen wir ihn logischerweise nicht Inserten.

-- 2. Daten in Unterkategorie Importieren
MERGE lager.unterkategorie AS tgt
using (SELECT DISTINCT COALESCE(englishproductsubcategoryname, 'Unterkategorie Fehlt') AS Unterkategorie,
                       -- COALESCE(englishproductcategoryname, 'Kategorie Fehlt') AS Kategorie,
                       kategorie.kategorie_id
       FROM dbo.artikelimport
              INNER JOIN lager.kategorie -- Hier sehen Sie auch noch ein INNER JOIN zu dem komme ich nachher noch
                      ON kategorie.kategorie = COALESCE(englishproductcategoryname, 'Kategorie Fehlt')) AS src
					  (unterkategorie, kategorie_id)
ON ( tgt.unterkategorie = src.unterkategorie )
WHEN NOT matched THEN
  INSERT(unterkategorie, kategorie_id)
  VALUES(src.unterkategorie, src.kategorie_id);

-- 3. Daten in Artikel Importieren
MERGE lager.Artikel AS tgt
using (SELECT DISTINCT EnglishProductName, SafetyStockLevel, Color,
			Unterkategorie.Unterkategorie_ID
		FROM dbo.ArtikelImport
	INNER JOIN lager.Unterkategorie
		ON Unterkategorie.Unterkategorie = COALESCE(EnglishProductSubcategoryName, 'Unterkategorie Fehlt')) AS src
	(Artikel, Mindestbestand, Farbe, Unterkategorie_ID)
ON (tgt.Artikel = src.Artikel)
WHEN MATCHED THEN -- Hier sehen Sie eines dieser WHEN MATCHED Statements welches nur Updated was eventuell nicht gleich ist.
	UPDATE SET tgt.Mindestbestand = src.Mindestbestand, tgt.Farbe = src.Farbe, tgt.Unterkategorie_ID = src.Unterkategorie_ID
WHEN NOT MATCHED THEN
	INSERT(Artikel, Mindestbestand, Farbe, Unterkategorie_ID)
	VALUES(src.Artikel, src.Mindestbestand, src.Farbe, src.Unterkategorie_ID);
GO
-- Aufruf Start Procedure
EXEC lager.usp_UpsertArtikel;
GO


CREATE OR ALTER PROCEDURE lager.usp_UpsertPreis
AS
-- 1. Währungen importieren
MERGE INTO lager.Waehrung AS tgt
using(
SELECT 'USD' AS Waehrung
UNION ALL -- Neue Zeile
SELECT 'EUR' AS Waehrung
) AS SRC (Waehrung)
ON (src.Waehrung = tgt.Waehrung)
WHEN NOT MATCHED THEN
	INSERT (Waehrung)
	VALUES (src.Waehrung);
-- 2. Verkaufspreis importieren
MERGE INTO lager.Verkaufspreis AS tgt
USING (SELECT DISTINCT Artikel.Artikel_ID, Waehrung.Waehrungs_ID, COALESCE(PriceUSD, 0) AS PriceUSD, COALESCE(PriceEUR, 0) AS PriceEUR
		FROM dbo.ArtikelImport
		INNER JOIN lager.Waehrung
		ON Waehrung.Waehrungs_ID = Waehrung.Waehrungs_ID
		INNER JOIN lager.Artikel
		ON Artikel.Artikel = EnglishProductName) AS src
	(Artikel_ID, Waehrungs_ID, PriceUSD, PriceEUR)
ON (tgt.Artikel_ID = src.Artikel_ID AND tgt.Waehrungs_ID = src.Waehrungs_ID)
	WHEN MATCHED THEN
UPDATE SET tgt.Verkaufspreis = CASE WHEN src.Waehrungs_ID = 1 THEN src.PriceUSD ELSE src.PriceEUR END
	WHEN NOT MATCHED THEN
INSERT (Artikel_ID, Waehrungs_ID, Verkaufspreis)
VALUES (src.Artikel_ID, src.Waehrungs_ID, CASE WHEN src.Waehrungs_ID = 1 THEN src.PriceUSD ELSE src.PriceEUR END);
GO

EXEC lager.usp_UpsertPreis;
GO

-- Start Procedure für Preis 2
CREATE OR ALTER PROCEDURE lager.usp_UpsertPreis2
AS
-- 1. Währungen importieren
MERGE INTO lager.Waehrung AS tgt
using(
SELECT 'USD' AS Waehrung
UNION ALL -- Neue Zeile
SELECT 'EUR' AS Waehrung
) AS SRC (Waehrung)
ON (src.Waehrung = tgt.Waehrung)
WHEN NOT MATCHED THEN
	INSERT (Waehrung)
	VALUES (src.Waehrung);

-- 2. Verkaufspreis importieren
WITH ctePreise
AS (
SELECT DISTINCT Artikel.Artikel_ID, Waehrung.Waehrungs_ID, COALESCE(PriceUSD, 0) AS PriceUSD, COALESCE(PriceEUR, 0) AS PriceEUR
		FROM dbo.ArtikelImport
		CROSS JOIN lager.Waehrung
		-- ON Waehrung.Waehrungs_ID = Waehrung.Waehrungs_ID, Braucht es nur bei Inner Join
		INNER JOIN lager.Artikel
		ON Artikel.Artikel = EnglishProductName
		WHERE PriceUSD > 0 AND PriceEUR > 0 -- Dies kann man auch beim USING machen (nach dem Select)
)
MERGE INTO lager.Verkaufspreis AS tgt
USING (SELECT * FROM ctePreise) AS src
	(Artikel_ID, Waehrungs_ID, PriceUSD, PriceEUR)
ON (tgt.Artikel_ID = src.Artikel_ID AND tgt.Waehrungs_ID = src.Waehrungs_ID)
	WHEN MATCHED THEN
UPDATE SET tgt.Verkaufspreis = CASE WHEN src.Waehrungs_ID = 1 THEN src.PriceUSD ELSE src.PriceEUR END
	WHEN NOT MATCHED THEN
INSERT (Artikel_ID, Waehrungs_ID, Verkaufspreis)
VALUES (src.Artikel_ID, src.Waehrungs_ID, CASE WHEN src.Waehrungs_ID = 1 THEN src.PriceUSD ELSE src.PriceEUR END);
GO

EXEC lager.usp_UpsertPreis2;
GO