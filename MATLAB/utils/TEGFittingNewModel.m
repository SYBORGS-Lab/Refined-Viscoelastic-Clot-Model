function estModelParams = TEGFittingNewModel(time_min, value, Ly60, TMA, opts)
% Initial guesses for parameters
baseline_value = value(1); % Assuming the first value is the baseline
threshold_value = 10 * baseline_value; % 250% of the baseline value

% Find the first index where value changes by at least 250%
change_index = find(value > threshold_value, 1);

if isempty(change_index)
    change_index = 1; % If no change is detected, use the first point
end

kd_guess = time_min(change_index); % Set kd1 initial guess to the corresponding time
kn_guess = 12;             % Initial Guess for Kn
k0_guess = 2;             % Initial Guess for K0
k1_guess = 0.1;             % Initial Guess for K1
k2_guess = 4;             % Initial Guess for K2
knc_guess = 2;
kpc_guess = 1;
kdc_guess = 15;

kn2_lower_bound = 0;
kp2_lower_bound = 0;

kn2_upper_bound = 1;
kp2_upper_bound = inf;
kd2_upper_bound = 300;
kd2_lower_bound = TMA;

if Ly60 == 0
%     kn2_upper_bound = 0;
%     kp2_upper_bound = 0;
%     kd2_lower_bound = 200;
%     kd2_upper_bound = 200;
    kn2_guess = 0;
    kp2_guess = 0;
    kd2_guess = 200;
else
    kn2_guess = 0.5;
    kp2_guess = 5;
    kd2_guess = TMA+10;
end

mapping_params = [kn_guess; k0_guess; k1_guess; k2_guess; kd_guess; knc_guess; kpc_guess; kdc_guess; kn2_guess; kp2_guess; kd2_guess];

% curve fitting bounds
lb = [0, 0, 0, 0, 0, 0, 0, 0, kn2_lower_bound, kp2_lower_bound, kd2_lower_bound];             % Forcing kd2 to be greater than TMA.
ub = [inf, inf, inf, inf, inf, inf, inf, inf, kn2_upper_bound, kp2_upper_bound, kd2_upper_bound]; 

if ~isnan(Ly60)
[estimated_tf_coeff_final, ~] = lsqcurvefit(@TEGModelTimeVaryingCATFitting, mapping_params, ...
    time_min, value, lb, ub, opts);
else
    estimated_tf_coeff_final = mapping_params;
end

estModelParams = estimated_tf_coeff_final;
end