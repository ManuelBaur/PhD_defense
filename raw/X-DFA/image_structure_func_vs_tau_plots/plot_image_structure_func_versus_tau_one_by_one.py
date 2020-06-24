#############################################################
# Plot image structure function D(q,tau) versus tau
#############################################################


# produce plot analogous to FIG 6 (top) in Giavazzi2009.pdf
# Read data of azimutal averaged image structure function d(q,tau)
# constant q, create vectors of tau and d(q,tau)


import numpy as np
import math
import matplotlib.colors 
import matplotlib.pyplot as plt
import glob # check certain directory for pathnames matching pattern

##########################################################
###### parameters of fake images
nPart = 10 ## number of particles
dyN = 2 ## type of dynamics (1 = const speed, rand dirction, 2 = Max Boltz distr
partSpeedFac = 1 ## multiplication factor on mean speed of particles
noise = 1 ## Noise added to artificial images (1 = no noise, 2 = random px noise as in experiments)
nTime = 3000 ## number of time steps, size of steps = 1

diamPart = 25 ## particle diamter in (px) in fake images


f_data = 'd_vs_tau/'

###### path + names of all data files - sorted by filenames
nam_dat_all = sorted(glob.glob((f_data + 'img_str_func_vs_tauq_nr*.dat')))

#### range q-values for plot 
q_min = 0.20 # 2. * np.pi / 2. / diamPart
q_max = 0.30 # 2.8 * q_min

##### range of files
nf0 = np.int32(np.floor(q_min * np.float32(len(nam_dat_all)-1.) / np.pi))
nfN = np.int32(np.floor(q_max * np.float32(len(nam_dat_all)-1.) / np.pi))

n_vec = np.arange(nfN-nf0) + nf0 ### indices of datafiles plotted below
id_files = np.int32(np.floor(np.linspace(0,len(n_vec)-1,8))) ## select 12 indices 
n_vec = n_vec[id_files]

# n_vec = [7,11,15,19,23] # [7,15, 23, 33, 40, 48]
q_vec = np.zeros(len(n_vec)) 
# import pdb; pdb.set_trace()

####################################################################################################
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



####### loop over datafiles - loop over varios q-values 
count_q1 = 0 # q counter for plot
for j in range(np.size(q_vec)):
	#### read in data
	data_in = np.loadtxt(nam_dat_all[n_vec[j]])	

	if j == 0:
		tau = np.zeros([np.size(data_in[:,0]), np.size(q_vec)])
		ddm = np.zeros([np.size(data_in[:,0]), np.size(q_vec)])

	### fill vector with d(q,tau) and tau 
	tau[:,j] = data_in[:,0]
	ddm[:,j] = data_in[:,1]
	q_vec[j] = data_in[0,2]



##### use colormap jet
cmap = plt.get_cmap('jet', len(q_vec))

###### create colorbar according to jet colormap
norm = matplotlib.colors.BoundaryNorm(np.arange(len(q_vec)+1)+0.5,len(q_vec))
sm = plt.cm.ScalarMappable(norm = norm, cmap = cmap)
sm.set_array([])

###### set colorbar with ticks for id_q_vec
cbar = fig.colorbar(sm, ticks=np.arange(1., len(q_vec)+1))


ax.tick_params(which='both',direction = 'in')
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')

ax.set_xlabel('delay time, $\\tau$ (time steps)')
ax.set_ylabel('$D(q,\\tau$) (a.u.)')

ax.set_xscale('log')
ax.set_yscale('log')

plt.xlim([1.,1000])
plt.ylim([2.*10**(-2.),10**1.])

	

##### style of color bar
###### adjust string of taus - numbers separated by underscore '_'
str_q = ['{:.2f}'.format(ii) for ii in q_vec]
cbar.ax.set_yticklabels(str_q) # str(id_q_vec))
cbar.set_label('wave number, $q$ (px$^{-1})$')

for n_q in range(np.size(q_vec)):
	#### plot of data	
	ax.plot(tau[:,n_q], ddm[:,n_q], 
	color = cmap(n_q))	
	
	fig.savefig('img_struc_func_vs_tau_q_range_' + 
		str('{:0>3d}'.format(n_q)) + 
		'simulations' + str(format(nPart)) + '.pdf',
		format='pdf', bbox_inches='tight')
	
	

plt.close()




