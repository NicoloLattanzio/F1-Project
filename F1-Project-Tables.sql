-- Creazione tabelle
CREATE TABLE Settore (
    IdSettore INT PRIMARY KEY,
    Nome VARCHAR(50),
    Budget DECIMAL(15,2),
    Capo VARCHAR(50),
    NumeroPersone INT
);

CREATE TABLE Fornitore (
    IdFornitore INT PRIMARY KEY,
    Nome VARCHAR(50),
    Settore INT REFERENCES Settore(IdSettore)
);

CREATE TABLE Strumento (
    IdStrumento INT PRIMARY KEY,
    Quantita INT,
    Nome VARCHAR(50)
);

CREATE TABLE Contratto (
    IdContratto INT PRIMARY KEY,
    Inizio DATE,
    Fine DATE,
    Bonus DECIMAL(10,2),
    Compenso DECIMAL(10,2)
);

CREATE TABLE Team (
    CF VARCHAR(16) PRIMARY KEY,
    DataNascita DATE,
    Nome VARCHAR(50),
    Cognome VARCHAR(50),
    Ruolo VARCHAR(50),
    Laurea BOOLEAN
);

CREATE TABLE Pilota (
    Numero INT PRIMARY KEY,
    Nome VARCHAR(50),
    Cognome VARCHAR(50),
    Altezza DECIMAL(3,2),
    Peso INT,
    Nazionalita VARCHAR(50)
);

CREATE TABLE Vettura (
    IdVettura INT PRIMARY KEY,
    Motore VARCHAR(50),
    Modello VARCHAR(50) DEFAULT 'SF-23'
);

CREATE TABLE Circuito (
    IdCircuito INT PRIMARY KEY,
    Nome VARCHAR(50),
    Localita VARCHAR(50),
    Paese VARCHAR(50),
    Lunghezza INT,
    NR_curve INT
);

CREATE TABLE GP (
    Data DATE,
    IdCircuito INT,
    GiroVeloce TIME,
    ZoneDRS INT,
    PRIMARY KEY (Data, IdCircuito),
    FOREIGN KEY (IdCircuito) REFERENCES Circuito(IdCircuito)
);

CREATE TABLE Giro (
    Data DATE,
    IdCircuito INT,
    NumeroGiro INT,
    NumeroPilota INT REFERENCES Pilota(Numero),
    Tempo TIME,
    VelocitaMax DECIMAL(5,2),
    VelocitaMin DECIMAL(5,2),
    PRIMARY KEY (Data, IdCircuito, NumeroGiro, NumeroPilota),
    FOREIGN KEY (Data, IdCircuito) REFERENCES GP(Data, IdCircuito)
);