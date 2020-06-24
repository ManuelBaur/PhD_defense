# gnuplot program
# polt N_0 spectrum directly emitted from tube

reset

set term postscript eps enhanced color solid dashed font ',25' size '5','7.5'

set samples 1000
set for [i=1:5] linetype i dt i


set style line 1 lc rgb "#0000ff" lw 5 
set style line 2 lc rgb "#009900" lw 5 
set style line 3 lc rgb "#ff0000" lw 5 
set style line 11 lt 1 lc rgb "#a6a6ff" # light blue for filling 

data_N0 = '2X_140kV_1mLuft.dat'
data_mu = 'attenuation_Al_with_absorption_edges.dat'
data_detectors = 'detector_response_all.dat'



set output 'Intensity_integral_multiplot.eps'

set multiplot layout 3,1
set lmargin 7


############################ spectrum - plot ###################
set tmargin 1.
set bmargin 0.4

set origin 0.,0.65
set size 1.,0.35 
unset key
set xrange[0:140]
set xtics format ''
set yrange[0:5]
set tics front


set label 1 at -18,1. rotate by 90 'Photon intensity, {/Helvetica-Italic N} (a.u.)'
set label 11 at 133,4.7 font ',30' 'a)'

plot	data_N0 u ($1):($2*10**(-11)) ls 11 with filledcurves,\
	data_N0 u ($1):($2*10**(-11)) ls 1 with lines 

unset label 1
unset label 11

########################## attenuation - plot #################

set origin 0.,0.35
set size 1.,0.3
set bmargin 0.4
set tmargin 0.

set xtics format ''
set logscale y
set yrange [0.1:20000.]
set ytics format "10^{%T}" 
set label 2 at -18,0.15 rotate by 90 \
	'Attenuation, {/Symbol m}({/Helvetica-Italic E,Z},{/Symbol r}) (1/cm)'
set label 22 at 133,8000 font ',30' 'b)'

den_Al = 2.6989 # density of aluminum (g/cm³)

plot data_mu u ($1*1000):($5*den_Al) ls 2 with lines

unset label 2
unset label 22

####################### sensitivity of detector - plot ##########
set origin 0.,0.
set size 1.,0.35
set bmargin 3.5

set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'
unset logscale
set format '%g'

set yrange [0:0.6]
set ytics 0,0.1,0.5
set label 3 at -18,0.02 rotate by 90 \
	'Detector sensitivity, {/Helvetica-Italic S(E)}'
set label 33 at 133,0.55 font ',30' 'c)'
# set label at 10,3 front textcolor rgb "#ff0000" font ',150' 'Norman'

plot [0:140.] data_detectors u 1:2 ls 3 with lines

unset label  
 
unset multiplot
unset output 


