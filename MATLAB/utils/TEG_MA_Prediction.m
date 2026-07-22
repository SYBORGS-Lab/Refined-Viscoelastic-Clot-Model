% This function predicts MA and TMA given the TEG model simulated curve and
% predicted R and K time
function [MA, TMA] = TEG_MA_Prediction(timespan, simTEG, R, K)
RK = R + K;
start_idx = find(timespan >= RK, 1, 'first');
dt = timespan(2) - timespan(1);
grad_threshold = 0.63;
for i = start_idx : length(timespan)-1
    % time_grad = [time_grad; [timespan(i), (simTEG(i+1) - simTEG(i))/dt]];
    grad = (simTEG(i+1) - simTEG(i))/dt;
    if grad <= grad_threshold
        idx_after = i;
        break
    else
        idx_after = -1;     % Error found
    end
end
if exist('idx_after', 'var') && idx_after > 0
    idx_prev = idx_after - 1;
    if idx_prev > 0
        MA_temp = mean([simTEG(idx_after), simTEG(idx_prev)]);
        TMA = mean([timespan(idx_after), timespan(idx_prev)]);
        MA = MA_temp / 2;
    else
        MA = -1;
        TMA = -1;
    end
else
    MA = -1;
    TMA = -1;
end