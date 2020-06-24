% Load data of 
%   initial x-ray spectrum of a tungsten tube
%   attenuation of 1cm aluminum block
%   detector response data
% Numerical integration of all three leads to the measured mu_eff value.
% Comparison to experimental values.


clear
close all

%% load data

% spectra data (140kV, 1m air, by Norman Uhlmann, Monte Carlo)
% 1000uA, 140kV, Comet MXR-225 Rosi (info from Norman Uhlmann)
in_spectrum = load('2X_140kV_1mLuft.dat');


% attenuation data of Al (1cm) created by XCOM (NIST)
in_mu_Al = load('attenuation_Al_with_absorption_edges1.dat');

keV_mu_in0 = in_mu_Al(:,1)*10^3; % energy values attenuation, with absorption edges
mu_Al_mass0 = in_mu_Al(:,5); % attenuation with absoroption edges

den_Al = 2.6989; % density aluminum from NIST, (g/cm^3)
mu_Al0 = mu_Al_mass0 * den_Al; % (1/cm)

% detector response data (Norman Uhlmann)
in_detectors = load('detector_response_all.dat');

keV_detectors0 = in_detectors(:,1);
det_per_el0 = in_detectors(:,2); % perkin elmer, units ?????????????
det_medipix0 = in_detectors(:,3); % Medipix, units ??????????
det_gm_ideas0 = in_detectors(:,4); % GM-ideas, units ??????


keV = in_spectrum(:,1); % energy values, in keV
spectrum = in_spectrum(:,2); % ???????? units?? might be number of photons

%% select data corresponding to integer energy values

ind_keV_mu_in = find(mod(keV_mu_in0,1)); % inidces of non integer elements
keV_mu_in = keV_mu_in0;
keV_mu_in(ind_keV_mu_in) = [];

mu_Al_mass = mu_Al_mass0;
mu_Al_mass(ind_keV_mu_in) = [];
mu_Al = mu_Al_mass * den_Al; % attenuation in (1/cm)


% energies for detector response
ind_keV_detectors = find(mod(keV_detectors0,1)); % indices of non integer elements
keV_detectors = keV_detectors0;
keV_detectors(ind_keV_detectors) = []; % delete indices 
keV_detectors(141:end) = []; % remaining: energey values 1:140 (working fine)


% detector perkin elmer, delete values belonging to non integer energies
det_per_el = det_per_el0;
det_per_el(ind_keV_detectors) = []; % delete non integer indices
det_per_el(141:end) = [];


% detector medipix, delete values belonging to non integer energies
det_medipix = det_medipix0;
det_medipix(ind_keV_detectors) = []; 
det_medipix(141:end) = [];


% detector GM-ideas, delete values belonging to non integer energies
det_gm_ideas = det_gm_ideas0;
det_gm_ideas(ind_keV_detectors) = []; 
det_gm_ideas(141:end) = [];


%% write to file, just integer energy values
% attenuation data of aluminum
fileNamAttAl = 'attenuation_Al.dat';
fileIDAttAl = fopen(fileNamAttAl,'w');
fprintf(fileIDAttAl,'%d %f\r\n',[keV mu_Al_mass]');
fclose(fileIDAttAl);


% detector data 
fileNamDetectors = 'detector_response.dat';
fileIDDetectors = fopen(fileNamDetectors,'w');
fprintf(fileIDDetectors,'%d %f %f %f\r\n',[keV det_per_el det_medipix det_gm_ideas]');
fclose(fileIDDetectors);



%% I0 data at detector Perkin Elmer - without transmitting material
I0_mult_per_el = spectrum .*  det_per_el; % integrand without attenuation
I0_per_el = sum(I0_mult_per_el); % summation = integration

I0_mult_medipix = spectrum .*  det_medipix; % integrand without attenuation
I0_medipix = sum(I0_mult_medipix); % summation = integration

I0_mult_gm_ideas = spectrum .*  det_gm_ideas; % integrand without attenuation
I0_gm_ideas = sum(I0_mult_gm_ideas); % summation = integration


%% I data for the 3 detectors (Perkin Elmer, Medipix, GM-ideas)
x = 0.0 : 0.04 : 4.0; % thickness of material in (cm)
x = x';
I_PerEl = zeros (length(x),1);
I_Med = zeros (length(x),1);
I_GM = zeros (length(x),1);


for j = 1:length(x)
    % integrand with attentuation term 
    I_mult_PerEl = spectrum .* exp(-mu_Al * x(j)) .* det_per_el;
    I_mult_Med = spectrum .* exp(-mu_Al * x(j)) .* det_medipix;
    I_mult_GM = spectrum .* exp(-mu_Al * x(j)) .* det_gm_ideas;
    
    I_PerEl(j) = sum(I_mult_PerEl);
    I_Med(j) = sum(I_mult_Med);
    I_GM(j) = sum(I_mult_GM);
end

% attenuation 
mu_eff_PerEl = -1./x .* log(I_PerEl/I0_per_el); % perkin elmer
mu_eff_Med = -1./x .* log(I_Med/I0_medipix); % medipix
mu_eff_GM = -1./x .* log(I_GM/I0_gm_ideas); % Gm-ideas

% write numerical mu_eff values to file
fileNam_muEff = 'Numerical_muEff_3detectors_corrected.dat';
fileID_muEff = fopen(fileNam_muEff,'w');
fprintf(fileID_muEff,'%f %f %f %f\r\n',[x mu_eff_PerEl mu_eff_Med mu_eff_GM]');
fclose(fileID_muEff);













