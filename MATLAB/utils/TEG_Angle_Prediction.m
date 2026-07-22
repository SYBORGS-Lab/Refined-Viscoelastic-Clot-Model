% This function predicts Alpha Angle given the TEG model simulated curve
function angle = TEG_Angle_Prediction(timespan, simTEG, varargin)

defaultKn1 = -1;
defaultKp1 = -1;
defaultKd1 = -1;
defaulta3 = -1;
p = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x);
addParameter(p, 'Kn1', defaultKn1, validScalarPosNum)
addParameter(p, 'Kp1', defaultKp1, validScalarPosNum)
addParameter(p, 'Kd1', defaultKd1, validScalarPosNum)
addParameter(p, 'a3', defaulta3, validScalarPosNum)
parse(p, varargin{:})
Kn1 = p.Results.Kn1;
Kp1 = p.Results.Kp1;
Kd1 = p.Results.Kd1;
a3 = p.Results.a3;

simTEG_adjusted = 0.5 * simTEG;
[gradient, ~] = findAngle(timespan, simTEG_adjusted);
angle_raw = compAngle(gradient);            
% This predicted angle is the raw value by finding the tangential line
% passing through the split point and the simualted TEG curve. It will be
% further adjusted according to Kn1, Kp1, Kd1, a3 and an equation
if Kn1 < 0 || Kp1 < 0 || Kd1 < 0 || a3 < 0
    angle = angle_raw;
else
    Predicted_percent_error = 6.4548*Kn1*a3/(1e10*Kp1) + 2.3557*Kd1 - 24.7;
    angle = angle_raw / (Predicted_percent_error/100 + 1);
end

function [gradient, intercept] = findAngle(timeVector, curve)
    splitpoint_idx = find(curve > 0, 1, 'first') - 1;
    splitpoint_time = timeVector(splitpoint_idx);
    % Estimate the actual split point
    splitpoint_time_est = splitpoint_time-1.25;
    splitpoint_idx_est = find(timeVector >= splitpoint_time_est, 1, 'first');
    splitpoint_amp = curve(splitpoint_idx_est);
    delta_coord_time = timeVector - splitpoint_time_est;
    delta_coord_time(delta_coord_time < 0) = 0;
    delta_coord_amp = curve - splitpoint_amp;
    gradient_temp_presplit = zeros(splitpoint_idx_est, 1);
    gradient_temp_aftersplit = delta_coord_amp(splitpoint_idx_est+1:end) ./ delta_coord_time(splitpoint_idx_est + 1:end);
    gradient_temp = [gradient_temp_presplit; gradient_temp_aftersplit];
    gradient = max(gradient_temp);
    intercept = -splitpoint_time_est*gradient;
end

function ang = compAngle(gradient)
    % on the plot, since TEG uses a specific scale, to calcualte the angle
    % correctly, we need to consider the scale as well.
    % one y-grid corresponds to 20 mm amplitude and its length is 9.9898
    % mm, one x-grid cooresponds to 5 min and it length is 9.110 mm
    % Then, 1-mm amplitude = 9.9898/20 mm and 1 min = 9.110/5;
    unit_x = 9.110/5;
    unit_y = 9.9898/20;
    ang = atan(gradient * unit_y / unit_x) * 180/pi;
end

end
