% This is the function that needs to be solved

% n :: number of iteration
% a,b,alpha :: fitparameters
% I,I0 :: intensities from radiogram
% xn :: position at nth iteration


function [f,df] = func_dfunc(xn,a,b,alpha,I,I_0)
    
    % function - follows from lambert-beer and our fit function
    f = xn*a + b*xn^(1-alpha) + log(I/I_0);

    % derivative of function
    df = a + b*(1-alpha)*xn^(-alpha);

end



