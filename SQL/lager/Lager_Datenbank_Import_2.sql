USE efzLager;
GO
-- Preise mit Merge und schlussendlich mit Procedure importieren
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

-- Start Procedure für Import von Lieferant und Einkaufspreis
CREATE OR ALTER PROCEDURE lager.usp_UpsertEinkaufLieferant
AS
MERGE lager.Lieferant AS tgt
USING (SELECT 'LieferantEUR' AS Lieferant
		UNION ALL
		SELECT 'LieferantUSD' AS Lieferant) AS src
	(Lieferant)
ON (tgt.Lieferant = src.Lieferant)
WHEN NOT MATCHED THEN
	INSERT(Lieferant)
	VALUES(src.Lieferant);

-- Merge und Common Table Expressions
-- Vorbereitung von Waehrung und Lieferamnt
WITH 
cteWaehrungLieferant -- Common Table Expression
AS( 
	SELECT * FROM lager.Waehrung
	CROSS JOIN lager.Lieferant
	WHERE CHARINDEX(Waehrung.Waehrung, Lieferant.Lieferant) > 0 -- Was wir suchen, Wo wir suchen
	-- Zahl steht für Stelle der Start Position
	-- USD als Suche, LieferantEUR als Suche = Wert gleich 0 da es nicht vorkommt
	-- USD als Suche, LieferantUSD als Suche = Wert gleich 10 da es an zehnter Stelle vorkommt
),
cteEinkaufspreise
AS 
(
-- Dataset mit Euro vorbereiten
SELECT DISTINCT Artikel.Artikel_ID, 
				cteWaehrungLieferant.Lieferant_ID, 
				cteWaehrungLieferant.Waehrungs_ID, 
				COALESCE(PriceEUR, 0) AS Preis
		FROM dbo.ArtikelImport
		INNER JOIN lager.Artikel
		ON Artikel.Artikel = EnglishProductName
		INNER JOIN cteWaehrungLieferant
		ON cteWaehrungLieferant.Waehrung = 'EUR'
		WHERE COALESCE(PriceEUR, 0) > 0
UNION ALL
-- Dataset für USD vorbereiten	
SELECT DISTINCT Artikel.Artikel_ID, 
				cteWaehrungLieferant.Lieferant_ID, 
				cteWaehrungLieferant.Waehrungs_ID, 
				COALESCE(PriceUSD, 0) AS Preis
		FROM dbo.ArtikelImport
		INNER JOIN lager.Artikel
		ON Artikel.Artikel = EnglishProductName
		INNER JOIN cteWaehrungLieferant
		ON cteWaehrungLieferant.Waehrung = 'USD'
		WHERE COALESCE(PriceUSD, 0) > 0 
)
-- SELECT * FROM cteEinkaufspreise
MERGE INTO lager.Einkauf AS tgt
using (SELECT * FROM cteEinkaufspreise) AS src
	(Artikel_ID, Lieferant_ID, Waehrungs_ID, Preis)
ON (tgt.Artikel_ID = src.Artikel_ID AND tgt.Waehrungs_ID = src.Waehrungs_ID AND tgt.Lieferant_ID = src.Lieferant_ID) -- Es könnte Theoretisch zwei Artikel mit gleicher Waehrung und Artikel ID geben aber mit anderen Lieferant_ID
	WHEN MATCHED THEN
UPDATE SET tgt.Einkaufspreis = src.Preis
	WHEN NOT MATCHED THEN
INSERT (Artikel_ID, Lieferant_ID, Waehrungs_ID, Einkaufspreis)
VALUES (src.Artikel_ID, src.Lieferant_ID, src.Waehrungs_ID, src.Preis);
GO

EXEC lager.usp_UpsertEinkaufLieferant;
GO