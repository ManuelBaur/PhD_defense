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
set format xy "%.1f"



set for [i=1:5] linetype i dt i
set for [i=1:5] style line i dt i

##### linetypes for different measurement series, for fit with heuristic expression ###########
set style line 1 lt 2 lc rgb "#ff0000" lw 5
set style line 2 lt 2 lc rgb "#0066cc" lw 5
set style line 3 lt 1 lc rgb "#ff8000" lw 5
set style line 4 lt 1 lc rgb "#00cccc" lw 5
set style line 5 lt 1 lc rgb "#ff8000" lw 5


# data for mu_eff plots
data_exp_140kV_Al_Norman = 'data_Norman/mu_eff_Al_140kV.dat'
data_num_140kV_Al='numerical_data/Numerical_muEff_new.dat'


##################################################################################################
####################### plot attenuation mu_eff of different materials at 140kV  #################
##################################################################################################
set output 'mu_eff_140kV_exp_vs_numeric_data_norman.eps'

set xlabel 'Thickness, {/Helvetica-Italic x} (cm)'
set ylabel 'Attenuation, {/Symbol m}_{eff}({/Helvetica-Italic E,x}) (1/cm)'



unset key #bottom right maxrows 3 width -16 title 'glass vs. bronze'

############ heuristic fit 140 kV, Al plates measurement #######################################

###### fit to data from Norman
a2= 2.
b2=5.
alpha2=0.5

f2(x)=a2+b2/x**alpha2
fit f2(x) data_exp_140kV_Al_Norman using 1:2 via a2,b2,alpha2


set xrange [0:4.2]
set yrange [0.6:1.5]
set xtics format '%.f'
set xtics 0,1,4
set ytics 0.6,0.2,1.4

set label 2 at 0.4,0.85 textcolor "#0066cc" 'Exp. data' front
set label 3 at 2.4,0.95 textcolor "#ff8000" 'Num. data '

## d in cm, mu in 1/cm 
plot	data_exp_140kV_Al_Norman u 1:2 ls 2 pt 65 ps 1.5,\
	data_num_140kV_Al u ($1):($2) ls 3 with lines
	# [0.1:4.2] f2(x) ls 2,\

unset output































