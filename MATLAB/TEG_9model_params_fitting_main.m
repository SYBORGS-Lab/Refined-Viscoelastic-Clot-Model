% This script is TEG transfer function parameter identification with
% time-varying parameters.

clear
close all
clc

% =============== Modify The Following If Necessary =================

% Load Raw Data Path
dir_path = '../Data/Raw/TEG/CAT-TEG/';

% Save Fitting Plots
save_fig = 0;
plot_path = "./Fig/TPATXA/ACIT/";

% Save TEG Info Spreadsheet
save_table = 0;
table_name = "TEG_Info_ACIT.xlsx";

% =============== Don't Touch =================
% Add dependencies
addpath('utils/')
addpath(dir_path)

%% Parse Raw Data Files
% Check if raw data folder is empty
Path_all = dir(dir_path + "*.*");
if isempty(Path_all)
    error('Invalid Path Name.')
end

% Parse all raw data files and Convert to string array and delete the 
% first two entries
files = string({Path_all.name});
files(1:2) = [];

% Get all files with '.CRD' as the extension 
crd_files = [];
for i = 1:length(files)
    exp_crd = '\S*.CRD';
    matched_files = regexp(files(i),exp_crd,'match');
    if ~isempty(matched_files)
        crd_files = [crd_files; matched_files];
    end
end

% Get all txt files
txt_files = [];
for i = 1:length(files)
    exp_txt = '\S*.txt';
    matched_files = regexpi(files(i),exp_txt,'match');
    if ~isempty(matched_files)
        txt_files = [txt_files; matched_files];
    end
end

% The number of txt files should match the number of the crd files
if length(txt_files) ~= length(crd_files)
    warning("Missing TXT or CRD files! Please double check you have all files in this folder!")
end 

