import csv
import random
from datetime import date, timedelta
from faker import Faker

fake = Faker('it_IT')

# --- Piloti fissi ---
piloti = [
    {
        'cf': 'SNZCRL99M01H501J',
        'nome': 'Carlos',
        'cognome': 'Sainz',
        'nazionalita': 'Italia',
        'data_nascita': '1999-05-01',
        'ruolo': 'pilota',
        'specializzazione': None,
        'laurea': None,
        'anni_esp': None,
        'settore': 'pista'
    },
    {
        'cf': 'LCRCHR97M16F839A',
        'nome': 'Charles',
        'cognome': 'Leclerc',
        'nazionalita': 'Italia',
        'data_nascita': '1997-10-16',
        'ruolo': 'pilota',
        'specializzazione': None,
        'laurea': None,
        'anni_esp': None,
        'settore': 'pista'
    }
]

# --- Genera membri del team casuali ---
def genera_team_member(n):
    membri = []
    ruoli = ['ingegnere', 'meccanico', 'manager']
    for i in range(n):
        ruolo = random.choice(ruoli)
        nome = fake.first_name()
        cognome = fake.last_name()
        cf = fake.bothify(text='????????????????')  # usa un placeholder semplice per CF
        data_nascita = fake.date_of_birth(minimum_age=22, maximum_age=60).isoformat()
        settore = random.choice(['progettazione', 'pista', 'amministrazione'])
        # Campi condizionali in base al ruolo
        if ruolo == 'meccanico':
            specializzazione = fake.job()
            laurea = None
            anni_esp = random.randint(1, 20)
        elif ruolo == 'ingegnere':
            specializzazione = None
            laurea = fake.word().capitalize()
            anni_esp = None
        else:  # manager
            specializzazione = None
            laurea = None
            anni_esp = random.randint(3, 30)

        membri.append({
            'cf': cf,
            'nome': nome,
            'cognome': cognome,
            'nazionalita': 'Italia',
            'data_nascita': data_nascita,
            'ruolo': ruolo,
            'specializzazione': specializzazione,
            'laurea': laurea,
            'anni_esp': anni_esp,
            'settore': settore
        })
    return membri

team_member_casuali = genera_team_member(20)  # ad es. 20 membri casuali

# --- Unisci piloti e team member ---
team_member = piloti + team_member_casuali

# --- Genera contratti per tutti i team member ---
contratti = []
oggi = date.today()

for i, membro in enumerate(team_member):
    id_contratto = f"C{i+1:04d}"
    inizio = oggi - timedelta(days=random.randint(365, 365*5))  # contratto iniziato da 1-5 anni fa
    # 50% chance che il contratto sia ancora attivo (fine = NULL)
    if random.random() < 0.5:
        fine = None
    else:
        fine = inizio + timedelta(days=random.randint(365, 365*4))
        if fine > oggi:
            fine = oggi
    compenso = round(random.uniform(30000, 3000000), 2)
    bonus = round(random.uniform(0, 100000), 2)
    cf_team = None
    cf_pilota = None

    if membro['ruolo'] == 'pilota':
        cf_pilota = membro['cf']
    else:
        cf_team = membro['cf']

    contratti.append({
        'id_contratto': id_contratto,
        'inizio': inizio.isoformat(),
        'fine': fine.isoformat() if fine else None,
        'compenso': compenso,
        'bonus_mensile': bonus,
        'cf_team': cf_team,
        'cf_pilota': cf_pilota
    })

