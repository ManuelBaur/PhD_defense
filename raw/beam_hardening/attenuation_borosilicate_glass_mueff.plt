# gnuplot program
# plot attenuation for borosilicate glass

reset

# fc='/nishome/manuel/Dokumente/papers_and_reports/x-ray_attenuation/attenuation_output/'
 
# directory=fc
# cd directory



# create eps output
set term postscript eps enhanced color solid dashed font ',30' size '5','3.5'
# set termoption dash
#set title ''
set samples 1000
set format xy "%.0f"



set for [i=1:5] linetype i dt i
set for [i=1:5] style line i dt i

##### linetypes for different measurement series, for fit with heuristic expression ###########
set style line 1 lt 1 lc rgb "#ff0000" lw 3
set style line 2 lt 1 lc rgb "#007e00" lw 3
set style line 3 lt 1 lc rgb "#ff8000" lw 3
set style line 4 lt 1 lc rgb "#cc00cc" lw 3
set style line 5 lt 1 lc rgb "#6600cc" lw 3
set style line 6 lt 1 lc rgb "#0066cc" lw 3

##### linetypes for different measurement series, for fit with function solving intensity integral ###########
set style line 11 lt 2 lc rgb "#ff0000" lw 3
set style line 22 lt 2 lc rgb "#007e00" lw 3
set style line 33 lt 2 lc rgb "#ff8000" lw 3
set style line 44 lt 2 lc rgb "#cc00cc" lw 3
set style line 55 lt 2 lc rgb "#6600cc" lw 3
set style line 66 lt 2 lc rgb "#0066cc" lw 3


# data for mu_eff plots
data_60kV='borosilicate_glass_plates/mu_eff_60kV_500uA_120ms.dat'
data_100kV='borosilicate_glass_plates/mu_eff_100kV_200uA_100ms.dat'
data_140kV='borosilicate_glass_plates/mu_eff_140kV_150uA_100ms.dat'
data_2mmAl_140kV='borosilicate_glass_plates/mu_eff_140kV_2mmAl_150uA_120ms.dat'
data_4mmAl_140kV='borosilicate_glass_plates/mu_eff_140kV_4mmAl_150uA_200ms.dat'
data_1mmCu_140kV='borosilicate_glass_plates/mu_eff_140kV_1mmCu_200uA_300ms.dat'

# data files containing mu_bar (tangential to Pease plots)
data_mu_bar_60kV='borosilicate_glass_plates/mu_bar_60kV_500uA_120ms.dat'
data_mu_bar_100kV='borosilicate_glass_plates/mu_bar_100kV_200uA_100ms.dat'
data_mu_bar_140kV='borosilicate_glass_plates/mu_bar_140kV_150uA_100ms.dat'
data_mu_bar_2mmAl_140kV='borosilicate_glass_plates/mu_bar_140kV_2mmAl_150uA_120ms.dat'
data_mu_bar_4mmAl_140kV='borosilicate_glass_plates/mu_bar_140kV_4mmAl_150uA_200ms.dat'
data_mu_bar_1mmCu_140kV='borosilicate_glass_plates/mu_bar_140kV_1mmCu_200uA_300ms.dat'


#######################################################################################################
####################### plot attenuation mu_eff of measurements without filter  #######################
#######################################################################################################
set output 'borosilicate_glass_voltages_mu_eff.eps'

set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic x}) (1/cm)'



unset key #bottom right maxrows 3 width -16 title 'glass vs. bronze'

############ heuristic fit 60 kV measurement ########################
a1= 2.554E-1 * 2.23 # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
b1=5
alpha1=0.5

f1(x)=a1+b1/x**alpha1
fit f1(x) data_60kV using ($1*100):($2/100) via a1,b1,alpha1


############ heuristic fit 100 kV measurement ########################
a2= 1.687E-1 * 2.23
b2=5
alpha2=0.5

f2(x)=a2+b2/x**alpha2
fit f2(x) data_100kV using ($1*100):($2/100) via a2,b2,alpha2


############ heuristic fit 140 kV measurement ########################
a3= 1.439E-1 * 2.23
b3=5
alpha3=0.5

f3(x)=a3+b3/x**alpha3
fit f3(x) data_140kV using ($1*100):($2/100) via a3,b3,alpha3


set xrange [0:4.2]
set yrange [0:4]
set ytics 1,1,4
set xtics 0,1,4

set label 1 at 0.9,2.6 textcolor "#ff0000" '60 kV'
set label 2 at 1.03,1.65 textcolor "#007e00" '100 kV'
set label 3 at 1.5,0.75 textcolor "#ff8000" '140 kV'


## d in cm, mu in 1/cm 
plot	data_60kV u ($1*100):($2/100) ls 1 pt 64 ps 1.5,\
	[0.1:] f1(x) ls 1,\
	data_100kV u ($1*100):($2/100) ls 2 pt 66 ps 1.5,\
	[0.1:] f2(x) ls 2,\
	data_140kV u ($1*100):($2/100) ls 3 pt 65 ps 1.5,\
	[0.1:] f3(x) ls 3

	
