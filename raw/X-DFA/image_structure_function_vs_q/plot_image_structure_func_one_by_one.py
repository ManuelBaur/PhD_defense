#############################################################
# Plot image structure function D(q,tau)
#############################################################


# produce plot analogous to FIG 5 in Giavazzi2009.pdf
# Read data of azimutal averaged image structure function d(q,tau)

import numpy as np
import math
import matplotlib.colors
import matplotlib.pyplot as plt

##########################################################
###### parameters of fake images
nPart = 10 ## number of particles
dyN = 2  ## type of dynamics (1 = const speed, rand dirction, 2 = Max Boltz distr
partSpeedFac = 1 ## multiplication factor on mean speed of particles
noise = 1 ## Noise added to artificial images (1 = no noise, 2 = random px noise as in experiments)
nTime = 2000 # 2000 ## number of time steps, size of steps = 1

f_data = 'azi_aver_image_struct_func_300images/'

# ############## log spacing of delay times - set constant number of data points per decade
# ## tau = np.zeros(N_img - n_img - n_av - 1)
# base_tau = 10.**(1./30.) # original : (1./12.) - adjust base to get decent number of datapoints per decade
# N_tau = np.floor(np.log(nTime)/np.log(base_tau)) # maximal power for N_img - n_img images
# id_tau = np.unique(np.floor(base_tau**np.arange(1,N_tau)))
# id_tau = id_tau.astype(int)
id_tau = [1,2,4,6,15,50,199,999]
tau = id_tau # [::6] # * dt # vector of delay times ### select every 10th timestep
img_size = 1. # 512.


##### loop to read data 
for j in range(0,np.size(tau)):
	#### name of data
	nam_data = ('img_struc_func_tau_' +  str('{:0>10d}'.format(tau[j])) + 'ms.dat')
	print (f_data + nam_data)
	##### read data
	data_d_q =  np.loadtxt((f_data + nam_data))

	#### allocate vectors for data
	if j == 0:
		# vector for wavenumbers
		vec_q = np.zeros([np.size(data_d_q[:,0]),np.size(tau)])
		# vector for d_q: image structure function 
		vec_d_q = np.zeros([np.size(data_d_q[:,0]),np.size(tau)]) 
	

	### fill vectors with q and D(q,tau) for different tau
	vec_q[:,j] = data_d_q[:,0] * img_size
	vec_d_q[:,j] = data_d_q[:,1]
	
###### adjust string of taus - numbers separated by underscore '_'
str_tau = str(tau)
str_tau = str_tau.replace(' ','_')
str_tau = str_tau.replace('[','')
str_tau = str_tau.replace(']','')


################### plot
### plot image structure function for constant q	

########## produce LaTex like fonts
font = {'family' : 'serif',
	'weight' : 'normal',
	'size' : 25}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
plt.rc
fig,ax = plt.subplots()
# ax = fig.add_subplot(111)

# #### marker accroding to 0.5 particle diameter
# linePart = plt.plot([0.21,0.21],[0.,10**11],\
# color=(0.85,0.85,0.85),linewidth='3.',zorder=0) # ,label='part. diam')


##### use colormap jet
cmap = plt.get_cmap('seismic', len(tau))

###### create colorbar according to jet colormap
norm = matplotlib.colors.BoundaryNorm(np.arange(len(tau)+1)+0.5,len(tau))
sm = plt.cm.ScalarMappable(norm = norm, cmap = cmap)
sm.set_array([])

###### set colorbar with ticks for values of tau 
cbar = fig.colorbar(sm, ticks=np.arange(1., len(tau)+1))
# cbar = fig.colorbar(sm, ticks=tau)


# ax.legend()
 
ax.tick_params(which='both',direction = 'in')
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')

ax.set_xlabel('wave number, $q$ (px$^{-1}$)')
ax.set_ylabel('$D(q,\\tau$)')

cbar.ax.set_yticklabels(tau) # str(q_vec))

cbar.set_label('delay time, $\\tau$ (time steps)')



ax.set_xscale('log')
ax.set_yscale('log')
 
plt.xlim([2*10**(-2),np.pi*img_size]) # range for units in (px^-1)
plt.ylim([10**(-5),10**2]) # 20000)


# plt.plot(vec_q[:,0],vec_d_q[:,0])	
n_tau = 0 # counter for number of delay times plotted
while n_tau < np.size(tau):
	# plt.plot(vec_q[:,n_tau], vec_d_q[:,n_tau], \
	# 	color = cmap(n_tau), \
	# 	label = ('$\\tau$ = ' + str(format(tau[n_tau])) + ' ms'))
	plt.scatter(vec_q[:,n_tau], vec_d_q[:,n_tau], \
		color = cmap(n_tau), \
		marker = '.', label = ('$\\tau$ = ' + str(format(tau[n_tau])) + ' ms'))

	fig.savefig('img_struc_func_vs_q_Ntau' +
	str(format(id_tau[n_tau])) +  
	'_nPart' + 
	str(format(nPart)) + '.pdf',
	format='pdf',bbox_inches='tight')

	n_tau = n_tau + 1


plt.close()


import pdb; pdb.set_trace()

	
