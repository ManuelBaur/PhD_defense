############################################################################################
# Functions for DDM - image analysis
############################################################################################

import cv2
import numpy as np
import scipy.io
import math
import os
import matplotlib as mpl
mpl.use('Agg')
from matplotlib import pyplot as plt 
import glob

### plot settings - latex look
font = {'family' : 'serif',
	'weight' : 'normal',
	'size' : 18}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
plt.rc

###########################################################################################
## create folders for output
def func_dir_out(f_meas, dir_add, n_av):

	try: 
		os.stat(f_meas + dir_add)
	except:
		os.mkdir(f_meas + dir_add)
	
	# ######### folder to save cropped roi from bed region
	# dir_roi = (f_meas + dir_add + 'cropped_roi/')
	# try: 
	# 	os.stat(dir_roi)
	# except:
	# 	os.mkdir(dir_roi)
	
	######### folder to save image structure function :: difference images in real and fourier space
	dir_stf = (f_meas + dir_add + 'image_struct_func_Av_' + \
		str('{:d}'.format(n_av)) + 'images/')
	try: 
		os.stat(dir_stf)
	except:
		os.mkdir(dir_stf)
	
	######### folder to save intermediate scattering function :: difference images in real and fourier space
	dir_scf = (f_meas + dir_add + 'interm_sc_func_Av_' + \
		str('{:d}'.format(n_av)) + 'images/')
	try: 
		os.stat(dir_scf)
	except:
		os.mkdir(dir_scf)
	
	
	# directory :: azimuthal averaged image structure function = stf
	dir_azi_aver_stf = (f_meas + dir_add + 'azi_aver_image_struct_func_' + \
		str('{:d}'.format(n_av)) + 'images/')
	try: 
		os.stat(dir_azi_aver_stf)
	except:
		os.mkdir(dir_azi_aver_stf)
	
	
	# directory :: azimuthal averaged image intermediate scattering function = scf 
	dir_azi_aver_scf = (f_meas + dir_add + 'azi_aver_interm_sc_func_' + \
		str('{:d}'.format(n_av)) + 'images/')
	try: 
		os.stat(dir_azi_aver_scf)
	except:
		os.mkdir(dir_azi_aver_scf)
	
	
	# dirctory for plots	
	dir_ddm_plots = f_meas + dir_add + 'ddm_plots/'
	try: 
		os.stat(dir_ddm_plots)
	except:
		os.mkdir(dir_ddm_plots)
	

	return dir_stf, dir_scf, \
		dir_azi_aver_stf, dir_azi_aver_scf, \
		dir_ddm_plots






########## calc diff image, d(q,tau) and, f(q,tau) for one time step 
## Input :
##  img_t :: image at time step t (float 64)
##  img_tau :: image at time step t + tau (float 64)
def ddm_per_timestep(img_t,img_tau):
		
	###########################################################################	
	d_img_t = img_tau - img_t ## difference image real space

	### fourier transform of image at time t and t + tau:
	f_img_t = np.fft.fft2(img_t) # time t
	f_img_tau = np.fft.fft2(img_tau) # time t + tau

	##### image structure function :: Giavazzi & Cerbino J. Opt. 16 (2014) 083001
	### abs square of difference of fourier transformed images
	d_q_tau_t = (np.abs(np.fft.fft2(d_img_t)))**2 

	##### image intermediate scattering function :: Giavazzi & Cerbino J. Opt. 16 (2014) 083001
	#### no abs() here! see van Mengen J.Chem. Phys (2017) Eq.(1)
	f_q_tau_t = f_img_tau * np.conj(f_img_t) # intermediate scattering function for timestep t 	
	
	##### image autocorrelation for normalizing interm. scatt. func.
	f_q_t_t = np.abs(f_img_t * np.conj(f_img_t))	

	#### return :: diff img real space, fourier space and image correlation
	return d_img_t, d_q_tau_t, f_q_tau_t, f_q_t_t








###########################################################################################
# matrix with distances of pixles from center of image
###########################################################################################

