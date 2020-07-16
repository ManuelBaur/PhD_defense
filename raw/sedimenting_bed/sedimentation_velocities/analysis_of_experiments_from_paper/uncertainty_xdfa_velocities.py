##########################################################
### estimate uncertainties of X-DFA velocites.
### Calibration is done for fixed volume fraction. 
### Thus the uncertainty in the px-to-mm scaling depends 
### on the volume fraction in the experiment. estimate uncertainties of X-DFA velocites.
### Calibration is done for fixed volume fraction. 
### Thus the uncertainty in the px-to-mm scaling depends 
### on the volume fraction in the experiment.
#########################################################

import numpy as np

###################################################
### load data volume fractions in the expanded state of the beds
nam_vol_frac = 'volume_fractions_expanded_beds.dat'
data_vol = np.loadtxt(nam_vol_frac) 

Phi_exp = data_vol[:,6]

nam_sed_vel = 'Sedimentation_velocities.dat'


###############################
### load data from velocity file
data_vel = np.loadtxt(nam_sed_vel)

n_meas = data_vel[:,0]
v_front = data_vel[:,1]
v_xdfa = data_vel[:,2]
std_xdfa = data_vel[:,3]
pump_rate = data_vel[:,4]


###############################
## from scaling of X-DFA via calibration measurement
## varying cuvette width

## mean phi during calibration
Phi_cal = 0.59 * np.ones(len(n_meas))
u_Phi = (Phi_cal - Phi_exp) / Phi_exp ## relative uncertainty

## relative posittion in the cuvette to rescale px to mm for xdfa
z_s = 0.1825 * np.ones(len(n_meas))
#### comment: uncertainty u_Phi by far too large. 
#### difference in Phi does not linearly result in uncertainty of scaling
u_s0 = z_s * u_Phi ### absolute uncertainty on scaling
u_s = z_s * 0.03

u_xdfa = np.sqrt(\
(std_xdfa/v_xdfa)**2. + (u_s/z_s)**2.) * v_xdfa

###################################
## relative difference of v_xdfa - v_front
rel_diff = np.abs(v_xdfa - v_front) / v_xdfa
rel_diff_a = np.append(rel_diff[0:13],rel_diff[14:27])

mean_rel_diff = np.mean(rel_diff_a)

import pdb; pdb.set_trace()
