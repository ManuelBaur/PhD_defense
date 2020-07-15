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
data_mu = 'intensity_integral_lin_spectrum_step_response_function/x-com_data.dat'
# data_detectors = 'intensity_integral_lin_spectrum_step_response_function/step_detector_response.dat'



set output 'XCOM_attenuation.eps'

# ############################ spectrum - plot ###################
# unset key
# set xrange[0:150]
# set xtics format ''
# set yrange[0:5]
# set tics front
# 
# set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'
# set ylabel 'Photon intensity, {/Helvetica-Italic N} (a.u.)'
# 
# plot [0:150.] data_N0 u ($1):($2) ls 1 with lines 

########################## attenuation - plot #################

# set origin 0.,0.35
# set size 1.,0.3
# set bmargin 0.4
# set tmargin 0.

### fit function total attenuation ########
den=2.23 # density to borosilicate glass
atot(x) = mu0 + c/x**3
fit atot(x) data_mu using ($1*1000):($5*den) via mu0,c



unset key

set logscale y
set xrange[0:150]
set yrange [0.2:19.630]
set ytics format "10^{%T}"
unset mytics
set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'
set ylabel 'Attenuation, {/Symbol m}({/Helvetica-Italic E}) (1/cm)'

# plot data_mu u ($1*1000):($2*den) ls 21 pt 66 ps 1.5,\
# data_mu u ($1*1000):($3*den) ls 22 pt 66 ps 1.5,\
# data_mu u ($1*1000):($4*den) ls 23 pt 66 ps 1.5,\
# data_mu u ($1*1000):($5*den) ls 24 pt 66 ps 1.5,\
# mu0 ls 222,\
# c/x**3 ls 233,\
# atot(x) ls 244

plot data_mu u ($1*1000):($5*den) ls 24 pt 66 ps 1.5,\
atot(x) ls 244


# plot data_mu u ($1*1000):($5*den) ls 2 with lines

unset label 2
unset label 29
unset label 21
unset label 22
unset label 23
unset label 24


# ####################### sensitivity of detector - plot ##########
# set origin 0.,0.
# set size 1.,0.35
# set bmargin 3.5
# 
# set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'
# unset logscale
# set format '%g'
# 
# set yrange [0:0.6]
# set ytics 0,0.1,0.5
# set label 3 at -15,0.02 rotate by 90 \
# 	'Detector sensitivity, {/Helvetica-Italic S(E)} (a.u.)'
# set label 33 at 143,0.55 font ',30' 'c)'
# # set label at 10,3 front textcolor rgb "#ff0000" font ',150' 'Norman'
# 
# plot [0:150.] data_detectors u 1:2 ls 3 with lines
# 
# unset label  
#  
# unset multiplot
# unset output 


