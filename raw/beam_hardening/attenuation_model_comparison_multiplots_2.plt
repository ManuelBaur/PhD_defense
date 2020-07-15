# gnuplot program
# Here we compare different fit function from the following papers to our fit function. We fit to the data
# of the attenuation measurement for borosilicate glass for 60kV and 140kV acceleration voltage.
# 	(1) Bjärngard & Shackford, 'Attenuation in high-energy x-ray beams', Med. Phys (1994)
#	(2) Yu, Sloboda & Murray, 'Linear accelerator photon beam quality', Med. Phys (1997)
#	(3) Kleinschmidt, 'Analytical consideration of beam hardening', Med. Phys (1999)
#	(4) Mudde, Alles & van der Hagen, 'Feasibility study of a time-resolving x-ray tomographic system'
#		Meas.Sci.Technol. (2008)

# Bjärngard and Yu did experimental works. They have equations for the integral attenuation coefficient mu_eff.
# Kleinschmidt is based on theoretical values. He uses the differential attenuation coefficient mu_bar.
# Kleinschmidt claims to use the equations from Bjärngard and Yu, but does not modify the equations mu_eff --> mu_bar.
# The first model by Yu (for mu_eff) is equivalent to the model c (for mu_bar) by Kleinschmidt.


# plot attenuation for borosilicate glass

reset

# fc='/nishome/manuel/Dokumente/papers_and_reports/x-ray_attenuation/attenuation_output/'
# 
# directory=fc
# cd directory



# create eps output
# set terminal epslatex color colortext standalone
set term postscript eps enhanced color solid dashed font ',30' size '5','6.5'
set samples 1000
set encoding iso_8859_1 # allow german Umlaut äöü  --> ä = \344



set for [i=1:7] linetype i dt i
set for [i=1:5] style line i dt i

##### linetypes for different measurement series, for fit with heuristic expression ###########
set style line 1 lt 1 lc rgb "#ff0000" lw 5 
set style line 2 lt 1 lc rgb "#007e00" lw 5 
set style line 3 lt 1 lc rgb "#ff8000" lw 5 
set style line 4 lt 1 lc rgb "#cc00cc" lw 5 
set style line 5 lt 1 lc rgb "#6600cc" lw 5 
set style line 6 lt 1 lc rgb "#0066cc" lw 5 

set style line 9 lt 1 lc rgb "#009999" lw 5 

##### linetypes for different measurement series, for fit with function solving intensity integral ###########
set style line 11 lt 2 lc rgb "#ff0000" lw 5
set style line 22 lt 2 lc rgb "#007e00" lw 5
set style line 33 lt 2 lc rgb "#ff8000" lw 5
set style line 44 lt 2 lc rgb "#cc00cc" lw 5
set style line 55 lt 2 lc rgb "#6600cc" lw 5
set style line 66 lt 2 lc rgb "#0066cc" lw 5
                                            
set style line 99 lt 2 lc rgb "#009999" lw 5

##### linetypes for different measurement series, for fit with function solving intensity integral ###########
set style line 111 lt 3 lc rgb "#ff0000" lw 5
set style line 222 lt 3 lc rgb "#007e00" lw 5
set style line 333 lt 3 lc rgb "#ff8000" lw 5
set style line 444 lt 3 lc rgb "#cc00cc" lw 5
set style line 555 lt 3 lc rgb "#6600cc" lw 5
set style line 666 lt 3 lc rgb "#0066cc" lw 5

##### linetypes for different measurement series, for fit with function solving intensity integral ###########
set style line 1111 lt 4 lc rgb "#ff0000" lw 5
set style line 2222 lt 4 lc rgb "#007e00" lw 5
set style line 3333 lt 4 lc rgb "#ff8000" lw 5
set style line 4444 lt 4 lc rgb "#cc00cc" lw 5
set style line 5555 lt 4 lc rgb "#6600cc" lw 5
set style line 6666 lt 4 lc rgb "#0066cc" lw 5


