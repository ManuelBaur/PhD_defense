# gnuplot program
# plot attenuation for borosilicate glass

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
set style line 1 lt 1 lc rgb "#ff0000" lw 5 
# set style line 2 lt 1 lc rgb "#007e00" lw 3
set style line 3 lt 1 lc rgb "#ff8000" lw 5 
# set style line 4 lt 1 lc rgb "#cc00cc" lw 3
# set style line 5 lt 1 lc rgb "#6600cc" lw 3
# set style line 6 lt 1 lc rgb "#0066cc" lw 3

##### linetypes for different measurement series, for fit with function solving intensity integral #
set style line 11 lt 2 lc rgb "#009999" lw 5 
# set style line 22 lt 2 lc rgb "#007e00" lw 3
set style line 33 lt 2 lc rgb "#0000ff" lw 5 
# set style line 44 lt 2 lc rgb "#cc00cc" lw 3
# set style line 55 lt 2 lc rgb "#6600cc" lw 3
# set style line 66 lt 2 lc rgb "#0066cc" lw 3

# ##### linetypes for different measurement series, for fit with function solving intensity integral
# set style line 111 lt 3 lc rgb "#ff0000" lw 3
# set style line 222 lt 3 lc rgb "#007e00" lw 3
# set style line 333 lt 3 lc rgb "#ff8000" lw 3
# set style line 444 lt 3 lc rgb "#cc00cc" lw 3
# set style line 555 lt 3 lc rgb "#6600cc" lw 3
# set style line 666 lt 3 lc rgb "#0066cc" lw 3



# data for mu_eff plots
data_60kV='borosilicate_glass_plates/mu_eff_60kV_500uA_120ms.dat'
data_100kV='borosilicate_glass_plates/mu_eff_100kV_200uA_100ms.dat'
data_140kV='borosilicate_glass_plates/mu_eff_140kV_150uA_100ms.dat'

# data for mu_eff plots - 3 datapoints. not limits in x 
data_60kV_1='borosilicate_glass_plates/mu_eff_60kV_3datapoints.dat'
data_100kV_1='borosilicate_glass_plates/mu_eff_100kV_3datapoints.dat'
data_140kV_1='borosilicate_glass_plates/mu_eff_140kV_3datapoints.dat'

# data for mu_eff plots - 3 datapoints. borders at limits of measured data 
data_60kV_2='borosilicate_glass_plates/mu_eff_60kV_3datapoints_2.dat'
data_100kV_2='borosilicate_glass_plates/mu_eff_100kV_3datapoints_2.dat'
data_140kV_2='borosilicate_glass_plates/mu_eff_140kV_3datapoints_2.dat'

# data for solving Newton - Thickness measurement via fit
data_New_60kV_1='length_measurement/Thickness_Newton_20datapoints_60kV.dat'
data_New_140kV_1='length_measurement/Thickness_Newton_20datapoints_140kV.dat'
data_New_60kV_2='length_measurement/Thickness_Newton_3datapoints_60kV.dat'
data_New_60kV_3points='length_measurement/Thickness_Newton_3datapoints_60kV_3.dat' # just 3 points in file
data_New_140kV_2='length_measurement/Thickness_Newton_3datapoints_140kV.dat'
data_New_140kV_3points='length_measurement/Thickness_Newton_3datapoints_140kV_3.dat' # just 3 points in file


###############################################################################
############ heuristic fit 60 kV measurement all data  ########################
a1= 2.554E-1 * 2.23 # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
b1=5
alpha1=0.5

f1(x)=a1+b1/x**alpha1
fit f1(x) data_60kV using ($1*100):($2/100) via a1,b1,alpha1

############ heuristic fit 60 kV measurement 3 data points - not at extrema ########################
# FIT_LIMIt = 1e-12
a11= -430. # value from NIST for 60kV acceleration voltage, multiplied with densitiy of boro glass
b11= 432.
alpha11= 0.00199

f11(x)=a11+b11/x**alpha11
fit f11(x) data_60kV_1 using ($1*100):($2/100) via a11,b11,alpha11

############ heuristic fit 140 kV measurement ########################
a3= 1.439E-1 * 2.23
b3=5
alpha3=0.5

f3(x)=a3+b3/x**alpha3
fit f3(x) data_140kV using ($1*100):($2/100) via a3,b3,alpha3

############ heuristic fit 140 kV measurement 3 data points not at extrema ########################
a33= 1.439E-1 * 2.23
b33=5
alpha33=0.5

f33(x)=a33+b33/x**alpha33
fit f33(x) data_140kV_1 using ($1*100):($2/100) via a33,b33,alpha33

###################################################################################################
############### multiplot of difference - data versus fit #########################################

set output '3datapoints_conclusion.eps'

# set multiplot layout 2,1
# 
# set bmargin 0.4
# set lmargin 7.
# 
# set origin 0.,0.49
# set size 1.,0.52

set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set ylabel '{/Symbol m}_{eff}({/Helvetica-Italic x}) (1/cm)'

set xrange [0:4.2]
set yrange [0.0:4.]
set xtics 1,1,4
# set xtics format ''
set ytics 1,1,4


unset key #at 4.,3.5

set label 1 at 0.5,3.25 textcolor "#ff0000" '60 kV'
# set label 2 at 1.1,1.7 textcolor "#007e00" '100 kV'
set label 3 at 1.5,0.7 textcolor "#ff8000" '140 kV'


## d in cm, mu in 1/cm 
plot data_60kV_1 u ($1*100):($2/100) ls 11 pt 5 ps 2,\
	data_140kV_1 u ($1*100):($2/100) ls 33 pt 7 ps 2,\
	[0.1:] f1(x) ls 1,\
	[0.1:] f11(x) ls 11,\
	[0.1:] f3(x) ls 3,\
	[0.1:] f33(x) ls 33 

# data_60kV u ($1*100):($2/100) ls 1 pt 64 ps 1.5,\
# data_140kV u ($1*100):($2/100) ls 3 pt 65 ps 1.5,\
# ghost plot for keys
# set key top right; unset tics; unset border; unset xlabel; unset ylabel
# 
# set origin 0.,0.6
# set size 1.,0.4
# plot [][-1:-0.5] 2 with linespoints ls 1 pt 64 ps 1.5 t '20 data fit, 60 kV',\
# 	2 with linespoints ls 3 pt 65 ps 1.5 t '20 data fit, 140 kV',\
# 	2 with linespoints ls 11 pt 5 ps 1.5 t '3 data fit, 60 kV',\
# 	2 with linespoints ls 33 pt 7 ps 1.5 t '3 data fit, 140 kV'


