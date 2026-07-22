% This function runs curvefitting algorithm on CAT models
function [estModelparams, timespan] = CATFitting(time, value, opts)
% Declare Parameters
Kn = 12;             % Initial Guess for Kn
K0 = 1.25;             % Initial Guess for K0
K1 = 3.75;             % Initial Guess for K1
K2 = 2.5;             % Initial Guess for K2
Kd = 1.5;             % Initial Guess for Kd

% preprocess the raw CAT data
tf = time(end);
raw_time = 0:1/3:tf;
if length(raw_time) > length(time)
    missing_entries = length(raw_time) - length(time);
    cat_fill_zero = zeros(missing_entries, 1);
    value_filled = [cat_fill_zero; value];
end
timespan = transpose(0:0.01:tf);
value_interp = interp1(raw_time, value_filled, timespan, 'linear', 'extrap');

% curvefitting
modelParams_iniguess = [Kn K0 K1 K2 Kd];
lb = [0 0 0 0 0];
up = [inf inf inf inf inf];

estModelparams = lsqcurvefit(@modelCATFit, modelParams_iniguess, timespan, value_interp, lb, up, opts);

end