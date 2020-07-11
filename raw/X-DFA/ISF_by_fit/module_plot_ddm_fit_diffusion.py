import numpy as np
import math
from scipy.optimize import curve_fit
import matplotlib.colors
import matplotlib.pyplot as plt

########## produce LaTex like fonts
font = {'family' : 'serif',
	'weight' : 'normal',
	'size' : 18}
plt.rc('text', usetex=True)
plt.rc('font', **font) # family='serif')
plt.rc

#### function to get indices of q-range
## Input:
## q_min :: lower boundary 
## q_max :: upper boundary
def id_q_range(q_min, q_max, q_vec):
	### check how this is done in function at end of script...
	##################################################	
	### extract q-range from all q-values
	id_q_range0 = np.arange(len(q_vec)) ## initial full range
	q_vec_bool1 = q_vec >= q_min
	q_vec1 = q_vec[q_vec_bool1] ## all below min deleted
	q_vec_bool2 = q_vec1 <= q_max
	q_vec2 = q_vec1[q_vec_bool2] ## all above max deleted
	
	id_q_range1 = id_q_range0[q_vec_bool1]
	id_q_range2 = id_q_range1[q_vec_bool2]

	id_min = id_q_range2[0] ### index of min q
	id_max = id_q_range2[len(id_q_range2)-1] + 1 ### index of max q

	return id_min, id_max

#### fit of diffusion constant 
## fitted to tau_d 
def fit_diffusion_coef(q_vecRg, D_coeff):
	return 1./(D_coeff * q_vecRg**2.)

#################### PLOT FIT PARAMETERS
## Plot analog to Germain (2015, Fig. 4)
## Input:
## q_vec :: vector of wave numbers
## A_vec :: fit paramets A(q) for every wave number - signal strength
## B_vec :: fit paramets B(q) for every wave number - background
## tau_d_vec :: fit paramets tau_d for every wave number - diffusion time
## q_min & q_max :: range for fit of diffusion coefficient tau_d

def plot_fit_parameters\
	(dir_out, \
	q_vec, A_vec, B_vec, tau_d_vec, \
	q_min, q_max):
	
	#######################################################################
	### extract q range and tau_d range for fit of diff coeff	
	id_min, id_max = id_q_range(q_min, q_max, q_vec)
	q_vecRg = q_vec[id_min : id_max]
	tau_d_Rg = tau_d_vec[id_min : id_max]
	

	### fit diffusion coefficient
	popt, pcov = curve_fit(fit_diffusion_coef, q_vecRg, tau_d_Rg)
	diff_coeff = popt[0] ### diffusion coefficient
	
	### define colors	
	col_tau_d = 'C9'
	col_A = 'C1'
	col_B = 'C2'	
	# col_slo1 = 'C3' ## slope = 1
	col_slo2 = 'C4' ## slope = 2
	col_diff_coeff = 'C3' ## diffusion coefficient
	
	fig = plt.figure()
	
	###########################################################################
	## tau_d(q) diffusion time
	ax0 = fig.add_subplot(111)	
	ax0.plot(q_vec, tau_d_vec, marker='.',color = col_tau_d)
	## fit of diffusion coeff
	ax0.plot(q_vecRg, 1./(diff_coeff*q_vecRg**2.), color = 'k') # col_diff_coeff)
	ax0.plot([q_min, q_min], [0.002, 10**5], color = (0.7,0.7,0.7), zorder=0)
	ax0.plot([q_max, q_max], [0.002, 10**5], color = (0.7,0.7,0.7), zorder=0)
	# plt.annotate('$D_{\mathrm{fit}}$ = %.2f Px$^2$/timestep' %diff_coeff, \
	# 	xy=(0.45,0.8), xycoords='axes fraction', color=col_diff_coeff)
	
	# plt.setp(ax0.get_xticklabels(), fontsize=18)
	
	ax0.tick_params(which='both',direction = 'in')
	ax0.xaxis.set_ticks_position('both')
	ax0.yaxis.set_ticks_position('both')

	ax0.set_xlabel('wave number, $q$ (px$^{-1}$)')
	ax0.set_ylabel('$\\tau_\mathrm{D}(q)$')

	ax0.set_xscale('log')
	ax0.set_yscale('log')
	ax0.set_ylim([0.1,2*10**3])
	
	#### check slope
	######### plot slope = - 1
	slopeX = np.arange(q_min, q_max, 10**(-1.)) ### define vector with slope = -1
	# slopeY = slopeX**(-1.) * 10 ### slope = exponent, factor = offset
 
	# linePart = plt.plot(slopeX,slopeY,\
	# color=col_slo1, linewidth='3.', zorder=0) 
	# plt.annotate('slope = -1', xy=(0.45,0.85), xycoords='axes fraction', color=col_slo1)

	######### plot slope = - 2
	# slope2X = np.arange(10.**(-1.), 10.**(0.), 10**(-1.)) ### define vector with slope = -2
	slope2X = np.arange(q_min, q_max, 10**(-1.)) ### define vector with slope = -2
	slope2Y = slopeX**(-2.) * 1.0 ### slope = exponent, factor = offset
	
	linePart = plt.plot(slope2X,slope2Y,\
	color=col_slo2, linewidth='3.', zorder=0) 
	plt.annotate('slope = -2', xy=(0.6,0.1), xycoords='axes fraction', color=col_slo2)

	


	
	# ############################################################################
	# ## parameters A(q), B(q)	
	# ax = fig.add_subplot(212, sharex=ax0)	
	# ax.plot(q_vec, A_vec, marker='.', color = col_A)
	# ax.plot(q_vec, B_vec, marker='.', color = col_B)
	# # plt.setp(ax.get_xticklabels(), sharex=ax0)

	# ax.tick_params(which='both',direction = 'in')
	# ax.xaxis.set_ticks_position('both')
	# ax.yaxis.set_ticks_position('both')
	
	# ax.set_xlabel('wave number, $q$ (px$^{-1}$)')
	# ax.set_ylabel('$A(q)$')
	
	# ax.set_xscale('log')
	# ax.set_yscale('log')

	# plt.xlim([10**(-2),np.pi])
	# plt.ylim([10**(-5),10**6])
	# plt.show()
		
		
	fig.savefig(dir_out + 'FitParamters.pdf',
		format='pdf', bbox_inches='tight')
	
	
	plt.close()

	##  import pdb;pdb.set_trace()
	##### save fit parameters
	np.savetxt(dir_out + 'Diffusion_coefficient.dat', 
		np.ones(2) * diff_coeff, 
		fmt='%e', delimiter=' ', newline='\n')
	
	# import pdb; pdb.set_trace()


