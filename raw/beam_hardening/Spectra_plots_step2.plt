# gnuplot program
# polt N_0 spectrum directly emitted from tube

reset

set term postscript eps enhanced color solid dashed font ',30' size '5','3.5'

set samples 1000
set for [i=1:5] linetype i dt i

# style of lines
set style line 1 lt 1 lc rgb "#0000ff" lw 5
set style line 2 lt 1 lc rgb "#ff0000" lw 5
set style line 3 lt 3 lc rgb "#0000ff" lw 5

# style of filled curves (slightly transparent)
set style line 11 lt 1 lc rgb "#6666ff" # light blue 
set style line 22 lt 1 lc rgb "#ff6666" # light red
set style line 33 lt 1 lc rgb "#a6a6ff" # very light blue

den_Al = 2.6989 # density of aluminum
############### N_0 spectrum as emitted from tube #######################
data_N0 = '2X_140kV_1mLuft.dat'

set output 'N0_initial_spectrum_filled_curves.eps'

unset key
set xrange[0:150]
set yrange[0:5]
set tics front

set xlabel 'Photon energy, {/Helvetica-Italic E} (keV)'
set ylabel 'Photon intensity, {/Helvetica-Italic N} (a.u.)'
plot 	data_N0 u ($1):($2*10**(-11)) ls 11 with filledcurves,\
	data_N0 u ($1):($2*10**(-11)) ls 1 with lines
	

unset output 


############### N spectrum after transmitted through slab of material ########
data_N = 'attenuation_photon_energy.dat'

set output 'N_spectrum_after_material_filled_curves_step2.eps'

# thickness of slab in (cm)
x0 = 0.6 

plot	data_N0 u ($1):($2*10**(-11)) ls 33 with filledcurves,\
	data_N0 u ($1):($2*10**(-11)) ls 1 with lines,\
	data_N u ($1*1000):($6*exp(-$5*den_Al*x0)*10**(-11)) ls 22 with filledcurves,\
	data_N u ($1*1000):($6*exp(-$5*den_Al*x0)*10**(-11)) ls 2 with lines

unset output


 
