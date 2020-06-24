# gnuplot program
# polt N_0 spectrum directly emitted from tube

reset

set term postscript eps enhanced color solid dashed font ',30' size '5','3.5'

set samples 1000
set for [i=1:5] linetype i dt i

# style of lines
set style line 2 lt 1 lc rgb "#ff0000" lw 5

data_detectors = 'detector_response_all.dat'

set output 'Detector_response.eps'

unset key
set xrange[0:150]
set yrange[0:0.6]
set ytics 0,0.1,0.5

set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'
set ylabel 'Detector sensitivity, {/Helvetica-Italic S(E)} (a.u.)'
plot [0:140.] data_detectors u 1:2 ls 2 with lines


unset output 


 