#### plot of d(q,tau) and f(q,tau) - and comparison with results from fit parameter
### Input:
## dir_out :: directory for output
## nam_d_dat_all :: all names ilc. directories to data files d(q,tau) vs tau
## nam_f_dat_all :: all names ilc. directories to data files d(f,tau) vs tau
## q_vec :: wave numbers
## A_vec, B_vec, tau_d_vec :: fit parameters (see main script :: main_A_B_from_fit.py)
def plot_f_d_with_fit \
	(dir_out, nam_d_dat_all, nam_f_dat_all, \
	q_vec, A_vec, B_vec, tau_d_vec):
	

	#### To Do :: select range of q-values (same as in original plots vs tau)
	n_q = 30 

	### ---- read in d(q,tau) -- e.g. look at d(q) - B(q) --> compare to A(q)	
	# data_d_In = np.loadtxt(nam_d_dat_all[10])
	# tau = data_d_In[:,0] ## always constant in every datafile
	# d_dat = data_d_In[:,1] ## d(q,tau) vs tau from data file (directly from images via DDM)
	

	### read in f(q,tau) - compare to results from fit
	data_f_In = np.loadtxt(nam_f_dat_all[n_q])
	tau = data_f_In[:,0] ## always constant in every datafile
	f_dat = data_f_In[:,1] ## f(q,tau) vs tau from data file (directly from corr of images)
	f_fit = np.exp(-tau / tau_d_vec[n_q]) 

	
	######### plot f_fit and f_dat vs tau
	fig = plt.figure()
	
	### define colors	
	col_img_corr = 'C0'
	col_fit = 'C1'

	ax0 = fig.add_subplot(111)	
	ax0.plot(tau, f_dat, marker='.',color = col_img_corr, label='from image corr.')
	ax0.plot(tau, f_fit, marker='.',color = col_fit, label='from fit')
	ax0.legend()

	ax0.tick_params(which='both',direction = 'in')
	ax0.xaxis.set_ticks_position('both')
	ax0.yaxis.set_ticks_position('both')
	
	ax0.set_xlabel('delay time, $\\tau$ (time steps)')
	ax0.set_ylabel('$f(q,\\tau)$ (a.u.)')

	ax0.set_xscale('log')
	# ax0.set_yscale('log')

	

	# plt.xlim([10**(-2),np.pi])
	plt.ylim([0,1.])
	# plt.show()
		
		
	fig.savefig(dir_out + 'f_q_tau_comp_img_corr_and_fit.eps',
		format='eps', bbox_inches='tight')
	

	plt.close()


	# import pdb; pdb.set_trace()



