# gnuplot program
# polt N_0 spectrum directly emitted from tube

reset

set term postscript eps enhanced color solid dashed font ',20' size '5','7.5'

set samples 1000
set for [i=1:5] linetype i dt i

#### spectrum
set style line 1 lc rgb "#0000ff" lw 6 ### spectrum

set style line 11 lt 1 lc rgb "#a6a6ff" # light blue for filling 
#### attenuation
set style line 21 lt 1 lc rgb '#ff66ff' lw 6 
set style line 22 lt 1 lc rgb '#0080ff' lw 6 
set style line 23 lt 1 lc rgb '#ff8000' lw 6 
set style line 24 lt 1 lc rgb '#009000' lw 6 
set style line 222 lt 2 lc rgb '#0080ff' lw 4
set style line 233 lt 2 lc rgb '#ff8000' lw 4 
set style line 244 lt 2 lc rgb '#009000' lw 4
#### detector response
set style line 3 lc rgb "#ff0000" lw 6 ### detector response

data_N0 = 'intensity_integral_numerical/Comet_with_energy.dat'
data_mu = 'intensity_integral_numerical/attenuation_Al_with_absorption_edges.dat'
data_detectors = 'intensity_integral_numerical/Detector_with_energy_all2.dat'

den_Al = 2.6989 # density of aluminum


set output 'Intensity_integral_multiplot_numerical.eps'

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
set yrange[0:4.5]
set ytics 0,1,4
set tics front


set label 1 at -15,1. rotate by 90 'Photon intensity, {/Helvetica-Italic N} (a.u.)'
set label 11 at 133,4.2 font ',30' 'a)'

plot	data_N0 u ($1):($2)/7000 ls 11 with filledcurves,\
	data_N0 u ($1):($2)/7000 ls 1 with lines 
# plot [0:140.] data_N0 u ($1):($2) ls 1 with lines 


unset label 1
unset label 11
unset ytics

########################## attenuation - plot #################

set origin 0.,0.35
set size 1.,0.3
set bmargin 0.4
set tmargin 0.

set xtics format ''
set logscale y
set yrange [0.1:20000]
set ytics 1,10,20000
set ytics format "10^{%T}" 
set label 2 at -15,0.5 rotate by 90 \
	'Attenuation, {/Symbol m}({/Helvetica-Italic E,Z},{/Symbol r}) (1/cm)'
set label 29 at 133,8000 font ',30' 'b)'

plot data_mu u ($1*1000):($5*den_Al) ls 24 with lines 


unset label 2
unset label 29

####################### sensitivity of detector - plot ##########
set origin 0.,0.
set size 1.,0.35
set bmargin 3.5

set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'
unset logscale
set format '%g'

set yrange [0:4]
set ytics 0,1,4
set label 3 at -15,0.02 rotate by 90 \
	'Detector sensitivity, {/Helvetica-Italic S(E)} (a.u.)'
set label 33 at 133,3.7 font ',30' 'c)'
# set label at 10,3 front textcolor rgb "#ff0000" font ',150' 'Norman'

plot [0:140.] data_detectors u 1:2 ls 3 with lines

unset label  
 
unset multiplot
unset output 


