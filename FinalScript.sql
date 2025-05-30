-- Tabella fornitore
CREATE TABLE fornitore (
    nome CHAR(10) PRIMARY KEY,
    settore VARCHAR(30) NOT NULL
);

-- Tabella strumento
CREATE TABLE strumento (
    id_strumento CHAR(10) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

-- Tabella fornitura
CREATE TABLE fornitura (
    id_fornitura CHAR(10) PRIMARY KEY,
    quantita INTEGER NOT NULL CHECK (quantita > 0), --Una fornitura per essere considerata tale deve essere di almeno 1 elemento
    data DATE NOT NULL,
	prezzo DECIMAL(10,2) NOT NULL,
    strumento CHAR(10) NOT NULL,
    fornitore CHAR(10) NOT NULL,
    FOREIGN KEY (strumento) REFERENCES strumento(id_strumento),
    FOREIGN KEY (fornitore) REFERENCES fornitore(nome)
);

--Tabella settore
CREATE TABLE settore (
    nome VARCHAR(20) PRIMARY KEY,
    budget DECIMAL(15,2) NOT NULL CHECK (budget > 0),
    capo CHAR(16),
    numero_persone INTEGER NOT NULL CHECK (numero_persone > 0),
	--FOREIGN KEY (capo) REFERENCES team_member(cf) on delete set null,
	--Non si può eliminare un intero settore se il capo viene licenziato
	UNIQUE (capo)
	--Una persona non può essere a capo di più settori
);

--Tabella utilizzo
CREATE TABLE utilizzo (
    strumento CHAR(10) NOT NULL,
    settore VARCHAR(20) NOT NULL,
    quantita INTEGER NOT NULL CHECK (quantita > 0), --per utilizzare uno strumento per forza deve essere almeno 1
    PRIMARY KEY (strumento, settore),
    FOREIGN KEY (strumento) REFERENCES strumento(id_strumento),
    FOREIGN KEY (settore) REFERENCES settore(nome) on update cascade on delete cascade
	--Se elimino un certo settore per un fork ho bisogno di eliminare tutte le assegnazioni degli strumenti
	--Poi organizzerò gli strumenti non ancora assegnati alla nuova organizzazione dei settori
);

--Tabella contratto
CREATE TABLE contratto (
    id_contratto CHAR(10) PRIMARY KEY,
    inizio DATE NOT NULL CHECK (fine is null or inizio < fine),
    fine DATE CHECK (fine is null or (fine is not null and fine > inizio)),
    compenso DECIMAL(15,2) NOT NULL CHECK (compenso > 0),
    bonus_mensile DECIMAL(10,2),
	cf_team CHAR(16),
	cf_pilota CHAR(16),
	--FOREIGN KEY (cf_team) REFERENCES team_member(cf) on delete cascade,
	--FOREIGN KEY (cf_pilota) REFERENCES pilota(cf),
	--Posso licenziare un team_member ma non un pilota, il tal caso elimino anche tutti i contratti ad egli associati
	CHECK (
	    (cf_team IS NOT NULL AND cf_pilota IS NULL) OR
	    (cf_team IS NULL AND cf_pilota IS NOT NULL)
	) --Non devono essere entrambe null
);

--Tabella team_member
CREATE TABLE team_member (
    cf CHAR(16) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    nazionalita VARCHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    ruolo VARCHAR(50) NOT NULL CHECK (ruolo in ('ingegnere', 'meccanico', 'manager')),
    specializzazione VARCHAR(50),
    laurea VARCHAR(50),
    anni_esp INTEGER,
	settore VARCHAR(20),
	FOREIGN KEY (settore) REFERENCES settore(nome) on update cascade on delete set null,
	--Qui ho bisogno di settare a NULL il settore a cui appartiene un certo dipendente poiché non posso eliminare
	--tutte le persone di un certo settore in quanto si pensa ad una riorganizzazione non ad un licenziamento massivo
	CHECK (
	    (ruolo = 'meccanico' AND specializzazione IS NOT NULL AND anni_esp IS NOT NULL AND laurea IS NULL)
	    OR
	    (ruolo = 'ingegnere' AND laurea IS NOT NULL AND specializzazione IS NULL AND anni_esp IS NULL)
	    OR
	    (ruolo = 'manager' AND anni_esp IS NOT NULL AND laurea IS NULL AND specializzazione IS NULL)
	)
);
--Tabella pilota
CREATE TABLE pilota (
    cf CHAR(16) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    numero INTEGER NOT NULL,
    nazionalita VARCHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    peso DECIMAL(5,2) NOT NULL CHECK (peso > 0),
    altezza DECIMAL(5,2) NOT NULL CHECK (altezza > 0),
	settore VARCHAR(20) NOT NULL CHECK (settore = 'Pista'),
	FOREIGN KEY (settore) REFERENCES settore(nome) on update cascade
	--Non ha senso mettere on delete poiché eliminare il settore "pista" al quale appartiene il pilota
	--significa che non è più una scuderia di Formula 1
);

--Tabella motore
CREATE TABLE motore (
    id_motore CHAR(10) PRIMARY KEY,
    cilindri INTEGER NOT NULL CHECK (cilindri > 0 and cilindri <= 16),
    peso DECIMAL(8,2) NOT NULL CHECK (peso > 0),
    alimentazione VARCHAR(50) NOT NULL CHECK (alimentazione in ('elettrico', 'combustione', 'ibrido')),
	produttore VARCHAR(50) NOT NULL
);

--Tabella vettura
CREATE TABLE vettura (
    id_vettura CHAR(10) PRIMARY KEY,
    modello VARCHAR(50) NOT NULL,
    anno INTEGER NOT NULL,
    peso DECIMAL(8,2) CHECK (peso > 0),
	cf CHAR(16),
	id_motore CHAR(10) NOT NULL,
	FOREIGN KEY (cf) REFERENCES pilota(cf),
	FOREIGN KEY (id_motore) REFERENCES motore(id_motore) on update cascade
	--Pongo CF come attributo opzionale in modo da permettere a vetture di non appartenere ad alcun ex pilota
	--Identificativi che hanno bisogno di una diversa numerazione di codice -> update cascade
);

--Tabella circuito
CREATE TABLE circuito (
    id_circuito CHAR(10) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    localita VARCHAR(100) NOT NULL,
    paese VARCHAR(50) NOT NULL,
    lunghezza DECIMAL(7,3) NOT NULL, CHECK (lunghezza > 0),
    nr_curve INTEGER NOT NULL CHECK (nr_curve > 0),
	UNIQUE (nome)
);

--Tabella gara
CREATE TABLE gara (
    pilota CHAR(16) NOT NULL,
    circuito CHAR(10) NOT NULL,
    data DATE NOT NULL,
    posizione INTEGER NOT NULL CHECK (posizione > 0),
    tempo_totale INTERVAL NOT NULL CHECK (tempo_totale > INTERVAL '0'),
    PRIMARY KEY (pilota, circuito, data),
    FOREIGN KEY (pilota) REFERENCES pilota(cf),
    FOREIGN KEY (circuito) REFERENCES circuito(id_circuito)
	--Analogamente a circuiti non avrebbe senso eliminare i gp
);

--Tabella giro
CREATE TABLE giro (
    numero_giro INTEGER NOT NULL CHECK (numero_giro > 0),
    circuito CHAR(10) NOT NULL,
    data DATE NOT NULL,
    pilota CHAR(16) NOT NULL,
    tempo INTERVAL NOT NULL CHECK (tempo > INTERVAL '0'), --millisecondi
    v_min DECIMAL(6,2) NOT NULL CHECK (v_min >= 0 and v_min < v_max),
    v_max DECIMAL(6,2) NOT NULL CHECK (v_max >= 0 and v_max > v_min),
    PRIMARY KEY (numero_giro, circuito, data, pilota),
    FOREIGN KEY (pilota, circuito, data) REFERENCES gara(pilota, circuito, data)
);

-- Popolamento tabella fornitore
INSERT INTO fornitore (nome, settore) VALUES
('Pirelli', 'Gomme'),
('Ferrari', 'Motori'),
('Brembo', 'Freni'),
('Shell', 'Carburante');

-- Popolamento tabella strumento
INSERT INTO strumento (id_strumento, nome) VALUES
('ST00000001', 'Analizzatore dati'),
('ST00000002', 'Simulatore guida'),
('ST00000003', 'Banco prova motore');

-- Popolamento tabella fornitura
INSERT INTO fornitura (id_fornitura, quantita, data, prezzo, strumento, fornitore) VALUES
('F000000001', 10, '2023-05-10', 5000.00, 'ST00000001', 'Pirelli'),
('F000000002', 3, '2023-06-15', 12000.00, 'ST00000002', 'Ferrari'),
('F000000003', 3, '2023-04-20', 8000.00, 'ST00000003', 'Brembo');

-- Popolamento tabella settore
INSERT INTO settore (nome, budget, capo, numero_persone) VALUES
('Aerodinamica', 1000000.00, 'RSSMRA80A01H501Z', 15),
('Motori', 1500000.00, 'FRDGPP85C23H501X', 20),
('Gomme', 800000.00, 'CRDGPP85C23H501X', 10),
('Ricerca e sviluppo', 2000000.00, 'BNCLGU75B12H501Y', 5),
('Pista', 5000000.00, 'BRDGPP85C23H501X', 20);

-- Popolamento tabella utilizzo
INSERT INTO utilizzo (strumento, settore, quantita) VALUES
('ST00000001', 'Aerodinamica', 5),
('ST00000002', 'Motori', 3),
('ST00000003', 'Gomme', 2);

-- Popolamento tabella contratto
INSERT INTO contratto (id_contratto, inizio, fine, compenso, bonus_mensile, cf_team, cf_pilota) VALUES
('CT00000001', '2023-01-01', '2025-12-31', 4000000.00, 150000.00, NULL, 'HAMILC44D01H501W'),  -- Hamilton
('CT00000002', '2023-01-01', '2026-12-31', 3000000.00, 120000.00, NULL, 'LECCHR16E02H501V'),   -- Leclerc
('CT00000003', '2019-01-01', '2029-12-31', 4000000.00, 150000.00, 'RSSMRA80A01H501Z', NULL),
('CT00000004', '2010-12-01', '2027-12-31', 4000000.00, NULL, 'BNCLGU75B12H501Y', NULL),
('CT00000005', '2005-05-01', '2030-12-31', 4000000.00, NULL, 'ARDGPP85C23H501X', NULL),
('CT00000006', '2020-01-01', NULL, 4000000.00, 150000.00, 'BRDGPP85C23H501X', NULL),
('CT00000007', '2016-01-01', '2025-12-31', 4000000.00, NULL, 'CRDGPP85C23H501X', NULL),
('CT00000008', '2022-01-01', '2025-12-31', 4000000.00, 150000.00, 'DRDGPP85C23H501X', NULL),
('CT00000009', '2023-04-01', NULL, 4000000.00, NULL, 'ERDGPP85C23H501X', NULL),
('CT00000010', '2023-05-01', NULL, 4000000.00, 150000.00, 'FRDGPP85C23H501X', NULL);

-- Popolamento tabella team_member
INSERT INTO team_member (cf, nome, cognome, nazionalita, data_nascita, ruolo, specializzazione, laurea, anni_esp, settore) VALUES
('RSSMRA80A01H501Z', 'Mario', 'Rossi', 'Italiana', '1980-01-01', 'ingegnere', NULL, 'Ingegneria Aerospaziale', NULL, 'Aerodinamica'),
('BNCLGU75B12H501Y', 'Luigi', 'Bianchi', 'Italiana', '1975-02-12', 'ingegnere', NULL, 'Ingegneria Meccanica', NULL,'Ricerca e sviluppo'),
('ARDGPP85C23H501X', 'Giuseppe', 'Verdi', 'Italiana', '1984-03-23', 'ingegnere', NULL, 'Chimica', NULL, 'Gomme'),
('BRDGPP85C23H501X', 'Leonardo', 'Esposito', 'Italiana', '1965-03-23', 'manager', NULL, NULL, 8, 'Pista'),
('CRDGPP85C23H501X', 'Giuseppe', 'Rossi', 'Italiana', '1995-01-23', 'manager', NULL, NULL, 8, 'Ricerca e sviluppo'),
('DRDGPP85C23H501X', 'Claudio', 'Bellio', 'Italiana', '1988-12-23', 'manager', NULL, NULL, 8, 'Aerodinamica'),
('ERDGPP85C23H501X', 'Lorenzo', 'Ferro', 'Italiana', '1985-03-23', 'meccanico', 'Freni', NULL, 8, 'Pista'),
('FRDGPP85C23H501X', 'Alessio', 'Sella', 'Italiana', '1985-03-23', 'meccanico', 'Carrozzeria', NULL, 10, 'Motori');

-- Popolamento tabella pilota
INSERT INTO pilota (cf, nome, cognome, numero, nazionalita, data_nascita, peso, altezza, settore) VALUES
('HAMILC44D01H501W', 'Lewis', 'Hamilton', 44, 'Britannica', '1985-01-07', 68, 1.74, 'Pista'),
('LECCHR16E02H501V', 'Charles', 'Leclerc', 16, 'Monegasco', '1997-10-16', 70, 1.80, 'Pista');

-- Popolamento tabella motore
INSERT INTO motore (id_motore, cilindri, peso, alimentazione, produttore) VALUES
('M000000001', 6, 150, 'ibrido', 'Ferrari'),
('M000000002', 6, 152, 'ibrido', 'Ferrari');

-- Popolamento tabella vettura
INSERT INTO vettura (id_vettura, modello, anno, peso, cf, id_motore) VALUES
('V000000001', 'F1-2023', 2023, 795, 'HAMILC44D01H501W', 'M000000001'),
('V000000002', 'F1-2023-B', 2023, 798, 'LECCHR16E02H501V', 'M000000002');

-- Popolamento tabella circuito
INSERT INTO circuito (id_circuito, nome, localita, paese, lunghezza, nr_curve) VALUES
('C000000001', 'Bahrain International Circuit', 'Sakhir', 'Bahrain', 5412, 15),
('C000000002', 'Jeddah Corniche Circuit', 'Gedda', 'Arabia Saudita', 6174, 27),
('C000000003', 'Albert Park Circuit', 'Melbourne', 'Australia', 5278, 14),
('C000000004', 'Suzuka International Racing Course', 'Suzuka', 'Giappone', 5807, 18),
('C000000005', 'Shanghai International Circuit', 'Shanghai', 'Cina', 5451, 16),
('C000000006', 'Miami International Autodrome', 'Miami', 'USA', 5410, 19),
('C000000007', 'Autodromo Enzo e Dino Ferrari', 'Imola', 'Italia', 4909, 19),
('C000000008', 'Circuit de Monaco', 'Monte Carlo', 'Monaco', 3337, 19),
('C000000009', 'Circuit Gilles Villeneuve', 'Montréal', 'Canada', 4361, 14),
('C000000010', 'Circuit de Barcelona-Catalunya', 'Barcellona', 'Spagna', 4675, 16),
('C000000011', 'Red Bull Ring', 'Spielberg', 'Austria', 4318, 10),
('C000000012', 'Silverstone Circuit', 'Silverstone', 'Regno Unito', 5891, 18),
('C000000013', 'Hungaroring', 'Mogyoród', 'Ungheria', 4381, 14),
('C000000014', 'Circuit de Spa-Francorchamps', 'Stavelot', 'Belgio', 7004, 19),
('C000000015', 'Circuit Zandvoort', 'Zandvoort', 'Paesi Bassi', 4259, 14),
('C000000016', 'Autodromo Nazionale Monza', 'Monza', 'Italia', 5793, 11),
('C000000017', 'Baku City Circuit', 'Baku', 'Azerbaigian', 6003, 20),
('C000000018', 'Marina Bay Street Circuit', 'Singapore', 'Singapore', 5063, 23),
('C000000019', 'Circuit of The Americas', 'Austin', 'USA', 5513, 20),
('C000000020', 'Autódromo Hermanos Rodríguez', 'Città del Messico', 'Messico', 4304, 17),
('C000000021', 'Autódromo José Carlos Pace', 'San Paolo', 'Brasile', 4309, 15),
('C000000022', 'Las Vegas Strip Circuit', 'Las Vegas', 'USA', 6120, 17),
('C000000023', 'Lusail International Circuit', 'Lusail', 'Qatar', 5410, 16),
('C000000024', 'Yas Marina Circuit', 'Abu Dhabi', 'Emirati Arabi Uniti', 5281, 21);
-- Popolamento tabella gara
INSERT INTO gara (pilota, id_circuito, data, posizione, tempo_totale) VALUES
('HAMILC44D01H501W', 'C000000001', '2023-03-05', 5, '01:33:30.456'),   -- Hamilton in Bahrain (5°)
('LECCHR16E02H501V', 'C000000001', '2023-03-05', 2, '01:32:15.123'),   -- Leclerc in Bahrain (2°)
('HAMILC44D01H501W', 'C000000012', '2023-07-09', 3, '01:25:45.789'),   -- Hamilton a Silverstone (3°)
('LECCHR16E02H501V', 'C000000012', '2023-07-09', 9, '01:27:22.456'),  -- Leclerc a Silverstone (9°)
('HAMILC44D01H501W', 'C000000016', '2023-09-03', 6, '01:21:30.111'),  -- Hamilton a Monza (6°)
('LECCHR16E02H501V', 'C000000016', '2023-09-03', 4, '01:20:45.222');  -- Leclerc a Monza (4°)

-- Popolamento tabella giro
INSERT INTO giro (numero_giro, circuito, data, pilota, tempo, v_min, v_max) VALUES
-- Bahrain
(1, 'C000000001', '2023-03-05', 'HAMILC44D01H501W', '00:01:35.456', 210, 320),
(2, 'C000000001', '2023-03-05', 'HAMILC44D01H501W', '00:1:34.123', 215, 325),
(1, 'C000000001', '2023-03-05', 'LECCHR16E02H501V', '00:1:33.789', 220, 330),
(2, 'C000000001', '2023-03-05', 'LECCHR16E02H501V', '00:1:32.456', 225, 335),
-- Silverstone
(1, 'C000000012', '2023-07-09', 'HAMILC44D01H501W', '00:1:30.111', 230, 340),
(2, 'C000000012', '2023-07-09', 'LECCHR16E02H501V', '00:1:31.222', 228, 338),
-- Monza
(1, 'C000000016', '2023-09-03', 'HAMILC44D01H501W', '00:1:24.555', 240, 360),
(1, 'C000000016', '2023-09-03', 'LECCHR16E02H501V', '00:1:23.666', 245, 365);


ALTER TABLE settore
ADD FOREIGN KEY (capo)
REFERENCES team_member(cf)
on delete set null;