%% Parse crd and txt files simultaneously
for ii = 1:length(crd_files)
    % Get TEG info for this crd files
    txt_file_name = dir_path + txt_files(ii);
    TEG_info_initial = TEGtxt2xlsx(txt_file_name);
    TEG_info_extend_temp = strings(size(TEG_info_initial, 1),12);       % Use this in the parfor loop
    TEG_info_extend = strings(size(TEG_info_initial, 1),11);

    % Get exp data from crd file
    crd_file_name = dir_path + crd_files(ii);
    Exp_WBTEG = parse_crd(crd_file_name);
    sample_num = length(fieldnames(Exp_WBTEG));
    sample_structs = [];
    for samples = 1:sample_num
        sample_name = 'Sample' + string(samples);
        sample_structs = [sample_structs; Exp_WBTEG.(sample_name)];
    end

    % Run lsqcurvefit options
    opts = optimoptions('lsqcurvefit','OptimalityTolerance', 1e-9, ...
        'MaxFunctionEvaluations', 1e6, 'FunctionTolerance', 1e-9, ...
        'MaxIterations', 3000, 'StepTolerance', 1e-9, ...
        'PlotFcn', 'optimplotx', 'Display', 'iter-detailed');
    % opts = optimoptions('lsqcurvefit','OptimalityTolerance', 1e-9, ...
    %     'MaxFunctionEvaluations', 1e6, 'FunctionTolerance', 1e-9, ...
    %     'MaxIterations', 5000, 'StepTolerance', 1e-9);


    for i = 1:sample_num
        error_flag = 0;
        sample = sample_structs(i);
        sample_name = 'Sample' + string(i);
        time_min = sample.Time_min;
        value = sample.value;

        % Find the row number in TEG Info table corresponding to the
        % current sample
        for jj = 1:size(TEG_info_initial, 1)
            if sample.SAMPLEDESCRIPTION == TEG_info_initial.SAMPLEDESCRIPTION(jj) ...
                && sample.CHANNEL == TEG_info_initial.CHANNEL(jj) ...
                && sample.ONTIME == TEG_info_initial.ONTIME(jj)
                
                % TEG_info_extend(jj,:) = [sample.fitted_TF_params, Rsq, sample_name];
                TEG_info_idx = jj;
                break
            end
        end
        
        if ~contains(table2array(TEG_info_initial(TEG_info_idx, ["R(min)", "K(min)", "MA(mm)", "Angle(deg)",  "TMA(min)", "LY30(%)"])), "NA")
            Ly30 = double(TEG_info_initial(TEG_info_idx, "LY30(%)").Variables);
            Ly60 = double(TEG_info_initial(TEG_info_idx, "LY60(%)").Variables);
            TMA = double(TEG_info_initial(TEG_info_idx, "TMA(min)").Variables);
            estimated_tf_coeff = TEGFitting(time_min, value, Ly30, Ly60, TMA, opts);
        else
            error_flag = 1;
            estimated_tf_coeff = -1*ones(9,1);
        end

        sample.fitted_TF_params = estimated_tf_coeff';
        % Calculate the R-squared value
        
        if error_flag == 0
            simTF = TEGModelTimeVaryingODEFitting(estimated_tf_coeff, time_min);
            Rsq = Rsquared(value, simTF);

            % Plot experimental data vs simulated results with R squared value and parameter values
            figure(Visible="on")
            plot(time_min, value, 'DisplayName', 'Exp Data', 'LineWidth', 2)
            grid on
            hold on
            plot(time_min, simTF, 'DisplayName', 'Fitted Curve', 'LineWidth', 2)
            xlabel('Time [min]')
            ylabel('TEG [mm]')

            % Create legend string with R^2 and parameter values
            legendStr = sprintf('Fitted Curve (R^2 = %.3f)\nKn1 = %.2e\nKp1 = %.2e\nKd1 = %.2e\nKnc = %.2f\nKpc = %.2f\nKdc = %.2f\nKn2 = %.2e\nKp2 = %.2e\nKd2 = %.2e', ...
                Rsq, estimated_tf_coeff(1), estimated_tf_coeff(2), estimated_tf_coeff(3), ...
                estimated_tf_coeff(4), estimated_tf_coeff(5), estimated_tf_coeff(6), estimated_tf_coeff(7), estimated_tf_coeff(8), estimated_tf_coeff(9));

            title(sample.SAMPLEDESCRIPTION, 'Interpreter', 'none')
            legend('Exp Data', legendStr, 'Location','best')
            hold off

            if save_fig == 1
                png_path = plot_path + string(crd_files(ii)) + "/png/";
                fig_path = plot_path + string(crd_files(ii)) + "/fig/";
                if ~isfolder(png_path)
                    mkdir(png_path)
                end
                if ~isfolder(fig_path)
                    mkdir(fig_path)
                end
                saveas(gcf, png_path + string(sample_name), 'png')
                savefig(fig_path+string(sample_name)+'.fig')
            end
        else
            Rsq = -1;
        end

        % Extend TEG info temp with the fitted parameters and R-squared value
        TEG_info_extend_temp(i,:) = [TEG_info_idx, sample.fitted_TF_params, Rsq, sample_name];
    end

    for i = 1:sample_num
        idx = double(TEG_info_extend_temp(i,1));
        TEG_info_extend(idx,:) = TEG_info_extend_temp(i,2:end);
    end

    % Convert extended TEG info to table including R^2
    TEG_info_extend_tab = array2table(TEG_info_extend, ...
        'VariableNames', ["Kn1", "Kp1", "Kd1", "Knc", "Kpc", "Kdc", "Kn2", "Kp2", "Kd2", "Rsq", "Fig Name"]);
    TEG_info = [TEG_info_initial TEG_info_extend_tab];
    
    if save_table == 1
        table_path = "../Data/Processed/TEG_Info/";
        if ~isfolder(table_path)
            mkdir(table_path)
        end
        writetable(TEG_info, table_path+table_name, 'Sheet', txt_files(ii));
    end

    close all
end

