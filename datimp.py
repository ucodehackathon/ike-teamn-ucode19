#/usr/bin/env python3

"""

    .. note:: This module is used to import data.
    
    .. moduleauthor:: Dominik Schuldhaus <schuldhaus.dominik@gmail.com>

"""

import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import scipy.signal

from process_signals import compare_two_signals

# set file

file_1 = sys.argv[1]
file_2 = sys.argv[2]

print(compare_two_signals(file_1, file_2))
