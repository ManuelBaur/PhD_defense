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
	'size' : 25}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
# params = {'text.latex.preamble': ['\usepackage{upgreek}']}
# plt.rcParams.update(params)
plt.rc

###############################
### data in 
nam_data = 'Sedimentation_velocities.dat'


###############################
### load data
data_In = np.loadtxt(nam_data)

n_meas_tot = np.uint32(data_In[:,0]) 
v_front = data_In[:,1] ## front velocity
uv_front = data_In[:,2]
v_xdfa = data_In[:,3]
uv_xdfa = data_In[:,4]

###### list of pumprates
pumprate = [750, 700, 650, 600, 550, 500, 450, 400, 350]
N_rate = len(pumprate)


N_meas = [3, 3, 3, 3, 3, 3, 3, 3, 3]  ### number of measurements per pump rate


##############################
### plot attenuation vs z_tilde 
fig1 = plt.figure()	
# plt.gca().set_aspect('equal', adjustable='box')
ax = fig1.add_subplot(111)
ax.tick_params(which='both',direction = 'in')
ax.axis('square')
ax.axis('scaled')
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')
ax.set_xlabel('$\langle v \\rangle_{\mathrm{front}}$ ($\mathrm{\mu}$m/s)')
ax.set_ylabel('$\langle v \\rangle_{\mathrm{xdfa}}$ ($\mathrm{\mu}$m/s)')

ax.set_xlim([40, 135])
ax.set_ylim([40, 135])	
ax.set_xticks((50,75,100,125))
ax.set_yticks((50,75,100,125))

ax.plot([0.,150.], [0.,150.], color='tab:gray', ls='--')

N_meas_tmp = 1 
################ loop over different pumprates
for n_rate in range(N_rate):
	N_meas_rate = 1 ## counter of measurement No in this rate
	
	
	###### loop over measurement for each pumprate
	for n_meas in range(N_meas[n_rate]):
		
		print N_meas_tmp

		
		#### v_tracking front vs v_xdfa
		ax.scatter(v_front[N_meas_tmp-1], v_xdfa[N_meas_tmp-1],\
		marker='.', color = ('C' + str(n_rate)))
		ax.errorbar(v_front[N_meas_tmp-1], v_xdfa[N_meas_tmp-1],\
		xerr=uv_front[N_meas_tmp-1],\
		yerr=uv_xdfa[N_meas_tmp-1],\
		color=('C' + str(n_rate)), capsize=3)



		#### increase counter of No Measurement
		N_meas_tmp = N_meas_tmp + 1 

	####### add a label for every pumprate
	ax.annotate((str(pumprate[n_rate])), \
		xy = (0.9 - (0.03 + 0.094*n_rate), 0.9 - (0.12 + 0.094*n_rate)), \
		xycoords='axes fraction', color=('C' + str(n_rate)))
	
	# import pdb; pdb.set_trace()	
fig1.savefig('Sedimentation_velocites_v_front_vs_v_X-DFA.pdf', 
	format='pdf', dpi=400, bbox_inches='tight')
plt.close()
	

