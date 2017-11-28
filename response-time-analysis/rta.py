# -----------------------------------------------------------------------------
# PROJECT:
# > Resonse Time Analysis
#
# DESCRIPTION: 
# > Response time analysis for a dual-period controller
#
# AUTHOR:
# > Xiaotian Dai, University of York
#
# VERSION:
# > v0.1.1.170629
# -----------------------------------------------------------------------------

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

from math import floor, ceil

DEBUG_MSG = True

def debug_msg(args):
    if DEBUG_MSG:
        print(args)

# -----------------------------------------------------------------------------
# PARAMETERS
# -----------------------------------------------------------------------------
# Flexible control task (high priority) 
# \tau_j = (C_j, T_gamma, T_jH, T_jL, t_s, D_j)
T_gamma = 1000          # hyperperiod
ts = T_gamma * 0.5      # switching point

C_j = 5            # Computation time
T_jH = 10  # T_high (fast control)
T_jL = 20  # T_low (slow control)


# Background task (lower prioirity)
# \tau_i = (C_i, D_i, T_i)
C_i = 0
T_i = 1000
D_i = T_i

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------
# FUNCTION:
# > test response time
# DESCRIPTION: 
# > assuming a response time and test if the result is true
def response_time_test(R):
    Rii = C_i + ( ceil(min(ts, R) / T_jH) + ceil(max(R - ts, 0) / T_jL) ) * C_j
    #debug_msg(R, Rii)
    if R > Rii:
        return False
    else:
        return True


# calculate response time
# (*) R_max is defined by initial value of R_h!
def response_time_analysis():
    R_l = C_i + C_j
    R_h = D_i
    R_i = (R_h + R_l) / 2
    #debug_msg(R_l, R_i, R_h)

    i = 0

    while (R_h - R_l > 1):
        i = i + 1
        #print("\r\niter:{0:d}".format(i))
        if (response_time_test(R_i)):
            R_l = R_i
        else:
            R_h = R_i

        R_i = (R_h + R_l) / 2
        #print(R_l, R_i, R_h)

    R_i = round(R_i)
    #debug_msg("---------------------------------------")
    #debug_msg("\r\nResponse Time is: {0:d}".format(R_i))
    #debug_msg("---------------------------------------")
    return R_i


# find the maximum allowed C_i'
def response_time_find_max_c():
    global C_i
    
    r_i = 0
    c_low = 0
    c_high = D_i
    
    #debug_msg("C_l \t C_i \t C_h \t R_i")
    while (c_high - c_low > 1.1):
        C_i = floor((c_low + c_high) / 2)
        r_i = response_time_analysis()
        if (r_i < D_i):
            c_low = C_i
        elif (r_i >= D_i):
            c_high = C_i
        C_i = c_low
        #debug_msg("{0:<5d} \t {1:<5d} \t {2:<5d} \t {3:<5d}".format(c_low, C_i, c_high, r_i))

    return C_i

# -----------------------------------------------------------------------------
# MAIN (PROGRAM ENTRY)
# -----------------------------------------------------------------------------
debug_msg("-------------------------------")
debug_msg("Th \t Tl \t CC_i")
debug_msg("-------------------------------")

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

for T_jL in range(10, 100 + 1, 5):
    for T_jH in range(10, T_jL + 1, 5):
        CC_i = response_time_find_max_c()
        
        #debug_msg("---------------------------------------")
        debug_msg("{0:d} \t {1:d} \t {2:d}".format(T_jH, T_jL, CC_i))
        #debug_msg("---------------------------------------")
        ax.scatter(T_jL, T_jH, CC_i)
        
# Setting the axes properties
#plt.xlim(0, 1)
#plt.ylim(0, 1)
plt.xlabel('T_l')
plt.ylabel('T_h')
#plt.title('test') 

plt.show()