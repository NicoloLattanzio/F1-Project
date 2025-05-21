import csv
import random
from datetime import datetime, timedelta

circuiti = {
    1:  {'giri': 57, 't_min': 93.5,  't_max': 102.0, 'v_max': 335, 'v_min': 285},  # Bahrain
    2:  {'giri': 50, 't_min': 88.0,  't_max': 96.5,  'v_max': 345, 'v_min': 295},  # Arabia Saudita
    3:  {'giri': 58, 't_min': 81.2,  't_max': 88.5,  'v_max': 315, 'v_min': 270},  # Australia
    4:  {'giri': 53, 't_min': 101.5, 't_max': 109.0, 'v_max': 330, 'v_min': 285},  # Giappone
    5:  {'giri': 56, 't_min': 105.8, 't_max': 113.5, 'v_max': 320, 'v_min': 275},  # Cina
    6:  {'giri': 57, 't_min': 95.8,  't_max': 103.5, 'v_max': 325, 'v_min': 280},  # Miami
    7:  {'giri': 63, 't_min': 82.5,  't_max': 90.0,  'v_max': 315, 'v_min': 265},  # Imola
    8:  {'giri': 78, 't_min': 72.5,  't_max': 79.0,  'v_max': 295, 'v_min': 250},  # Monaco
    9:  {'giri': 70, 't_min': 74.8,  't_max': 82.2,  'v_max': 315, 'v_min': 265},  # Canada
    10: {'giri': 66, 't_min': 83.5,  't_max': 91.0,  'v_max': 325, 'v_min': 275},  # Spagna
    11: {'giri': 71, 't_min': 66.8,  't_max': 74.2,  'v_max': 325, 'v_min': 280},  # Austria
    12: {'giri': 52, 't_min': 90.5,  't_max': 98.0,  'v_max': 340, 'v_min': 295},  # Silverstone
    13: {'giri': 70, 't_min': 86.3,  't_max': 93.8,  'v_max': 310, 'v_min': 265},  # Ungheria
    14: {'giri': 44, 't_min': 110.0, 't_max': 118.5, 'v_max': 360, 'v_min': 310},  # Belgio (Spa)
    15: {'giri': 72, 't_min': 73.5,  't_max': 80.0,  'v_max': 310, 'v_min': 260},  # Olanda
    16: {'giri': 53, 't_min': 78.0,  't_max': 85.5,  'v_max': 355, 'v_min': 310},  # Italia (Monza)
    17: {'giri': 71, 't_min': 95.0,  't_max': 102.5, 'v_max': 320, 'v_min': 275},  # Baku
    18: {'giri': 62, 't_min': 113.0, 't_max': 121.5, 'v_max': 305, 'v_min': 260},  # Singapore
    19: {'giri': 56, 't_min': 92.3,  't_max': 100.0, 'v_max': 335, 'v_min': 290},  # Austin
    20: {'giri': 71, 't_min': 76.8,  't_max': 84.2,  'v_max': 340, 'v_min': 295},  # Messico
    21: {'giri': 50, 't_min': 105.5, 't_max': 113.0, 'v_max': 345, 'v_min': 295},  # Las Vegas
    22: {'giri': 57, 't_min': 95.2,  't_max': 104.5, 'v_max': 330, 'v_min': 285},  # Qatar
    23: {'giri': 58, 't_min': 100.5, 't_max': 110.0, 'v_max': 325, 'v_min': 275},  # Abu Dhabi
    24: {'giri': 57, 't_min': 98.5,  't_max': 106.0, 'v_max': 315, 'v_min': 270}   # Brasile
}

piloti = [16, 44]

# Inserimento date personalizzate per ogni circuito
date_gp = {
    1: '02-03-2024',
    2: '09-03-2024',
    3: '24-03-2024',
    4: '07-04-2024',
    5: '21-04-2024',
    6: '05-05-2024',
    7: '19-05-2024',
    8: '26-05-2024',
    9: '09-06-2024',
    10: '23-06-2024',
    11: '30-06-2024',
    12: '07-07-2024',
    13: '21-07-2024',
    14: '28-07-2024',
    15: '25-08-2024',
    16: '01-09-2024',
    17: '15-09-2024',
    18: '22-09-2024',
    19: '20-10-2024',
    20: '27-10-2024',
    21: '03-11-2024',
    22: '24-11-2024',
    23: '01-12-2024',
    24: '08-12-2024',
}


def format_tempo(seconds):
    td = timedelta(seconds=seconds)
    total_seconds = int(td.total_seconds())
    hours = total_seconds // 3600
    minutes = (total_seconds % 3600) // 60
    secs = total_seconds % 60
    millis = int((td.total_seconds() - total_seconds) * 1000)
    return f"{hours:02}:{minutes:02}:{secs:02}.{millis:03}"


with open('giri.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['Data', 'IdCircuito', 'NumeroGiro', 'NumeroPilota', 'Tempo', 'VelocitaMax', 'VelocitaMin'])

    for circuito_id, params in circuiti.items():
        data_gp_corrente = date_gp[circuito_id]
        for giro in range(1, params['giri'] + 1):
            for pilota in piloti:
                sec = round(random.uniform(params['t_min'], params['t_max']), 3)
                tempo_formattato = format_tempo(sec)
                vel_max = round(params['v_max'] + random.random() * 3 + (giro * 0.1), 2)
                vel_min = round(params['v_min'] + random.random() * 2 + (giro * 0.05), 2)

                writer.writerow([
                    data_gp_corrente,
                    circuito_id,
                    giro,
                    pilota,
                    tempo_formattato,
                    vel_max,
                    vel_min
                ])
