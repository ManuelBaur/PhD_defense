#########################################################################################
### Calc FFT of single images - check particle form factor and structure factor
########################################################################################


import cv2
import numpy as np
import math
import matplotlib as mpl
mpl.use('Agg')
from matplotlib import pyplot as plt 
import os

import module_ddm_funcs

### plot settings - latex look
font = {'family' : 'serif',
	'weight' : 'normal',
	'size' : 30}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
plt.rc


############################### path to crop regions of images in real space
img_nam = '1Particle_25Px_synthetic.png'

PixelSize = 1.	

img = cv2.imread(img_nam, -1)
img = np.float64(img) / (2**16 -1)

f_img = np.fft.fft2(img)
f_img[0,0] = 0. ## delete 0 mode
f_img_shift = np.abs(np.fft.fftshift(f_img))

########## plot shifted fourier image
# module_ddm_funcs.plot_magnitude_spectrum\
# 	(dir_out, 'mag_spectrum_1_particle',0, 0, f_img_shift)
###### fourier spectrum in decibel to visualize week modes
f_spect = 20 * np.log(1 + np.abs(f_img_shift)) # use log-scale	

plt.subplot(111)
plt.imshow(f_spect, cmap = 'gray')
cbar = plt.colorbar()
plt.title('Mag. Spectrum, 1 particle'), plt.xticks([]), plt.yticks([])
plt.savefig('Mag_Spectrum_1_particle.png',
	format='png',dpi=400,bbox_inches='tight')

plt.close()	

######### radial average
img_dist_px = module_ddm_funcs.dist_px(f_img_shift,'')	

## create wave vector q according to pixle scaling
q_vec = (2*np.pi) / (np.size(img[0,:]) * PixelSize) *\
	np.arange(0,np.size(img[0,:])/2.)
			
f_img_azi = module_ddm_funcs.azim_aver(f_img_shift,q_vec,\
		img_dist_px,0,'',0)
	

######## plot radial avaraged magnitude spectrum
q_vec=q_vec[1:] ### delete q-of 0 mode

fig,ax = plt.subplots()

# plt.scatter(q_vec, f_img_azi, \
# 	marker = '.')
plt.plot(q_vec, f_img_azi, linewidth=3)
 
ax.tick_params(which='both',direction = 'in')
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')
ax.set_xticklabels([])
ax.set_yticklabels([])
ax.set_xlabel('')
ax.set_ylabel('')
ax.set_xlabel('wave number, $q$ (px$^{-1}$)')
ax.set_ylabel('mag. spectrum (a.u.)')
ax.set_xticks([])
ax.set_yticks([])


ax.set_xscale('log')
ax.set_yscale('log')
 
plt.xlim([10**(-2),np.pi]) # range for units in (px^-1)
plt.ylim([10**(-3),10**1]) # 20000)


fig.savefig('form_factor.pdf',
	format='pdf',bbox_inches='tight')

plt.close()




 
