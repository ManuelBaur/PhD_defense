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
old_scale = 0.00973 # mm/px (relative to mid plane of cuvette)
new_scale = 0.00943 # mm/px (after calibration via beam hardening correction)


nam_Or_data = 'summary_2019-07-02_ROI.dat'

data_Or = np.loadtxt(nam_Or_data)

n_meas_tot = np.arange(27) + 1
pump_rateIn = np.uint32(data_Or[:,0])

track_front = data_Or[:,4]
xdfa_Or = data_Or[:,5]
xdfa_scaled = xdfa_Or / old_scale * new_scale 
u_xdfa= data_Or[:,6]
u_xdfa_scaled = u_xdfa / old_scale * new_scale


###### list of pumprates
pumprate = [750, 700, 650, 600, 550, 500, 450, 400, 350]
N_rate = len(pumprate)


N_meas = [3, 3, 3, 3, 3, 3, 3, 3, 3]  ### number of measurements per pump rate


##############################
### plot attenuation vs z_tilde 
fig1 = plt.figure()	
# fig1.suptitle('Measurement day: 2019-07-02')

ax = fig1.add_subplot(111)
ax.tick_params(which='both',direction = 'in')
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')
ax.set_xlabel('No.\ of measurement')
ax.set_ylabel('Sedimentation velocity ($\mathrm{\mu}$m/s)')
ax.set_xlim([0, 28])
ax.set_ylim([40, 150])	


N_meas_tmp = 1 
################ loop over different pumprates
for n_rate in range(N_rate):
	N_meas_rate = 1 ## counter of measurement No in this rate
	
	
	###### loop over measurement for each pumprate
	for n_meas in range(N_meas[n_rate]):
		
		print N_meas_tmp

		
		#### tracking front
		ax.scatter(n_meas_tot[N_meas_tmp-1], track_front[N_meas_tmp-1],\
		marker='o', color = ('C' + str(n_rate)))
		
		#### old scaling X-DFA
		ax.scatter(n_meas_tot[N_meas_tmp-1], xdfa_Or[N_meas_tmp-1],\
		marker='d', color = ('C' + str(n_rate)))

		#### new scaling X-DFA
		ax.scatter(n_meas_tot[N_meas_tmp-1], xdfa_scaled[N_meas_tmp-1],\
		marker='x', color = ('C' + str(n_rate)))
		ax.errorbar(n_meas_tot[N_meas_tmp-1], xdfa_scaled[N_meas_tmp-1],\
		yerr=u_xdfa_scaled[N_meas_tmp-1], color=('C' + str(n_rate)))


		#### increase counter of No Measurement
		N_meas_tmp = N_meas_tmp + 1 

	####### add a label for every pumprate
	ax.annotate((str(pumprate[n_rate])), \
		xy = (0.03 + 0.105*n_rate, 0.9), \
		xycoords='axes fraction', color=('C' + str(n_rate)))
	
	###### plot legend
	ax.scatter(2,70, marker='o', color='k')	
	ax.text(3,68, 'front tracking')
	ax.scatter(2,60, marker='d', color='k')
	ax.text(3,58, 'X-DFA old')
	ax.scatter(2,50, marker='x', color='k')
	ax.text(3,48, 'X-DFA new')

fig1.savefig('Sedimentation_velocites.png', 
	format='png', dpi=400, bbox_inches='tight')
plt.close()
	

##################################
#### save rescaled data
file_velocities = ('Sedimentation_velocities.dat')

header_file = 'N_meas, front (um/s), X-DFA (um/s), pump rate (ul/min)'

np.savetxt(file_velocities, \
np.transpose((n_meas_tot, track_front, xdfa_scaled, u_xdfa_scaled, pump_rateIn)),\
fmt='%02d %.5f %.5f %.5f %.5f', delimiter=' ', newline='\n', header=header_file)


