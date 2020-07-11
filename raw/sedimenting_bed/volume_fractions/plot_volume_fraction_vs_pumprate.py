#####################################################################
### Plot volume fractions vs pumprate of all measurement days
#######################################################################

import numpy as np
import os
import shutil ### to copy datafiles
# import glob
import matplotlib as mpl
mpl.use('Agg') ## needed to create plots when running via ssh
import matplotlib.pyplot as plt 

### plot settings - latex look
font = {'family' : 'sans serif',
	'weight' : 'normal',
	'size' : 18}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
plt.rc

# ### plot settings - latex look
# font = {'weight' : 'normal',
# 	'size' : 18}
# # plt.rc('text', usetex=True)
# plt.rc('font', **font) # family='serif')
# plt.rc

###########################################################################
#### create figure 
fig1 = plt.figure()	



### subplot with position of edge 
ax = fig1.add_subplot(111)
ax.tick_params(which='both',direction = 'in')
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')
ax.set_xlabel('Pump rate, $Q$ ($\mu$l/min)')
ax.set_ylabel('Volume fraction, $\Phi$')
ax.set_xlim([250, 800])
ax.set_ylim([0.44, 0.57])


##################################################
#### load data
nam_data_in = 'volume_fractions_expanded_beds_with_uncertainties.dat'
data_in = np.loadtxt(nam_data_in)

Phi = data_in[:,3]	
u_Phi = data_in[:,4]
pump_rate = data_in[:,5]

## systematic error from measure of total cuvette height 
ax.errorbar(pump_rate[-1], Phi[-1], yerr = u_Phi[-1],\
marker = 'o', color='red', capsize=3, zorder = 0)


#### plot volume fraction vs pump rate	 
ax.scatter(pump_rate, Phi, \
marker='o', edgecolor='red', facecolor=(1,1,1), linewidth=2) # , alpha=.5) 
# ax.errorbar(pump_rate, Phi,\
# yerr=u_Phi,\
# color='red', capsize=3)

	
###### save plot of current pumprate
fig1.savefig('Phi_vs_pump_rate.pdf',
	format='pdf',dpi=400,bbox_inches='tight')

plt.close()
		
	
import pdb; pdb.set_trace()  		