# Calculate distance of pixels from 0 mode of fft.fft2 + fft.fftshift. 
# In the case of a 2x2 array this is the element [1,1]
# In the case of an even nxn array : [np.floor(n/2), np.ceil(n/2)] 
# In the case of an odd mxm array : [np.floor(m/2), np.ceil(m/2)]
# see: https://docs.scipy.org/doc/scipy/reference/tutorial/fftpack.html

# INPUT: 
# im_in : input image - 2D array to be averages 
# dir_azi_aver : directory for output (plots/data)
# 

# OUTPUT:
# img_dist_px : 2D matrix of distances from origin 

def dist_px(im_in,dir_azi_aver):
	

	#### position of 0-mode after fft.fftshift
	### creating matrix of distances 
	center = ([len(im_in[:,0]) / 2, len(im_in[0,:]) / 2])
	
	y, x = np.indices((im_in.shape)) # x,y distances
	img_dist_px = np.sqrt((x - center[0])**2 + (y - center[1])**2) # 2D matrix of distances
		
	
	########### plot distance array 
	fig=plt.figure()
	plt.subplot(111)
	plt.imshow(img_dist_px,cmap = 'gray')
	plt.title('distance image') 
	plt.xticks([]), plt.yticks([])
	plt.colorbar()
	# plt.show()
	plt.close()	
	       
	fig.savefig(dir_azi_aver + 'Distance_from_0_mode_' +
	'Dim_' + str('{:0>4d}'.format(np.size(im_in[1,:]))) + 
	'x' + str('{:0>4d}'.format(np.size(im_in[:,1]))) + 
	'.png',
	format='png',dpi=400,bbox_inches='tight')
	
	########### save data
	file_dist_px = (dir_azi_aver + 'Distance_from_0_mode_' +
		'Dim_' + str('{:0>4d}'.format(np.size(im_in[1,:]))) + 
		'x' + str('{:0>4d}'.format(np.size(im_in[:,1]))) + '.dat')
	
	np.savetxt(file_dist_px, img_dist_px, fmt='%.4e') # , fmt='%e', delimiter='', newline='\n')
	# import pdb; pdb.set_trace()	

	return img_dist_px


###########################################################################################
####### azimutal averaging of fourier transformed difference image
###########################################################################################

# Azimutal averaging of the amplitude spectrum of difference images. 
# This gives the image structure function 'd_q_t' (Giavazzi et. al., Pys. Rev. E 80, 031403 (2009)),
# i.e. the azimutally averaged diff. image over the wave number q. Intermediate scattering function
# as defined in Giavazzi and Cerbino J. Opt. 16 (2014) 083001

# INPUT
# im_in : image which has to be radially averaged
# img_dist_px : array with distance of a pixel from the image center
# dir_our : directory to write output 
# tau : delay time in seconds
# case : 0 if working on d_q_tau, 1 if working on f_q_tau

def azim_aver(im_in,q_vec,img_dist_px,tau,dir_out,case):
	# import pdb; pdb.set_trace()
	
	##  im_in = np.random.randn(len(im_in), len(im_in))

	r_bin = img_dist_px.astype(np.int) # round to integers
	tbin = np.bincount(r_bin.ravel(), im_in.ravel()) # count intensities with same distance r_bin
	nr = np.bincount(r_bin.ravel()) # count number of distances in r_bin
	rad_av = tbin / nr # radial averaged intensities
	rad_av = rad_av[0:len(q_vec)]

	## remove first q-value (irrelevant)
	rad_av = rad_av[1:] 
	q_vec = q_vec[1:]
	# q_vec = range(1,len(rad_av)+1) # q vectors of same length as rad_av
	# import pdb;pdb.set_trace()
 

	######################## quick plot and save data
	if case == 0:
		# plot image structure function	
		fig=plt.figure()
		ax = fig.add_subplot(111)
		ax.set_xlabel('wave vector, $q$ (mm$^{-1}$)')
		ax.set_ylabel('image structure function, $d(q,\\tau$) (a.u.)')
		plt.plot(q_vec,rad_av)	
		# plt.show()
 		# import pdb; pdb.set_trace()

		fig.savefig(dir_out + 'img_struc_func_tau_' + 
		str('{:0>10d}'.format(np.int(round(tau)))) + 'ms.png',
		format='png',dpi=400,bbox_inches='tight')
		plt.close()

		# save data image structure function 
		file_img_strc_func = (dir_out + 'img_struc_func_tau_' + 
		str('{:0>10d}'.format(np.int(round(tau)))) + 'ms.dat')
		np.savetxt(file_img_strc_func, np.transpose((q_vec,rad_av)), fmt='%.10f', \
			delimiter=' ', newline='\n')
	
		# import pdb; pdb.set_trace()


	elif case == 1:
		# plot image scattering function	
		fig=plt.figure()
		ax = fig.add_subplot(111)
		ax.set_xlabel('wave vector, $q$ (mm$^{-1}$)')
		ax.set_ylabel('interm. sc. func. $f(q,\\tau$) (a.u.)')
		plt.plot(q_vec,rad_av,color='red')	
		# plt.show()
 		# import pdb; pdb.set_trace()

		fig.savefig(dir_out + 'interm_scatt_func_tau_' + 
		str('{:0>10d}'.format(np.int(round(tau)))) + 'ms.png',
		format='png',dpi=400,bbox_inches='tight')
		plt.close()

		# save data image structure function 
		file_img_strc_func = (dir_out + 'interm_scatt_func_tau_' + 
		str('{:0>10d}'.format(np.int(round(tau)))) + 'ms.dat')
		np.savetxt(file_img_strc_func, np.transpose((q_vec,rad_av)), fmt='%.10f', \
			delimiter=' ', newline='\n')


	return rad_av 


#####################################################################################################		
#### function to save image and data of difference image	
## Input:
## dir_stf :: directory for output (directory structure function)
## d_img :: number of difference images between timesteps t+tau and t
## tau_tmp :: delay time
## diff_img :: difference image in real space
def plot_diff_img(dir_stf, d_img, tau_tmp, diff_img):
	########### plot and save difference image in real space (averaged)
	plt.subplot(111)
	plt.imshow(diff_img,vmin=np.amin(diff_img),vmax=np.amax(diff_img),cmap = 'gray')
	plt.title('$\\tau$ = ' + str('{:.3f}'.format(tau_tmp)) + ' time steps') 
	plt.xticks([]), plt.yticks([])
	plt.colorbar()
	plt.savefig(dir_stf + 'Diff_img_real_space_d_img_' +
		str('{:0>5d}'.format(d_img)) + '.png',
		format='png',dpi=400,bbox_inches='tight')
	plt.close()	
	
	########## save data of differecne image in real space as .mat file
	file_diff_img =(dir_stf + 'Data_Diff_img_real_space_d_img_' +
		str('{:0>5d}'.format(d_img)) + '.mat')
	scipy.io.savemat(file_diff_img, mdict={'out': diff_img}, oned_as='row') 	
	# diff_img_in = scipy.io.loadmat(file_diff_img) ### how to read in 
	# diff_img_in['out'] #### to acess the data



#####################################################################################################		
#### function to plot magnitude spectrum of 2D input fouier image	
## Input:
## dir_out :: output directory
## str_case :: string to differentiate between d_q_t and f_q_t case
## tau_tmp :: current delay time
## d_img :: number of difference images between timesteps t+tau and t
## f_img_shift :: fourier transformed image, after fft.fftshift

def plot_magnitude_spectrum(dir_out, str_case, tau_tmp, d_img, f_img_shift):
	
	###### fourier spectrum in decibel to visualize week modes
	f_spect = 20 * np.log(1 + np.abs(f_img_shift)) # use log-scale	

	plt.subplot(111)
	plt.imshow(f_spect, cmap = 'gray')
	cbar = plt.colorbar()
	plt.title('$\\tau$ = ' + \
		str('{:.3f}'.format(tau_tmp)) + ' time steps'), plt.xticks([]), plt.yticks([])
	plt.savefig(dir_out + 'Mag_Spectrum_' + str_case + '_img_' +
		str('{:0>5d}'.format(d_img)) + '.png',
		format='png',dpi=400,bbox_inches='tight')
	
	plt.close()	
	

	########## save data of magnitude spctrum in real space as .mat file
	file_mag_spec = (dir_out + 'Data_Mag_Spectrum_' + str_case + ' _img_' +
		str('{:0>5d}'.format(d_img)) + '.mat')
	scipy.io.savemat(file_mag_spec, mdict={'out': f_spect}, oned_as='row') 	
	# diff_img_in = scipy.io.loadmat(file_diff_img) ### how to read in 
	# diff_img_in['out'] #### to acess the data





	
