import csv
import random
from datetime import datetime
import os

# Dati dei circuiti
circuiti_db = {
    'C000000001': {'nome': 'Bahrain International Circuit', 'localita': 'Sakhir', 'paese': 'Bahrain', 'lunghezza': 5412, 'nr_curve': 15, 'giri': 57},
    'C000000002': {'nome': 'Jeddah Corniche Circuit', 'localita': 'Gedda', 'paese': 'Arabia Saudita', 'lunghezza': 6174, 'nr_curve': 27, 'giri': 50},
    'C000000003': {'nome': 'Albert Park Circuit', 'localita': 'Melbourne', 'paese': 'Australia', 'lunghezza': 5278, 'nr_curve': 14, 'giri': 58},
    'C000000004': {'nome': 'Suzuka International Racing Course', 'localita': 'Suzuka', 'paese': 'Giappone', 'lunghezza': 5807, 'nr_curve': 18, 'giri': 53},
    'C000000005': {'nome': 'Shanghai International Circuit', 'localita': 'Shanghai', 'paese': 'Cina', 'lunghezza': 5451, 'nr_curve': 16, 'giri': 56},
    'C000000006': {'nome': 'Miami International Autodrome', 'localita': 'Miami', 'paese': 'USA', 'lunghezza': 5410, 'nr_curve': 19, 'giri': 57},
    'C000000007': {'nome': 'Autodromo Enzo e Dino Ferrari', 'localita': 'Imola', 'paese': 'Italia', 'lunghezza': 4909, 'nr_curve': 19, 'giri': 63},
    'C000000008': {'nome': 'Circuit de Monaco', 'localita': 'Monte Carlo', 'paese': 'Monaco', 'lunghezza': 3337, 'nr_curve': 19, 'giri': 78},
    'C000000009': {'nome': 'Circuit Gilles Villeneuve', 'localita': 'Montréal', 'paese': 'Canada', 'lunghezza': 4361, 'nr_curve': 14, 'giri': 70},
    'C000000010': {'nome': 'Circuit de Barcelona-Catalunya', 'localita': 'Barcellona', 'paese': 'Spagna', 'lunghezza': 4675, 'nr_curve': 16, 'giri': 66},
    'C000000011': {'nome': 'Red Bull Ring', 'localita': 'Spielberg', 'paese': 'Austria', 'lunghezza': 4318, 'nr_curve': 10, 'giri': 71},
    'C000000012': {'nome': 'Silverstone Circuit', 'localita': 'Silverstone', 'paese': 'Regno Unito', 'lunghezza': 5891, 'nr_curve': 18, 'giri': 52},
    'C000000013': {'nome': 'Hungaroring', 'localita': 'Mogyoród', 'paese': 'Ungheria', 'lunghezza': 4381, 'nr_curve': 14, 'giri': 70},
    'C000000014': {'nome': 'Circuit de Spa-Francorchamps', 'localita': 'Stavelot', 'paese': 'Belgio', 'lunghezza': 7004, 'nr_curve': 19, 'giri': 44},
    'C000000015': {'nome': 'Circuit Zandvoort', 'localita': 'Zandvoort', 'paese': 'Paesi Bassi', 'lunghezza': 4259, 'nr_curve': 14, 'giri': 72},
    'C000000016': {'nome': 'Autodromo Nazionale Monza', 'localita': 'Monza', 'paese': 'Italia', 'lunghezza': 5793, 'nr_curve': 11, 'giri': 53},
    'C000000017': {'nome': 'Baku City Circuit', 'localita': 'Baku', 'paese': 'Azerbaigian', 'lunghezza': 6003, 'nr_curve': 20, 'giri': 51},
    'C000000018': {'nome': 'Marina Bay Street Circuit', 'localita': 'Singapore', 'paese': 'Singapore', 'lunghezza': 5063, 'nr_curve': 23, 'giri': 61},
    'C000000019': {'nome': 'Circuit of The Americas', 'localita': 'Austin', 'paese': 'USA', 'lunghezza': 5513, 'nr_curve': 20, 'giri': 56},
    'C000000020': {'nome': 'Autódromo Hermanos Rodríguez', 'localita': 'Città del Messico', 'paese': 'Messico', 'lunghezza': 4304, 'nr_curve': 17, 'giri': 71},
    'C000000021': {'nome': 'Autódromo José Carlos Pace', 'localita': 'San Paolo', 'paese': 'Brasile', 'lunghezza': 4309, 'nr_curve': 15, 'giri': 71},
    'C000000022': {'nome': 'Las Vegas Strip Circuit', 'localita': 'Las Vegas', 'paese': 'USA', 'lunghezza': 6120, 'nr_curve': 17, 'giri': 50},
    'C000000023': {'nome': 'Lusail International Circuit', 'localita': 'Lusail', 'paese': 'Qatar', 'lunghezza': 5410, 'nr_curve': 16, 'giri': 57},
    'C000000024': {'nome': 'Yas Marina Circuit', 'localita': 'Abu Dhabi', 'paese': 'Emirati Arabi Uniti', 'lunghezza': 5281, 'nr_curve': 21, 'giri': 58}
}

