import random
from datetime import date, timedelta
import uuid

# === Utilità ===

def random_date(start, end):
    """Genera una data casuale tra start e end"""
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days))

def random_cf():
    """CF casuale (semplificato)"""
    return ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=6)) + \
           ''.join(random.choices('0123456789', k=2)) + 'H501' + random.choice('XYZWVUT')

# === Team Member ===

nomi = ['Alessandro', 'Luca', 'Marco', 'Giovanni', 'Paolo', 'Francesco']
cognomi = ['Rossi', 'Bianchi', 'Verdi', 'Conti', 'Gallo', 'Moretti']
nazionalita = ['Italiana', 'Tedesca', 'Francese']
ruoli = ['ingegnere', 'manager', 'meccanico']
specializzazioni = ['Freni', 'Motori', 'Elettronica', 'Carrozzeria']
lauree = ['Ingegneria Meccanica', 'Ingegneria Aerospaziale', 'Chimica', 'Fisica']
settori = ['Aerodinamica', 'Pista', 'Ricerca e sviluppo', 'Telaio']

team_members = []
for _ in range(10):
    cf = random_cf()
    nome = random.choice(nomi)
    cognome = random.choice(cognomi)
    naz = random.choice(nazionalita)
    nascita = random_date(date(1960, 1, 1), date(2000, 1, 1)).isoformat()
    ruolo = random.choice(ruoli)
    spec = random.choice(specializzazioni) if ruolo == 'meccanico' else 'NULL'
    laurea = random.choice(lauree) if ruolo == 'ingegnere' else 'NULL'
    anni_esp = random.randint(1, 15) if ruolo != 'ingegnere' else 'NULL'
    settore = random.choice(settori)
    team_members.append((cf, nome, cognome, naz, nascita, ruolo, spec, laurea, anni_esp, settore))

# === Contratti ===

contratti = []
for i in range(10):
    id_contratto = f"CT{i+11:08d}"
    inizio = random_date(date(2010, 1, 1), date(2023, 1, 1)).isoformat()
    fine = random_date(date(2025, 1, 1), date(2035, 1, 1)).isoformat() if random.random() < 0.7 else 'NULL'
    compenso = round(random.uniform(1_000_000, 5_000_000), 2)
    bonus = round(random.uniform(100_000, 200_000), 2) if random.random() < 0.5 else 'NULL'
    cf_team = random.choice([tm[0] for tm in team_members]) if random.random() < 0.5 else 'NULL'
    cf_pilota = random.choice(['HAMILC44D01H501W', 'LECCHR16E02H501V']) if cf_team == 'NULL' else 'NULL'
    contratti.append((id_contratto, inizio, fine, compenso, bonus, cf_team, cf_pilota))

# === Generazione SQL ===

# INSERT team_member
print("-- INSERT team_member")
print("INSERT INTO team_member (cf, nome, cognome, nazionalita, data_nascita, ruolo, specializzazione, laurea, anni_esp, settore) VALUES")
for i, tm in enumerate(team_members):
    cf, nome, cognome, naz, nascita, ruolo, spec, laurea, anni_esp, settore = tm
    values = f"('{cf}', '{nome}', '{cognome}', '{naz}', '{nascita}', '{ruolo}', " \
             f"{'NULL' if spec == 'NULL' else f'\'{spec}\''}, " \
             f"{'NULL' if laurea == 'NULL' else f'\'{laurea}\''}, " \
             f"{'NULL' if anni_esp == 'NULL' else anni_esp}, '{settore}')"
    print(values + ("," if i < len(team_members) - 1 else ";"))

print("\n-- INSERT contratto")
print("INSERT INTO contratto (id_contratto, inizio, fine, compenso, bonus_mensile, cf_team, cf_pilota) VALUES")
for i, c in enumerate(contratti):
    id_contratto, inizio, fine, compenso, bonus, cf_team, cf_pilota = c
    values = f"('{id_contratto}', '{inizio}', {f'NULL' if fine == 'NULL' else f'\'{fine}\''}, {compenso}, " \
             f"{'NULL' if bonus == 'NULL' else bonus}, " \
             f"{'NULL' if cf_team == 'NULL' else f'\'{cf_team}\''}, " \
             f"{'NULL' if cf_pilota == 'NULL' else f'\'{cf_pilota}\''})"
    print(values + ("," if i < len(contratti) - 1 else ";"))
