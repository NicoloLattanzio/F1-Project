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
    {'id_circuito': 'CIR01', 'nome': 'Monza', 'localita': 'Monza', 'paese': 'Italia', 'lunghezza': 5.793, 'nr_curve': 11},
    {'id_circuito': 'CIR02', 'nome': 'Silverstone', 'localita': 'Silverstone', 'paese': 'UK', 'lunghezza': 5.891, 'nr_curve': 18},
    {'id_circuito': 'CIR03', 'nome': 'Spa', 'localita': 'Francorchamps', 'paese': 'Belgio', 'lunghezza': 7.004, 'nr_curve': 19},
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