# data for mu_eff plots
data_60kV='borosilicate_glass_plates/mu_eff_60kV_500uA_120ms.dat'
data_100kV='borosilicate_glass_plates/mu_eff_100kV_200uA_1100ms.dat'
data_140kV='borosilicate_glass_plates/mu_eff_140kV_150uA_100ms.dat'
data_2mmAl_140kV='borosilicate_glass_plates/mu_eff_140kV_2mmAl_150uA_120ms.dat'
data_4mmAl_140kV='borosilicate_glass_plates/mu_eff_140kV_4mmAl_150uA_200ms.dat'
data_1mmCu_140kV='borosilicate_glass_plates/mu_eff_140kV_1mmCu_200uA_300ms.dat'



#######################################################################################################
####################### 60kV Measurement, fits and multiplot ##########################################
#######################################################################################################

############ Bjärngard fit 60 kV measurement ########################
mu0_60kV_a = 2.554E-1 * 2.23 # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
lambda_60kV_a = 5.

mueff_60kV_a(x) = mu0_60kV_a - lambda_60kV_a * x
fit mueff_60kV_a(x) data_60kV using ($1*100):($2/100) via mu0_60kV_a, lambda_60kV_a

############ Yu 1 = Kleinschmidt c fit 60 kV measurement ########################
mu0_60kV_b = 5.4 # 2.554E-1 * 2.23 # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
lambda_60kV_b = 20. # must be positive to fulfill limit for x--> infty

mueff_60kV_b(x) = mu0_60kV_b / (1 + lambda_60kV_b * x)
fit mueff_60kV_b(x) data_60kV using ($1*100):($2/100) via mu0_60kV_b, lambda_60kV_b

############ Yu 2 fit 60 kV measurement ########################
mu0_60kV_b2 = 5.4 # 2.554E-1 * 2.23 # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
lambda_60kV_b2 = 20. # must be positive to fulfill limit for x--> infty
beta_b2=0.5

mueff_60kV_b2(x) = mu0_60kV_b2 / (1 + lambda_60kV_b2 * x)**beta_b2
fit mueff_60kV_b2(x) data_60kV using ($1*100):($2/100) via mu0_60kV_b2, lambda_60kV_b2, beta_b2

############ Kleinschmidt (1997) Equ. d) fit 60 kV measurement ########################
# originally defined for differential attenuation, transformed for integral attenuation coeff.
mu0_60kV_d = 2.554E-1 * 2.23 # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
mu1_60kV_d = 5.4 
lambda_60kV_d1 = 20.
lambda_60kV_d2 = 20.

mueff_60kV_d(x) = mu0_60kV_d + \
	2*mu1_60kV_d / (x * (-lambda_60kV_d1**2 + 4*lambda_60kV_d2)**(0.5)) * \
	(atan((lambda_60kV_d1 + 2*lambda_60kV_d2*x) / (-lambda_60kV_d1**2 + 4*lambda_60kV_d2)**(0.5)) - \
	atan(lambda_60kV_d1 / (-lambda_60kV_d1**2 + 4*lambda_60kV_d2)**(0.5)))


fit mueff_60kV_d(x) data_60kV using ($1*100):($2/100) via mu1_60kV_d, lambda_60kV_d1, lambda_60kV_d2

############## Mudde (2008), 60 kV measurement ##########################
# originally defined for grayvalue intensity at detector, transformed to integral attenuation coeff.
A1_60kV=0.5
B1_60kV=0.5
C1_60kV=5. 
 
mudde_60kV(x) = A1_60kV + B1_60kV * exp(-x/C1_60kV)
fit mudde_60kV(x) data_60kV using ($1*100):($6/$4) via A1_60kV,B1_60kV,C1_60kV
             
mueff_60kV_e(x) = -1./x * log(mudde_60kV(x))

