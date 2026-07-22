clear
close all
clc

% Load data from Sample Set F - Sample 16
addpath("./utils/")
addpath("./Fig/TPATXA/Sample Set F/")

SF_Sample16_New_fig = openfig('./Fig/TPATXA/Sample Set F/SFtP.CRD/fig/Sample16.fig');
SF_Sample16_Old_fig = openfig('./Fig/TPATXA/Sample Set F/6 ParamsSFtP.CRD/fig/Sample16.fig');
axesobjs = findall(SF_Sample16_New_fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_new = lineobjs(1).YData;
expTEG = lineobjs(2).YData;
close(SF_Sample16_New_fig)

axesobjs = findall(SF_Sample16_Old_fig, 'Type', 'axes');
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_old = lineobjs(1).YData;
close(SF_Sample16_Old_fig)


figure
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
TEG_plot(t, simTEG_new, '#08589e', '--', 2, 'New Sim TEG (R^2 = 0.999)');
TEG_plot(t, -simTEG_new, '#08589e', '--', 2);
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.997)');
TEG_plot(t, -simTEG_old, '#708090', '-', 2);
xlabel("Time (min)")
ylabel("Amplitude (mm)")
legend('Interpreter', 'tex', 'Location', 'east')
title("(a) Sample F BioReplicate #1: tPA = 0, TXA = 0")
clear expTEG simTEG_new simTEG_old

% Sample Set F: Sample 15
SF_Sample15_New_fig = openfig('./Fig/TPATXA/Sample Set F/SFtP.CRD/fig/Sample15.fig');
SF_Sample15_Old_fig = openfig('./Fig/TPATXA/Sample Set F/6 ParamsSFtP.CRD/fig/Sample15.fig');
axesobjs = findall(SF_Sample15_New_fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_new = lineobjs(1).YData;
expTEG = lineobjs(2).YData;
close(SF_Sample15_New_fig)

axesobjs = findall(SF_Sample15_Old_fig, 'Type', 'axes');
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_old = lineobjs(1).YData;
close(SF_Sample15_Old_fig)

figure
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
TEG_plot(t, simTEG_new, '#08589e', '--', 2, 'New Sim TEG (R^2 = 0.999)');
TEG_plot(t, -simTEG_new, '#08589e', '--', 2);
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.992)');
TEG_plot(t, -simTEG_old, '#708090', '-', 2);
xlabel("Time (min)")
ylabel("Amplitude (mm)")
legend('Interpreter', 'tex', 'Location', 'east')
title("(b) Sample F BioReplicate #2: tPA = 100, TXA = 0")
clear expTEG simTEG_new simTEG_old

% Sample Set F: Sample 2
SF_Sample2_New_fig = openfig('./Fig/TPATXA/Sample Set F/SFtP.CRD/fig/Sample2.fig');
SF_Sample2_Old_fig = openfig('./Fig/TPATXA/Sample Set F/6 Params/legacy/SFtP.CRD/fig/Sample2.fig');
axesobjs = findall(SF_Sample2_New_fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_new = lineobjs(1).YData;
expTEG = lineobjs(2).YData;
close(SF_Sample2_New_fig)

axesobjs = findall(SF_Sample2_Old_fig, 'Type', 'axes');
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_old = lineobjs(1).YData;
close(SF_Sample2_Old_fig)

figure
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
TEG_plot(t, simTEG_new, '#08589e', '--', 2, 'New Sim TEG (R^2 = 0.996)');
TEG_plot(t, -simTEG_new, '#08589e', '--', 2);
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.994)');
TEG_plot(t, -simTEG_old, '#708090', '-', 2);
xlabel("Time (min)")
ylabel("Amplitude (mm)")
legend('Interpreter', 'tex', 'Location', 'east')
title("(c) Sample F BioReplicate #5: tPA = 0, TXA = 0")
clear expTEG simTEG_new simTEG_old

