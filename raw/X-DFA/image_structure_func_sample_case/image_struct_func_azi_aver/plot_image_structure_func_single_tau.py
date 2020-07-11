#############################################################
# Plot image structure function D(q,tau)
#############################################################


# produce plot analogous to FIG 5 in Giavazzi2009.pdf
# Read data of azimutal averaged image structure function d(q,tau)

import numpy as np
import math
import matplotlib.colors
import matplotlib.pyplot as plt

# ########## produce LaTex like fonts
# font = {'family' : 'serif',
# 	'weight' : 'normal',
# 	'size' : 25}
# plt.rc('text', usetex=True)
# plt.rc('font', **font) # family='serif')
# plt.rc

########## produce fonts fitting better to inkscape font
font = {'weight' : 'normal',
	'size' : 25}

plt.rc('font', **font)
plt.rc('xtick', labelsize=18)
plt.rc('ytick', labelsize=18)

plt.rc


##########################################################
img_size = 1. # 512 ## size of the image in (Px)
tau = 10 # delay time

#### name of data
nam_data = ('img_struc_func_tau_' +  str('{:0>10d}'.format(tau)) + 'ms')
print (nam_data)
##### read data
data_d_q =  np.loadtxt((nam_data + '.dat'))

# vector for wavenumbers
vec_q = data_d_q[:,0] * img_size
# vector for d_q: image structure function 
vec_d_q = data_d_q[:,1]
	


################### plot
### plot image structure function for constant q	
fig,ax = plt.subplots()
plt.plot(vec_q[:],vec_d_q[:], color='C1', lw='3')

ax.set_xscale('log')
ax.set_yscale('log')
 
ax.tick_params(which='both',direction = 'in')

ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')
ax.xaxis.set_minor_locator(plt.NullLocator())
ax.yaxis.set_minor_locator(plt.NullLocator())

ax.set_xlabel('wave number, $q$ (px$^{-1}$)')
ax.set_ylabel('$D(q,\\tau$) (a.u.)')



plt.xlim([2*10**(-2),np.pi*img_size]) 
plt.ylim([10**(-4),10**2]) 
ax.set_yticks([10**(-3),10**(-1),10**(1)])
fig.savefig(nam_data + '.pdf',
	format='pdf',bbox_inches='tight')
plt.close()


	
