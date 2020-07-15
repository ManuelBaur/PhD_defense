# gnuplot program
# polt N_0 spectrum directly emitted from tube

reset

set term postscript eps enhanced color solid dashed font ',30' size '5','3.5'

set samples 1000
set for [i=1:5] linetype i dt i


set style line 1 lc rgb "#0000ff" lw 3
set style line 2 lc rgb "#009900" lw 5 
set style line 3 lc rgb "#ff0000" lw 3
set style line 11 lt 1 lc rgb "#a6a6ff" # light blue for filling 

# data_N0 = '2X_140kV_1mLuft.dat'
data_mu = 'attenuation_Al_with_absorption_edges.dat'
# data_detectors = 'detector_response_all.dat'



set output 'Attenuation_vs_energy.eps'

 
unset key 
unset mytics
set logscale y
set yrange [0.1:20000.]
set ytics format "10^{%T}" 
set ylabel 'Attenuation, {/Symbol m}({/Helvetica-Italic E,Z},{/Symbol r}) (1/cm)'
set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'

den_Al = 2.6989 # density of aluminum (g/cm³)

plot data_mu u ($1*1000):($5*den_Al) ls 2 with lines

unset output 


