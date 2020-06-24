clear 
close all


old_data = load('2X_140kV_1mLuft.dat');
new_data = load('data_sent_2018-10-09/Comet_with_energy.dat');

figure;
plot(old_data(:,1),old_data(:,2)/mean(old_data(:,2)),'-r');
hold on
plot(new_data(:,1),new_data(:,2)/mean(new_data(:,2)),'--b');