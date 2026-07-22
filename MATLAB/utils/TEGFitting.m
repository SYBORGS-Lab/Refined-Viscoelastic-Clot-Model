function estModelParams = TEGFitting(time_min, value, Ly30, Ly60, TMA, opts)
% Initial guesses for parameters
baseline_value = value(1); % Assuming the first value is the baseline
threshold_value = 10 * baseline_value; % 250% of the baseline value

% Find the first index where value changes by at least 250%
change_index = find(value > threshold_value, 1);

if isempty(change_index)
    change_index = 1; % If no change is detected, use the first point
end

kd1_guess = time_min(change_index); % Set kd1 initial guess to the corresponding time
kp1_guess = 0.5;
kn1_guess = 15;
Knc_guess = 2;
Kpc_guess = 1;
Kdc_guess = 15;
% kp1_guess = 0.5;
% kn1_guess = 50;
% Knc_guess = 2;
% Kpc_guess = 1;
% Kdc_guess = 15;

kn2_lower_bound = 0;
kp2_lower_bound = 0;
kd2_guess = TMA + 5;

if TMA < 0
    TMA = -TMA;
end
kn2_upper_bound = inf;
kp2_upper_bound = inf;
kd2_upper_bound = 300;
kd2_lower_bound = TMA;

if Ly60 == 0 || isnan(Ly60)
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
    kd2_guess = TMA + 10;
end

mapping_params = [kn1_guess; kp1_guess; kd1_guess; Knc_guess; Kpc_guess; Kdc_guess; kn2_guess; kp2_guess; kd2_guess]; % Making kn2 be 0 for now so that the second half of the model is irrelevant

% curve fitting bounds
lb = [0, 0.1, 0, 0, 0, 0, kn2_lower_bound, kp2_lower_bound, kd2_lower_bound];             % Forcing kd2 to be greater than TMA.
ub = [inf, inf, inf, inf, inf, inf, kn2_upper_bound, kp2_upper_bound, kd2_upper_bound]; 
if ~isnan(Ly30)
    [estimated_tf_coeff_final, ~] = lsqcurvefit(@TEGModelTimeVaryingODEFitting, mapping_params, ...
        time_min, value, lb, ub, opts);
else
    estimated_tf_coeff_final = mapping_params;
end

estModelParams = estimated_tf_coeff_final;
end