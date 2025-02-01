Create Database Autovermietung_Harald;

USE Autovermietung_Harald;

/* Nach der Erstellung der Datenbank können wir mit den einzelnen Tabellen beginnen
*/

CREATE TABLE Kunde
(
  Kunden_ID INT NOT NULL,
  Vorname VARCHAR(255) NOT NULL,
  Nachname VARCHAR(255) NOT NULL,
  Adresse VARCHAR(255) NOT NULL,
  Ort VARCHAR(255) NOT NULL,
  Postleitzahl INT NOT NULL,
  Telefon_Nr INT NOT NULL,
  Geschlecht ENUM ('m', 'w'),
  PRIMARY KEY (Kunden_ID)
);

CREATE TABLE Versicherung
(
  Police_Nr INT NOT NULL,
  Versicherungsname VARCHAR (255) NOT NULL,
  Versicherungsart ENUM ('Vollkasko', 'Teilkasko') NOT NULL,
  PRIMARY KEY (Police_Nr)
);

CREATE TABLE Reservation
(
  Reservations_Nr INT,
  Abholdatum DATE,
  Rückgabedatum DATE,
  FK_Kunden_ID INT,
  PRIMARY KEY (Reservations_Nr),
  FOREIGN KEY (FK_Kunden_ID) REFERENCES Kunde(Kunden_ID)
);

CREATE TABLE Abholstation
(
  Abholstations_Nr INT,
  Adresse VARCHAR (255),
  Postleitzahl INT,
  Ort VARCHAR (255),
  PRIMARY KEY (Abholstations_Nr)
);

CREATE TABLE Tarifklassen
(
  Grundgebühr INT NOT NULL,
  Preis_pro_Km INT NOT NULL,
  Tarifklassen_ID INT NOT NULL,
  PRIMARY KEY (Tarifklassen_ID)
);


CREATE TABLE Zahlung
(
  Zahlbetrag INT,
  Zahldatum DATE,
  Zahlungsmethode ENUM ('Rechnung','Karte','Twint'),
  Buchungs_Nr INT,
  FK_Kunden_ID INT,
  FK_Reservations_Nr INT,
  PRIMARY KEY (Buchungs_Nr),
  FOREIGN KEY (FK_Kunden_ID) REFERENCES Kunde(Kunden_ID),
  FOREIGN KEY (FK_Reservations_Nr) REFERENCES Reservation(Reservations_Nr)
);



ALTER TABLE Zahlung MODIFY Buchungs_Nr int NOT NULL AUTO_INCREMENT;

CREATE TABLE Filiale
(
  Filial_Nr INT NOT NULL,
  Adresse VARCHAR (255) NOT NULL,
  Postleitzahl INT NOT NULL,
  Ort VARCHAR (255) NOT NULL,
  PRIMARY KEY (Filial_Nr)
);

CREATE TABLE Angestellter
(
  Angestellter_ID INT NOT NULL,
  Vorname VARCHAR (255) NOT NULL,
  Nachname VARCHAR (255) NOT NULL,
  Adresse VARCHAR (255) NOT NULL,
  Ort VARCHAR (255) NOT NULL,
  Postleitzahl INT NOT NULL,
  Telefon_Nr INT,
  Geburtsdatum DATE NOT NULL,
  Geschlecht ENUM ('m', 'w') NOT NULL,
  Lohn INT NOT NULL,
  FK_Filial_Nr INT,
  FK_Abteilungs_Nr INT,
  FK_leitetAbteilungs_Nr INT,
  PRIMARY KEY (Angestellter_ID)
);

CREATE TABLE Fahrzeug
(
  Fahrzeug_ID INT NOT NULL,
  Baujahr INT NOT NULL,
  Kennzeichen VARCHAR (255) NOT NULL,
  Fahrzeugart ENUM ('Coupe', 'Limousine', 'Cabriolet') NOT NULL,
  Marke ENUM ('BMW', 'Audi', 'Mercedes', 'Rolls Royce', 'Lamborghini', 'Ferrari', 'Bentley') NOT NULL,
  Modell VARCHAR (255) NOT NULL,
  Kilometerstand INT NOT NULL,
  FK_Filial_Nr INT,
  FK_Police_Nr INT,
  FK_Abholstations_Nr INT,
  FK_Tarifklassen_ID INT,
  PRIMARY KEY (Fahrzeug_ID),
  FOREIGN KEY (FK_Filial_Nr) REFERENCES Filiale(Filial_Nr),
  FOREIGN KEY (FK_Police_Nr) REFERENCES Versicherung(Police_Nr),
  FOREIGN KEY (FK_Abholstations_Nr) REFERENCES Abholstation(Abholstations_Nr),
  FOREIGN KEY (FK_Tarifklassen_ID) REFERENCES Tarifklassen(Tarifklassen_ID)
);

