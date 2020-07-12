################################################
### plot tau vs q	
#############################################

import numpy as np
from matplotlib import pyplot as plt


###################################################################################################
nam_data = 'taus.dat'
data_taus = np.loadtxt(nam_data)

q_vec = data_taus[:,0]
tau_ballistic = data_taus[:,1]
tau_delta = data_taus[:,2]

###########################################################################################
############### PLOT
########## produce LaTex like fonts
font = {'family' : 'serif',
	'weight' : 'normal',
	'size' : 18}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
plt.rc
fig = plt.figure()
ax = fig.add_subplot(111)

##### define vector with slope = 1
slopeX = [0.008,0.08]
slopeY = [0.8,0.08]

#### plot slope = 1 
ax.plot(slopeX,slopeY,\
color=(0.4,0.4,0.4),linewidth='3.', zorder=0) # linestyle= '--', 
ax.annotate('slope = -1', xy=(0.25,0.15),xycoords='axes fraction', color=(0.2,0.2,0.22))



### plot MSD with floating point positions
plt.scatter(q_vec, tau_ballistic, color=(1.,0.6,0))
plt.scatter(q_vec, tau_delta, color='C2')

ax.tick_params(which='both',direction = 'in')
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')
ax.set_xlabel('wave number, $q$ ($\mu$m$^{-1}$)')
ax.set_ylabel('$\\tau_v (q)$ (s), $\\tau_{\delta v} (q)$ (s)')

ax.set_xlim([7*10**(-3), 1.2*10**(-1)])
# ax.set_ylim([6*10**(-2), 1.5])
ax.set_ylim([6*10**(-2), 40])

ax.set_xscale('log')
ax.set_yscale('log')

fig.savefig('tau_vs_q.pdf',
	format='pdf', bbox_inches='tight')
plt.close()

v_s = 1/(q_vec * tau_ballistic)

import pdb; pdb.set_trace()
















