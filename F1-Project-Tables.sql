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
	prezzo_fnt DECIMAL(10,2) NOT NULL,
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

--Tabella gp
CREATE TABLE gp (
    id_circuito CHAR(10) NOT NULL,
    data DATE NOT NULL,
	--Data non UNIQUE poiché possono esserci più gran premi nella stessa data come per il caso della formula 2
    condizioni_meteo VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_circuito, data),
    FOREIGN KEY (id_circuito) REFERENCES circuito(id_circuito)
	--Non si possono eliminare i circuiti e nemmeno aggiornare perché non avrebbe senso in un database che
	--funziona anche da cronologia di eventi per lo studio delle prestazioni della scuderia nel lungo periodo
);

--Tabella gara
CREATE TABLE gara (
    pilota CHAR(16) NOT NULL,
    id_circuito CHAR(10) NOT NULL,
    data DATE NOT NULL,
    posizione INTEGER NOT NULL CHECK (posizione > 0),
    tempo_totale INTERVAL NOT NULL CHECK (tempo_totale > 0),
    PRIMARY KEY (pilota, id_circuito, data),
    FOREIGN KEY (pilota) REFERENCES pilota(cf),
    FOREIGN KEY (id_circuito, data) REFERENCES gp(id_circuito, data)
	--Analogamente a circuiti non avrebbe senso eliminare i gp
);

--Tabella giro
CREATE TABLE giro (
    numero_giro INTEGER NOT NULL CHECK (numero_giro > 0),
    id_circuito CHAR(10) NOT NULL,
    data DATE NOT NULL,
    pilota CHAR(16) NOT NULL,
    tempo INTERVAL NOT NULL CHECK (tempo > 0), --millisecondi
    v_min DECIMAL(6,2) NOT NULL CHECK (v_min >= 0 and v_min > v_max),
    v_max DECIMAL(6,2) NOT NULL CHECK (v_max >= 0 and v_max > v_min),
    PRIMARY KEY (numero_giro, id_circuito, data, pilota),
    FOREIGN KEY (pilota, id_circuito, data) REFERENCES gara(pilota, id_circuito, data)
);



ALTER TABLE settore
ADD FOREIGN KEY (capo)
REFERENCES team_member(cf)
on delete set null;
