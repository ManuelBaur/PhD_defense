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
set term postscript eps enhanced color solid dashed font ',30' size '5','8'
set samples 1000
set encoding iso_8859_1 # allow german Umlaut äöü  --> ä = \344



set for [i=1:7] linetype i dt i
set for [i=1:5] style line i dt i

##### linetypes for different measurement series, for fit with heuristic expression ###########
set style line 1 lt 1 lc rgb "#009900" lw 5 

# data for mu_eff plots
data_60kV='borosilicate_glass_plates/mu_eff_60kV_500uA_120ms.dat'
data_100kV='borosilicate_glass_plates/mu_eff_100kV_200uA_1100ms.dat'
data_140kV='borosilicate_glass_plates/mu_eff_140kV_150uA_100ms.dat'
data_2mmAl_140kV='borosilicate_glass_plates/mu_eff_140kV_2mmAl_150uA_120ms.dat'
data_4mmAl_140kV='borosilicate_glass_plates/mu_eff_140kV_4mmAl_150uA_200ms.dat'
data_1mmCu_140kV='borosilicate_glass_plates/mu_eff_140kV_1mmCu_200uA_300ms.dat'






#######################################################################################################
####################### 140kV Measurement, fits and multiplot ##########################################
#######################################################################################################

############ Bjärngard fit 140 kV measurement ########################
mu0_140kV_a = 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
lambda_140kV_a = 5.

mueff_140kV_a(x) = mu0_140kV_a - lambda_140kV_a * x
fit mueff_140kV_a(x) data_140kV using ($1*100):($2/100) via mu0_140kV_a, lambda_140kV_a

############ Yu 1=Kleinschmidt c fit 140 kV measurement ########################
mu0_140kV_b = 5.4 # 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
lambda_140kV_b = 20. # must be positive to fulfill limit for x--> infty

mueff_140kV_b(x) = mu0_140kV_b / (1 + lambda_140kV_b * x)
fit mueff_140kV_b(x) data_140kV using ($1*100):($2/100) via mu0_140kV_b, lambda_140kV_b

############ Yu 2 fit 140 kV measurement ########################
mu0_140kV_b2 = 5.4 # 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
lambda_140kV_b2 = 20. # must be positive to fulfill limit for x--> infty
beta_b2=0.5

mueff_140kV_b2(x) = mu0_140kV_b2 / (1 + lambda_140kV_b2 * x)**beta_b2
fit mueff_140kV_b2(x) data_140kV using ($1*100):($2/100) via mu0_140kV_b2, lambda_140kV_b2,beta_b2

############ Kleinschmidt (1997) Equ. d) fit 140 kV measurement ########################
mu0_140kV_d = 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
mu1_140kV_d = 5.4 
lambda_140kV_d1 = 20.
lambda_140kV_d2 = 20.

mueff_140kV_d(x) = mu0_140kV_d + \
	2*mu1_140kV_d / (x * (-lambda_140kV_d1**2 + 4*lambda_140kV_d2)**(0.5)) * \
	(atan((lambda_140kV_d1 + 2*lambda_140kV_d2*x) / (-lambda_140kV_d1**2 + 4*lambda_140kV_d2)**(0.5)) - \
	atan(lambda_140kV_d1 / (-lambda_140kV_d1**2 + 4*lambda_140kV_d2)**(0.5)))


fit mueff_140kV_d(x) data_140kV using ($1*100):($2/100) via mu1_140kV_d, lambda_140kV_d1, lambda_140kV_d2

############## Mudde (2008), 140 kV measurement ##########################
# originally defined for grayvalue intensity at detector, transformed to integral attenuation coeff.
A1_140kV=0.5
B1_140kV=0.5
C1_140kV=5. 
 
mudde_140kV(x) = A1_140kV + B1_140kV * exp(-x/C1_140kV)
fit mudde_140kV(x) data_140kV using ($1*100):($6/$4) via A1_140kV,B1_140kV,C1_140kV
             
mueff_140kV_e(x) = -1./x * log(mudde_140kV(x))

############ our fit-function, 140 kV measurement ########################
a1= 2.554E-1 * 2.23 # value from NIST for 140kV acceleration voltage, multiplied with densitiy of boro glass
b1=5.
alpha1=0.5

f1(x)=a1+b1/x**alpha1
fit f1(x) data_140kV using ($1*100):($2/100) via a1,b1,alpha1


######################################################################################################
##################### multiplot of 140 kV measurement - data and fits #################################
set output 'borosilicate_glass_140kV.eps'

# set multiplot layout 2,1 # spacing...0.

# set bmargin 0.4
set lmargin 7

set origin 0.,0.6
set size 1.,0.4

set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic x}) (1/cm)'
set xtics 0.4,0.4,4
set xtics format '%.1f'
set xrange [0:4.2]
set yrange [0.5:3.]
set ytics 1.,0.5,4.5
set ytics format '%.1f'
set key off
# set label 1 at 0.05,0.65 font ',30'  'a)'

########### write legend #############
# set key at 4.,2.4 maxrows 7 samplen 6.0


####### attenuation plot 140 kV ###########
## d in cm, mu in 1/cm  , \344 = ä
plot	data_140kV u ($1*100):($2/100) ls 1 pt 64 ps 1.5 t '140 kV data' # ,\

 

 


unset output