############ our fit-function, 60 kV measurement ########################
a1= -75 # 2.554E-1 * 2.23 # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
b1=77.
alpha1=0.01

f1(x)=a1+b1/x**alpha1
fit f1(x) data_60kV using ($1*100):($2/100) via a1,b1,alpha1


######################################################################################################
##################### multiplot of 60 kV measurement - data and fits #################################
set output 'borosilicate_glass_60kV_model_comparison_multiplot_2.eps'

set multiplot layout 2,1 # spacing...0.

set bmargin 0.4
set lmargin 7

set origin 0.,0.6
set size 1.,0.4

set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic x}) (1/cm)'
set xtics 0,1,4
set xtics format ''
set xrange [0:4.2]
set yrange [0.5:4.]
set ytics 1,1,4
set ytics format '%.f'

set label 1 at 0.05,0.7 font ',30'  'a)'

########### write legend #############
set key at 4.,3.5 maxrows 7 samplen 6.0


####### attenuation plot 60 kV ###########
## d in cm, mu in 1/cm  , \344 = ä
plot    data_60kV u ($1*100):($2/100) ls 1 pt 64 ps 1.5 t '60 kV data',\
	[0.1:] mueff_60kV_a(x) lt 3 lc '#007e00' lw 5 t 'BS' # ,\
	# [0.1:] mueff_60kV_b(x) lt 2 lc '#cc00cc' lw 5 t 'Yu 1',\
	# [0.1:] mueff_60kV_e(x) lt 4 lc '#66cc00' lw 5 t 'KS',\
	# [0.1:] f1(x) lt 1 lc '#0066cc' lw 5 t 'BA'
	# [0.1:] mueff_60kV_e(x) lt 7 lc '#ff8000' lw 5 t 'MU',\


###### deviation plot 60 kV #############
unset label
set bmargin 3.5
set tmargin 0

set size 1.,0.6

set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set label 2 at 0.05,0.22 font ',30' 'b)'

set xtics format '%.f'
set yrange [-0.2:0.25]
set ylabel '{/Symbol D}{/Symbol m}_{eff} (1/cm)' offset 0.8 
set ytics -0.2,0.1,0.2
set ytics format '%.1f'

set key at 0.7,-0.105 top left maxrows 3 noinvert samplen 4.0 enhanced
set arrow from 0.,0. to 4.2,0. nohead lt 3 lw 5 lc '#000000' back # zero line

plot	data_60kV u ($1*100):(mueff_60kV_a($1*100) - $2/100)\
	lc '#007e00' lt 3 lw 5 pt 15 ps 1.5 with linespoints t 'BS',\
	2 with linespoints lc "#ffffff" lt 2 t ' ',\
	2 with linespoints lc "#ffffff" lt 2 t ' ',\
	2 with linespoints lc "#ffffff" lt 2 t ' ',\
	2 with linespoints lc "#ffffff" lt 2 t ' ',\
	2 with linespoints lc "#ffffff" lt 2 t ' '
	#  lc '#cc00cc' lt 2 lw 5 pt 68 ps 1.5 with linespoints t 'Yu 1',\
	# data_60kV u ($1*100):(mueff_60kV_b2($1*100) - $2/100)\
	#  lc '#6600cc' lt 6 lw 5 pt 13 ps 1.5 with linespoints t 'Yu 2',\
	# data_60kV u ($1*100):(mueff_60kV_d($1*100) - $2/100)\
	#  lc '#66cc00' lt 4 lw 5 pt 67 ps 1.5 with linespoints t 'KS',\
	# data_60kV u ($1*100):(mueff_60kV_e($1*100) - $2/100)\
	#  lc '#ff8000' lt 7 lw 5 pt 9 ps 1.5 with linespoints t 'MU',\
	# data_60kV u ($1*100):(f1($1*100) - $2/100)\
	#  lc '#0066cc' lt 1 lw 5 pt 65 ps 1.5 with linespoints t 'BA'

