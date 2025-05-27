import csv
from faker import Faker
import random

fake = Faker('it_IT')

def genera_cf():
    # Codice fiscale simulato: 6 lettere + 10 cifre
    return ''.join(fake.random_uppercase_letter() for _ in range(6)) + ''.join(str(random.randint(0, 9)) for _ in range(10))

def genera_team_members(n):
    ruoli = ['ingegnere', 'meccanico', 'manager']
    settori_possibili = ['motori', 'aerodinamica', 'pista']
    membri = []

    for _ in range(n):
        cf = genera_cf()
        nome = fake.first_name()
        cognome = fake.last_name()
        nazionalita = 'Italia'  # Fisso
        data_nascita = fake.date_of_birth(minimum_age=22, maximum_age=65).isoformat()
        ruolo = random.choice(ruoli)
        settore = random.choice(settori_possibili)

        # Attributi variabili per ruolo
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

        membri.append([
            cf,
            nome,
            cognome,
            nazionalita,
            data_nascita,
            ruolo,
            specializzazione,
            laurea,
            anni_esp,
            settore
        ])
    return membri

def scrivi_csv(membri, nome_file):
    intestazioni = ['cf', 'nome', 'cognome', 'nazionalita', 'data_nascita', 'ruolo', 'specializzazione', 'laurea', 'anni_esp', 'settore']
    with open(nome_file, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(intestazioni)
        writer.writerows(membri)

# Esegui generazione
membri = genera_team_members(1500)  # Cambia 50 con il numero di righe desiderato
scrivi_csv(membri, 'team_member.csv')
print("✅ File 'team_member.csv' creato con nazionalità italiana.")