unset output

#######################################################################################################
####################### plot attenuation mu_eff of measurements with filter  ##########################
#######################################################################################################

############ heuristic fit 140 kV 2mm Al measurement ########################
a4=a3
b4=5
alpha4=0.5

f4(x)=a4+b4/x**alpha4
fit f4(x) data_2mmAl_140kV using ($1*100):($2/100) via a4,b4,alpha4


############ heuristic fit 140 kV 4 mm Al measurement ########################
a5=a3
b5=5
alpha5=0.5

f5(x)=a5+b5/x**alpha5
fit f5(x) data_4mmAl_140kV using ($1*100):($2/100) via a5,b5,alpha5


############ heuristic fit 140 kV 1mm Cu measurement ########################
a6=a3
b6=0.12
alpha6=0.5

f6(x)=a6+b6/x**alpha6
fit f6(x) data_1mmCu_140kV using ($1*100):($2/100) via a6,b6,alpha6


unset label 1
unset label 2 
unset label 3
set output 'borosilicate_glass_filters_mu_eff.eps'
set yrange [0.0:3]

set label 3 at 1.9,1.17 rotate by -10 textcolor "#ff8000" 'no filter'
set label 4 at 0.45,1.3 rotate by -15 textcolor "#cc00cc" 'filter: 2mm Al'
set label 5 at 0.2,0.83 rotate by -8 textcolor "#6600cc" 'filter: 4mm Al'
set label 6 at 1,0.36 textcolor "#0066cc" 'filter: 1mm Cu'
set label 7 at 1.6,1.9 textcolor "#000000" '140 kV' font ',30'

plot	data_140kV u ($1*100):($2/100) ls 3 pt 65 ps 1.5,\
	[0.1:] f3(x) ls 3,\
	data_2mmAl_140kV u ($1*100):($2/100) ls 4 pt 11 ps 1.5,\
	[0.1:] f4(x) ls 4,\
	data_4mmAl_140kV u ($1*100):($2/100) ls 5 pt 68 ps 1.5,\
	[0.1:] f5(x) ls 5,\
	data_1mmCu_140kV u ($1*100):($2/100) ls 6 pt 5 ps 1.5,\
	[0.1:] f6(x) ls 6



unset output






######################################################################################################
###################### print fit parameters to file #################################################
######################################################################################################

set fit errorvariables
set print 'fit_parameters_mu_eff_borosilicate_glass.dat'
print a1, a1_err, b1, b1_err, alpha1, alpha1_err
print a2, a2_err, b2, b2_err, alpha2, alpha2_err
print a3, a3_err, b3, b3_err, alpha3, alpha3_err
print a4, a4_err, b4, b4_err, alpha4, alpha4_err
print a5, a5_err, b5, b5_err, alpha5, alpha5_err
print a6, a6_err, b6, b6_err, alpha6, alpha6_err




