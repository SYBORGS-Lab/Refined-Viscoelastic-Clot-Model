% This script identifies parameters for a given transfer function from 
% experimental data using lsqcurvefit, with two methods:
% Method 1: an approach that splits the time domain based on 95% of peak 
%           amplitude. This method tends to fix the inconsistent
%           interpretation issue of Kd2
% Method 2: Fitting all parameters simultaneously. This is the same method
%           used in "Quick model-based viscoelastic clot strength 
%           predictions from blood protein concentrations for cybermedical 
%           coagulation control."

clear
close all
clc

save_fig = 0;       % Change to 1 if saving each fitted figure is desired

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dir_path = '../Data/Raw/TEG/Sample Set C/';
addpath(dir_path)
addpath('./utils/')
Path_all = dir(dir_path + "*.*");
fitting_method = 1;
if isempty(Path_all)
    error('Invalid Path Name.')
end

% Convert to string array and delete the first two entries
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
    TEG_info_extend_temp = strings(size(TEG_info_initial, 1),9);       % Use this in the parfor loop
    TEG_info_extend = strings(size(TEG_info_initial, 1),8);

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
        'MaxIterations', 1000, 'StepTolerance', 1e-9, ...
        'PlotFcn', 'optimplotx', 'Display', 'iter-detailed');
    for i = 1:sample_num
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

        if fitting_method == 1
        
            % Initial guesses for parameters
            baseline_value = value(1); % Assuming the first value is the baseline
            threshold_value = 10 * baseline_value; % 250% of the baseline value
            
            % Find the first index where value changes by at least 250%
            change_index = find(value > threshold_value, 1);
            
            if isempty(change_index)
                change_index = 1; % If no change is detected, use the first point
            end
            
            kd1_guess = time_min(change_index); % Set kd1 initial guess to the corresponding time
    
        
            % kd1_guess = DetermineDelayTherapy(time_min,value);
            % if kd1_guess < 0
            %     warning('Calculated Delay is negative, setting Delay to 0.');
            %     kd1_guess = 2.5;
            % end
    
            kp1_guess = 5;
            kn1_guess = 2.5e10;
            kn2_guess = 2.5e10;
            kp2_guess = 5;
            kd2_guess = 35;
            mapping_params = [kn1_guess; kp1_guess; kd1_guess; kn2_guess; kp2_guess; kd2_guess]; % Making kn2 be 0 for now so that the second half of the model is irrelevant
            
            estimated_tf_coeff = zeros(sample_num, 6);
    
    
            % Identify peak amplitude and split point
            peak_amplitude = max(value);
            split_point = find(value >= 1.00 * peak_amplitude, 1);
            
            % Split data into two segments
            value_first_segment = value(1:split_point);
    
            % Create "Fake" values equal to the last value before the split
            fake_values = repmat(value(split_point), length(value) - length(value_first_segment), 1);
            
            % Concatenate "Fake" values to match the original length
            value_final = [value_first_segment; fake_values];
            
            % First segment optimization (before 99% peak amplitude)
            lb = [0 0 0 0 0 0];
            ub = [inf inf inf inf inf inf];
    
            if length(time_min) > 10
                [estimated_tf_coeff_temp, ~] = lsqcurvefit(@modelFit_1_1, mapping_params, ...
                    time_min, value_final, lb, ub, opts);
            else
                estimated_tf_coeff_temp = -1 * ones(6,1);
            end
            estimated_tf_coeff(i, :) = estimated_tf_coeff_temp';
            
            % Fix the first three variables for the second optimization
            kn1_fixed = estimated_tf_coeff_temp(1);
            kp1_fixed = estimated_tf_coeff_temp(2);
            kd1_fixed = estimated_tf_coeff_temp(3);
            
            kn2_guess = kn1_fixed;
            kn2_upper_bound = kn1_fixed * (1 - 1e-6);
    
            kd2_guess = time_min(split_point);
            kd2_lower_bound = time_min(split_point);
            
            kp2_guess = kp1_fixed;
    
            mapping_params_fixed = [kn1_fixed; kp1_fixed; kd1_fixed; ...
                                    kn2_guess; kp2_guess; kd2_guess];
          
            % Second segment optimization (entire time domain with first 3 variables fixed)
            lb_fixed = [kn1_fixed, kp1_fixed, kd1_fixed, 0, 0, kd2_lower_bound]; % Forcing kd2 to be MORE than the 95% peak.
            ub_fixed = [kn1_fixed, kp1_fixed, kd1_fixed, inf, inf, inf]; % Making the max of kn2 be kn1. If this is not true then numbers are wrong.
            
            if length(time_min) > 10
                [estimated_tf_coeff_final, ~] = lsqcurvefit(@modelFit_1_2, mapping_params_fixed, ...
                    time_min, value, lb_fixed, ub_fixed, opts);
    
                estimated_tf_coeff(i, :) = estimated_tf_coeff_final';
            else
                estimated_tf_coeff_final = -1*ones(6,1);
                estimated_tf_coeff(i, :) = estimated_tf_coeff_final';
            end
            sample.fitted_TF_params = estimated_tf_coeff_final';
            
            % Calculate the R-squared value
            if all(estimated_tf_coeff_final ~= -1)
                simTF = modelFit_0(estimated_tf_coeff_final, time_min);
                Rsq = Rsquared(value, simTF);
            else
                simTF = value;
                Rsq = -1;
            end
        elseif fitting_method == 2
            kp1_guess = 5  ;
            kn1_guess = 2.5e10 ; 
            kd1_guess = 2  ; 
            kn2_guess = 2.5e10 ;
            kp2_guess = 5 ;
            kd2_guess = 35 ;
            mapping_params = [kn1_guess;kp1_guess;kd1_guess;kn2_guess;kp2_guess;kd2_guess];
            estimated_tf_coeff = zeros(sample_num, 6);

            lb = [0 0 0 0 0 0];
            ub = [inf inf inf inf inf inf];
            if length(time_min) > 10
                [estimated_tf_coeff_temp, ~] = lsqcurvefit(@modelFit, mapping_params, ...
                    time_min, value, lb, ub, opts);
            else
                estimated_tf_coeff_temp = -1 * ones(6,1);
            end
            estimated_tf_coeff_final = estimated_tf_coeff_temp;
            sample.fitted_TF_params = estimated_tf_coeff_final';
            % Exp_WBTEG.(sample_name).fitted_TF_params = estimated_tf_coeff_final';
            % Calculate the R-squared value
            if all(estimated_tf_coeff_final ~= -1)
                simTF = modelFit(estimated_tf_coeff_final, time_min);
                Rsq = Rsquared(value, simTF);
            else
                simTF = value;
                Rsq = -1;
            end
        end
        
        % Extend TEG info temp with the fitted parameters and R-squared value
        TEG_info_extend_temp(i,:) = [TEG_info_idx, sample.fitted_TF_params, Rsq, sample_name];
        
        % Plot experimental data vs simulated results with R squared value and parameter values
        figure
        plot(time_min, value, 'DisplayName', 'Exp Data', 'LineWidth', 2)
        grid on
        hold on
        plot(time_min, simTF, 'DisplayName', 'Fitted Curve', 'LineWidth', 2)
        xlabel('Time [min]')
        ylabel('TEG [mm]')
        
        % Create legend string with R^2 and parameter values
        legendStr = sprintf('Fitted Curve (R^2 = %.3f)\nKn1 = %.2e\nKp1 = %.2e\nKd1 = %.2e\nKn2 = %.2e\nKp2 = %.2e\nKd2 = %.2e', ...
            Rsq, estimated_tf_coeff_final(1), estimated_tf_coeff_final(2), estimated_tf_coeff_final(3), ...
            estimated_tf_coeff_final(4), estimated_tf_coeff_final(5), estimated_tf_coeff_final(6));
        
        title(sample.SAMPLEDESCRIPTION, 'Interpreter', 'none')
        legend('Exp Data', legendStr, 'Location','best')
        hold off
        
        if save_fig == 1
            png_path = "./Fig/TPATXA/ACIT/6 Params/" + string(crd_files(ii)) + "/png/";
            fig_path = "./Fig/TPATXA/ACIT/6 Params/" + string(crd_files(ii)) + "/fig/";
            if ~isfolder(png_path)
                mkdir(png_path)
            end
            if ~isfolder(fig_path)
                mkdir(fig_path)
            end
            saveas(gcf, png_path + string(sample_name), 'png')
            savefig(fig_path+string(sample_name)+'.fig')
        end
        if mod(i, 20) == 0
            close all
        end
    end 

    for i = 1:sample_num
        idx = double(TEG_info_extend_temp(i,1));
        TEG_info_extend(idx,:) = TEG_info_extend_temp(i,2:end);
    end
    
    % Convert extended TEG info to table including R^2
    TEG_info_extend_tab = array2table(TEG_info_extend, ...
        'VariableNames', ["Kn1", "Kp1", "Kd1", "Kn2", "Kp2", "Kd2", "Rsq", "Fig Name"]);
    TEG_info = [TEG_info_initial TEG_info_extend_tab];
    
    writetable(TEG_info, '../Data/Processed/TEG_Info/TEG_info_SampleSetC_6params_Method2.xlsx', 'Sheet', txt_files(ii));
    close all
end
