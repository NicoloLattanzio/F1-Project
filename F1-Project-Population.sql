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
INSERT INTO fornitura (id_fornitura, quantita, data, prezzo_fnt, strumento, fornitore) VALUES
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

-- Popolamento tabella gp
INSERT INTO gp (id_circuito, data, condizioni_meteo) VALUES
('C000000001', '2023-03-05', 'Sereno'),       -- Bahrain
('C000000002', '2023-03-19', 'Sereno'),       -- Arabia Saudita
('C000000003', '2023-04-02', 'Variabile'),    -- Australia
('C000000004', '2023-04-16', 'Pioggia'),      -- Giappone (data sostitutiva)
('C000000005', '2023-04-30', 'Nuvoloso'),     -- Cina (non disputata nel 2023, data ipotetica)
('C000000006', '2023-05-07', 'Sereno'),       -- Miami
('C000000007', '2023-05-21', 'Pioggia leggera'), -- Imola (annullata per alluvione, data ipotetica)
('C000000008', '2023-05-28', 'Sereno'),       -- Monaco
('C000000009', '2023-06-18', 'Variabile'),    -- Canada
('C000000010', '2023-06-04', 'Sereno'),      -- Spagna (data reale)
('C000000011', '2023-07-02', 'Pioggia'),     -- Austria
('C000000012', '2023-07-09', 'Sereno'),      -- Gran Bretagna
('C000000013', '2023-07-23', 'Afoso'),       -- Ungheria
('C000000014', '2023-07-30', 'Variabile'),   -- Belgio
('C000000015', '2023-08-27', 'Sereno'),      -- Olanda
('C000000016', '2023-09-03', 'Pioggia'),     -- Italia
('C000000017', '2023-09-17', 'Sereno'),      -- Azerbaijan
('C000000018', '2023-09-17', 'Umido'),       -- Singapore (data corretta)
('C000000019', '2023-10-22', 'Sereno'),      -- USA (Austin)
('C000000020', '2023-10-29', 'Asciutto'),    -- Messico
('C000000021', '2023-11-05', 'Pioggia'),     -- Brasile
('C000000022', '2023-11-19', 'Freddo'),      -- Las Vegas
('C000000023', '2023-10-08', 'Afoso'),       -- Qatar (data reale)
('C000000024', '2023-11-26', 'Sereno');      -- Abu Dhabi

-- Popolamento tabella gara
INSERT INTO gara (pilota, id_circuito, data, posizione, tempo_totale) VALUES
('HAMILC44D01H501W', 'C000000001', '2023-03-05', 5, '01:33:30.456'),   -- Hamilton in Bahrain (5°)
('LECCHR16E02H501V', 'C000000001', '2023-03-05', 2, '01:32:15.123'),   -- Leclerc in Bahrain (2°)
('HAMILC44D01H501W', 'C000000012', '2023-07-09', 3, '01:25:45.789'),   -- Hamilton a Silverstone (3°)
('LECCHR16E02H501V', 'C000000012', '2023-07-09', 9, '01:27:22.456'),  -- Leclerc a Silverstone (9°)
('HAMILC44D01H501W', 'C000000016', '2023-09-03', 6, '01:21:30.111'),  -- Hamilton a Monza (6°)
('LECCHR16E02H501V', 'C000000016', '2023-09-03', 4, '01:20:45.222');  -- Leclerc a Monza (4°)

-- Popolamento tabella giro
INSERT INTO giro (numero_giro, id_circuito, data, pilota, tempo, v_min, v_max) VALUES
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