unset xlabel
unset ylabel
unset label
unset arrow
unset multiplot





# #######################################################################################################
# ####################### 140kV Measurement, fits and multiplot ##########################################
# #######################################################################################################
# 
# ############ Bjärngard fit 140 kV measurement ########################
# mu0_140kV_a = 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
# lambda_140kV_a = 5.
# 
# mueff_140kV_a(x) = mu0_140kV_a - lambda_140kV_a * x
# fit mueff_140kV_a(x) data_140kV using ($1*100):($2/100) via mu0_140kV_a, lambda_140kV_a
# 
# ############ Yu 1=Kleinschmidt c fit 140 kV measurement ########################
# mu0_140kV_b = 5.4 # 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
# lambda_140kV_b = 20. # must be positive to fulfill limit for x--> infty
# 
# mueff_140kV_b(x) = mu0_140kV_b / (1 + lambda_140kV_b * x)
# fit mueff_140kV_b(x) data_140kV using ($1*100):($2/100) via mu0_140kV_b, lambda_140kV_b
# 
# ############ Yu 2 fit 140 kV measurement ########################
# mu0_140kV_b2 = 5.4 # 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
# lambda_140kV_b2 = 20. # must be positive to fulfill limit for x--> infty
# beta_b2=0.5
# 
# mueff_140kV_b2(x) = mu0_140kV_b2 / (1 + lambda_140kV_b2 * x)**beta_b2
# fit mueff_140kV_b2(x) data_140kV using ($1*100):($2/100) via mu0_140kV_b2, lambda_140kV_b2,beta_b2
# 
# ############ Kleinschmidt (1997) Equ. d) fit 140 kV measurement ########################
# mu0_140kV_d = 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
# mu1_140kV_d = 5.4 
# lambda_140kV_d1 = 20.
# lambda_140kV_d2 = 20.
# 
# mueff_140kV_d(x) = mu0_140kV_d + \
# 	2*mu1_140kV_d / (x * (-lambda_140kV_d1**2 + 4*lambda_140kV_d2)**(0.5)) * \
# 	(atan((lambda_140kV_d1 + 2*lambda_140kV_d2*x) / (-lambda_140kV_d1**2 + 4*lambda_140kV_d2)**(0.5)) - \
# 	atan(lambda_140kV_d1 / (-lambda_140kV_d1**2 + 4*lambda_140kV_d2)**(0.5)))
# 
# 
# fit mueff_140kV_d(x) data_140kV using ($1*100):($2/100) via mu1_140kV_d, lambda_140kV_d1, lambda_140kV_d2
# 
# ############## Mudde (2008), 140 kV measurement ##########################
# # originally defined for grayvalue intensity at detector, transformed to integral attenuation coeff.
# A1_140kV=0.5
# B1_140kV=0.5
# C1_140kV=5. 
#  
# mudde_140kV(x) = A1_140kV + B1_140kV * exp(-x/C1_140kV)
# fit mudde_140kV(x) data_140kV using ($1*100):($6/$4) via A1_140kV,B1_140kV,C1_140kV
#              
# mueff_140kV_e(x) = -1./x * log(mudde_140kV(x))
# 
# ############ our fit-function, 140 kV measurement ########################
# a1= 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
# b1=5.
# alpha1=0.5
# 
# f1(x)=a1+b1/x**alpha1
# fit f1(x) data_140kV using ($1*100):($2/100) via a1,b1,alpha1
# 
# 
# ######################################################################################################
# ##################### multiplot of 140 kV measurement - data and fits #################################
# set output 'borosilicate_glass_140kV_model_comparison_multiplot.eps'
# 
# set multiplot layout 2,1 # spacing...0.
# 
# set bmargin 0.4
# set lmargin 7
# 
# set origin 0.,0.6
# set size 1.,0.4
# 
# set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic x}) (1/cm)'
# set xtics 0.4,0.4,4
# set xtics format ''
# set xrange [0:4.2]
# set yrange [0.5:3.]
# set ytics 1.,0.5,4.5
# set ytics format '%.1f'
# 
# set label 1 at 0.05,0.65 font ',30'  'a)'
# 
# ########### write legend #############
# set key at 4.,2.4 maxrows 7 samplen 6.0
# 
# 
# ####### attenuation plot 140 kV ###########
# ## d in cm, mu in 1/cm  , \344 = ä
# plot	data_140kV u ($1*100):($2/100) ls 1 pt 64 ps 1.5 t '140 kV data',\
# 	[0.1:] mueff_140kV_a(x) lt 3 lc '#007e00' lw 5 t 'BS',\
# 	[0.1:] mueff_140kV_e(x) lt 7 lc '#ff8000' lw 5 t 'MU',\
# 	[0.1:] f1(x) lt 1 lc '#0066cc' lw 5 t 'BA'
# 	
# ###### deviation plot 140 kV #############
# unset label
# set bmargin 3.5
# set tmargin 0
# 
# set size 1.,0.6
# 
# set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
# set label 2 at 0.05,0.22 font ',30' 'b)'
# 
# set xtics format '%.1f'
# set yrange [-0.2:0.25]
# set ylabel '{/Symbol D}{/Symbol m}_{eff} (1/cm)' offset 0.8 
# set ytics -0.2,0.1,0.2
# 
# set key at 3.6,-0.105 maxrows 3 noinvert samplen 4.0 
# set arrow from 0.,0. to 4.2,0. nohead lt 3 lw 5 lc '#000000' back # zero line
# 
# plot	data_140kV u ($1*100):(mueff_140kV_a($1*100) - $2/100)\
# 	 lc '#007e00' lt 3 lw 5 pt 15 ps 1.5 with linespoints t 'BS',\
# 	data_140kV u ($1*100):(mueff_140kV_b($1*100) - $2/100)\
# 	 lc '#cc00cc' lt 2 lw 5 pt 68 ps 1.5 with linespoints t 'Yu 1',\
# 	data_140kV u ($1*100):(mueff_140kV_b2($1*100) - $2/100)\
# 	 lc '#6600cc' lt 6 lw 5 pt 13 ps 1.5 with linespoints t 'Yu 2',\
# 	data_140kV u ($1*100):(mueff_140kV_d($1*100) - $2/100)\
# 	 lc '#66cc00' lt 4 lw 5 pt 67 ps 1.5 with linespoints t 'KS',\
# 	data_140kV u ($1*100):(mueff_140kV_e($1*100) - $2/100)\
# 	 lc '#ff8000' lt 7 lw 5 pt 9 ps 1.5 with linespoints t 'MU',\
# 	data_140kV u ($1*100):(f1($1*100) - $2/100)\
# 	 lc '#0066cc' lt 1 lw 5 pt 65 ps 1.5 with linespoints t 'BA'
# 
# unset xlabel
# unset ylabel
# unset label
# unset arrow
# unset multiplot
# 
# 
# ######################################################################################################
# ###################### print fit parameters to file #################################################
# ######################################################################################################
# # 
# # set fit errorvariables
# # set print 'attenuation_data/plots_for_draft/fit_parameters_Kleinschmidt_fits.dat'
# # print a1, a1_err, b1, b1_err, alpha1, alpha1_err
# # print a2, a2_err, b2, b2_err, alpha2, alpha2_err
# # print a3, a3_err, b3, b3_err, alpha3, alpha3_err
# # print a4, a4_err, b4, b4_err, alpha4, alpha4_err
# # print a5, a5_err, b5, b5_err, alpha5, alpha5_err
# # print a6, a6_err, b6, b6_err, alpha6, alpha6_err
# # 
# 
# 
# unset output


# final directory
# cd 'plot_scripts'