# Dati piloti
piloti_db = {
    44: 'HAMILC44D01H501W',
    16: 'LECCHR16E02H501V'
}

# Genera dati gara e mappa pilota+circuito -> (data, giri)
def generate_gara_data():
    gara_data = []
    gara_index = {}

    for circuito, info in circuiti_db.items():
        data = datetime(2023, random.randint(3, 11), random.randint(1, 28))
        numero_giri = info['giri']

        for _, pilota in piloti_db.items():
            posizione = random.randint(1, 20)
            tempo_sec = numero_giri * random.uniform(85, 110)
            ore = int(tempo_sec // 3600)
            minuti = int((tempo_sec % 3600) // 60)
            secondi = int(tempo_sec % 60)
            millis = int((tempo_sec - int(tempo_sec)) * 1000)
            tempo_totale = f"{ore:02}:{minuti:02}:{secondi:02}.{millis:03}"

            data_str = data.strftime('%Y-%m-%d')

            gara_data.append({
                'pilota': pilota,
                'circuito': circuito,
                'data': data_str,
                'posizione': posizione,
                'tempo_totale': tempo_totale,
                'numero_giri': numero_giri
            })

            gara_index[(pilota, circuito)] = (data_str, numero_giri)

    return gara_data, gara_index

# Genera dati giro usando mappa gare
def generate_giro_data(gara_index):
    giro_data = []

    for (pilota, circuito), (data, numero_giri) in gara_index.items():
        for giro in range(1, numero_giri + 1):
            tempo_sec = random.uniform(75, 120)
            minuti = int(tempo_sec // 60)
            secondi = int(tempo_sec % 60)
            millis = int((tempo_sec - int(tempo_sec)) * 1000)
            tempo = f"00:{minuti:02}:{secondi:02}.{millis:03}"

            giro_data.append({
                'numero_giro': giro,
                'circuito': circuito,
                'data': data,
                'pilota': pilota,
                'tempo': tempo,
                'v_min': round(random.uniform(200, 250), 2),
                'v_max': round(random.uniform(300, 360), 2)
            })

    return giro_data

# Converte i dizionari in istruzioni SQL
def generate_sql_inserts(data, table_name):
    sql_lines = []
    for row in data:
        columns = ', '.join(row.keys())
        values = ', '.join([f"'{v}'" if isinstance(v, str) else str(v) for v in row.values()])
        sql_lines.append(f"INSERT INTO {table_name} ({columns}) VALUES ({values});")
    return sql_lines

# Generazione dati e salvataggio
gara_data, gara_index = generate_gara_data()
giro_data = generate_giro_data(gara_index)

with open('insert_gara.sql', 'w') as f:
    f.write('\n'.join(generate_sql_inserts(gara_data, 'gara')))

with open('insert_giro.sql', 'w') as f:
    f.write('\n'.join(generate_sql_inserts(giro_data, 'giro')))

print("✅ File SQL generati: insert_gara.sql e insert_giro.sql")
