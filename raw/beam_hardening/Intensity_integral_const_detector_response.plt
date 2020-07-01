# gnuplot program
# polt N_0 spectrum directly emitted from tube

reset

set term postscript eps enhanced color solid dashed font ',30' size '5','3.5'

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

# data_N0 = 'intensity_integral_lin_spectrum_step_response_function/lin_decaying_spectrum.dat'
# data_mu = 'intensity_integral_lin_spectrum_step_response_function/x-com_data.dat'
data_detectors = 'intensity_integral_lin_spectrum_step_response_function/step_detector_response.dat'



set output 'detector_const.eps'

####################### sensitivity of detector - plot ##########
set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'
unset key
set format '%g'

set yrange [0:0.6]
set ytics 0,0.1,0.5
set ylabel 'Detector sensitivity, {/Helvetica-Italic S(E)} (a.u.)'

plot [0:150.] data_detectors u 1:2 ls 3 lw 6 with lines

unset label  
 
unset output 


