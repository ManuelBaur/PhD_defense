# gnuplot program
# polt N_0 spectrum directly emitted from tube

reset

set term postscript eps enhanced color solid dashed font ',30' size '5','3.5'

set samples 1000
set for [i=1:5] linetype i dt i


set style line 1 lc rgb "#009900" lw 5 
set style line 2 lc rgb "#66CDAA" lw 5 

data_muAl = 'attenuation_Al_with_absorption_edges.dat'
# data_muGlass = 'attenuation_glass.dat'
data_muGlass = 'attenuation_glass_nist.dat'
data_muWater = 'attenuation_water_nist.dat'



set output 'Attenuation_vs_energy.eps'

 
unset key 
set logscale y
set xrange [0:140]
set yrange [0.1:20000.]
set ytics format "10^{%T}" 
set ylabel 'Attenuation, {/Symbol m}({/Helvetica-Italic E,Z},{/Symbol r}) (1/cm)'
set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'

den_Al = 2.6989 # density of aluminum (g/cm³)
den_Glass = 2.23
den_Water = 1.


set label 1 at 10, 0.2 'water' textcolor '#66CDAA'
set label 2 at 45, 1.5 'glass' textcolor '#009900'

plot data_muGlass u ($1*1000):($2*den_Glass) ls 1 with lines,\
	data_muWater u ($1*1000):($2*den_Water) ls 2 with lines


unset output 


