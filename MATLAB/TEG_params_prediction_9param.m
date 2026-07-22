% This scripts predict TEG parameters: R, K, MA, TMA, and Angle based on
% the TEG model paramters
clear
close all
clc

%% Load necessary files
addpath('./utils/')         % Load MATLAB Functions
addpath('../Data/Processed/TEG_Info/')

% IMPORTANT! DON'T FORGET TO CHANGE THIS FILE NAME IF DEALING WITH NEW DATASET
TEG_info_filename = "TEG_Info_Sample_Set_C_9params.xlsx";

%% Result Exporting Settings
save_result = 0;            % Change to 0 if wish not to save the prediction table
export_filename = "TEG_params_prediction_SampleSetC.xlsx";      % Must be a spreadsheet format
exp_path = "../Data/Processed/TEG_params_prediction_studies/";

%% DON'T TOUCH！
exp_spreadsheet = exp_path+export_filename;
addpath(exp_path)
% Load TEG info that contains TEG model parameters
sheetNames = sheetnames(TEG_info_filename);
t = (0:5/60:90)';     % Time vector, dt = 5/60 since the TEG sampling time is 5 sec.

for sheetNo = 1:length(sheetNames)
    TEG_info = readtable(TEG_info_filename, 'VariableNamingRule','preserve', 'Sheet', sheetNames(sheetNo));
    num_exp = height(TEG_info);
    exp_names = string(TEG_info.("Fig Name"));
    R_exp = zeros(num_exp, 1);
    K_exp = zeros(num_exp, 1);
    MA_exp = zeros(num_exp, 1);
    TMA_exp = zeros(num_exp, 1);
    Ang_exp = zeros(num_exp, 1);
    R_pred = zeros(num_exp, 1);
    K_pred = zeros(num_exp, 1);
    MA_pred = zeros(num_exp, 1);
    TMA_pred = zeros(num_exp, 1);
    Ang_pred = zeros(num_exp, 1);
    valid_exp = strings(num_exp, 1);
    LY30_exp = zeros(num_exp, 1);
    LY60_exp = zeros(num_exp, 1);
    LY30_pred = zeros(num_exp, 1);
    LY60_pred = zeros(num_exp, 1);

    for i = 1:num_exp
        Exp_TEG_info = TEG_info(i,:);
        if isinvalidTEG(Exp_TEG_info)
            valid_exp(i) = "Invalid";
            continue;
        end
        valid_exp(i,1) = exp_names(i);
        % if isnumeric(TEG_info(i,["Kn2", "Kp2", "Kd2"]).Variables)
        %     TEG_model_params_str = [string(TEG_info(i,["Kn1", "Kp1", "Kd1", "a1", "a2", "a3"]).Variables), "", "", ""];
        % else
        %     TEG_model_params_str = string(TEG_info(i,["Kn1", "Kp1", "Kd1", "a1", "a2", "a3", "Kn2", "Kp2", "Kd2"]).Variables);
        % end
        TEG_model_params_str = string(TEG_info(i,["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2"]).Variables);
        TEG_model_params_mat = zeros(9,1);
        for j = 1:length(TEG_model_params_mat)
            if TEG_model_params_str(j) == ""
                TEG_model_params_mat(j) = nan;
            else
                TEG_model_params_mat(j) = str2double(TEG_model_params_str(j));
            end
        end

        simTEG = TEGModelTimeVaryingODEFitting(TEG_model_params_mat, t);

        R_exp(i) = str2double(TEG_info(i, "R(min)").Variables);
        K_exp(i) = str2double(TEG_info(i, "K(min)").Variables);
        MA_exp(i) = str2double(TEG_info(i, "MA(mm)").Variables);
        TMA_exp(i) = str2double(TEG_info(i, "TMA(min)").Variables);
        Ang_exp(i) = str2double(TEG_info(i, "Angle(deg)").Variables);
        LY30_exp(i) = str2double(TEG_info(i, "LY30(%)").Variables);
        LY60_exp(i) = str2double(TEG_info(i, "LY60(%)").Variables);

        [R_pred(i), K_pred(i)] = TEG_RK_Prediction(t, simTEG, TEG_model_params_mat(3), TEG_model_params_mat(2));
        [MA_pred(i), TMA_pred(i)] = TEG_MA_Prediction(t, simTEG, R_pred(i), K_pred(i));
        Ang_pred(i) = TEG_Angle_Prediction(t, simTEG, 'Kn1', TEG_model_params_mat(1), 'Kp1', ...
            TEG_model_params_mat(2), 'Kd1', TEG_model_params_mat(3), 'a3', TEG_model_params_mat(6));
        % Ang_pred(i) = TEG_Angle_Prediction(t, simTEG, 'Kn1', -1, 'Kp1', -1, 'Kd1', -1, 'a3', -1);
        [LY30_pred(i), LY60_pred(i)] = TEG_LY_Prediction(t, simTEG, MA_pred(i), TMA_pred(i));
    end
    RK_exp = R_exp + K_exp;
    RK_pred = R_pred + K_pred;
    % Percentage error
    R_error = (R_pred - R_exp)./(R_exp)*100;
    K_error = (K_pred - K_exp)./(K_exp)*100;
    RK_error = (RK_pred - RK_exp)./(RK_exp)*100;
    MA_error = (MA_pred - MA_exp)./(MA_exp)*100;
    TMA_error = (TMA_pred - TMA_exp)./(TMA_exp)*100;
    Ang_error = (Ang_pred - Ang_exp)./(Ang_exp)*100;
    LY30_exp = fillmissing(LY30_exp, 'constant', 0);
    LY60_exp = fillmissing(LY60_exp, 'constant', 0);
    LY30_error = (LY30_pred - LY30_exp);
    LY60_error = (LY60_pred - LY60_exp);

    % Prediction
    result_mat = [R_exp, R_pred, R_error, K_exp, K_pred, K_error, RK_exp, RK_pred, RK_error, MA_exp, MA_pred, MA_error, TMA_exp, TMA_pred, TMA_error, Ang_exp, Ang_pred, Ang_error, LY30_exp, LY30_pred, LY30_error, LY60_exp, LY60_pred, LY60_error];
    invalid_idx = find(valid_exp == "Invalid");
    for k = length(invalid_idx):-1:1
        result_mat(invalid_idx(k),:) = [];
    end
    valid_exp = valid_exp(valid_exp ~= "Invalid");
    result = array2table(result_mat, 'VariableNames', ["Exp: R time (min)", "Prediction: R time (min)", "R Prediction Error (%)", ...
        "Exp: K time (min)", "Prediction: K time (min)", "K Prediction Error (%)", "Exp: R+K time (min)", "Prediction: R+K time (min)", ...
        "R+K Prediction Error (%)", "Exp: MA (mm)", "Prediction: MA (mm)", "MA Prediction Error (%)", ...
        "Exp: TMA (min)", "Prediction: TMA (min)", "TMA Prediction Error (%)", ...
        "Exp: Angle (deg)", "Prediction: Angle (deg)", "Angle Prediction Error (%)", ...
        "Exp: LY30 (%)", "Prediction: LY30 (%)", "LY30 Prediction Error (%)", ...
        "Exp: LY60 (%)", "Prediction: LY60 (%)", "LY60 Prediction Error (%)"], 'RowNames',valid_exp);
    fprintf("--------------Results----------------\n")
    fprintf("Mean Prediction Error of R Time is %.2f%%\n", mean(abs(result_mat(:,3))))
    fprintf("Std Prediction Error of R Time is %.2f%%\n", std(result_mat(:,3)))
    fprintf("Mean Prediction Error of K Time is %.2f%%\n", mean(abs(result_mat(:,6))))
    fprintf("Std Prediction Error of K Time is %.2f%%\n", std(result_mat(:,6)))
    fprintf("Mean Prediction Error of R+K Time is %.2f%%\n", mean(abs(result_mat(:,9))))
    fprintf("Std Prediction Error of R+K Time is %.2f%%\n", std(result_mat(:,9)))
    fprintf("Mean Prediction Error of MA is %.2f%%\n", mean(abs(result_mat(:,12))))
    fprintf("Std Prediction Error of MA is %.2f%%\n", std(result_mat(:,12)))
    fprintf("Mean Prediction Error of TMA is %.2f%%\n", mean(abs(result_mat(:,15))))
    fprintf("Std Prediction Error of TMA is %.2f%%\n", std(result_mat(:,15)))
    fprintf("Mean Prediction Error of Angle is %.2f%%\n", mean(abs(result_mat(:,18))))
    fprintf("Std Prediction Error of Angle is %.2f%%\n", std(result_mat(:,18)))
    fprintf("Mean Prediction Error of LY30 is %.2f%%\n", mean(abs(result_mat(:,21))))
    fprintf("Std Prediction Error of LY30 is %.2f%%\n", std(result_mat(:,21)))
    fprintf("Mean Prediction Error of LY60 is %.2f%%\n", mean(abs(result_mat(:,24))))
    fprintf("Std Prediction Error of LY60 is %.2f%%\n", std(result_mat(:,24)))

    if save_result == 1
        writetable(result, exp_spreadsheet, "WriteVariableNames",true, "WriteRowNames", true, 'Sheet', sheetNames(sheetNo))
    end
end

function flag = isinvalidTEG(Exp_TEG_info)
% Input: Exp_TEG_info -- This is not the entire TEG info table. It is only
%        for a specific experiment, i.e. a row in the TEG info table.
% Output: flag: if there is any abnormal value detect in the Exp_TEG_info,
%        return 1.

    flag = 0;
    if string(Exp_TEG_info(1, "SAMPLEDESCRIPTION").Variables) == "NA" || ...
                    str2double(Exp_TEG_info(1, "Rsq").Variables) <= 0.8 || ...
                    isnan(str2double(Exp_TEG_info(1, "R(min)").Variables)) || ...
                    isnan(str2double(Exp_TEG_info(1, "K(min)").Variables)) || ...
                    string(Exp_TEG_info(1, "R(min)").Variables) == "NA" || ...
                    string(Exp_TEG_info(1, "K(min)").Variables) == "NA"
        flag = 1;
    end

end