%% Plot figure for the old teg model issue
% Sample Set 2C Sample 3
S2C_Sample3_Old_Fig = openfig("Fig/TPATXA/Sample Set C/6 Params/legacy/S2C_tPA.CRD/fig/Sample3.fig");
axesobjs = findall(S2C_Sample3_Old_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_old = lineobjs(1).YData;
expTEG = lineobjs(2).YData;
close(S2C_Sample3_Old_Fig)

figure(4)
subplot(2,2,1)
% plot(t, expTEG, 'LineWidth', 2, 'Color', '#f0825a', 'DisplayName', 'Exp TEG')
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
% plot(t, simTEG_old, 'LineWidth', 2, 'LineStyle', '-', 'Color', '#708090', 'DisplayName', 'Old Sim TEG (R^2 = 0.999)')
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.999)')
TEG_plot(t, -simTEG_old, '#708090', '-', 2)
% legend
xlabel("Time (min)")
ylabel("Amplitude (mm)")
% title("(a) Sample C BioReplicate #2 Trial 1: tPA = 0, TXA = 0")
title("(a) R^2 = 0.999")
clear expTEG simTEG_old

% Sample Set 2C Sample 4
S2C_Sample4_Old_Fig = openfig("Fig/TPATXA/Sample Set C/6 Params/legacy/S2C_tPA.CRD/fig/Sample4.fig");
axesobjs = findall(S2C_Sample4_Old_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_old = lineobjs(1).YData;
expTEG = lineobjs(2).YData;
close(S2C_Sample4_Old_Fig)

figure(4)
subplot(2,2,2)
% plot(t, expTEG, 'LineWidth', 2, 'Color', '#f0825a', 'DisplayName', 'Exp TEG')
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-')
% plot(t, simTEG_old, 'LineWidth', 2, 'LineStyle', '-', 'Color', '#708090', 'DisplayName', 'Old Sim TEG (R^2 = 0.998)')
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.998)')
TEG_plot(t, -simTEG_old, '#708090', '-', 2)
% legend
xlabel("Time (min)")
ylabel("Amplitude (mm)")
% title("(b) Sample C BioReplicate #2 Trial 2: tPA = 0, TXA = 0")
title("(b) R^2 = 0.998")
clear expTEG simTEG_old

% Sample Set 2C Sample 16
S2C_Sample16_Old_Fig = openfig("Fig/TPATXA/Sample Set C/6 Params/legacy/S2C_tPA.CRD/fig/Sample16.fig");
axesobjs = findall(S2C_Sample16_Old_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_old = lineobjs(1).YData;
expTEG = lineobjs(2).YData;
close(S2C_Sample16_Old_Fig)

figure(4)
subplot(2,2,3)
% plot(t, expTEG, 'LineWidth', 2, 'Color', '#f0825a', 'DisplayName', 'Exp TEG')
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
% plot(t, simTEG_old, 'LineWidth', 2, 'LineStyle', '-', 'Color', '#708090', 'DisplayName', 'Old Sim TEG (R^2 = 0.995)')
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.995)')
TEG_plot(t, -simTEG_old, '#708090', '-', 2)
% legend
xlabel("Time (min)")
ylabel("Amplitude (mm)")
% title("(c) Sample C BioReplicate #2 Trial 1: tPA = 100, TXA = 0")
title("(c) R^2 = 0.995")
clear expTEG simTEG_old

% Sample Set E Sample 46
SE_Sample46_Old_Fig = openfig("Fig/TPATXA/Sample Set E/6 Params/legacy/SampleE_tPA.CRD/fig/Sample46.fig");
axesobjs = findall(SE_Sample46_Old_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_old = lineobjs(1).YData;
expTEG = lineobjs(2).YData;
close(SE_Sample46_Old_Fig)

figure(4)
subplot(2,2,4)
% plot(t, expTEG, 'LineWidth', 2, 'Color', '#f0825a', 'DisplayName', 'Exp TEG')
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
% plot(t, simTEG_old, 'LineWidth', 2, 'LineStyle', '-', 'Color', '#708090', 'DisplayName', 'Old Sim TEG (R^2 = 0.918)')
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.918)')
TEG_plot(t, -simTEG_old, '#708090', '-', 2)
% legend
xlabel("Time (min)")
ylabel("Amplitude (mm)")
% title("(d) Sample E BioReplicate #2: tPA = 75, TXA = 0")
title("(d) R^2 = 0.918")
clear expTEG simTEG_old

