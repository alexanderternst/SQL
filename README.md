- [SQL Projekte](#sql-projekte)
  - [ERM (Entity Relationship Model)](#erm-entity-relationship-model)
  - [T-SQL (Transact-SQL)](#t-sql-transact-sql)
    - [Import von Daten aus Tabelle](#import-von-daten-aus-tabelle)
    - [Select Statements](#select-statements)
    - [Indexierung/Transaktionen](#indexierungtransaktionen)
  - [Zugriff auf SQL über C#](#zugriff-auf-sql-über-c)
    - [ADO.NET](#adonet)
    - [OR-Mapper](#or-mapper)

# SQL Projekte
In SQL habe ich schon T-SQL Befehle, für das Kreieren, modifizieren, und lesen von Datenbanken/Tabellen gelernt und SSIS durch C# und T-SQL mit Procedures und Merge Statements gelernt. In C# habe ich die Frameworks ADO.NET und Entity Framework (OR-Mapper) kennengelernt.

---

## ERM (Entity Relationship Model)

Ein ERM (Entity Relationship Model) beschreibt Tabellen, Schemas und Beziehungen einer Datenbank.  
Bevor man anfängt die Datenbank zu erstellen und mit Daten zu befüllen sollte man immer ein ERM zuerst erstellen.  
Hier ist ein Beispiel von einem ERM Diagramm:  
![ERM](https://github.com/alexanderternst/SQL/blob/main/SQL/lager/Lager_Datenbank_ERM.png?raw=true)

[PNG herunterladen](https://github.com/alexanderternst/SQL/blob/main/SQL/lager/Lager_Datenbank_ERM.png?raw=true)  
[XML herunterladen](https://raw.githubusercontent.com/alexanderternst/SQL/main/SQL/lager/Lager_ERM.xml)

---

## T-SQL (Transact-SQL)

Transact-SQL ist die Sprache, die wir benutzen, um Datenbanken, Tabellen und Beziehungen/Verbindungen zwischen Tabellen zu erstellen.  
Hier sind zwei völlig funktionierende Beispiele, von T-SQL Befehlen (z.B. Datenbank, Stored Procedures, Merge Statements, Select Statements erstellen).  
Ich habe auch ein drittes Beispiel, was auf das erste aufbaut, aber nicht völlig funktioniert, da eine Tabelle fehlt.  

Umsetzung von obigem ERM (Lagersystem) in T-SQL mit allen Verbindungen und Beziehungen (funktionierend):  
[1. Datenbank und Tabellen erstellen (T-SQL)](https://raw.githubusercontent.com/alexanderternst/SQL/main/SQL/lager/Lager_Datenbank.sql)  
[2. Erstellen von Tabelle für Import von Daten (T-SQL)](https://raw.githubusercontent.com/alexanderternst/SQL/main/SQL/lager/Lager_Datenbank_ArtikelImport.sql)

### Import von Daten aus Tabelle

Mit Merge Statements und Stored Procedures können wir Tabellen befüllen und Daten modifizieren. In diesem Beispiel befüllen wir unsere Tabellen in unserem Lagersystem mit Daten aus einer anderen Tabelle.  

Umsetzung von Stored Procedures und Merge Statements (funktionierend):  
[1. Import von Daten (T-SQL)](https://raw.githubusercontent.com/alexanderternst/SQL/main/SQL/lager/Lager_Datenbank_Import.sql)  
[2. Import von Daten (T-SQL)](https://raw.githubusercontent.com/alexanderternst/SQL/main/SQL/lager/Lager_Datenbank_Import_2.sql)  

### Select Statements

Select Statements können wir benutzen, um Datenbanken und Tabellen abzufragen. In diesem Beispiel gibt es mehrere Select Statements, Inner und Cross Joins und die Modifizierung/Abfrage von Datensätzen.

Umsetzung von Select Statements:  
[Select Statements (T-SQL)](https://raw.githubusercontent.com/alexanderternst/SQL/main/SQL/lager/Lager_Datenbank_Select.sql)  

### Indexierung/Transaktionen

Hier habe ich noch ein Beispiel eines SQL-Skriptes, indem ich die Indexierung kennengelernt habe. Zusätzlich habe ich auch noch Transaktionen kennengelernt, welche ich in diesem Skript auch mit verschiedenen Isolationsstufen verwendet habe.  
Transaktionen sind mehrere unteilbare (atomare) Operationen, welche in einer Datenbank ausgeführt werden. Diese werden entweder alle ausgeführt (Commit) oder alle nicht ausgeführt (Rollback), dies heisst auch alles oder nichts Prinzip.

[Transaktionen und Indexierung (T-SQL)](https://raw.githubusercontent.com/alexanderternst/SQL/main/SQL/transaktion-index/Banken.sql) 

---

## Zugriff auf SQL über C#

Mit C# können wir auch auf SQL Datenbanken zugreifen und diese bearbeiten.  
Hier habe ich zwei Beispiele, eines, welches mit ADO.NET erstellt wurde und eines, das durch OR-Mapper mit einem Db-First Ansatz erstellt wurde.

### ADO.NET

Hier habe ich ein Beispiel von mehreren Abfragen unseres Lagersystems, welche durch ADO.NET in einem C# Konsolen-Projekt umgesetzt wurden.  
Natürlich müssen Sie in dem appsettings.json File ihren Connection String (Server, Datenbank, Authentifizierung) angeben, damit das Programm richtig läuft.

[Projekt finden Sie im Ordner SQL/ADONET](https://github.com/alexanderternst/SQL/tree/main/SQL/ADONET)  

### OR-Mapper

Der Nachteil, wenn wir ADO.NET verwenden ist, dass wir immer noch T-SQL Statements schreiben müssen.  
Mit einem OR-Mapper System können wir dies, eliminieren, da wir hier keine SQL Befehle mehr schreiben, sondern Datenbanken mit Klassen nach OOP erstellen.  
Bei OR-Mapper systemen gibt es zwei Ansätze, Database-First (Db-First) und Code-First.  
Bei Db-First erstellen wir erst die Datenbanken mit T-SQL und importieren diese dann in einem OR-Mapper System, und bei Code-First erstellen wir die Datenbank auch mit einem OR-Mapper System.  
In C# (die Programmiersprache, die wir hier verwenden), wird ein OR-Mapper System mit dem Entity Framework durhcgeführt.  
Ein Beispiel eines Code-First Ansatzes finden Sie in meinem [Web API](https://github.com/alexanderternst/JetstreamSkiserviceAPI) welches mit einem Code-First Datenbank System durchgeführt wurde.  
Hier habe ich jetzt noch ein Beispiel eines Entity Framework (Db-First) Projektes von unserem Lagersystem: