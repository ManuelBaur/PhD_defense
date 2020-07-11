#########################################################################
## Script to get A(q) and B(q) by fit to d(q,tau) (=diffusive motion)
##
## This script needs datafiles containing d(q,tau) vs tau -
## Run script in advance :: main_order_data_vs_tau.py
########################################################################

# See Germain et al 2015 (matlab script: DDM_FitDDMMatrix.m)
import numpy as np
import math
from scipy.optimize import curve_fit
import glob
import os

import module_plot_ddm_fit_diffusion

	


##########################################################
###### parameters to select right fake image run 
nPart = 10 ## number of particles
dyN = 2 ## type of dynamics (1 = const speed, rand dirction, 2 = Max Boltz distr
partSpeedFac = 1 ## multiplication factor on mean speed of particles
noise = 1 ## Noise added to artificial images (1 = no noise, 2 = random px noise as in experiments)

diamPart = 25 ## particle diamter in (px) in fake images


######### switch fit on=1 and off=0, if off read paramters from file
FitOnOff = 1 


dir_out = 'DDM_fit/'
try: 
	os.stat(dir_out)
except:
	os.mkdir(dir_out)

file_fitParam = (dir_out + '1st_fit_parameter_values_meanB.dat')
	

############# path + names of all data files - sorted by filename (increasing q-value)
d_dataIn = 'd_vs_tau/' ### folder with d(q,tau) image structure function
f_dataIn = 'f_vs_tau/' ### folder with f(q,tau) intermediate scattering function

nam_d_dat_all = sorted(glob.glob((d_dataIn + 'img_str_func_vs_tauq_nr*.dat')))
nam_f_dat_all = sorted(glob.glob((f_dataIn + 'interm_scatt_func_vs_tauq_nr*.dat')))

### data d(q,tau) vs q at minimal tau
dir_d_vs_q_tau0 = ('azi_aver_image_struct_func_300images/img_struc_func_tau_0000000001ms.dat')

#### read in datafile for q=0 (all tau) -- start value for fit parameter a1
data_In0 = np.loadtxt(nam_d_dat_all[0])
q0 = data_In0[0,2]

## wave vector = 0 has no meaning - delete first file name from input list	
if q0 == 0:
	nam_d_dat_all = nam_d_dat_all[1:]
	nam_f_dat_all = nam_f_dat_all[1:]
	data_In0 = np.loadtxt(nam_d_dat_all[0])


N_q = len(nam_d_dat_all)

###------------------------------------------------------------------------------------------
### read fit parameter values from datafile	
if FitOnOff == 0:	
	fit_param = np.loadtxt(file_fitParam)	
	q_vec = fit_param[:,0]
	A_vec = fit_param[:,1]
	B_vec = fit_param[:,2]
	tau_d_vec = fit_param[:,3]
	
	## wave vector = 0 has no meaning - delete this value	
	if q_vec[0] == 0:
		q_vec = q_vec[1:]
		A_vec = A_vec[1:]
		B_vec = B_vec[1:]
		tau_d_vec = tau_d_vec[1:]
		v_vec = v_vec[1:]


###------------------------------------------------------------------------------------------
### perfrom fit
elif FitOnOff == 1:
	#### approx bkg :: start parameter for B_vec: file d(q,tau) vs q at smallest tau
	data_bkg = np.loadtxt(dir_d_vs_q_tau0)
	fac_bkg = 0.1 # factor < 1, because d(q,tau) does not start from plateau
	st_bkg = np.min(data_bkg[:,1]) * fac_bkg 
	
	#### Allocate
	q_vec = np.zeros(N_q) ## allocate for wave vectors
	A_vec = np.zeros(N_q) ## allocate for wave vectors
	B_vec = np.zeros(N_q) ## allocate for wave vectors
	tau_d_vec = np.zeros(N_q) ## diffusion time Eq. (6), Germain 2015 

	#### fit function - the same for all wave numbers
	## - output are the fitparameter-values fitting best to all tau
	## implemented as in Germain et al (matlab script: DDM_FitDDMMatrix.m)
	## tau (delay time between images) 
	def fit_func(tau,a0,a1,a2):
		return np.log(a0 * (1-np.exp(-tau/a2)) + a1)
	#### --------- more function can be implemented here and tested

	### loop over wave vectors q
	for nn_q in np.arange(N_q): # [132]: # 
		print nn_q

		#### read data d(q,tau) vs tau for every q
		data_In = np.loadtxt(nam_d_dat_all[nn_q]) 
		
		#### read in parameters	
		tau = data_In[:,0] ## delay time
		d_q = data_In[:,1] ## image structure function
		q_vec[nn_q] = data_In[0,2] ## wave number
		
		#### start paramters fit::
		## maximum value of d_q over all tau
		## np.min(d_q) ## minimum value of d_q over all tau
		## this should be close to diffusion time 		
 		Params0 = [np.max(d_q)*2., \
			st_bkg, \
			1./np.float32(partSpeedFac)] 

		#### lower and upper bounds of fit parameters (lb,ub)
		lb = [0.2*Params0[0],\
			0.2*st_bkg,\
			0.]
		ub = [1.8*Params0[0],\
			1.8*st_bkg,\
			1000.]		

		param_bounds = (lb, ub)
		
		#### actual fit
		# popt, pcov = curve_fit(fit_func, tau, np.log(d_q))	
		popt, pcov = curve_fit(fit_func, tau, np.log(d_q),\
		 	p0 = [Params0[0], Params0[1], Params0[2]],\
			bounds = param_bounds)

		A_vec[nn_q] = popt[0]
		B_vec[nn_q] = popt[1]
		tau_d_vec[nn_q] = popt[2] # diffusion time for all q-values	
		
			
	##### save fit parameters
	B_vec = np.mean(B_vec) * np.ones(len(B_vec))
	np.savetxt(file_fitParam, np.transpose((q_vec, A_vec, B_vec, tau_d_vec)), 
		fmt='%e', delimiter=' ', newline='\n')
	

#### define q-range - check fit parameters plot for that
q_min = 0.20 # 10**(-1.) # (-0.9) 
q_max =	0.30 # 0.8 # 10**(0.) # (-0.5)	
	
############# call module for plots
module_plot_ddm_fit_diffusion.plot_fit_parameters\
	(dir_out,\
	q_vec, A_vec, B_vec, tau_d_vec,\
	q_min, q_max)
      

############ f(q,tau), d(q,tau) from fit parameters
module_plot_ddm_fit_diffusion.plot_f_d_with_fit\
	(dir_out, nam_d_dat_all, nam_f_dat_all, \
	q_vec, A_vec, B_vec, tau_d_vec)
	

############ f(q,tau) from fit for range of q-values
module_plot_ddm_fit_diffusion.plot_f_d_range_q\
	(dir_out, nam_d_dat_all, \
	q_vec, A_vec, B_vec, tau_d_vec, \
	q_min, q_max)
	
import pdb; pdb.set_trace()




