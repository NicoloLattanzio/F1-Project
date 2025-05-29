-- Popolamento tabella Fornitore
INSERT INTO Fornitore (Nome, Settore) VALUES
('Pirelli', 'Gomme'),
('Ferrari', 'Motori'),
('Brembo', 'Freni'),
('Shell', 'Carburante');

-- Popolamento tabella Strumento
INSERT INTO Strumento (IdStrumento, Nome) VALUES
('ST001', 'Analizzatore dati'),
('ST002', 'Simulatore guida'),
('ST003', 'Banco prova motore');

-- Popolamento tabella Settore
INSERT INTO Settore (Nome, Budget, Capo, NumeroPersone) VALUES
('Aerodinamica', 1000000.00, 'Mario Rossi', 15),
('Motori', 1500000.00, 'Luigi Bianchi', 20),
('Gomme', 800000.00, 'Giuseppe Verdi', 10),
('Piloti', 2000000.00, 'Stefano Ricci', 5);

-- Popolamento tabella TeamMember
INSERT INTO TeamMember (CF, Nome, Cognome, Nazionalità, DataNascita, Ruolo, Specializzazione, Laurea, AnniEsp) VALUES
('RSSMRA80A01H501Z', 'Mario', 'Rossi', 'Italiana', '1980-01-01', 'Aerodinamica', 'Fluidodinamica', 'Ingegneria Aerospaziale', 10),
('BNCLGU75B12H501Y', 'Luigi', 'Bianchi', 'Italiana', '1975-02-12', 'Motori', 'Propulsione', 'Ingegneria Meccanica', 15),
('VRDGPP85C23H501X', 'Giuseppe', 'Verdi', 'Italiana', '1985-03-23', 'Gomme', 'Materiali', 'Chimica', 8);

-- Popolamento tabella Pilota
INSERT INTO Pilota (CF, Nome, Cognome, Numero, Nazionalità, DataNascita, Peso, Altezza, Settore) VALUES
('HAMILC44D01H501W', 'Lewis', 'Hamilton', 44, 'Britannica', '1985-01-07', 68, 1.74, 'Piloti'),
('LECCHR16E02H501V', 'Charles', 'Leclerc', 16, 'Monegasco', '1997-10-16', 70, 1.80, 'Piloti');

-- Popolamento tabella Contratto
INSERT INTO Contratto (ID, Dipendente, Inizio, Fine, Compenso, BonusMensile) VALUES
('CT002', 'HAMILC44D01H501W', '2023-01-01', '2025-12-31', 4000000.00, 150000.00),  -- Hamilton
('CT003', 'LECCHR16E02H501V', '2023-01-01', '2026-12-31', 3000000.00, 120000.00);   -- Leclerc

-- Popolamento tabella Vettura
INSERT INTO Vettura (IDVettura, Modello, Anno, Peso) VALUES
('V001', 'F1-2023', 2023, 795),
('V002', 'F1-2023-B', 2023, 798);

-- Popolamento tabella Motore
INSERT INTO Motore (IDMotore, Cilindri, Peso, Alimentazione, Produttore) VALUES
('M001', 6, 150, 'Ibrida', 'Ferrari'),
('M002', 6, 152, 'Ibrida', 'Ferrari');

-- Popolamento basico
INSERT INTO Circuito (IdCircuito, Nome, Localita, Paese, Lunghezza, NR_curve) VALUES
(1, 'Bahrain International Circuit', 'Sakhir', 'Bahrain', 5412, 15),
(2, 'Jeddah Corniche Circuit', 'Gedda', 'Arabia Saudita', 6174, 27),
(3, 'Albert Park Circuit', 'Melbourne', 'Australia', 5278, 14),
(4, 'Suzuka International Racing Course', 'Suzuka', 'Giappone', 5807, 18),
(5, 'Shanghai International Circuit', 'Shanghai', 'Cina', 5451, 16),
(6, 'Miami International Autodrome', 'Miami', 'USA', 5410, 19),
(7, 'Autodromo Enzo e Dino Ferrari', 'Imola', 'Italia', 4909, 19),
(8, 'Circuit de Monaco', 'Monte Carlo', 'Monaco', 3337, 19),
(9, 'Circuit Gilles Villeneuve', 'Montréal', 'Canada', 4361, 14),
(10, 'Circuit de Barcelona-Catalunya', 'Barcellona', 'Spagna', 4675, 16),
(11, 'Red Bull Ring', 'Spielberg', 'Austria', 4318, 10),
(12, 'Silverstone Circuit', 'Silverstone', 'Regno Unito', 5891, 18),
(13, 'Hungaroring', 'Mogyoród', 'Ungheria', 4381, 14),
(14, 'Circuit de Spa-Francorchamps', 'Stavelot', 'Belgio', 7004, 19),
(15, 'Circuit Zandvoort', 'Zandvoort', 'Paesi Bassi', 4259, 14),
(16, 'Autodromo Nazionale Monza', 'Monza', 'Italia', 5793, 11),
(17, 'Baku City Circuit', 'Baku', 'Azerbaigian', 6003, 20),
(18, 'Marina Bay Street Circuit', 'Singapore', 'Singapore', 5063, 23),
(19, 'Circuit of The Americas', 'Austin', 'USA', 5513, 20),
(20, 'Autódromo Hermanos Rodríguez', 'Città del Messico', 'Messico', 4304, 17),
(21, 'Autódromo José Carlos Pace', 'San Paolo', 'Brasile', 4309, 15),
(22, 'Las Vegas Strip Circuit', 'Las Vegas', 'USA', 6120, 17),
(23, 'Lusail International Circuit', 'Lusail', 'Qatar', 5410, 16),
(24, 'Yas Marina Circuit', 'Abu Dhabi', 'Emirati Arabi Uniti', 5281, 21)