%% Old vs New using Sample C BioReplicate 2
% Sample Set 2C Sample 3
S2C_Sample3_Old_Fig = openfig("Fig/TPATXA/Sample Set C/6 Params/legacy/S2C_tPA.CRD/fig/Sample3.fig");
S2C_Sample3_New_fig = openfig('./Fig/TPATXA/Sample Set C/S2C_tPA.CRD/fig/Sample3.fig');
axesobjs = findall(S2C_Sample3_Old_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_old = lineobjs(1).YData;
expTEG = lineobjs(2).YData;

axesobjs = findall(S2C_Sample3_New_fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_new = lineobjs(1).YData;

close(S2C_Sample3_Old_Fig)
close(S2C_Sample3_New_fig)

figure(5)
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.999)')
TEG_plot(t, -simTEG_old, '#708090', '-', 2)
TEG_plot(t, simTEG_new, '#08589e', '--', 2, 'New Sim TEG (R^2 = 0.998)')
TEG_plot(t, -simTEG_new, '#08589e', '--', 2)
xlabel("Time (min)")
ylabel("Amplitude (mm)")
title("(a) Sample C BioReplicate #2 TechReplicate #1: tPA = 0, TXA = 0")
legend("Location", 'east')

% Sample Set 2C Sample 4
S2C_Sample4_Old_Fig = openfig("Fig/TPATXA/Sample Set C/6 Params/legacy/S2C_tPA.CRD/fig/Sample4.fig");
S2C_Sample4_New_fig = openfig('./Fig/TPATXA/Sample Set C/S2C_tPA.CRD/fig/Sample4.fig');
axesobjs = findall(S2C_Sample4_Old_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_old = lineobjs(1).YData;
expTEG = lineobjs(2).YData;

axesobjs = findall(S2C_Sample4_New_fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_new = lineobjs(1).YData;

close(S2C_Sample4_Old_Fig)
close(S2C_Sample4_New_fig)

figure(6)
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.998)')
TEG_plot(t, -simTEG_old, '#708090', '-', 2)
TEG_plot(t, simTEG_new, '#08589e', '--', 2, 'New Sim TEG (R^2 = 0.999)')
TEG_plot(t, -simTEG_new, '#08589e', '--', 2)
xlabel("Time (min)")
ylabel("Amplitude (mm)")
title("(a) Sample C BioReplicate #2 TechReplicate #2: tPA = 0, TXA = 0")
legend("Location", 'east')

% Sample Set 2C Sample 16
S2C_Sample16_Old_Fig = openfig("Fig/TPATXA/Sample Set C/6 Params/legacy/S2C_tPA.CRD/fig/Sample16.fig");
S2C_Sample16_New_fig = openfig('./Fig/TPATXA/Sample Set C/S2C_tPA.CRD/fig/Sample16.fig');
axesobjs = findall(S2C_Sample16_Old_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_old = lineobjs(1).YData;
expTEG = lineobjs(2).YData;

axesobjs = findall(S2C_Sample16_New_fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_new = lineobjs(1).YData;

close(S2C_Sample16_Old_Fig)
close(S2C_Sample16_New_fig)

figure(7)
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.995)')
TEG_plot(t, -simTEG_old, '#708090', '-', 2)
TEG_plot(t, simTEG_new, '#08589e', '--', 2, 'New Sim TEG (R^2 = 1.000)')
TEG_plot(t, -simTEG_new, '#08589e', '--', 2)
xlabel("Time (min)")
ylabel("Amplitude (mm)")
title("(b) Sample C BioReplicate #2: tPA = 100, TXA = 0")
legend("Location", 'east')

% Sample Set E Sample 46
SE_Sample46_Old_Fig = openfig("Fig/TPATXA/Sample Set E/6 Params/legacy/SampleE_tPA.CRD/fig/Sample46.fig");
SE_Sample46_New_Fig = openfig("Fig/TPATXA/Sample Set E/SampleE_tPA.CRD/fig/Sample46.fig");
axesobjs = findall(SE_Sample46_Old_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_old = lineobjs(1).YData;
expTEG = lineobjs(2).YData;

axesobjs = findall(SE_Sample46_New_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_new = lineobjs(1).YData;

close(SE_Sample46_Old_Fig)
close(SE_Sample46_New_Fig)

figure(8)
% subplot(2,2,4)
% plot(t, expTEG, 'LineWidth', 2, 'Color', '#f0825a', 'DisplayName', 'Exp TEG')
TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
hold on
grid on
TEG_plot(t, -expTEG, '#f0825a', '-', 2)
% plot(t, simTEG_old, 'LineWidth', 2, 'LineStyle', '-', 'Color', '#708090', 'DisplayName', 'Old Sim TEG (R^2 = 0.918)')
TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.918)')
TEG_plot(t, -simTEG_old, '#708090', '-', 2)
TEG_plot(t, simTEG_new, '#08589e', '--', 2, 'New Sim TEG (R^2 = 0.999)')
TEG_plot(t, -simTEG_new, '#08589e', '--', 2)
% legend
xlabel("Time (min)")
ylabel("Amplitude (mm)")
title("(c) Sample E BioReplicate #2: tPA = 75, TXA = 0")
legend("Location", 'east')

%% Modular model
% Sample Set 2C Sample 3
S2C_Sample3_CAT_fig = openfig('./Fig/TEG and CAT Infused Model/Sample Set C/S2C_tPA.CRD/fig/Sample3.fig');
S2C_Sample3_New_fig = openfig('./Fig/TPATXA/Sample Set C/S2C_tPA.CRD/fig/Sample3.fig');
axesobjs = findall(S2C_Sample3_CAT_fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_cat = lineobjs(1).YData;
expTEG = lineobjs(2).YData;

axesobjs = findall(S2C_Sample3_New_fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_new = lineobjs(1).YData;

close(S2C_Sample3_CAT_fig)
close(S2C_Sample3_New_fig)

figure(9)
% subplot(2,2,1)
% TEG_plot(t, expTEG, '#f0825a', '-', 2, 'Exp TEG')
% hold on
% grid on
% TEG_plot(t, -expTEG, '#f0825a', '-', 2)
% % TEG_plot(t, simTEG_old, '#708090', '-', 2, 'Old Sim TEG (R^2 = 0.999)')
% % TEG_plot(t, -simTEG_old, '#708090', '-', 2)
% TEG_plot(t, simTEG_cat, '#08589e', '--', 2, 'New Sim TEG (R^2 = 0.998)')
% TEG_plot(t, -simTEG_cat, '#08589e', '--', 2)
plot(t, expTEG, 'Color','#f0825a', 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Exp TEG')
grid on
hold on
plot(t, simTEG_cat, 'Color', 'blue', 'LineStyle', ':', 'LineWidth', 2, 'DisplayName', 'Infused Model')
xlabel("Time (min)")
ylabel("Amplitude (mm)")
% title("(a) Sample C BioReplicate #2 TechReplicate #1: tPA = 0, TXA = 0")
title("(a) R^2 = 1.000")
% legend("Location", 'east')

figure(10)
% subplot(2,2,2)
plot(t, expTEG, 'Color','#f0825a', 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Exp TEG')
grid on
hold on
plot(t, simTEG_new, 'Color', '#08589e', 'LineStyle', ':', 'LineWidth', 2, 'DisplayName', 'New TEG Model')
xlabel("Time (min)")
ylabel("Amplitude (mm)")
title("(b) R^2 = 0.998")

% Sample Set E Sample 46
SE_Sample46_CAT_Fig = openfig("Fig/TEG and CAT Infused Model/Sample Set E/SampleE_tPA.CRD/fig/Sample46.fig");
SE_Sample46_New_Fig = openfig("Fig/TPATXA/Sample Set E/SampleE_tPA.CRD/fig/Sample46.fig");
axesobjs = findall(SE_Sample46_CAT_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
t = lineobjs(1).XData;
simTEG_cat = lineobjs(1).YData;
expTEG = lineobjs(2).YData;

axesobjs = findall(SE_Sample46_New_Fig, 'Type', 'axes');
% Get all line objects inside those axes
lineobjs = findall(axesobjs, 'Type', 'line');
simTEG_new = lineobjs(1).YData;

close(SE_Sample46_CAT_Fig)
close(SE_Sample46_New_Fig)

figure(11)
% subplot(2,2,3)
plot(t, expTEG, 'Color','#f0825a', 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Exp TEG')
hold on
grid on
plot(t, simTEG_cat, 'Color', 'blue', 'LineStyle', ':', 'LineWidth', 2, 'DisplayName', 'Infused Model')
xlabel("Time (min)")
ylabel("Amplitude (mm)")
title("(c) R^2 = 1.000")

% subplot(2,2,4)
figure(12)
plot(t, expTEG, 'Color','#f0825a', 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', 'Exp TEG')
grid on
hold on
plot(t, simTEG_new, 'Color', '#08589e', 'LineStyle', ':', 'LineWidth', 2, 'DisplayName', 'New TEG Model')
xlabel("Time (min)")
ylabel("Amplitude (mm)")
title("(d) R^2 = 0.999")

%% Model prediction error comparison
clear; close all; clc
TEG_param_names = ["R", "K", "MA", "TMA", "Angle"];
% Means (% error). Rows = TEG params, Cols = models [Model1, Model2]
tXATPA_percent_pred_error_mean = [10.82 17.66;
                                  12.49 44.67;
                                  1.23  14.26;
                                  8.87  96.66;
                                  10.79 35.32];
tXATPA_abs_pred_error_mean = [1.11 8.74];       % for ly30 only
tXATPA_percent_pred_error_std = [10.13 17.38;
                                 8.37  59.55;
                                 1.01  24.32;
                                 7.33  67.95;
                                 10.85 30.72];
tXATPA_abs_pred_error_std = [2.43  35.45];      % for ly30 only

ACIT_percent_pred_error_mean = [7.50  3.87;
                                18.78 12.68;
                                1.59  2.93;
                                4.80  44.51;
                                10.87 17.53];
ACIT_abs_pred_error_mean = [0.67 2.61];         % for ly30 only
ACIT_percent_pred_error_std = [4.06  7.90;
                               8.21  13.88;
                               10.21 13.96;
                               10.66 18.45;
                               7.89  20.94];
ACIT_abs_pred_error_std = [2.11  10.74];        % for ly30 only

figure('Color','w')
hold on
box on
tXATPA_percent_pred_mean_bar = bar(tXATPA_percent_pred_error_mean, 'grouped');
% Place error bars at bar centers
for i = 1:numel(tXATPA_percent_pred_mean_bar)
    x = tXATPA_percent_pred_mean_bar(i).XEndPoints;
    lower_end = min( tXATPA_percent_pred_error_mean(:,i), tXATPA_percent_pred_error_std(:,i) );
    errorbar(x', tXATPA_percent_pred_error_mean(:,i), lower_end, tXATPA_percent_pred_error_std(:,i), ...
        'k', 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 10);
end

% Axes + labels
set(gca, 'XTick', 1:numel(TEG_param_names), 'XTickLabel', TEG_param_names, 'FontSize', 16);
ylabel('Mean absolute percentage error (%)');
% title('Model Comparison: tPATXA Dataset');
legend({'Nine-parameter TEG Model','Six-parameter TEG Model'}, 'Location','northwest');
grid on;
ylim([0 105])

figure('Color','w')
hold on
box on
ACIT_percent_pred_mean_bar = bar(ACIT_percent_pred_error_mean, 'grouped');
% Place error bars at bar centers
for i = 1:numel(ACIT_percent_pred_mean_bar)
    x = ACIT_percent_pred_mean_bar(i).XEndPoints;
    lower_end = min( ACIT_percent_pred_error_mean(:,i), ACIT_percent_pred_error_std(:,i) );
    errorbar(x', ACIT_percent_pred_error_mean(:,i), lower_end, ACIT_percent_pred_error_std(:,i), ...
        'k', 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 10);
end

% Axes + labels
set(gca, 'XTick', 1:numel(TEG_param_names), 'XTickLabel', TEG_param_names, 'FontSize', 16);
ylabel('Mean absolute percentage error (%)');
% title('Model Comparison: ACIT Dataset');
legend({'Nine-parameter TEG Model','Six-parameter TEG Model'}, 'Location','northwest');
grid on;
ylim([0 105])




