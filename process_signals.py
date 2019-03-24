import pandas as pd
import numpy as np
from itertools import zip_longest
import math

def load_signals_as_matrices(file):
    # read file
    df = pd.read_csv(file)

    # x, y, z are in columns 1 through 3

    # get accel - left
    l_acc = df.values[:, 0:3]

    # get gyro - left
    l_gyr = df.values[:, 3:6]

    # get accel - right
    r_acc = df.values[:, 6:9]

    # get gyro - right
    r_gyr = df.values[:, 9:12]

    return l_acc, l_gyr, r_acc, r_gyr

def split_signal(sign):
    x, y, z = np.hsplit(sign, 3)
    return x.flatten(), y.flatten(), z.flatten()

def corr_coef_signals(a, b):
    if len(a) < len(b):
        result = np.zeros(len(b))
        result[:len(a)] = a
        a = result
    else:
        result = np.zeros(len(a))
        result[:len(b)] = b
        b = result

    return np.corrcoef(a, b)[1, 0]

def compare_two_signals(file_1, file_2):
    l_acc_1, l_gyr_1, r_acc_1, r_gyr_1 = map(split_signal, load_signals_as_matrices(file_1))
    l_acc_2, l_gyr_2, r_acc_2, r_gyr_2 = map(split_signal, load_signals_as_matrices(file_2))

    l_acc = [(corr_coef_signals(a, b) + 1) / 2 for (a, b) in zip(l_acc_1, l_acc_2)]
    r_acc = [(corr_coef_signals(a, b) + 1) / 2 for (a, b) in zip(r_acc_1, r_acc_2)]
    l_gyr = [(corr_coef_signals(a, b) + 1) / 2 for (a, b) in zip(l_gyr_1, l_gyr_2)]
    r_gyr = [(corr_coef_signals(a, b) + 1) / 2 for (a, b) in zip(r_gyr_1, r_gyr_2)]

    msgs = []

    pct = ((sum(l_acc) / len(l_acc)) + (sum(r_acc) / len(r_acc)) + (sum(l_gyr) / len(l_gyr)) + (sum(r_gyr) / len(r_gyr))) / 4

    if pct > 0.70:
        msgs.append(("¡Bravo! Estás cerca de tu ídolo", 1))
    elif pct < 0.50:
        msgs.append(("Tienes que mejorar", 0))

    if sum(l_gyr) / len(l_gyr) > 0.55:
        msgs.append(("Vas mejorando, sigue así", 1))
    elif sum(l_gyr) / len(l_gyr) > 0.686:
        msgs.append(("¡Muy bien! Estás cerca", 1))

    if l_gyr.index(min(l_gyr)) == 0:
        msgs.append(("Intenta darle mas con el interior", 0))
    elif l_gyr.index(min(l_gyr)) == 1:
        msgs.append(("Prueba a darle mas con el empeine", 0))
    else:
        msgs.append(("Tienes que controlar el balón mejor", 0))

    max_x_1 = 0
    max_y_1 = 0
    max_z_1 = 0
    
    max_x_2 = 0
    max_y_2 = 0
    max_z_2 = 0
    for i in range(0, len(l_acc_1[0])):
        max_x_1 += l_acc_1[0][i] ** 2
        max_y_1 += l_acc_1[1][i] ** 2
        max_z_1 += l_acc_1[2][i] ** 2

        max_x_2 += l_acc_2[0][i] ** 2
        max_y_2 += l_acc_2[1][i] ** 2
        max_z_2 += l_acc_2[2][i] ** 2

    max_acc_1 = max(math.sqrt(max_x_1), math.sqrt(max_y_1), math.sqrt(max_z_1))
    max_acc_2 = max(math.sqrt(max_x_2), math.sqrt(max_y_2), math.sqrt(max_z_2))

    if max_acc_2 > max_acc_1:
        pot = int(max_acc_1 / max_acc_2 * 10)
    else:
        pot = int(max_acc_2 / max_acc_1 * 10)

    return {
        'pct': pct,
        'msgs': msgs,
        'pot': pot,
    }
