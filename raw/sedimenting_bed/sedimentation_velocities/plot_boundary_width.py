#########################################################
#### estimate boundary width, create plot and data 
#### 
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
nam_data = 'Sedimentation_velocities_0.dat'

### width of cuvette
d = 10.2 ## (mm)

###############################
### load data
data_In = np.loadtxt(nam_data)

n_meas_tot = np.uint32(data_In[:,0]) 
v_front = data_In[:,1] ## front velocity
v_xdfa = data_In[:,3]
# std_xdfa = data_In[:,3] ### std of xdfa velocity of three different ROIs
pump_rate = data_In[:,5]


##############################################################
## calculate width of boundary
b1 = d/2. * (1. + np.sqrt(1.-2.*(1. - v_front/v_xdfa)))
b2 = d/2. * (1. - np.sqrt(1.-2.*(1. - v_front/v_xdfa)))


##################################
#### save rescaled data
file_boundaries = ('Boundary_width.dat')

header_file = 'N_meas, boundary1 (mm), 2 (mm), pump rate (ul/min)'

np.savetxt(file_boundaries, \
np.transpose((n_meas_tot, b1, b2, pump_rate)),\
fmt='%02d %.5f %.5f %.5f', delimiter=' ', newline='\n', header=header_file)

import pdb; pdb.set_trace()

