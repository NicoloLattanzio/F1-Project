import csv
import random
from datetime import datetime, timedelta
import os

# Dati preesistenti dai file forniti
circuiti_db = {
    'C000000001': {'nome': 'Bahrain International Circuit', 'localita': 'Sakhir', 'paese': 'Bahrain', 'lunghezza': 5412, 'nr_curve': 15},
    'C000000002': {'nome': 'Jeddah Corniche Circuit', 'localita': 'Gedda', 'paese': 'Arabia Saudita', 'lunghezza': 6174, 'nr_curve': 27},
    'C000000003': {'nome': 'Albert Park Circuit', 'localita': 'Melbourne', 'paese': 'Australia', 'lunghezza': 5278, 'nr_curve': 14},
    'C000000004': {'nome': 'Suzuka International Racing Course', 'localita': 'Suzuka', 'paese': 'Giappone', 'lunghezza': 5807, 'nr_curve': 18},
    'C000000005': {'nome': 'Shanghai International Circuit', 'localita': 'Shanghai', 'paese': 'Cina', 'lunghezza': 5451, 'nr_curve': 16},
    'C000000006': {'nome': 'Miami International Autodrome', 'localita': 'Miami', 'paese': 'USA', 'lunghezza': 5410, 'nr_curve': 19},
    'C000000007': {'nome': 'Autodromo Enzo e Dino Ferrari', 'localita': 'Imola', 'paese': 'Italia', 'lunghezza': 4909, 'nr_curve': 19},
    'C000000008': {'nome': 'Circuit de Monaco', 'localita': 'Monte Carlo', 'paese': 'Monaco', 'lunghezza': 3337, 'nr_curve': 19},
    'C000000009': {'nome': 'Circuit Gilles Villeneuve', 'localita': 'Montréal', 'paese': 'Canada', 'lunghezza': 4361, 'nr_curve': 14},
    'C000000010': {'nome': 'Circuit de Barcelona-Catalunya', 'localita': 'Barcellona', 'paese': 'Spagna', 'lunghezza': 4675, 'nr_curve': 16},
    'C000000011': {'nome': 'Red Bull Ring', 'localita': 'Spielberg', 'paese': 'Austria', 'lunghezza': 4318, 'nr_curve': 10},
    'C000000012': {'nome': 'Silverstone Circuit', 'localita': 'Silverstone', 'paese': 'Regno Unito', 'lunghezza': 5891, 'nr_curve': 18},
    'C000000013': {'nome': 'Hungaroring', 'localita': 'Mogyoród', 'paese': 'Ungheria', 'lunghezza': 4381, 'nr_curve': 14},
    'C000000014': {'nome': 'Circuit de Spa-Francorchamps', 'localita': 'Stavelot', 'paese': 'Belgio', 'lunghezza': 7004, 'nr_curve': 19},
    'C000000015': {'nome': 'Circuit Zandvoort', 'localita': 'Zandvoort', 'paese': 'Paesi Bassi', 'lunghezza': 4259, 'nr_curve': 14},
    'C000000016': {'nome': 'Autodromo Nazionale Monza', 'localita': 'Monza', 'paese': 'Italia', 'lunghezza': 5793, 'nr_curve': 11},
    'C000000017': {'nome': 'Baku City Circuit', 'localita': 'Baku', 'paese': 'Azerbaigian', 'lunghezza': 6003, 'nr_curve': 20},
    'C000000018': {'nome': 'Marina Bay Street Circuit', 'localita': 'Singapore', 'paese': 'Singapore', 'lunghezza': 5063, 'nr_curve': 23},
    'C000000019': {'nome': 'Circuit of The Americas', 'localita': 'Austin', 'paese': 'USA', 'lunghezza': 5513, 'nr_curve': 20},
    'C000000020': {'nome': 'Autódromo Hermanos Rodríguez', 'localita': 'Città del Messico', 'paese': 'Messico', 'lunghezza': 4304, 'nr_curve': 17},
    'C000000021': {'nome': 'Autódromo José Carlos Pace', 'localita': 'San Paolo', 'paese': 'Brasile', 'lunghezza': 4309, 'nr_curve': 15},
    'C000000022': {'nome': 'Las Vegas Strip Circuit', 'localita': 'Las Vegas', 'paese': 'USA', 'lunghezza': 6120, 'nr_curve': 17},
    'C000000023': {'nome': 'Lusail International Circuit', 'localita': 'Lusail', 'paese': 'Qatar', 'lunghezza': 5410, 'nr_curve': 16},
    'C000000024': {'nome': 'Yas Marina Circuit', 'localita': 'Abu Dhabi', 'paese': 'Emirati Arabi Uniti', 'lunghezza': 5281, 'nr_curve': 21}
}

