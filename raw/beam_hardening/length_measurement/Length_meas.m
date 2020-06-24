%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program to determine length of transmitted object from fit parametes for
% µ_eff. First application on fit to 3 data points. Measure the thickness
% at all data points for a comparison to the real thickness.


% The function 'f' that is solved follows from our fit-function (1) and
% beer-lambert for energy averaged attenuation (2)
%   (1) µ_eff = a + b/x^alpha
%   (2) I = I0 exp(-µ_eff x)

clear
close all


%% allocate vectors for newton's method, set start values
nmax = 100;
tol = 1e-5; % tolerance, choose smaller than experimental error

f_iter = zeros(nmax,1); % values of f at position of xiter
df_iter = zeros(nmax,1); % derivative of f at position..
x_iter = zeros(nmax,1); % x-values for iteration steps
dx_iter = zeros(nmax,1); % difference in x in two consecutive iteration steps
x_iter(1) = 2; % start parameter, chose size within range of sample size (units in cm)

x_plates = [0.2:0.2:4]'; % length of plates in (cm)

% x_max and x_min give range of object to measure in (cm)
x_max = 4; % maximal value of x, >= total thickness of object
x_min = 0.05; % minimal value of x, , must be positive

x_pl_new = zeros(length(x_plates),1); % save final values from Newton
dx_plates = x_pl_new; % safe difference from real (exp) values
n_iter = x_pl_new; % save number of iterations until convergence



%% read fit parameters from file (output from gnuplot)
nmeas = 4; % number of measurements

% files and parameters with 20 data points
para60_20 = load ('fit_parameters_20_data_fit_60kV.dat'); % 60kV meas 
para140_20 = load ('fit_parameters_20_data_fit_140kV.dat'); % 140kV meas 

a60_20 = para60_20(1);
b60_20 = para60_20(2);
alpha60_20 = para60_20(3);

a140_20 = para140_20(1);
b140_20 = para140_20(2);
alpha140_20 = para140_20(3);


% files and parameters with 3 data points
para60_3 = load ('fit_parameters_3_data_fit_60kV.dat'); % 60kV meas fit para
para140_3 = load ('fit_parameters_3_data_fit_140kV.dat'); % 140kV meas fit para

a60_3 = para60_3(1);
b60_3 = para60_3(2);
alpha60_3 = para60_3(3);

a140_3 = para140_3(1);
b140_3 = para140_3(2);
alpha140_3 = para140_3(3);

%% I & I_0 values (from radiograms - here of boro. glass plates)

% 60 kV measurement
boro_meas_60 = load('mu_eff_60kV_500uA_120ms.dat');
boro_meas_140 = load('mu_eff_140kV_150uA_100ms.dat');

% intenisties for 60 kV measurement
I0_60 = boro_meas_60(:,4);
I_60 = boro_meas_60(:,6);


% intensities for 140 kV measurement
I0_140 = boro_meas_140(:,4);
I_140 = boro_meas_140(:,6);





%% calculate thickness for every #plates and every measurement
for nnmeas = 1:nmeas % measurements loop
    % set fit parameters and intensities 
    if nnmeas == 1
        str = '3datapoints_60kV'; % string for naming of file
        a = a60_3;
        b = b60_3;
        alpha = alpha60_3;
        I0 = I0_60;
        I = I_60;
    elseif nnmeas == 2
        str = '3datapoints_140kV';
        a = a140_3;
        b = b140_3;
        alpha = alpha140_3;
        I0 = I0_140;
        I = I_140;
    elseif nnmeas == 3
        str = '20datapoints_60kV';
        a = a60_20;
        b = b60_20;
        alpha = alpha60_20;
        I0 = I0_60;
        I = I_60;
    elseif nnmeas == 4
        str = '20datapoints_140kV';
        a = a140_20;
        b = b140_20;
        alpha = alpha140_20;
        I0 = I0_140;
        I = I_140;
    end

    for nnplate = 1:20 % plates loop
        %% Newton's method
        % calculate function and derivative (start values)
        [f_iter(1),df_iter(1)] = func_dfunc(x_iter(1),a,b,alpha,I(nnplate),I0(nnplate));

        for n=2:nmax

            % Iteration step 'n' in Newton's method
            x_iter(n) = x_iter(n-1) - f_iter(n-1) / df_iter(n-1);
            
            % x_iter > 0! positive length scale. otherwise complex results
            if x_iter(n) < 0.0
                x_iter(n) = x_min;
            end

            % calculate function and derivative (iteration steps)
            [f_iter(n),df_iter(n)] = func_dfunc(x_iter(n),a,b,alpha,I(nnplate),I0(nnplate));

            % difference between iteration steps
            dx_iter(n) = x_iter(n)-x_iter(n-1); % starts at n=2

            % stop
            if abs(dx_iter(n)) < tol
                
                % save final value from newton
                x_pl_new(nnplate) = x_iter(n);
                dx_plates(nnplate) = x_pl_new(nnplate) - x_plates(nnplate);
                n_iter(nnplate) = n;
                
                % end loop for this plate
                break
            end
        end
    end
    
    %% save values from this measurement to file
    fileNamThickness = ['Thickness_Newton_',str,'.dat'];
    fileID_Thickness = fopen(fileNamThickness,'w');
    
    fprintf(fileID_Thickness, '%f %f %f %d\r\n', [x_plates, x_pl_new, dx_plates,n_iter]');
    fclose(fileID_Thickness); 
    
end






