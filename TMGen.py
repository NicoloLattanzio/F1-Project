import csv
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker('it_IT')

ruoli = ['ingegnere', 'meccanico', 'manager']
settori_possibili = ['motori', 'aerodinamica', 'pista']

def genera_team_members(n):
    membri = []
    for _ in range(n):
        # Genero un cf fittizio, solo come ID unico
        cf = fake.bothify(text='????????????????').upper()

        nome = fake.first_name()
        cognome = fake.last_name()
        nazionalita = 'Italia'
        data_nascita = fake.date_of_birth(minimum_age=22, maximum_age=65)
        ruolo = random.choice(ruoli)
        settore = random.choice(settori_possibili)

        specializzazione = None
        laurea = None
        anni_esp = None

        if ruolo == 'ingegnere':
            laurea = fake.job()
        elif ruolo == 'meccanico':
            specializzazione = fake.word()
            anni_esp = random.randint(1, 30)
        elif ruolo == 'manager':
            anni_esp = random.randint(1, 30)

        membri.append({
            'cf': cf,
            'nome': nome,
            'cognome': cognome,
            'nazionalita': nazionalita,
            'data_nascita': data_nascita.isoformat(),
            'ruolo': ruolo,
            'specializzazione': specializzazione,
            'laurea': laurea,
            'anni_esp': anni_esp,
            'settore': settore
        })
    return membri

def genera_contratti(membri):
    contratti = []
    for i, membro in enumerate(membri):
        id_contratto = f"C{i+1:04d}"
        inizio = fake.date_between(start_date='-10y', end_date='-1y')
        # Contratti con fine oppure ancora attivi
        if random.random() < 0.7:
            fine = fake.date_between(start_date=inizio + timedelta(days=30), end_date='today')
        else:
            fine = None

        compenso = round(random.uniform(2000, 15000), 2)
        bonus_mensile = round(random.uniform(0, 2000), 2) if random.random() < 0.5 else None

        contratti.append({
            'id_contratto': id_contratto,
            'inizio': inizio.isoformat(),
            'fine': fine.isoformat() if fine else None,
            'compenso': compenso,
            'bonus_mensile': bonus_mensile,
            'cf_team': membro['cf'],
            'cf_pilota': None
        })
    return contratti

def scrivi_csv_team_member(membri, filename='team_member.csv'):
    intestazioni = ['cf', 'nome', 'cognome', 'nazionalita', 'data_nascita', 'ruolo',
                   'specializzazione', 'laurea', 'anni_esp', 'settore']
    with open(filename, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=intestazioni)
        writer.writeheader()
        writer.writerows(membri)

def scrivi_csv_contratti(contratti, filename='contratto.csv'):
    intestazioni = ['id_contratto', 'inizio', 'fine', 'compenso', 'bonus_mensile', 'cf_team', 'cf_pilota']
    with open(filename, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=intestazioni)
        writer.writeheader()
        writer.writerows(contratti)

# --- Genera dati ---
membri = genera_team_members(1500)
contratti = genera_contratti(membri)

# --- Scrivi su file CSV ---
scrivi_csv_team_member(membri)
scrivi_csv_contratti(contratti)

print("✅ File team_member.csv e contratto.csv generati senza CF (codice fiscale).")
