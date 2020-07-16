################################################
### plot tau vs q	
#############################################

import numpy as np
import math
import matplotlib.colors 
import matplotlib.pyplot as plt

###########################################################################################
############### PLOT
########## produce LaTex like fonts
font = {'family' : 'serif',
	'weight' : 'normal',
	'size' : 25}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
plt.rc
fig = plt.figure()
ax = fig.add_subplot(111)


###################################################################################################
nam_data = 'tQfQt.dat'
data_fQt = np.loadtxt(nam_data)

# ## restrict in q-range - take out 0 mode
# data_fQt = data_fQt0[:,nq_min*2:

# odd : tau * q
# even : f(q,tau q) * beta(q)

N_data = len(data_fQt[0,:]) # 10:-10]) 
len_data = len(data_fQt[:,0])

# tau_q = np.zeros((N_data/2, len_data)) ## sort in odd
# f_tau_q = np.zeros((N_data/2, len_data)) ## sort in even

###### create colorbar according to jet colormap
data_q = np.loadtxt('Names_original.dat')
q_vec = data_q[np.arange(0,N_data,2) + 1]

##### use colormap jet
cmap = plt.get_cmap('jet', len(q_vec))

norm = matplotlib.colors.BoundaryNorm(q_vec, len(q_vec)) # np.arange(len(q_vec)+1)+0.5,len(q_vec))
sm = plt.cm.ScalarMappable(norm = norm, cmap = cmap)
sm.set_array([])



### loop over data and sort for plotting for all wave numbers q
# for n_dat in [84]: # np.arange(2,N_data,2): ## go through data in stepping of two
for n_dat in np.arange(2,N_data,2): ## go through data in stepping of two

	## fill vectors for plotting
	# tau_q[n_dat/2,:] = data_fQt[:,n_dat] ## horizontal axis
	# f_tau_q[n_dat/2 + 1,:] = data_fQt[:,n_dat+1] ## vertical axis
	tau_q = data_fQt[:,n_dat] ## horizontal axis
	f_tau_q = data_fQt[:,n_dat+1] ## vertical axis

	## plotting
	ax.scatter(tau_q, f_tau_q, marker='.',
	 	color = cmap(n_dat/2))

ax.tick_params(which='both',direction = 'in')
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')
ax.set_xlabel('$\\tau q$ (s/$\mu$m)')
ax.set_ylabel('$f(q,\\tau q)$')

ax.set_xlim([3*10**(-4), 3*10**(0)])
ax.set_ylim([-1, 1])

ax.set_xscale('log')


### colorbar
q_vec_ticks = [0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1]
# cbar = fig.colorbar(sm, ticks=np.arange(1., len(q_vec)+1))
c_bar = fig.colorbar(sm, ticks=q_vec_ticks) # ax=ax)
# c_bar.ax.set_ytick([0.009, 0.09])
c_bar.set_label('wave number, $q$ ($\mu$m$^{-1})$')



fig.savefig('fqt_tq.pdf',
	format='pdf', bbox_inches='tight')
plt.close()


import pdb; pdb.set_trace()
