CREATE TABLE Abteilung
(
  Abteilungs_Nr INT NOT NULL,
  Abteilungsname ENUM ('Management','Finanzen','Werkstatt') NOT NULL,
  FK_Filial_Nr INT,
  PRIMARY KEY (Abteilungs_Nr),
  FOREIGN KEY (FK_Filial_Nr) REFERENCES Filiale(Filial_Nr)
);

CREATE TABLE mietet
(
  Datum DATE,
  FK_Fahrzeug_ID INT,
  FK_Kunden_ID INT NOT NULL,
  PRIMARY KEY (FK_Fahrzeug_ID, FK_Kunden_ID),
  FOREIGN KEY (FK_Fahrzeug_ID) REFERENCES Fahrzeug(Fahrzeug_ID),
  FOREIGN KEY (FK_Kunden_ID) REFERENCES Kunde(Kunden_ID)
);

CREATE TABLE wählt
(
  FK_Reservations_Nr INT NOT NULL,
  FK_Fahrzeug_ID INT NOT NULL,
  PRIMARY KEY (FK_Reservations_Nr, FK_Fahrzeug_ID),
  FOREIGN KEY (FK_Reservations_Nr) REFERENCES Reservation(Reservations_Nr),
  FOREIGN KEY (FK_Fahrzeug_ID) REFERENCES Fahrzeug(Fahrzeug_ID)
);

/* Bei folgenden Zeilen werden die Fremdschlüssel im Nachhinein hinzugefügt, 
da diese ansonsten bei der initialen Erstellung eine Fehlermeldung ausgelöst haben.
*/

ALTER TABLE Angestellter ADD FOREIGN KEY (FK_Filial_Nr) REFERENCES Filiale(Filial_Nr);
ALTER TABLE Angestellter ADD FOREIGN KEY (FK_Abteilungs_Nr) REFERENCES Abteilung(Abteilungs_Nr);
ALTER TABLE Angestellter ADD FOREIGN KEY (FK_leitetAbteilungs_Nr) REFERENCES Abteilung(Abteilungs_Nr);


/*
 Jetzt können wir mit dem Einfügen von Testdaten beginnen. Wir fügen in jede Tabelle genügend Daten
 für unsere Queries und Trigger ein.
*/

INSERT INTO Fahrzeug (Fahrzeug_ID, Baujahr, Kennzeichen, Fahrzeugart, Marke, Modell, Kilometerstand)
Values(1200, 2016, 'AG 55', 'Coupe', 'Mercedes', 'C63 AMG S', 19700),
(1300, 2022, 'AG 423721', 'Cabriolet', 'BMW', 'M5 Competition', 500),
(1400, 1999, 'SO 123456', 'Limousine', 'Rolls Royce', 'Silver Seraph', 150000),
(1500, 2020, 'ZH 1', 'Limousine', 'Bentley', 'Continental GT', 3200),
(1600, 2015, 'SH 88', 'Cabriolet', 'Ferrari', '458 Pista', 7900),
(1700, 2019, 'GE 9', 'Coupe', 'Audi', 'RS7', 22000),
(1800, 1964, 'AI 5', 'Cabriolet', 'Mercedes', '300 SE', 355000),
(1900, 2021, 'SG 888', 'Limousine', 'Audi', 'R8 Spyder', 45670),
(2000, 2014, 'TI 45678', 'Coupe', 'BMW', 'X6 M', 245000),
(2100, 2022, 'BS 3', 'Limousine', 'Rolls Royce', 'Wraith', 100);

/*
 Bei den Tarifklassen gibt es 3 Klassen
 Tarifklasse 1 ist für die Limousinen, 
 2 für die Coupes 
 3 für Cabriolets.
*/

INSERT INTO Tarifklassen (Grundgebühr, Preis_pro_Km, Tarifklassen_ID)
Values(100, 5, 1),
(150, 7, 2),
(300, 15, 3);

