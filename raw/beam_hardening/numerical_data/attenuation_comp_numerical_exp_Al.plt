# gnuplot program
# plot attenuation for different materials:
#  borosilicate glass & Al & Cu at 140 kV

reset

# fc='/nishome/manuel/Dokumente/papers_and_reports/x-ray_attenuation/attenuation_output/'
#  
# directory=fc
# cd directory



# create eps output
set term postscript eps enhanced color solid dashed font ',20' size '5','3.5'
# set termoption dash
#set title ''
set samples 1000
set format xy "%.1f"



set for [i=1:5] linetype i dt i
set for [i=1:5] style line i dt i

##### linetypes for different measurement series, for fit with heuristic expression ###########
set style line 1 lt 2 lc rgb "#ff0000" lw 3
set style line 2 lt 2 lc rgb "#007e00" lw 3
set style line 3 lt 1 lc rgb "#0000ff" lw 3
set style line 4 lt 1 lc rgb "#00cccc" lw 3
set style line 5 lt 1 lc rgb "#ff8000" lw 3


# data for mu_eff plots
data_exp_140kV_Al='Al_plates/mu_eff_140kV_175uA_100ms.dat'
data_exp_140kV_Al_Norman = 'data_Norman/mu_eff_Al_140kV.dat'
data_num_140kV_Al='numerical_data/Numerical_muEff_perkin_elmer.dat'


##################################################################################################
####################### plot attenuation mu_eff of different materials at 140kV  #################
##################################################################################################
set output 'mu_eff_140kV_exp_vs_numeric.eps'

set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic E,x}) (1/cm)'



unset key #bottom right maxrows 3 width -16 title 'glass vs. bronze'

############ heuristic fit 140 kV, Al plates measurement #######################################

####### fit to ct-rex data 
a1= 2.
b1=5.
alpha1=0.5

f1(x)=a1+b1/x**alpha1
fit f1(x) data_exp_140kV_Al using ($1*100):($2/100) via a1,b1,alpha1

###### fit to data from Norman
a2= 2.
b2=5.
alpha2=0.5

f2(x)=a2+b2/x**alpha2
fit f2(x) data_exp_140kV_Al_Norman using 1:2 via a2,b2,alpha2


set xrange [0:4.2]
set yrange [0.0:3.]
set xtics 0.4,0.4,4

set label 1 at 0.4,2.5 textcolor "#ff0000" 'Exp. data, CT-Rex' front
set label 2 at 0.4,0.8 textcolor "#007e00" 'Exp. data, Setup Norman' front
set label 3 at 2.4,1.1 textcolor "#0000ff" 'Num. data, Perkin Elmer'
set label 4 at 1.5,1.6 textcolor "#00cccc" 'Num. data, Medipix'
set label 5 at 2.7,2.6 textcolor "#ff8000" 'Num. data, GM-ideas'

## d in cm, mu in 1/cm 
plot	data_exp_140kV_Al u ($1*100):($2/100) ls 1 pt 7 ps 1.5,\
	[0.1:4.2] f1(x) ls 1,\
	data_exp_140kV_Al_Norman u 1:2 ls 2 pt 65 ps 1.5,\
	[0.1:4.2] f2(x) ls 2,\
	data_num_140kV_Al u ($1):($2) ls 3 with lines,\
	data_num_140kV_Al u 1:3 ls 4 with lines,\
	data_num_140kV_Al u 1:4 ls 5 with lines
unset output































