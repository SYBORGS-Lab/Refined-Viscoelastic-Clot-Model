function [Ly30, Ly60] = TEG_LY_Prediction(timespan, simTEG, MA, TMA)
rectangle_ub = 2*MA*ones(size(timespan));
time_idx_start = find(timespan >= TMA, 1, 'first');
time_idx_30_end = find(timespan >= TMA+30, 1, 'first');
if TMA+60 <= max(timespan)
    time_idx_60_end = find(timespan >= TMA+60, 1, 'first');
else
    time_idx_60_end = length(timespan);
end
% area_under_curve_30 = trapz(timespan(time_idx_start:time_idx_30_end), simTEG(time_idx_start:time_idx_30_end));
% area_under_curve_60 = trapz(timespan(time_idx_start:time_idx_60_end), simTEG(time_idx_start:time_idx_60_end));
rectangle_area_30 = trapz(rectangle_ub(time_idx_start:time_idx_30_end));
rectangle_area_60 = trapz(rectangle_ub(time_idx_start:time_idx_60_end));
area_under_curve_30 = trapz(simTEG(time_idx_start:time_idx_30_end));
area_under_curve_60 = trapz(simTEG(time_idx_start:time_idx_60_end));
Ly30 = 100 - area_under_curve_30/rectangle_area_30 * 100;
Ly60 = 100 - area_under_curve_60/rectangle_area_60 * 100;
if Ly30 <= 0 || isnan(Ly30)
    Ly30 = 0;
end
if Ly60 <= 0 || isnan(Ly60)
    Ly60 = 0;
end