INSERT INTO Versicherung (Police_Nr ,Versicherungsname ,Versicherungsart)
VALUES(100000, 'AXA', 'Vollkasko'),
(100001, 'Generali', 'Teilkasko'),
(100002, 'Basler', 'Teilkasko'),
(100003, 'Zürich Versicherungen', 'Teilkasko'),
(100004, 'AXA', 'Vollkasko'),
(100005, 'Basler', 'Vollkasko'),
(100006, 'Basler', 'Teilkasko'),
(100007, 'Generali', 'Teilkasko'),
(100008, 'AXA', 'Vollkasko'),
(100009, 'AXA', 'Teilkasko');

INSERT INTO Filiale (Filial_Nr, Adresse, Postleitzahl, Ort)
VALUES (1, 'Langstrasse 3', 8002, 'Zürich'),
(2, 'Hauptstrasse 12', 4000, 'Basel'),
(3, 'Bahnhofsplatz 44', 5013, 'Solothurn');

INSERT INTO Abteilung (Abteilungs_Nr, Abteilungsname)
VALUES (110, 'Management'),
(120, 'Finanzen'),
(130, 'Werkstatt');

INSERT INTO Kunde (Kunden_ID ,Vorname, Nachname, Adresse, Ort, Postleitzahl, Telefon_Nr, Geschlecht)
VALUES(1010, 'Max', 'Muster', 'Eiche 5','Zürich', 8000, 0780000001, 'm'),
(1020, 'Helene', 'Fischer','Bahnhofstrasse 12', 'Zürich', 8000, 0780000002, 'w'),
(1030,'Marco', 'White', 'Bielstarsse 6', 'Bern', 3000, 0780000004, 'm'),
(1040, 'Giuseppe', 'Bertone','Gerolzweg 44', 'Zürich', 8000, 0780000005, 'm'),
(1050, 'Eveline', 'Bauer', 'Bachweg 67', 'Solothurn', 4500, 0780000006, 'w'),
(1060,'Phillip', 'Rickenbacher', 'Sonnhalde 34', 'Basel', 4000, 078000007, 'm'),
(1070, 'Lisa', 'Gieger', 'Marktweg 69', 'Solothurn', 4500, 0780000008, 'w'),
(1080, 'Benni', 'Hägler', 'Bifang 7', 'Solothurn', 4500, 0780000009, 'm'),
(1090, 'Anna', 'Paulinski','Fichtenweg 77', 'Basel', 4000, 0780000010, 'w'),
(1100, 'Angelo', 'Baretta', 'Davinci Alle 4', 'Solothurn', 4500, 0780000011, 'm');

INSERT INTO Reservation (Reservations_Nr ,Abholdatum ,Rückgabedatum ,FK_Kunden_ID)
VALUES
(10000, '2021-07-15', '2021-07-22', 1010),
(10001, '2021-08-18', '2021-08-25', 1020),
(10002, '2021-09-10', '2021-09-17', 1030),
(10003, '2021-09-20', '2021-09-27', 1040),
(10004, '2021-10-10', '2021-10-17', 1040),
(10005, '2021-10-17', '2021-10-24', 1050),
(10006, '2021-10-18', '2021-10-25', 1060),
(10007, '2021-10-14', '2021-10-21', 1070),
(10008, '2021-11-17', '2021-11-24', 1080),
(10009, '2021-12-20', '2021-12-27', 1090);

INSERT INTO wählt (FK_Reservations_Nr, FK_Fahrzeug_ID) 
VALUES ('10000', '1200'),
('10001', '1300'),
('10002', '1400'),
('10003', '1500'),
('10004', '1600'),
('10005', '1700'),
('10006', '1800'),
('10007', '1900'),
('10008', '2000'),
('10009', '2100');

INSERT INTO Zahlung (Zahlbetrag, Zahldatum, Zahlungsmethode, FK_Kunden_ID, FK_Reservations_Nr)
Values(700, '2021-07-10', 'Rechnung', 1010, 10000),
(600, '2021-08-14', 'Karte', 1020, 10001),
(1000, '2021-09-04', 'Twint', 1030, 10002),
(850, '2021-09-05', 'Karte', 1040, 10003),
(1300, '2021-10-06', 'Rechnung', 1050, 10004),
(1500, '2021-10-07', 'Twint', 1050, 10005),
(900, '2021-10-08', 'Karte', 1060, 10006),
(750, '2021-10-09', 'Rechnung', 1070, 10007),
(500, '2021-11-10', 'Twint', 1080, 10008),
(850, '2021-12-12', 'Karte', 1090, 10009);

