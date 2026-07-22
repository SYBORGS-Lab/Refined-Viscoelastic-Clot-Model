% Monte Carlo Simulation (±10% Variation on All Parameters Simultaneously)
clear; close all; clc;
% Add dependencies
addpath('utils/')

% Percentage change of model parameters
delta = 0.1;    % Meaning +- 10%
trials = 10;

% Original parameters using Sample Set F: Sample 15
Kn1 = 0.0030081281;
Kp1 = 0.81172462;
Kd1 = 8.0833333;
Knc = 1576.832;
Kpc = 0.19365811;
Kdc = 2.2756544;
Kn2 = 0.49824412;
Kp2 = 0.137205;
Kd2 = 30.771497;
TEG_model_params = [Kn1 Kp1 Kd1 Knc Kpc Kdc Kn2 Kp2 Kd2];
TEG_model_params_name = ["Kn1" "Kp1" "Kd1" "Knc" "Kpc" "Kdc" "Kn2" "Kp2" "Kd2"];
num_params = numel(TEG_model_params_name);

% Time span
t = transpose(0:5/60:90);

% Baseline simulation
simBL = TEGModelTimeVaryingODEFitting(TEG_model_params, t);
featureBL = TEG_feature_prediction(t, simBL, TEG_model_params);

% TEG profiles
for i = 1:length(TEG_model_params)
    varied_params = TEG_model_params;
    current_param = TEG_model_params(i);
    for j = 0:trials-1
        new_params = (1-delta)*current_param + ( (1+delta)-(1-delta) )/trials*j*current_param;
        varied_params(i) = new_params;
        simTemp = TEGModelTimeVaryingODEFitting(varied_params, t);
        if min(simTemp) < 0
            continue
        end
        
        % plot effects of parameter variations on TEG profiles
        figure(1)
        subplot(3,3,i)
        hold on;
        grid on;
        plot(t, simTemp, 'Color', [0.6 0.6 1 0.5])

    end
    plot(t, simBL, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1)
    xlabel("Time (min)")
    ylabel("TEG (mm)")
    title(TEG_model_params_name(i))
end

% TEG parameters
feature_names = ["R" "K" "MA" "TMA" "Angle" "Ly30" "Ly60"];
num_features = numel(feature_names);
feature_sens = zeros(num_features, num_params);
for i = 1:length(TEG_model_params)
    varied_params_ub = TEG_model_params;
    varied_params_lb = TEG_model_params;
    current_param = TEG_model_params(i);
    current_param_ub = (1+delta)*current_param;
    current_param_lb = (1-delta)*current_param;
    
    varied_params_ub(i) = current_param_ub;
    varied_params_lb(i) = current_param_lb;

    simTemp_ub = TEGModelTimeVaryingODEFitting(varied_params_ub, t);
    simTemp_lb = TEGModelTimeVaryingODEFitting(varied_params_lb, t);

    feature_ub = TEG_feature_prediction(t, simTemp_ub, varied_params_ub);
    feature_lb = TEG_feature_prediction(t, simTemp_lb, varied_params_lb);

    % Normalized sensitivity
    feature_sens(:, i) = ( (feature_ub-feature_lb) ./(2*delta*featureBL) )';

end
figure(2)
h = heatmap(TEG_model_params_name, feature_names, feature_sens);
h.Colormap = parula;
h.ColorLimits = [-4.7993 4.7993];
h.CellLabelFormat = '%.2f';
% title('Feature Sensitivity Heatmap');
xlabel('TEG Model Parameters');
ylabel('TEG Parameters');

