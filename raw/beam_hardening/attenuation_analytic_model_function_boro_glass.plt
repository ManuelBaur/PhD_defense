# gnuplot program
# plot attenuation for borosilicate glass

reset
set term postscript eps enhanced color solid dashed font ',30' size '5','3.5'

set samples 1000



# fc='/nishome/manuel/Dokumente/papers_and_reports/x-ray_attenuation/x-ray_attenuation_glass_plates/'
# fc1='detector_linearization_and_attenuation' 
# directory=fc.fc1 # concatenate the strings
# cd directory





#set logscale xy

set for [i=1:5] linetype i dt i
set for [i=1:5] style line i dt i

##### linetypes for different measurement series, for fit with heuristic expression ###########
set style line 1 lt 1 lc rgb "#ff0000" lw 5 
set style line 2 lt 1 lc rgb "#007e00" lw 5 
set style line 3 lt 1 lc rgb "#ff8000" lw 5 
set style line 4 lt 1 lc rgb "#cc00cc" lw 5 
set style line 5 lt 1 lc rgb "#6600cc" lw 5 
set style line 6 lt 1 lc rgb "#0066cc" lw 5 



data_60kV='borosilicate_glass_plates/mu_eff_60kV_500uA_120ms.dat'
data_140kV='borosilicate_glass_plates/mu_eff_140kV_150uA_100ms.dat'

set print '-'


##############################################################################################################
###################### implement function for different measurement series ###################################
##############################################################################################################
############ fit function from intensity intervall : 60 kV measurement
Emin=10. # minimum Energy in (keV) when detector starts to respond
c=43506.4 #42549 # from fit to photoelectric absorption (NIST Data), (keV)^3/cm
mu0=0.358228 #0.1443*2.23 # mean of data from NIST times density - incoherent scattering, (1/cm)







#### 140kV measurement #####################################################################################
##########################################################################################################
Emax140=140. # maximum Energy in (keV) during measurement

# define upper incomplete gamma functions (in gnuplot igamma=normalized lower incomplete gamma function)
igmax1_140(x) = gamma(1./3.) - igamma(1./3.,c*x/Emax140**3.) * gamma(1./3.)
igmax2_140(x) = gamma(2./3.) - igamma(2./3.,c*x/Emax140**3.) * gamma(2./3.)

igmin1_140(x) = gamma(1./3.) - igamma(1./3.,c*x/Emin**3.) * gamma(1./3.)
igmin2_140(x) = gamma(2./3.) - igamma(2./3.,c*x/Emin**3.) * gamma(2./3.)

simax_140(x) = (c*x/Emax140**3.)**(2./3.) * Emax140 * igmax1_140(x)
s2max_140(x) = exp(-c*x/Emax140**3.)
s3max_140(x) = exp(c*x/Emax140**3.) * (c*x/Emax140**3.)**(1./3.) * igmax2_140(x)

s1min_140(x) = (c*x/Emin**3.)**(2./3.) * Emin * igmin1_140(x)
s2min_140(x) = exp(-c*x/Emin**3.)
s3min_140(x) = exp(c*x/Emin**3.) * (c*x/Emin**3.)**(1./3.) * igmin2_140(x)

A_140kV(x) = 0.5*Emax140 * (simax_140(x) - s2max_140(x) * (2.*Emax140*s3max_140(x)-Emax140))
B_140kV(x) = 0.5*Emin * (s1min_140(x) - s2min_140(x) * (2*Emax140*s3min_140(x)-2.*Emax140+Emin))

I_140kV(x) = (A_140kV(x)-B_140kV(x)) * exp(-mu0*x) 
I_0_140kV = I_140kV(0.0) # intensity without material

mu_140kV(x) = 1/x * log(I_0_140kV/I_140kV(x))




##########################################################################################################
#  plot mu with measurment data ##########################################################################
##########################################################################################################
set output 'attenuation_borosilicate_glass_voltages_first_principle_fit.eps'

unset key

set format xy "%.1f"

set xrange [0:4.2]
set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic E,x}) (1/cm)'
set yrange [0.:2.6]
set xtics 0.4,0.4,4

set label 1 at 0.9,1.7 textcolor "#0066cc" 'Exp. data'
set label 3 at 1.5,0.5 textcolor "#ff8000" 'Analytic model'
# mu_heuristic_60kV(x) ls 1,\

## d in cm, mu in 1/cm 
plot data_140kV u ($1*100.):($2/100.) ls 6 pt 66 ps 2,\
	mu_140kV(x) ls 3
	
unset output

# cd 'scripts/attenuation'