INSERT INTO Abholstation (Abholstations_Nr, Adresse, Postleitzahl, Ort)
VALUES( 10, 'Hauptstrasse 1', 4500, 'Solothurn'),
( 11, 'Von Rollstrasse 10', 4600 , 'Solothurn'),
( 12, 'Alte Gasse 32', 4500, 'Solothurn'),
( 20, 'Bahnhofweg 2', 8000, 'Zürich'),
( 21, 'Ruedigerstrasse 21', 8003, 'Zürich'),
( 22, 'Paradeplatz 8', 8001, 'Zürich'), 
( 23, 'Hardstrasse 201', 8005, 'Zürich'),
( 30, 'Schulweg 3', 4010, 'Basel'),
( 31, 'Grenzacherstrasse 183', 4058,'Basel'),
( 32, 'Bläsiring 12', 4057,'Basel');


INSERT INTO Angestellter (Angestellter_ID ,Vorname, Nachname,Adresse ,Ort, Postleitzahl, Telefon_Nr,Geburtsdatum, Geschlecht, Lohn)
VALUES
(100, 'Max', 'Muster','Lindenweg 55','Zürich', 8100, 0764325426,'1997-11-10', 'm',4000),
(101, 'Linda', 'Helene', 'Goldbergstrasse 33','Zürich', 8100, 0764367891,'1997-05-11', 'w',4000),
(102,'Mohamed', 'Maxamed', 'Postplatz 65', 'Basel', 4000, 0764375426,'1998-04-23', 'm',4800),
(103,'Filio', 'White', 'Zugerweg 9', 'Solothurn', 4502, 0754325428,'1997-11-03', 'm',4200),
(104,'Ursula', 'Bauer', 'Zürichstrasse 14', 'Solothurn', 4501, 0764375428,'1997-11-15', 'm',4300),
(105,'Svenn', 'Rickenbacher', 'Hagenholzweg 87', 'Aargau', 5000, 0784325926, '1996-11-20','m',4500),
(106, 'Gina', 'Gieger', 'Müllerstrasse 33', 'Aargau', 5000, 0774925426, '1999-10-10','m',4200),
(107,'Dario', 'Harambasic', 'Parkgasse 11', 'Solothurn', 4500, 0774825426,'1930-11-10', 'm',6000),
(108,'Shallau', 'Muhamad', 'Baumstrasse 32', 'Basel',   4000, 0794425426,'1997-09-11', 'm',6000),
(109,'Julian', 'Schifferle', 'Bachweg 4', 'Solothurn',  4500, 0784325326,'1995-07-11', 'm',6000);

/*
Hier befüllen wir die Tabelle 'mietet' . Dies haben wir mit der automatischen Methode im MySQL gemacht
*/

INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('1200', '1010');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('1300', '1020');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('1400', '1030');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('1500', '1040');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('1600', '1050');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('1700', '1060');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('1800', '1070');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('1900', '1080');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('2000', '1090');
INSERT INTO `autovermietung_harald`.`mietet` (`FK_Fahrzeug_ID`, `FK_Kunden_ID`) VALUES ('2100', '1100');

/*
Hier ändern wir die Tabelle Angestellter und fügen neue Werte hinzu
Dies ist nötig damit die Trigger richtig funktionieren können
*/

UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Abteilungs_Nr` = '110' WHERE (`Angestellter_ID` = '100');

UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '2', `FK_Abteilungs_Nr` = '120' WHERE (`Angestellter_ID` = '101');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '3', `FK_Abteilungs_Nr` = '130' WHERE (`Angestellter_ID` = '102');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '1', `FK_Abteilungs_Nr` = '110' WHERE (`Angestellter_ID` = '103');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '2', `FK_Abteilungs_Nr` = '120' WHERE (`Angestellter_ID` = '104');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '3', `FK_Abteilungs_Nr` = '130' WHERE (`Angestellter_ID` = '105');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '1', `FK_Abteilungs_Nr` = '110' WHERE (`Angestellter_ID` = '106');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '2', `FK_Abteilungs_Nr` = '120', `FK_leitetAbteilungs_Nr` = '120' WHERE (`Angestellter_ID` = '107');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '3', `FK_Abteilungs_Nr` = '130', `FK_leitetAbteilungs_Nr` = '130' WHERE (`Angestellter_ID` = '108');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '1', `FK_Abteilungs_Nr` = '110', `FK_leitetAbteilungs_Nr` = '110' WHERE (`Angestellter_ID` = '109');
UPDATE `autovermietung_harald`.`Angestellter` SET `FK_Filial_Nr` = '1' WHERE (`Angestellter_ID` = '100');

UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '2' WHERE (`Fahrzeug_ID` = '1200');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '3' WHERE (`Fahrzeug_ID` = '1300');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '1' WHERE (`Fahrzeug_ID` = '1400');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '1' WHERE (`Fahrzeug_ID` = '1500');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '3' WHERE (`Fahrzeug_ID` = '1600');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '2' WHERE (`Fahrzeug_ID` = '1700');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '3' WHERE (`Fahrzeug_ID` = '1800');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '1' WHERE (`Fahrzeug_ID` = '1900');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '2' WHERE (`Fahrzeug_ID` = '2000');
UPDATE `autovermietung_harald`.`Fahrzeug` SET `FK_Tarifklassen_ID` = '1' WHERE (`Fahrzeug_ID` = '2100');


/* Dieser Trigger dient der automatischen Aktualisierung des Kilometerpreises für eine Tarifklasse,
 wenn eine Reservierung in der Reservation Tabelle eingefügt wird.
*/


DELIMITER //

    CREATE TRIGGER increase_price_per_km
	AFTER INSERT
	ON Reservation
	FOR EACH ROW
	BEGIN
		 UPDATE Tarifklassen
		SET Preis_pro_Km = Preis_pro_Km + 5
		WHERE Tarifklassen_ID in (
				SELECT f.FK_Tarifklassen_ID
			FROM Reservation r
			INNER JOIN wählt w
			ON r.Reservations_Nr = w.FK_Reservations_Nr
			INNER JOIN Fahrzeug f
			ON w.FK_Fahrzeug_ID = f.Fahrzeug_ID
			WHERE r.Reservations_Nr = w.FK_Reservations_Nr
        );
	END//
    
    DELIMITER ;

/* Dieser Trigger aktualisiert das Gehalt eines Mitarbeiters in der Tabelle 
Angestellter, sobald der Datensatz aktualisiert wird. Wenn der Mitarbeiter ein 
Abteilungsleiter ist (d.h. das Feld leitetAbteilungs_Nr ist nicht NULL), 
wird sein Gehalt um 10% erhöht. 
*/
	DELIMITER //
    
	CREATE TRIGGER update_employee_salary 
	before UPDATE ON Angestellter 
	FOR EACH ROW 
    BEGIN 
    IF NEW.FK_leitetAbteilungs_Nr IS NOT NULL 
	THEN SET new.Lohn = ( 
	SELECT Lohn * 1.10 
	FROM Angestellter 
	WHERE NEW.Angestellter_ID = Angestellter_ID 
	LIMIT 2 ); 
	END IF; 
    END//
    
    DELIMITER ;
    
/* Nun ist die Datenbank vollständig und nachfolgend werden die Queries erstellt:
*/


	SELECT
	Kunde.Kunden_ID,
    Adresse,
    Ort, 
    Postleitzahl,
    Vorname, 
    Nachname 
		FROM 		Kunde
		JOIN 		Reservation
		ON 			Kunde.Kunden_ID = Reservation.FK_Kunden_ID
		WHERE 		Abholdatum >= '2021-11-11' 
		AND 		Rückgabedatum <= '2022-04-19'
		AND 		Geschlecht = 'm' 
		AND 		ort != 'Basel'
		GROUP BY 	Kunde.Kunden_ID;
    -- Query 1
    
	SELECT
    MIN(Angestellter_Lohn),
    MAX(Angestellter_Lohn)
	FROM
    (SELECT
        Lohn,
        AVG (Lohn) AS Angestellter_Lohn
    FROM 		Angestellter
    GROUP BY 	Lohn
    ORDER BY 	Angestellter_Lohn) AS inner_Query;
    -- Query 2
    
	SELECT
    CASE WHEN 	Baujahr < 2020 THEN 'Altes Fahrzeug'
        WHEN 	Baujahr >= 2020 THEN 'Neues Fahrzeug'
        ELSE 	'AutoBaujahr Unbekannt'
    END AS 		Fahrzeug_JG,
				Count(*)
	FROM		Fahrzeug
	GROUP BY	Fahrzeug_JG;
    -- Query 3
    
/* Diese Abfrage gibt alle Zeilen aus den Tabellen Kunde und Reservierung zurück, 
die eine passende Kunden_ID bzw. Reservierungs_Nr haben und die auch eine entsprechende 
Zeile in der Tabelle Zahlung mit einer Zahlungsmethode 'Rechnung' haben. Die Zeilen werden 
nach der Spalte Kunden_ID in aufsteigender Reihenfolge sortiert.
 */
 
	SELECT          	*
	FROM            Kunde k
	JOIN            Reservation r
	ON              k.Kunden_ID = r.FK_Kunden_ID
	JOIN            Zahlung z
	ON              r.Reservations_Nr = z.FK_Reservations_Nr
	WHERE           z.Zahlungsmethode = 'Rechnung'
	ORDER BY        k.Kunden_ID ASC;
 -- Query 4

	/* Diese Abfrage wählt die Vor- und Nachnamen der Kunden aus der Tabelle Kunden 
    und den Gesamtbetrag Betrag, den sie für Mieten ausgegeben haben, aus der Tabelle Zahlung.
    Die Daten werden mit INNER JOIN Klauseln kombiniert und nach customer ID gruppiert. 
    Die resultierende Datensatzmenge wird dann gefiltert, um nur die Kunden zu filtern, die 
    mehr als 70 CHF für Mieten ausgegeben haben, und die Ergebnisse werden nach Gesamtbetrag in
    absteigender Reihenfolge geordnet.
	*/
    
	SELECT          Kunde.Vorname,
					Kunde.Nachname,
					SUM(Zahlung.Zahlbetrag) AS Total_Spent
	FROM            Kunde
	INNER JOIN      Reservation
	ON              Reservation.FK_Kunden_ID = Kunde.Kunden_ID
	INNER JOIN      Zahlung
	ON              Zahlung.FK_Reservations_Nr = Reservation.Reservations_Nr
	GROUP BY        Kunde.Kunden_ID
	HAVING          SUM(Zahlung.Zahlbetrag) > 70
	ORDER BY        Total_Spent DESC;
     -- Query 5

SELECT * FROM Angestellter;
/* Diese zwei Befehle lösen die beiden Trigger aus.

	INSERT INTO Reservation (Reservations_Nr, Abholdatum, Rückgabedatum, FK_Kunden_ID)
	VALUES (10020, '2021-09-22', '2021-09-20', 1010);
    
    UPDATE angestellter SET FK_LeitetAbteilungs_Nr = 110 WHERE angestellter.angestellter_ID = 108;
*/

use autovermietung_harald;
SELECT * FROM Angestellter;

EXPLAIN ANALYZE SELECT * FROM Angestellter;


SELECT Projekt.Name, Abteilung.AName
FROM Projekt JOIN Abteilung
ON Abteilung = AbtNr;

SELECT p.Name, Count(DISTINCT Angestellter)
FROM projektmitarbeit pm  JOIN Projekt P
ON pm.Projekt = P.ProjNr
Group by P.name;

SELECT * 
FROM 
	(Angestellter a JOIN Abteilung ab ON a.Abteilung = ab.Abtnr)
    JOIN Abt_Ort ON ao.AbtNr = ab.Abtnr
    WHERE ao.Ort = "Kloten";
    
SELECT a.NName,a.VName,a.Adresse
	FROM 
		(Angestellter a JOIN projektmitarbeit pm ON a.AHVNr = pm.angestellter)
		JOIN Projekt p ON pm.projekt = p.ProjNr
        WHERE pm.projekt IN (SELECT ProjNr FROM Projekt WHERE P.Name Like 'Produkt _'); 
        

       
       CREATE TABLE Angestellter (
       AHVNr INT Primary key,
       NName VARCHAR(20) NOT NULL,
       VName VARCHAR(20)NOT NULL,
       Gebtag DATE,
       Adresse VARCHAR(20),
       Geschlecht ENUM ('M','W'),
       SALAER INT,
       FK_Vorgesetzter INT,
       CONSTRAINT FK_Vorgesetzter FOREIGN KEY (FK_Vorgesetzter) REFERENCES Angestellter(AHVNr)
       );
       
       CREATE TABLE Abteilung (
       AbtNr INT PRIMARY KEY,
       AName VARCHAR(30) NOT NULL,
       FK_Leiter INT,
       Ort VARCHAR(30),
       FOREIGN KEY (FK_Leiter) REFERENCES Angestellter (AHVNr)
       ); 
       
      ALTER TABLE Angestellter ADD CONSTRAINT FK_Abteilung FOREIGN KEY (FK_Abteilung) REFERENCES Abteilung(AbtNr);
       
       
       
	
        
        
        