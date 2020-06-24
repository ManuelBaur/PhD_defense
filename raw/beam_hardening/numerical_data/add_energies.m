clear 
close all

or_Comet = load('data_sent_2018-10-09/Comet_MXR225HP11_140kV_10000Me_long450.spec');

or_Detector = load('data_sent_2018-10-09/Detektor_m1mmCFK_300muCsI_100k_pCh.dat');

energy_Comet = (1:1:450)';

energy_Detector = (1:1:225)';


%%
outComet = 'data_sent_2018-10-09/Comet_with_energy_all2.dat';
CometID = fopen(outComet,'w');

fprintf(CometID, '%.1f %d\r\n', [energy_Comet, or_Comet]');

fclose(CometID);

%%
outDet = 'data_sent_2018-10-09/Detector_with_energy_all2.dat';
DetID = fopen(outDet,'w');

fprintf(DetID, '%.1f %.18f\r\n', [energy_Detector, or_Detector]');


fclose(DetID);


