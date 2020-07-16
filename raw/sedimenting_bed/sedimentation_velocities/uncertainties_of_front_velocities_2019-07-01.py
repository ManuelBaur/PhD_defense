#########################################################
#### read and rescale data measured by Manuel Escobedo 
#### according to factor from beam hardening correction
########################################################

import numpy as np
import matplotlib as mpl
mpl.use('Agg') ## needed to create plots when running via ssh
import matplotlib.pyplot as plt 

### plot settings - latex look
font = {'family' : 'serif',
	'weight' : 'normal',
	'size' : 18}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
plt.rc

###############################
### data in 
nam_data = '2019-07-01_sedimentation_vel_tracked_front.dat'


###############################
### load data
data_In = np.loadtxt(nam_data)

n_meas_tot = np.uint32(data_In[:,0]) 
v_front = data_In[:,1] ## front velocity
# v_xdfa = data_In[:,2]
# std_xdfa = data_In[:,3] ### std of xdfa velocity of three different ROIs
pump_rate = data_In[:,3]

##############################################################
## from script '../quantify_magnification/uncertainty_xdfa_scaling.py' 
# u_sxdfa = 0.10446749035216737 * np.ones(len(v_xdfa)) ## uncertainty of the scaling 
# s_xdfa = 9.25470662970663 * np.ones(len(v_xdfa)) ## um/Px
u_mid = 0.05308283344168488 * np.ones(len(v_front)) ## uncertainty of scaling mid plane
s_mid = 9.742434742434742 * np.ones(len(v_front)) ## um/Px

##################################
### total uncertainty - X-DFA
# u_xdfa  = np.sqrt(\
# (u_sxdfa/s_xdfa)**2. + (std_xdfa/v_xdfa)**2.) * v_xdfa


#################################
### total uncertainty of front tracking
u_front = u_mid / s_mid * v_front


###########################################
## relative difference of both velocities
# v_mean = (v_xdfa + v_front) / 2. 
# rel_diff0 = np.abs(v_xdfa - v_front) / v_mean
# rel_diff = np.append(rel_diff0[0:13],rel_diff0[14:27])
# 
# min_rel_diff = np.amin(rel_diff)
# max_rel_diff = np.amax(rel_diff)
# mean_rel_diff = np.mean(rel_diff)


##################################
#### save rescaled data
file_velocities = ('2019-07-01_sedimentation_velocities_with_uncertainties.dat')

header_file = 'N_meas, front (um/s), delta front (um/s), pump rate (ul/min)'

np.savetxt(file_velocities, \
np.transpose((n_meas_tot, v_front, u_front, pump_rate)),\
fmt='%02d %.5f %.5f %03d', delimiter=' ', newline='\n', header=header_file)

import pdb; pdb.set_trace()

