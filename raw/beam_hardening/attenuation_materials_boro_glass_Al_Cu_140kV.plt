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
set style line 1 lt 1 lc rgb "#00cccc" lw 3
set style line 2 lt 1 lc rgb "#808080" lw 3
set style line 3 lt 1 lc rgb "#994c00" lw 3



# data for mu_eff plots
data_140kV_bglass='borosilicate_glass_plates/mu_eff_140kV_150uA_100ms.dat'
data_140kV_Al='Al_plates/mu_eff_140kV_175uA_100ms.dat'
data_140kV_Cu='Cu_plates/mu_eff_140kV_160uA_100ms.dat'

#######################################################################################################
####################### plot attenuation mu_eff of different materials at 140kV  ######################
#######################################################################################################
set output 'materials_mu_eff_140kV_fit.eps'

set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic x}) (1/cm)'



unset key #bottom right maxrows 3 width -16 title 'glass vs. bronze'

############ heuristic fit 140 kV, borosilicate glass plates measurement ########################
a1= 1.439E-1 * 2.23 # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
b1=5.
alpha1=0.5

f1(x)=a1+b1/x**alpha1
fit f1(x) data_140kV_bglass using ($1*100):($2/100) via a1,b1,alpha1


############ heuristic fit 140 kV, Al plates measurement #######################################
a2= 2.
b2=5.
alpha2=0.5

f2(x)=a2+b2/x**alpha2
fit f2(x) data_140kV_Al using ($1*100):($2/100) via a2,b2,alpha2


############ heuristic fit 140 kV, Cu plates measurement #######################################
a3=2. 
b3=5.
alpha3=0.5

f3(x)=a3+b3/x**alpha3
fit f3(x) data_140kV_Cu using ($1*100):($2/100) via a3,b3,alpha3


set xrange [0:4.2]
set yrange [0.0:13.]
set xtics 0,1,4
set ytics 0,4,12

set label 1 at 0.1,.7 textcolor "#00cccc" 'boro. glass'
set label 2 at 0.8,2.2 textcolor "#808080" 'Al'
set label 3 at 1.5,3.2 textcolor "#994c00" 'Cu'
set label 4 at 1.6,7.0 textcolor "#000000" '140 kV'

## d in cm, mu in 1/cm 
plot	data_140kV_bglass u ($1*100):($2/100) ls 1 pt 64 ps 1.5,\
	[0.1:] f1(x) ls 1,\
	data_140kV_Al u ($1*100):($2/100) ls 2 pt 7 ps 1.5,\
	[0.1:] f2(x) ls 2,\
	data_140kV_Cu u ($1*100):($2/100) ls 3 pt 66 ps 1.5,\
	[0.1:] f3(x) ls 3


unset output



# ######################################################################################################
# ##################### plot I over I0 to understand mu_eff for varying materials ######################
# ######################################################################################################
# set output 'plots/materials_I_over_I0_140kV.eps'
# 
# unset yrange
# set ylabel '{/Helvetica-Italic I/I_0}'
# unset label
# 
# ## d in cm, mu in 1/cm 
# plot	data_140kV_bglass u ($1*100):($6/$4) ls 1 pt 64 ps 1.5,\
# 	data_140kV_Al u ($1*100):($6/$4) ls 2 pt 65 ps 1.5,\
# 	data_140kV_Cu u ($1*100):($6/$4) ls 3 pt 66 ps 1.5
# 
# 
# unset output
# 
# # final directory
# cd 'plot_scripts'
# 
# 
# 