#####################################################################################################		
#### function to plot energy content	
def plot_energy_content(dir_ddm_plots, tau, sig_sq, N_img, n_av):	
	######### energy content of intensity fluctuations in real space
	fig = plt.figure()
	ax = fig.add_subplot(111)
	
	ax.tick_params(which='both',direction = 'in')
	ax.xaxis.set_ticks_position('both')
	ax.yaxis.set_ticks_position('both')
	ax.set_xlabel('Delay time, $\\tau$ (time steps)')
	ax.set_ylabel('energy content, $\sigma^2$($\\tau$) (a.u.)')
	
	plt.semilogx(tau,sig_sq,color='red',zorder=1)
	plt.scatter(tau,sig_sq,marker='o',color='red',zorder=2)
	plt.savefig(dir_ddm_plots + 'energy_content_intensity_fluc_' +
		'N_img_' + str('{:0>4d}'.format(N_img)) + 
		'n_av_' + str('{:0>4d}'.format(n_av)) + '.eps',
		format='eps',bbox_inches='tight')
	
	# save data
	file_en_real_space = (dir_ddm_plots + 'energy_content_intensity_fluc_' +
		'N_img_' + str('{:0>4d}'.format(N_img)) + 
		'n_av_' + str('{:0>4d}'.format(n_av)) + '.dat')
	np.savetxt(file_en_real_space, np.transpose((tau, sig_sq)), fmt='%.4f', delimiter=' ', newline='\n')



##############################################################################
### function to write datafiles d(q,tau) and f(q,tau) vs tau 
### = one file for every q
### output from main_ddm.py gives datafiles d(q,tau), f(q,tau) vs q
### = one file for every tau
def order_data_vs_tau(file_nam, dir_out, file_nam_out):
	## add create file for output
	try: 
		os.stat(dir_out)
	except:
		os.mkdir(dir_out)
	
	## directory and nam of infile
	nam_dat_all = sorted(glob.glob((file_nam)))
	tauN = len(nam_dat_all)
	tau = np.zeros(tauN-1)

  	##### loop over delay times tau and opeen files
	for count_t in np.arange(tauN - 1): # np.uint16(tau):
		### name of data file and reading of data
		nam_data = nam_dat_all[count_t]
		data_in = np.loadtxt(nam_data)			
		# import pdb; pdb.set_trace()
		
		###########################################################
		### crop interesting range of q-values [q_min, q_max]
		q_vec = data_in[:,0]
		ddm_q = data_in[:,1]

	 	###### extract tau from filename (vector for time delay)
		# import pdb; pdb.set_trace()
		str_tau = nam_data
		str_tau = str_tau.replace('_',' ')
		str_tau = str_tau.replace('ms',' ')
		num_filename = [int(s) for s in str_tau.split() if s.isdigit()]
		tau[count_t] = num_filename[len(num_filename) - 1]
		
		if count_t == 0:	
			###### allocate 2D array: 
 			### all values of d(q,tau) or f(q,tau) vs tau and q
			arr_ddm = np.zeros([np.size(tau), np.size(q_vec)])
	

		 	
	  	###################################################################################	
	 	##### loop over q_vec to extract values of d(q,tau) from files 
	  	for count_q in np.arange(len(q_vec)):
			
			#### delay time = tau
	   		arr_ddm[count_t,count_q] = ddm_q[count_q]
	 		#### wave number q = q_vec	 
	 
		 			
		

	####################################################################################################
	##### write data to file
	#### loop over q values
	for count_q1 in np.arange(len(q_vec)):
		## fill vector with current q-value
	 	q_const = np.ones(len(tau)) * q_vec[count_q1]
	
	 	nam_out = (file_nam_out + 'q_nr' + \
			str('{:0>4d}'.format(count_q1)) + '.dat')
	
	 	np.savetxt(dir_out + nam_out, \
	 	np.transpose((tau, arr_ddm[:,count_q1], q_const)),\
	 	fmt = '%e', delimiter=' ', newline='\n')
	 
	 		 