# Aggiunta numero giri casuale per ogni circuito (tra 50 e 70)
for circuito in circuiti_db.values():
    circuito['giri'] = random.randint(50, 70)

piloti_db = {
    44: 'HAMILC44D01H501W',
    16: 'LECCHR16E02H501V'
}

# Genera dati gara casuali
def generate_gara_data():
    gara_data = []
    for circuit_id, circuit_info in circuiti_db.items():
        race_date = datetime(2023, random.randint(3, 11), random.randint(1, 28))
        numero_giri = circuit_info['giri']

        for driver_id, driver_cf in piloti_db.items():
            posizione = random.randint(1, 20)

            # Tempo totale in secondi e formato hh:mm:ss.mmm
            base_time = numero_giri * random.uniform(85, 110)
            ore = int(base_time // 3600)
            minuti = int((base_time % 3600) // 60)
            secondi = int(base_time % 60)
            millis = int((base_time - int(base_time)) * 1000)
            tempo_totale = f"{ore:02}:{minuti:02}:{secondi:02}.{millis:03}"

            gara_data.append({
                'pilota': driver_cf,
                'id_circuito': circuit_id,
                'data': race_date.strftime('%Y-%m-%d'),
                'posizione': posizione,
                'tempo_totale': tempo_totale,
                'numero_giri': numero_giri
            })
    return gara_data

# Genera dati giro casuali
def generate_giro_data():
    giro_data = []
    for circuit_id, circuit_info in circuiti_db.items():
        race_date = datetime(2023, random.randint(3, 11), random.randint(1, 28))
        numero_giri = circuit_info['giri']

        for driver_id, driver_cf in piloti_db.items():
            for giro_num in range(1, numero_giri + 1):
                tempo_giro = random.uniform(75, 120)
                min_sec = int(tempo_giro // 60)
                sec = int(tempo_giro % 60)
                millis = int((tempo_giro - int(tempo_giro)) * 1000)
                tempo = f"00:{min_sec:02}:{sec:02}.{millis:03}"

                giro_data.append({
                    'numero_giro': giro_num,
                    'id_circuito': circuit_id,
                    'data': race_date.strftime('%Y-%m-%d'),
                    'pilota': driver_cf,
                    'tempo': tempo,
                    'v_min': round(random.uniform(200, 250), 2),
                    'v_max': round(random.uniform(300, 360), 2)
                })
    return giro_data

# Converti dati in SQL
def generate_sql_inserts(data, table_name):
    sql_lines = []
    for row in data:
        columns = ', '.join(row.keys())
        values = ', '.join([
            f"'{value}'" if isinstance(value, str) else str(value)
            for value in row.values()
        ])
        sql_lines.append(f"INSERT INTO {table_name} ({columns}) VALUES ({values});")
    return sql_lines

# Genera e salva i dati
gara_data = generate_gara_data()
giro_data = generate_giro_data()

with open('insert_gara.sql', 'w') as f:
    f.write('\n'.join(generate_sql_inserts(gara_data, 'gara')))

with open('insert_giro.sql', 'w') as f:
    f.write('\n'.join(generate_sql_inserts(giro_data, 'giro')))

print("File SQL generati: insert_gara.sql e insert_giro.sql")