# --- Circuiti fissi ---
circuiti = [
    {'id_circuito': 'CIR01', 'nome': 'Bahrain International Circuit', 'localita': 'Sakhir', 'paese': 'Bahrain', 'lunghezza': 5412, 'nr_curve': 15},
    {'id_circuito': 'CIR02', 'nome': 'Jeddah Corniche Circuit', 'localita': 'Gedda', 'paese': 'Arabia Saudita', 'lunghezza': 6174, 'nr_curve': 27},
    {'id_circuito': 'CIR03', 'nome': 'Albert Park Circuit', 'localita': 'Melbourne', 'paese': 'Australia', 'lunghezza': 5278, 'nr_curve': 14},
    {'id_circuito': 'CIR04', 'nome': 'Suzuka International Racing Course', 'localita': 'Suzuka', 'paese': 'Giappone', 'lunghezza': 5807, 'nr_curve': 18},
    {'id_circuito': 'CIR05', 'nome': 'Shanghai International Circuit', 'localita': 'Shanghai', 'paese': 'Cina', 'lunghezza': 5451, 'nr_curve': 16},
    {'id_circuito': 'CIR06', 'nome': 'Miami International Autodrome', 'localita': 'Miami', 'paese': 'USA', 'lunghezza': 5410, 'nr_curve': 19},
    {'id_circuito': 'CIR07', 'nome': 'Autodromo Enzo e Dino Ferrari', 'localita': 'Imola', 'paese': 'Italia', 'lunghezza': 4909, 'nr_curve': 19},
    {'id_circuito': 'CIR08', 'nome': 'Circuit de Monaco', 'localita': 'Monte Carlo', 'paese': 'Monaco', 'lunghezza': 3337, 'nr_curve': 19},
    {'id_circuito': 'CIR09', 'nome': 'Circuit Gilles Villeneuve', 'localita': 'Montréal', 'paese': 'Canada', 'lunghezza': 4361, 'nr_curve': 14},
    {'id_circuito': 'CIR10', 'nome': 'Circuit de Barcelona-Catalunya', 'localita': 'Barcellona', 'paese': 'Spagna', 'lunghezza': 4675, 'nr_curve': 16},
    {'id_circuito': 'CIR11', 'nome': 'Red Bull Ring', 'localita': 'Spielberg', 'paese': 'Austria', 'lunghezza': 4318, 'nr_curve': 10},
    {'id_circuito': 'CIR12', 'nome': 'Silverstone Circuit', 'localita': 'Silverstone', 'paese': 'Regno Unito', 'lunghezza': 5891, 'nr_curve': 18},
    {'id_circuito': 'CIR13', 'nome': 'Hungaroring', 'localita': 'Mogyoród', 'paese': 'Ungheria', 'lunghezza': 4381, 'nr_curve': 14},
    {'id_circuito': 'CIR14', 'nome': 'Circuit de Spa-Francorchamps', 'localita': 'Stavelot', 'paese': 'Belgio', 'lunghezza': 7004, 'nr_curve': 19},
    {'id_circuito': 'CIR15', 'nome': 'Circuit Zandvoort', 'localita': 'Zandvoort', 'paese': 'Paesi Bassi', 'lunghezza': 4259, 'nr_curve': 14},
    {'id_circuito': 'CIR16', 'nome': 'Autodromo Nazionale Monza', 'localita': 'Monza', 'paese': 'Italia', 'lunghezza': 5793, 'nr_curve': 11},
    {'id_circuito': 'CIR17', 'nome': 'Baku City Circuit', 'localita': 'Baku', 'paese': 'Azerbaigian', 'lunghezza': 6003, 'nr_curve': 20},
    {'id_circuito': 'CIR18', 'nome': 'Marina Bay Street Circuit', 'localita': 'Singapore', 'paese': 'Singapore', 'lunghezza': 5063, 'nr_curve': 23},
    {'id_circuito': 'CIR19', 'nome': 'Circuit of The Americas', 'localita': 'Austin', 'paese': 'USA', 'lunghezza': 5513, 'nr_curve': 20},
    {'id_circuito': 'CIR20', 'nome': 'Autódromo Hermanos Rodríguez', 'localita': 'Città del Messico', 'paese': 'Messico', 'lunghezza': 4304, 'nr_curve': 17},
    {'id_circuito': 'CIR21', 'nome': 'Autódromo José Carlos Pace', 'localita': 'San Paolo', 'paese': 'Brasile', 'lunghezza': 4309, 'nr_curve': 15},
    {'id_circuito': 'CIR22', 'nome': 'Las Vegas Strip Circuit', 'localita': 'Las Vegas', 'paese': 'USA', 'lunghezza': 6120, 'nr_curve': 17},
    {'id_circuito': 'CIR23', 'nome': 'Lusail International Circuit', 'localita': 'Lusail', 'paese': 'Qatar', 'lunghezza': 5410, 'nr_curve': 16},
    {'id_circuito': 'CIR24', 'nome': 'Yas Marina Circuit', 'localita': 'Abu Dhabi', 'paese': 'Emirati Arabi Uniti', 'lunghezza': 5281, 'nr_curve': 21},
]

# --- Genera GP negli ultimi 3 mesi ogni 30 giorni ---
gp_list = []
for circuit in circuiti:
    for i in range(0, 90, 30):
        data_gp = oggi - timedelta(days=i)
        gp_list.append({
            'circuito': circuit['id_circuito'],
            'data': data_gp.isoformat(),
            'condizioni_meteo': random.choice(['sereno', 'pioggia', 'nuvoloso', 'vento'])
        })

# --- Gare per piloti fissi ---
gare = []
for gp in gp_list:
    piloti_ordinati = piloti[:]
    random.shuffle(piloti_ordinati)
    posizione = 1
    for pilota in piloti_ordinati:
        tempo_totale = random.randint(5400000, 7200000)  # 1.5-2 ore in ms
        gare.append({
            'pilota': pilota['cf'],
            'circuito': gp['circuito'],
            'data': gp['data'],
            'posizione': posizione,
            'tempo_totale': tempo_totale
        })
        posizione += 1

# --- Funzione per scrivere CSV ---
def scrivi_csv(filename, data, headers):
    with open(filename, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        writer.writerows(data)

# --- Scrittura CSV ---
scrivi_csv('team_member.csv', team_member, ['cf', 'nome', 'cognome', 'nazionalita', 'data_nascita', 'ruolo', 'specializzazione', 'laurea', 'anni_esp', 'settore'])
scrivi_csv('contratto.csv', contratti, ['id_contratto', 'inizio', 'fine', 'compenso', 'bonus_mensile', 'cf_team', 'cf_pilota'])
scrivi_csv('circuito.csv', circuiti, ['id_circuito', 'nome', 'localita', 'paese', 'lunghezza', 'nr_curve'])
scrivi_csv('gp.csv', gp_list, ['circuito', 'data', 'condizioni_meteo'])
scrivi_csv('gara.csv', gare, ['pilota', 'circuito', 'data', 'posizione', 'tempo_totale'])

print("File CSV generati: team_member.csv, contratto.csv, circuito.csv, gp.csv, gara.csv")
