-- Creazione schema
CREATE SCHEMA IF NOT EXISTS f1_management;

-- Tabella Fornitore
CREATE TABLE Fornitore (
    Nome VARCHAR(100) PRIMARY KEY,
    Settore VARCHAR(100) NOT NULL
);

-- Tabella Strumento
CREATE TABLE Strumento (
    IdStrumento VARCHAR(50) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

-- Tabella Fornitura
CREATE TABLE Fornitura (
    IdFornitura SERIAL PRIMARY KEY,
    Quantita INTEGER NOT NULL,
    Data DATE NOT NULL,
    Strumento VARCHAR(50) NOT NULL,
    Fornitore VARCHAR(100) NOT NULL,
    FOREIGN KEY (Strumento) REFERENCES Strumento(IdStrumento),
    FOREIGN KEY (Fornitore) REFERENCES Fornitore(Nome)
);

-- Tabella Settore
CREATE TABLE Settore (
    Nome VARCHAR(100) PRIMARY KEY,
    Budget DECIMAL(15,2) NOT NULL,
    Capo VARCHAR(100) NOT NULL,
    NumeroPersone INTEGER NOT NULL
);

-- Tabella Utilizzo
CREATE TABLE Utilizzo (
    Strumento VARCHAR(50) NOT NULL,
    Settore VARCHAR(100) NOT NULL,
    Quantita INTEGER NOT NULL,
    PRIMARY KEY (Strumento, Settore),
    FOREIGN KEY (Strumento) REFERENCES Strumento(IdStrumento),
    FOREIGN KEY (Settore) REFERENCES Settore(Nome)
);

-- Tabella Team Member
CREATE TABLE "Team Member" (
    CF VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Nazionalita VARCHAR(50) NOT NULL,
    "Data Nascita" DATE NOT NULL,
    Ruolo VARCHAR(100) NOT NULL,
    Specializzazione VARCHAR(100),
    Laurea VARCHAR(100),
    "Anni Esp." INTEGER
);

-- Tabella Contratto
CREATE TABLE Contratto (
    ID SERIAL PRIMARY KEY,
    Inizio DATE NOT NULL,
    Fine DATE,
    Compenso DECIMAL(15,2) NOT NULL,
    "Bonus Mensile" DECIMAL(10,2)
);

-- Tabella Pilota
CREATE TABLE Pilota (
    CF VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Numero INTEGER NOT NULL,
    Nazionalita VARCHAR(50) NOT NULL,
    "Data Nascita" DATE NOT NULL,
    Peso DECIMAL(5,2) NOT NULL,
    Altezza DECIMAL(5,2) NOT NULL
);

-- Tabella Vettura
CREATE TABLE Vettura (
    IDVettura SERIAL PRIMARY KEY,
    Modello VARCHAR(100) NOT NULL,
    Anno INTEGER NOT NULL,
    Peso DECIMAL(8,2) -- Puo essere NULL in quanto per vetture ancora in sviluppo potrebbe non essere preciso
);

-- Tabella Motore
CREATE TABLE Motore (
    IDMotore SERIAL PRIMARY KEY,
    Cilindri INTEGER NOT NULL,
    Peso DECIMAL(8,2),
    Alimentazione VARCHAR(50) NOT NULL
);

-- Tabella Circuito
CREATE TABLE Circuito (
    IdCircuito SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Localita VARCHAR(100) NOT NULL,
    Paese VARCHAR(50) NOT NULL,
    Lunghezza DECIMAL(6,3) NOT NULL,
    "Nr Curve" INTEGER NOT NULL
);

-- Tabella GP
CREATE TABLE GP (
    Circuito INTEGER,
    Data DATE NOT NULL,
    "Condizioni Meteo" VARCHAR(100) NOT NULL,
    PRIMARY KEY (Circuito, Data),
    FOREIGN KEY (Circuito) REFERENCES Circuito(IdCircuito)
);

-- Tabella Gara
CREATE TABLE Gara (
    Pilota VARCHAR(16),
    Circuito INTEGER NOT NULL,
    Data DATE NOT NULL,
    Posizione INTEGER NOT NULL,
    TempoTotale INTERVAL NOT NULL,
    PRIMARY KEY (Pilota, Circuito, Data),
    FOREIGN KEY (Pilota) REFERENCES Pilota(CF),
    FOREIGN KEY (Circuito, Data) REFERENCES GP(Circuito, Data)
);

-- Tabella Giro
CREATE TABLE Giro (
    NumeroGiro INTEGER,
    Circuito INTEGER NOT NULL,
    Data DATE NOT NULL,
    Pilota VARCHAR(16) NOT NULL,
    Tempo INTERVAL, -- Per errori di lettura potrebbe non essere possibile avere una telemetria precisa quindi puo essere NULL
    VMin DECIMAL(6,2),
    VMax DECIMAL(6,2),
    PRIMARY KEY (NumeroGiro, Circuito, Data, Pilota),
    FOREIGN KEY (Pilota, Circuito, Data) REFERENCES Gara(Pilota, Circuito, Data)
);