##########################################################################################
##### function to extract the right q-range of f(q,tau) and d(q,tau)  
def plot_f_d_range_q\
	(dir_out, nam_d_dat_all0, \
	q_vec0, A_vec0, B_vec0, tau_d_vec0, \
	q_min, q_max): 

	#### read tau (delay times) from file
	data_d_In = np.loadtxt(nam_d_dat_all0[0])
	tau = data_d_In[:,0] ## always constant in every datafile

	
	##################################################	
	### extract q-range from all q-values
	id_min, id_max = id_q_range(q_min, q_max, q_vec0)

	id_q_range0 = np.arange(len(q_vec0)) ## initial full range
	q_vec_bool1 = q_vec0 >= q_min
	q_vec1 = q_vec0[q_vec_bool1] ## all below min deleted
	q_vec_bool2 = q_vec1 <= q_max
	q_vec2 = q_vec1[q_vec_bool2] ## all above max deleted
	
	id_q_range1 = id_q_range0[q_vec_bool1]
	id_q_range2 = id_q_range1[q_vec_bool2]

	id_min = id_q_range2[0] ### index of min q
	id_max = id_q_range2[len(id_q_range2)-1] + 1 ### index of max q

	nam_d_dat_all2 = nam_d_dat_all0[id_min : id_max]

	A_vec2 = A_vec0[id_min : id_max]
	
	B_vec2 = B_vec0[id_min : id_max]
	
	tau_d_vec2 = tau_d_vec0[id_min : id_max]
	
		
	### select 12 indices 
	id_q_sel = np.int32(np.floor(np.linspace(0,len(q_vec2)-1,8))) 
	q_vec = q_vec2[id_q_sel]
	A_vec = A_vec2[id_q_sel]
	B_vec = B_vec2[id_q_sel]
	tau_d_vec = tau_d_vec2[id_q_sel]
	
	nam_d_dat_all = [nam_d_dat_all2[0]]
	for id_q_N in id_q_sel[1::]:
		nam_d_dat_all.append(nam_d_dat_all2[id_q_N])	
	

	#### call plot function to plot d(q,tau) vs tau plots
	plot_f_and_d_vs_tau \
		(nam_d_dat_all, dir_out, \
		q_min, q_max, tau, id_q_sel, \
		q_vec, A_vec, B_vec, tau_d_vec)



	
	
	
	
