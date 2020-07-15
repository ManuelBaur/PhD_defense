# gnuplot program
# plot attenuation for different materials:
#  borosilicate glass & Al & Cu at 140 kV

reset

# fc='/nishome/manuel/Dokumente/papers_and_reports/x-ray_attenuation/attenuation_output/'
#  
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
set style line 1 lt 1 lc rgb "#0000cc" lw 6
set style line 2 lt 1 lc rgb "#0066cc" lw 6
set style line 3 lt 1 lc rgb "#009900" lw 6
set style line 4 lt 1 lc rgb "#66cc00" lw 6
set style line 5 lt 1 lc rgb "#99004c" lw 6
set style line 6 lt 1 lc rgb "#cc00cc" lw 6




####### data setup Norman for mu_eff plots
data_Al_140kV_Norm = 'data_Norman/mu_eff_Al_140kV.dat'
# data_NaSiO2_140kV_Norm = 'data_Norman/mu_eff_NaSiO2_140kV.dat'


####### data our setup: CT-Rex
data_Al_140kV_Rex = 'Al_plates/mu_eff_140kV_175uA_100ms.dat'
# data_boro_glass_140kV_Rex = 'borosilicate_glass_plates/mu_eff_140kV_150uA_100ms.dat'

#######################################################################################################
####################### plot attenuation mu_eff of different materials at 140kV  ######################
#######################################################################################################
set output 'comp_both_setups.eps'

set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic E,x}) (1/cm)'



unset key #bottom right maxrows 3 width -16 title 'glass vs. bronze'

############ heuristic fit Al 140 kV - data Norman ########################
a1= 1.439E-1 * 2.23 
b1=5.
alpha1=0.5

f1(x)=a1+b1/x**alpha1
fit f1(x) data_Al_140kV_Norm using 1:2 via a1,b1,alpha1

# ############# heuristic fit NaSiO2 140 kV - data Norman ########################
# a2= 2.
# b2=5.
# alpha2=0.5
# 
# f2(x)=a2+b2/x**alpha2
# fit f2(x) data_NaSiO2_140kV_Norm using 1:2 via a2,b2,alpha2


############# heuristic fit Al 140 kV - data CT-Rex ########################
a3= 1.439E-1 * 2.23 
b3=5.
alpha3=0.5

f3(x)=a3+b3/x**alpha3
fit f3(x) data_Al_140kV_Rex using ($1*100):($2/100) via a3,b3,alpha3 ## units different


# ############# heuristic fit boro silicate glass 140 kV - data CT-Rex ########################
# a4= 2.
# b4=5.
# alpha4=0.5
# 
# f4(x)=a4+b4/x**alpha4
# fit f4(x) data_boro_glass_140kV_Rex using ($1*100):($2/100) via a4,b4,alpha4 # units different


###################### plot data and fits ##############################
set xrange [0:4.2]
set yrange [0.5:3.0]
set xtics 0,1,4
set ytics 1,1,3

set label 1 at 0.6,0.7 textcolor "#0000cc" 'Al, 140 kV, setup 2' # rotate by -13
# set label 2 at 1.6,0.7 textcolor "#0066cc" 'Sodium Silicate, 140 kV, setup 2' rotate by -4
set label 3 at 0.6,1.9 textcolor "#009900" 'Al, 140 kV, setup 1'
# set label 4 at 2.3,1.1 textcolor "#66cc00" 'Boro. glass, 140 kV, setup 1' rotate by -10


## d in cm, mu in 1/cm 
plot	data_Al_140kV_Norm u 1:2 ls 1 pt 13 ps 1.5,\
	[0.1:] f1(x) ls 1,\
	data_Al_140kV_Rex u ($1*100):($2/100) ls 3 pt 5 ps 1.5,\
	[0.1:] f3(x) ls 3
	# data_NaSiO2_140kV_Norm u 1:2 ls 2 pt 66 ps 1.5,\
	# [0.1:] f2(x) ls 2,\
	# data_boro_glass_140kV_Rex u ($1*100):($2/100) ls 4 pt 67 ps 1.5,\
	# [0.1:] f4(x) ls 4 
	


unset output



# final directory
# cd 'plot_scripts'