%% Heatmap for all tPATXA samples
addpath("../Data/Processed/TEG_Info/")
S1C_TEGinfo = readtable("TEG_Info_Sample_Set_C_9params.xlsx", 'VariableNamingRule','preserve');
S2C_TEGinfo = readtable("TEG_Info_Sample_Set_C_9params.xlsx", 'VariableNamingRule','preserve', 'Sheet', 'S2C_tPA.TXT');
S3C_TEGinfo = readtable("TEG_Info_Sample_Set_C_9params.xlsx", 'VariableNamingRule','preserve', 'Sheet', 'S3C_tP.TXT');
S4C_TEGinfo = readtable("TEG_Info_Sample_Set_C_9params.xlsx", 'VariableNamingRule','preserve', 'Sheet', 'S4C_tP.TXT');
S5C_TEGinfo = readtable("TEG_Info_Sample_Set_C_9params.xlsx", 'VariableNamingRule','preserve', 'Sheet', 'S5C_tPA.TXT');
S6C_TEGinfo = readtable("TEG_Info_Sample_Set_C_9params.xlsx", 'VariableNamingRule','preserve', 'Sheet', 'S6C_tP.TXT');

% Sample Set C
S1C_TEG_model_params = double(string(S1C_TEGinfo(:,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables));
S2C_TEG_model_params = double(string(S2C_TEGinfo(:,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables));
S3C_TEG_model_params = double(string(S3C_TEGinfo(:,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables));
S4C_TEG_model_params = double(string(S4C_TEGinfo(:,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables));
S5C_TEG_model_params = double(string(S5C_TEGinfo(:,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables));
S6C_TEG_model_params = double(string(S6C_TEGinfo(:,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables));

% S1C
row_condition_no_lysis = S1C_TEG_model_params(:,9) > 128 | S1C_TEG_model_params(:,7) <= 1e-2;
row_condition_with_lysis = S1C_TEG_model_params(:,9) < 128 & S1C_TEG_model_params(:,7) > 1e-2;
S1C_TEG_params_no_lysis = S1C_TEG_model_params(row_condition_no_lysis, :);
S1C_TEG_params_with_lysis = S1C_TEG_model_params(row_condition_with_lysis, :);

% S2C
row_condition_no_lysis = S2C_TEG_model_params(:,9) > 128 | S2C_TEG_model_params(:,7) <= 1e-2;
row_condition_with_lysis = S2C_TEG_model_params(:,9) < 128 & S2C_TEG_model_params(:,7) > 1e-2;
S2C_TEG_params_no_lysis = S2C_TEG_model_params(row_condition_no_lysis, :);
S2C_TEG_params_with_lysis = S2C_TEG_model_params(row_condition_with_lysis, :);

% S3C
row_condition_no_lysis = S3C_TEG_model_params(:,9) > 128 | S3C_TEG_model_params(:,7) <= 1e-2;
row_condition_with_lysis = S3C_TEG_model_params(:,9) < 128 & S3C_TEG_model_params(:,7) > 1e-2;
S3C_TEG_params_no_lysis = S3C_TEG_model_params(row_condition_no_lysis, :);
S3C_TEG_params_with_lysis = S3C_TEG_model_params(row_condition_with_lysis, :);

% S4C
row_condition_no_lysis = S4C_TEG_model_params(:,9) > 128 | S4C_TEG_model_params(:,7) <= 1e-2;
row_condition_with_lysis = S4C_TEG_model_params(:,9) < 128 & S4C_TEG_model_params(:,7) > 1e-2;
S4C_TEG_params_no_lysis = S4C_TEG_model_params(row_condition_no_lysis, :);
S4C_TEG_params_with_lysis = S4C_TEG_model_params(row_condition_with_lysis, :);

% S5C
row_condition_no_lysis = S5C_TEG_model_params(:,9) > 128 | S5C_TEG_model_params(:,7) <= 1e-2;
row_condition_with_lysis = S5C_TEG_model_params(:,9) < 128 & S5C_TEG_model_params(:,7) > 1e-2;
S5C_TEG_params_no_lysis = S5C_TEG_model_params(row_condition_no_lysis, :);
S5C_TEG_params_with_lysis = S5C_TEG_model_params(row_condition_with_lysis, :);

% S6C
row_condition_no_lysis = S6C_TEG_model_params(:,9) > 128 | S6C_TEG_model_params(:,7) <= 1e-2;
row_condition_with_lysis = S6C_TEG_model_params(:,9) < 128 & S6C_TEG_model_params(:,7) > 1e-2;
S6C_TEG_params_no_lysis = S6C_TEG_model_params(row_condition_no_lysis, :);
S6C_TEG_params_with_lysis = S6C_TEG_model_params(row_condition_with_lysis, :);

% Sample Set C 
SC_model_params_no_lysis = [S1C_TEG_params_no_lysis; S2C_TEG_params_no_lysis; S3C_TEG_params_no_lysis;...
    S4C_TEG_params_no_lysis; S5C_TEG_params_no_lysis; S6C_TEG_params_no_lysis];
SC_model_params_with_lysis = [S1C_TEG_params_with_lysis; S2C_TEG_params_with_lysis; S3C_TEG_params_with_lysis; ...
    S4C_TEG_params_with_lysis; S5C_TEG_params_with_lysis; S6C_TEG_params_with_lysis];
SC_model_params_no_lysis( SC_model_params_no_lysis(:,1) == -1, : ) = [];
SC_model_params_with_lysis( SC_model_params_with_lysis(:,1) == -1, : ) = [];

% Sample Set E
SE_Ca_TEGinfo = readtable("TEG_Info_Sample_Set_E_9params.xlsx", 'VariableNamingRule','preserve');
SE_E_TEGinfo = readtable("TEG_Info_Sample_Set_E_9params.xlsx", 'VariableNamingRule','preserve', 'Sheet', 'SampleE_tPA.TXT');
SE_TEGinfo = [SE_Ca_TEGinfo; SE_E_TEGinfo];
SE_TEG_model_params = double(string( SE_TEGinfo(:,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables) );
row_condition_no_lysis = SE_TEG_model_params(:,9) > 128 | SE_TEG_model_params(:,7) <= 1e-2;
row_condition_with_lysis = SE_TEG_model_params(:,9) < 128 & SE_TEG_model_params(:,7) > 1e-2;
SE_TEG_params_no_lysis = SE_TEG_model_params(row_condition_no_lysis, :);
SE_TEG_params_with_lysis = SE_TEG_model_params(row_condition_with_lysis, :);
SE_TEG_params_no_lysis( SE_TEG_params_no_lysis(:,1) == -1, : ) = [];
SE_TEG_params_with_lysis( SE_TEG_params_with_lysis(:,1) == -1, : ) = [];

% Sample Set F
SF_TEGinfo = readtable("TEG_Info_Sample_Set_F_9params.xlsx", 'VariableNamingRule','preserve');
SF_TEG_model_params = double(string( SF_TEGinfo(:,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables) );
SF_TEG_model_params( SF_TEG_model_params(:,1) == -1, :  ) = [];
row_condition_no_lysis = SF_TEG_model_params(:,9) > 128 | SF_TEG_model_params(:,7) <= 1e-2;
row_condition_with_lysis = SF_TEG_model_params(:,9) < 128 & SF_TEG_model_params(:,7) > 1e-2;
SF_TEG_params_no_lysis = SF_TEG_model_params(row_condition_no_lysis, :);
SF_TEG_params_with_lysis = SF_TEG_model_params(row_condition_with_lysis, :);

% Classify model parameters into two group of all tPATXA dataset
model_params_no_lysis = [SC_model_params_no_lysis; SE_TEG_params_no_lysis; SF_TEG_params_no_lysis];
model_params_with_lysis = [SC_model_params_with_lysis; SE_TEG_params_with_lysis; SF_TEG_params_with_lysis];

% Mean profile simulation - No lysis
% TEG profiles no parameter perturbation
figure(3)
hold on;
grid on;
TEG_profiles_no_lysis = zeros(length(t), size(model_params_no_lysis, 1));
for i = 1:length(model_params_no_lysis)
    current_param = model_params_no_lysis(i,:);
    simTemp = TEGModelTimeVaryingODEFitting(current_param, t);
    TEG_profiles_no_lysis(:,i) = simTemp;
    plot(t, simTemp, 'Color', [0.6 0.6 1 0.5])
end
TEG_profiles_no_lysis_median = median(TEG_profiles_no_lysis, 2);
TEG_profiles_no_lysis_q1 = prctile(TEG_profiles_no_lysis, 25, 2);
TEG_profiles_no_lysis_q3 = prctile(TEG_profiles_no_lysis, 75, 2);
plot(t, TEG_profiles_no_lysis_median, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1)
plot(t, TEG_profiles_no_lysis_q1, 'Color', 'black', 'LineStyle', ':', 'LineWidth', 1)
plot(t, TEG_profiles_no_lysis_q3, 'Color', 'black', 'LineStyle', ':', 'LineWidth', 1)
xlabel("Time (min)")
ylabel("TEG (mm)")
title("tPATXA Samples No Lysis")

% Mean profile simulation - With lysis
% TEG profiles no parameter perturbation
figure(4)
hold on;
% grid on;
TEG_profiles_with_lysis = zeros(length(t), size(model_params_with_lysis, 1));
for i = 1:length(model_params_with_lysis)
    current_param = model_params_with_lysis(i,:);
    simTemp = TEGModelTimeVaryingODEFitting(current_param, t);
    TEG_profiles_with_lysis(:,i) = simTemp;
    plot(t, simTemp, 'Color', [0.6 0.6 1 0.5])
end
TEG_profiles_with_lysis_median = median(TEG_profiles_with_lysis, 2);
TEG_profiles_with_lysis_q1 = prctile(TEG_profiles_with_lysis, 25, 2);
TEG_profiles_with_lysis_q3 = prctile(TEG_profiles_with_lysis, 75, 2);
plot(t, TEG_profiles_with_lysis_median, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1)
plot(t, TEG_profiles_with_lysis_q1, 'Color', 'black', 'LineStyle', ':', 'LineWidth', 1)
plot(t, TEG_profiles_with_lysis_q3, 'Color', 'black', 'LineStyle', ':', 'LineWidth', 1)

xlabel("Time (min)")
ylabel("TEG (mm)")
title("tPATXA Samples No Lysis")

% Heatmap analysis for the whole dataset - No lysis
num_sample_no_lysis = length(model_params_no_lysis);
feature_sens_no_lysis = zeros(num_features, num_params, num_sample_no_lysis);
for i = 1:num_sample_no_lysis
    current_model_params = model_params_no_lysis(i,:);
    for j = 1:num_params
        varied_params_ub = current_model_params;
        varied_params_lb = current_model_params;
        current_param = current_model_params(j);
        current_param_ub = (1+delta)*current_param;
        current_param_lb = (1-delta)*current_param;
        
        varied_params_ub(j) = current_param_ub;
        varied_params_lb(j) = current_param_lb;

        simTemp_ub = TEGModelTimeVaryingODEFitting(varied_params_ub, t);
        simTemp_lb = TEGModelTimeVaryingODEFitting(varied_params_lb, t);

        if max(simTemp_lb) < 30 || max(simTemp_ub) < 30
            feature_sens_no_lysis(:, j, i) = nan*ones(num_features, 1);
        else
            feature_ub = TEG_feature_prediction(t, simTemp_ub, varied_params_ub);
            feature_lb = TEG_feature_prediction(t, simTemp_lb, varied_params_lb);
    
            % Normalized sensitivity
            feature_sens_no_lysis(:, j, i) = ( (feature_ub-feature_lb) ./(2*delta*featureBL) )';
        end
    end
end

% Heatmap analysis for the whole dataset - With lysis
num_sample_with_lysis = length(model_params_with_lysis);
feature_sens_with_lysis = zeros(num_features, num_params, num_sample_with_lysis);
for i = 1:num_sample_with_lysis
    current_model_params = model_params_with_lysis(i,:);
    for j = 1:num_params
        varied_params_ub = current_model_params;
        varied_params_lb = current_model_params;
        current_param = current_model_params(j);
        current_param_ub = (1+delta)*current_param;
        current_param_lb = (1-delta)*current_param;
        
        varied_params_ub(j) = current_param_ub;
        varied_params_lb(j) = current_param_lb;

        simTemp_ub = TEGModelTimeVaryingODEFitting(varied_params_ub, t);
        simTemp_lb = TEGModelTimeVaryingODEFitting(varied_params_lb, t);

        if max(simTemp_lb) < 30 || max(simTemp_ub) < 30
            feature_sens_with_lysis(:, j, i) = nan*ones(num_features, 1);
        else
            feature_ub = TEG_feature_prediction(t, simTemp_ub, varied_params_ub);
            feature_lb = TEG_feature_prediction(t, simTemp_lb, varied_params_lb);
    
            % Normalized sensitivity
            feature_sens_with_lysis(:, j, i) = ( (feature_ub-feature_lb) ./(2*delta*featureBL) )';
        end
    end
end

% Delete samples in feature_sens when NaN is appeared
badsamples_no_lysis = squeeze( any(any(isnan(feature_sens_no_lysis), 1), 2) );
feature_sens_no_lysis(:,:,badsamples_no_lysis) = [];
badsamples_with_lysis = squeeze( any(any(isnan(feature_sens_with_lysis), 1), 2) );
feature_sens_with_lysis(:,:,badsamples_with_lysis) = [];

% Plot heatmap using signed median
feature_sens_no_lysis_median = median(feature_sens_no_lysis, 3);
feature_sens_with_lysis_median = median(feature_sens_with_lysis, 3);

signed_iqr_no_lysis = iqr(feature_sens_no_lysis, 3);
signed_iqr_with_lysis = iqr(feature_sens_with_lysis, 3);

figure
% No lysis signed median heatmap
h_no_lysis = heatmap(TEG_model_params_name, feature_names, feature_sens_no_lysis_median);
h_no_lysis.Colormap = parula;
limit_max = max( [max(abs(feature_sens_no_lysis_median(:))) max(abs(feature_sens_with_lysis_median(:)))] );
h_no_lysis.ColorLimits = [-limit_max limit_max];
h_no_lysis.CellLabelFormat = '%.2f';
% title('TEG Parameters Sensitivity Heatmap - All tPATXA No Lysis');
xlabel('TEG Model Parameters');
ylabel('TEG Parameters');

figure
% No lysis signed median IQR heatmap
h_no_lysis = heatmap(TEG_model_params_name, feature_names, signed_iqr_no_lysis);
h_no_lysis.Colormap = parula;
iqr_limit_max = max( [max(abs(signed_iqr_no_lysis(:))) max(abs(signed_iqr_with_lysis(:)))] );
h_no_lysis.ColorLimits = [0 iqr_limit_max];
h_no_lysis.CellLabelFormat = '%.2f';
% title('TEG Parameters Sensitivity Heatmap - All tPATXA No Lysis');
xlabel('TEG Model Parameters');
ylabel('TEG Parameters');

figure
h_with_lysis = heatmap(TEG_model_params_name, feature_names, feature_sens_with_lysis_median);
h_with_lysis.Colormap = parula;
h_with_lysis.ColorLimits = [-limit_max limit_max];
h_with_lysis.CellLabelFormat = '%.2f';
% title('TEG Parameters Sensitivity Heatmap - All tPATXA With Lysis');
xlabel('TEG Model Parameters');
ylabel('TEG Parameters');

figure
% With lysis signed median IQR heatmap
h_with_lysis = heatmap(TEG_model_params_name, feature_names, signed_iqr_with_lysis);
h_with_lysis.Colormap = parula;
iqr_limit_max = max( [max(abs(signed_iqr_no_lysis(:))) max(abs(signed_iqr_with_lysis(:)))] );
h_with_lysis.ColorLimits = [0 iqr_limit_max];
h_with_lysis.CellLabelFormat = '%.2f';
% title('TEG Parameters Sensitivity Heatmap - All tPATXA No Lysis');
xlabel('TEG Model Parameters');
ylabel('TEG Parameters');