##########################################################################################
##### plot d(q,tau) from fit  vs tau, vs tau*q and tau*q**2
def plot_f_and_d_vs_tau(nam_d_dat_all, dir_out, \
	q_min, q_max, tau, id_q_sel, \
	q_vec, A_vec, B_vec, tau_d_vec):
	
	################### define figures and axes for all plots 
	fig1,ax1 = plt.subplots() #### f(q,tau) versus tau
	sufix1 = 'interm_sc_func_over_tau_multiple_q' ## naming of plot
	ax1.set_xlabel('$\\tau$ (time steps)')
	ax1.set_ylabel('$f(q,\\tau)$')
	ax1.set_xscale('log')
	ax1.set_ylim([0,1.1])
	
	fig2,ax2 = plt.subplots() #### f(q,tau) versus tau * q
	sufix2 = 'interm_sc_func_over_tau_q_multiple_q'
	ax2.set_xlabel('$\\tau q$ (time steps/px)')
	ax2.set_ylabel('$f(q,\\tau$)')
	ax2.set_xscale('log')
	ax2.set_ylim([0,1.1])

	fig3,ax3 = plt.subplots() #### f(q,tau) versus tau * q^2
	sufix3 = 'interm_sc_func_over_tau_q_sq_multiple_q'	
	ax3.set_xlabel('$\\tau q^2$ (time steps/px$^{2}$)')
	ax3.set_ylabel('$f(q,\\tau$)')
	ax3.set_xscale('log')
	ax3.set_ylim([0,1.1])

	fig4,ax4 = plt.subplots() ##### d(q,tau) versus tau
	sufix4 = 'img_struc_func_over_tau_multiple_q'
	ax4.set_xlabel('$\\tau$ (time steps)')
	ax4.set_ylabel('$d(q,\\tau$)')
	ax4.set_xscale('log')
	ax4.set_yscale('log')
	ax4.set_ylim([10**-2.,5*10**2])
	
	# fig5,ax5 = plt.subplots() ##### d(q,tau) versus tau * q
	# sufix5 = 'img_struc_func_over_tau_q_multiple_q'
	# ax5.set_xlabel('$\\tau q$ (time steps/Px)')
	# ax5.set_ylabel('$d(q,\\tau$) (a.u.)')
	# ax5.set_xscale('log')
	# ax5.set_yscale('log')
	# ax5.set_ylim([10**1,5*10**4])

	# fig6,ax6 = plt.subplots() ##### d(q,tau) versus tau * q^2
	# sufix6 = 'img_struc_func_over_tau_q_sq_multiple_q'
	# ax6.set_xlabel('$\\tau q^2$ (time steps/Px$^2$)')
	# ax6.set_ylabel('$d(q,\\tau$) (a.u.)')
	# ax6.set_xscale('log')
	# ax6.set_yscale('log')
	# ax6.set_ylim([10**1,5*10**4])


	##### use colormap jet
	cmap = plt.get_cmap('jet', len(q_vec))
	
		
	####### loop over datafiles = loop over varius q-values 
	for id_q in np.arange(len(q_vec)):
		# import pdb; pdb.set_trace()
		### read in d(q,tau) - compare to results from fit
		f_fit = np.exp(-tau / tau_d_vec[id_q]) 
		data_d_In = np.loadtxt(nam_d_dat_all[id_q])
		d_dat = data_d_In[:,1] ## f(q,tau) vs tau from data file (directly from corr of images)
		d_fit = A_vec[id_q] * (1. - f_fit) + B_vec[id_q]
		
		
		## plot of data
		## plot f(q,tau) versus tau	
		ax1.plot(tau, f_fit, 
			color = cmap(id_q))  
		
		## plot f(q,tau) versus tau * q
		ax2.plot(tau * q_vec[id_q], f_fit, 
			color = cmap(id_q))  

		## plot f(q,tau) versus tau * q^2
		ax3.plot(tau * q_vec[id_q]**2., f_fit, 
			color = cmap(id_q))  

		## plot d(q,tau) versus tau (compare with fit)
		ax4.plot(tau, d_fit, linestyle='-', # linewidth=3, 
			color = cmap(id_q))
		ax4.scatter(tau, d_dat, marker='.',
			color = cmap(id_q))

 		# ## plot 1/A(q) * (d(q,tau)-B(q)) versus tau*q (from fit)
		# ax5.plot(tau * q_vec[id_q], 1/A_vec[id_q] * (d_fit-B_vec[id_q]), linestyle='-', # linewidth=3, 
		# 	color = cmap(id_q))
		# # ax5.scatter(tau, d_dat, marker='.',
		# # 	color = cmap(id_q))

 		# ## plot d(q,tau)-B(q) versus tau*q (from fit)
		# ax6.plot(tau * q_vec[id_q]**2., d_fit-B_vec[id_q], linestyle='-', # linewidth=3, 
		# 	color = cmap(id_q))


	#### call function to set axes, colorbar, and save plot	
	save_plot(dir_out, fig1, ax1, sufix1, cmap, q_min, q_max, q_vec)
	save_plot(dir_out, fig2, ax2, sufix2, cmap, q_min, q_max, q_vec)
	save_plot(dir_out, fig3, ax3, sufix3, cmap, q_min, q_max, q_vec)
	save_plot(dir_out, fig4, ax4, sufix4, cmap, q_min, q_max, q_vec)
	# save_plot(dir_out, fig5, ax5, sufix5, cmap, q_min, q_max, q_vec)
	# save_plot(dir_out, fig6, ax6, sufix6, cmap, q_min, q_max, q_vec)

	plt.close('all')

	
def save_plot(dir_out, fig, ax, sufix, cmap, q_min, q_max, q_vec):	
	
	###### create colorbar according to jet colormap
	norm = matplotlib.colors.BoundaryNorm(np.arange(len(q_vec)+1)+0.5,len(q_vec))
	sm = plt.cm.ScalarMappable(norm = norm, cmap = cmap)
	sm.set_array([])
	

	###### set colorbar with ticks for q_vec
	str_q = ['{:.2f}'.format(ii) for ii in q_vec] #### str of q. setting number of digits
	cbar = fig.colorbar(sm, ticks=np.arange(1., len(q_vec)+1)) ### adjust for non integer q
	cbar.ax.set_yticklabels(str_q) # adjust for non integer q 
	cbar.set_label('wave number, $q$ (px$^{-1})$') #### ('wave number, $q$ (Px$^{-1})$')
	
	ax.tick_params(which='both',direction = 'in')
	ax.xaxis.set_ticks_position('both')
	ax.yaxis.set_ticks_position('both')
	
	# ax.set_xlabel('$\\tau$ (time steps)')
	# ax.set_ylabel('$f(q,\\tau$) (a.u.)')
	##  cbar.ax1.set_ticks(q_vec,update_ticks=True)
	
		
	fig.savefig(dir_out + sufix + 
		str('{:0>3d}'.format(int(q_min*100))) + '-' + 
		str('{:0>3d}'.format(int(q_max*100))) + '.eps',
		format='eps', bbox_inches='tight')
		
	 
		
	
	
	
	
	
	
	