# #######################################################################################################
# ####################### plot voltage measurements Fig4 in Pease (2012) ################################ 
# #######################################################################################################
# unset label
# 
# ################################ asymptotic for mu_bar, and slope triangel ############################
# ####### read data from mu_bar files (manually) ##########
# set table
# 
# ########################## y-value , x-value ########### get values from file
# plot data_mu_bar_60kV us 0:($0==5?(x_mubar=$1):$1)
# plot data_mu_bar_60kV us 0:($0==5?(I_mubar=$6):$6)
# plot data_mu_bar_60kV us 0:($0==5?(I0_mubar=$4):$4)
# plot data_mu_bar_60kV us 0:($0==5?(mu_bar=$2):$2)
# unset table
# 
# set print '-'
# 
# tang_mu_bar(x) = mu_bar/100.*(x-x_mubar*100) - log(I_mubar/I0_mubar) # tangential mu_bar in point x_mubar
# 
# set arrow 1 from x_mubar*100.,(-log(I_mubar/I0_mubar)) \
# 	to 5./4.*100.*x_mubar,tang_mu_bar(5./4.*100.*x_mubar) nohead lw 3
# set arrow 2 from x_mubar*100.,(-log(I_mubar/I0_mubar)) \
# 	to 5./4.*100.*x_mubar,(-log(I_mubar/I0_mubar)) nohead lw 3
# set arrow 3 from 5./4.*100.*x_mubar,(-log(I_mubar/I0_mubar)) \
# 	to 5./4.*100.*x_mubar, tang_mu_bar(5./4.*100.*x_mubar) nohead lw 3
# set obj circle at x_mubar*100.,(-log(I_mubar/I0_mubar)) \
# 	size 0.2 arc [0.:40.]
# 
# set label 11 at 1.55,2.7 '~{/Symbol m}{.4-}' 
# 
# 
# ############################# mu_eff, slope triangel #################################################
# #set arrow from 100.*x_mubar,0 to 100.*x_mubar,(-log(I_mubar/I0_mubar)) nohead lw 3 dt 3
# set arrow 4 from 0,0 \
# 	to 100.*x_mubar,(-log(I_mubar/I0_mubar)) nohead lw 3 dt 3
# set arrow 5 from 0.75*x_mubar*100.,0.75*(-log(I_mubar/I0_mubar)) \
# 	to 100.*x_mubar,(-log(I_mubar/I0_mubar)) nohead lw 3
# set arrow 6 from 0.75*x_mubar*100.,0.75*(-log(I_mubar/I0_mubar)) \
# 	to 100.*x_mubar,0.75*(-log(I_mubar/I0_mubar)) nohead lw 3
# set arrow 7 from 100.*x_mubar,0.75*(-log(I_mubar/I0_mubar)) \
# 	to 100.*x_mubar,(-log(I_mubar/I0_mubar)) nohead lw 3
# set obj circle at 0.75*x_mubar*100.,0.75*(-log(I_mubar/I0_mubar)) \
# 	size 0.2 arc [0.:52.]
# 
# 
# set label 111 at 1.25,2.2 '{/Symbol m}_{eff}'
# 
# ########################### mu_0 from NIST, slope triangle ###########################################
# mu_0_60 = 2.417E-1*2.23 # value from NIST, multiplied with density
# 
# 
# set arrow 8 from 1.2,mu_0_60*1.2 to 1.6,mu_0_60*1.6 nohead lw 3
# set arrow 9 from 1.2,mu_0_60*1.2 to 1.6,mu_0_60*1.2 nohead lw 3
# set arrow 10 from 1.6,mu_0_60*1.2 to 1.6,mu_0_60*1.6 nohead lw 3
# set obj circle at 1.2,mu_0_60*1.2 \
# 	size 0.2 arc [0.:17.]
# 
# 
# set label 1111 at 1.65,0.75 '{/Symbol m}_{60keV}'
# 
# 
# 
# set output 'plots/Pease_plot_compare_mus_voltages_borosilicate_glass.eps'
# 
# 
# set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
# set ylabel '-ln({/Helvetica-Italic I/I_0})'
# #set logscale xy
# 
# set xrange [0:4.2]
# set yrange [0.0:4.5]
# set xtics 0.4,0.4,4
# 
# 
# set label 1 at 3.4,4.3 textcolor "#ff0000" '60 kV'
# set label 2 at 3.4,3.4 textcolor "#007e00" '100 kV'
# set label 3 at 3.4,2.5 textcolor "#ff8000" '140 kV'
# 
# 
# ## x in cm, mu_eff in 1/cm 
# plot data_60kV u ($1*100):(-log($6/$4)) ls 1 pt 64 ps 1.5,\
# 	f1(x)*x ls 1,\
#  	tang_mu_bar(x) ls 11,\
# 	mu_0_60*x lc "#000000" lw 3 dt 3,\
#         data_100kV u ($1*100):(-log($6/$4)) ls 2 pt 65 ps 1.5,\
#  	f2(x)*x ls 2,\
#         data_140kV u ($1*100):(-log($6/$4)) ls 3 pt 66 ps 1.5,\
#  	f3(x)*x ls 3
# 
# unset output
# 
# 
# 
# 
# 
# #######################################################################################################
# ####################### plot filter measurements Fig4 in Pease (2012) ################################ 
# #######################################################################################################
# set output 'plots/Pease_plot_compare_mus_filters_borosilicate_glass.eps'
# 
# 
# unset arrow
# unset label
# unset obj
# 
# set yrange [0:3.]
# 
# set label 3 at 2.4,2.5 rotate by 23 textcolor "#ff8000" '140 kV'
# set label 4 at 2.4,2. rotate by 23 textcolor "#cc00cc" '140kV 2mm Al'
# set label 5 at 2.4,1.45 rotate by 23 textcolor "#6600cc" '140kV 4mm Al'
# set label 6 at 2.4,1. rotate by 23 textcolor "#0066cc" '140kV 1mm Cu'
# 
# 
# ## x in cm, mu_eff in 1/cm 
# plot data_140kV u ($1*100):(-log($6/$4)) ls 3 pt 66 ps 1.5,\
# 	f3(x)*x ls 3,\
# 	data_2mmAl_140kV u ($1*100):(-log($6/$4)) ls 4 pt 67 ps 1.5,\
# 	f4(x)*x ls 4,\
#         data_4mmAl_140kV u ($1*100):(-log($6/$4)) ls 5 pt 68 ps 1.5,\
# 	f5(x)*x ls 5,\
# 	data_1mmCu_140kV u ($1*100):(-log($6/$4)) ls 6 pt 69 ps 1.5,\
# 	f6(x)*x ls 6
# 
# unset output


# final directory
# cd 'plot_scripts'