INSERT INTO GP (Circuito, Data, CondizioniMeteo) VALUES
(1, '2023-03-05', 'Sereno'),       -- Bahrain
(2, '2023-03-19', 'Sereno'),       -- Arabia Saudita
(3, '2023-04-02', 'Variabile'),    -- Australia
(4, '2023-04-16', 'Pioggia'),      -- Giappone (data sostitutiva)
(5, '2023-04-30', 'Nuvoloso'),     -- Cina (non disputata nel 2023, data ipotetica)
(6, '2023-05-07', 'Sereno'),       -- Miami
(7, '2023-05-21', 'Pioggia leggera'), -- Imola (annullata per alluvione, data ipotetica)
(8, '2023-05-28', 'Sereno'),       -- Monaco
(9, '2023-06-18', 'Variabile'),    -- Canada
(10, '2023-06-04', 'Sereno'),      -- Spagna (data reale)
(11, '2023-07-02', 'Pioggia'),     -- Austria
(12, '2023-07-09', 'Sereno'),      -- Gran Bretagna
(13, '2023-07-23', 'Afoso'),       -- Ungheria
(14, '2023-07-30', 'Variabile'),   -- Belgio
(15, '2023-08-27', 'Sereno'),      -- Olanda
(16, '2023-09-03', 'Pioggia'),     -- Italia
(17, '2023-09-17', 'Sereno'),      -- Azerbaijan
(18, '2023-09-17', 'Umido'),       -- Singapore (data corretta)
(19, '2023-10-22', 'Sereno'),      -- USA (Austin)
(20, '2023-10-29', 'Asciutto'),    -- Messico
(21, '2023-11-05', 'Pioggia'),     -- Brasile
(22, '2023-11-19', 'Freddo'),      -- Las Vegas
(23, '2023-10-08', 'Afoso'),       -- Qatar (data reale)
(24, '2023-11-26', 'Sereno');      -- Abu Dhabi

-- Popolamento tabella Fornitura
INSERT INTO Fornitura (IdFornitura, Quantità, PrezzoFornitura, Data, Strumento, Fornitore) VALUES
('F001', 2, 5000.00, '2023-05-10', 'ST001', 'Pirelli'),
('F002', 1, 12000.00, '2023-06-15', 'ST002', 'Ferrari'),
('F003', 3, 8000.00, '2023-04-20', 'ST003', 'Brembo');

-- Popolamento tabella Utilizzo
INSERT INTO Utilizzo (Strumento, Settore, Quantità) VALUES
('ST001', 'Aerodinamica', 5),
('ST002', 'Motori', 3),
('ST003', 'Gomme', 2);

-- Popolamento tabella Gara
INSERT INTO Gara (Pilota, Circuito, Data, Posizione, TempoTotale) VALUES
('HAMILC44D01H501W', 1, '2023-03-05', 5, '1:33:30.456'),   -- Hamilton in Bahrain (5°)
('LECCHR16E02H501V', 1, '2023-03-05', 2, '1:32:15.123'),   -- Leclerc in Bahrain (2°)
('HAMILC44D01H501W', 12, '2023-07-09', 3, '1:25:45.789'),   -- Hamilton a Silverstone (3°)
('LECCHR16E02H501V', 12, '2023-07-09', 9, '1:27:22.456'),  -- Leclerc a Silverstone (9°)
('HAMILC44D01H501W', 16, '2023-09-03', 6, '1:21:30.111'),  -- Hamilton a Monza (6°)
('LECCHR16E02H501V', 16, '2023-09-03', 4, '1:20:45.222');  -- Leclerc a Monza (4°)

-- Popolamento tabella Giro
INSERT INTO Giro (NumeroGiro, Circuito, Data, Pilota, Tempo, VMin, VMax) VALUES
-- Bahrain
(1, 1, '2023-03-05', 'HAMILC44D01H501W', '1:35.456', 210, 320),
(2, 1, '2023-03-05', 'HAMILC44D01H501W', '1:34.123', 215, 325),
(1, 1, '2023-03-05', 'LECCHR16E02H501V', '1:33.789', 220, 330),
(2, 1, '2023-03-05', 'LECCHR16E02H501V', '1:32.456', 225, 335),
-- Silverstone
(1, 12, '2023-07-09', 'HAMILC44D01H501W', '1:30.111', 230, 340),
(2, 12, '2023-07-09', 'LECCHR16E02H501V', '1:31.222', 228, 338),
-- Monza
(1, 16, '2023-09-03', 'HAMILC44D01H501W', '1:24.555', 240, 360),
(1, 16, '2023-09-03', 'LECCHR16E02H501V', '1:23.666', 245, 365);


INSERT INTO Settore (IdSettore, Nome, Budget, Capo, NumeroPersone) VALUES

