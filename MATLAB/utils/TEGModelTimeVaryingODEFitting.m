% This script uses ode model to fit TEG profiles
function simTF = TEGModelTimeVaryingODEFitting(params, timespan)

S.kn1 = params(1)*1e9;
S.kp1 = params(2);
S.kd1 = params(3);
S.Knc = params(4);
S.Kpc = params(5);
S.Kdc = params(6);
S.kn2 = params(end-2);
S.kp2 = params(end-1);
S.kd2 = params(end);

if size(timespan, 1) > 1 && size(timespan, 2) == 1
    % timespan is a column vector
    t = timespan';
elseif size(timespan, 2) > 1 && size(timespan, 1) == 1
    % timespan is a row vector
    t= timespan;
end
S.timespan = t;

dt = t(2) - t(1);
% define an impulse signal equivalent to 5pM impulse
input_sig = zeros(size(t));
t_high = 0.5/dt;        % number of timepoints that the input values are not zero
high_endidx = int8(2+t_high);
input_sig(2:high_endidx) = 10e-9;
S.input_sig = input_sig;

% Version 1
kn_t = (1+S.Knc*(1+tanh(S.Kpc*t-S.Kdc))) .* (1-S.kn2*(1+tanh(S.kp2*(t-S.kd2))));
% Version 2
% kn_t = (1+S.Knc*(1+tanh(S.Kpc*t-S.Kdc))) .* (1-S.kn2*(1+tanh(S.kp2*t-S.kd2)));

x0 = [0;0];
xs = EulerMethod(@TEGModelOde, t, x0, S);
simTF = transpose(xs(1,:) .* kn_t);

function xs = EulerMethod(funcHd, t, x, S)
xs = zeros(2, length(t));
xs(:,1) = x;
    for i = 2:length(t)
        xsdot = funcHd(t(i), x, S);
        xs(:,i) = (t(i)-t(i-1))*xsdot + x;
        x = xs(:,i);
    end

function xsdot = TEGModelOde(t, x, S)
% x1 = x(1);          % This corresponds to y
x2 = x(2);            % This corresponds to ydot

kn1 = S.kn1;
kp1 = S.kp1;

% Input signal
u = impulseInput(t, S);
x1dot = x2;

% original
x2dot = -1/kp1*x2 + kn1/kp1 * u;

xsdot = [x1dot;x2dot];

function u = impulseInput(t, S)
kd1 = S.kd1;
input_sig = S.input_sig;
dt = S.timespan(2) - S.timespan(1);
t_delay = kd1/dt;
t_delay_idx = round(t_delay);
input_delay_padding = zeros(1, t_delay_idx);
input_sig = [input_delay_padding, input_sig];
input_sig(end-t_delay_idx+1:end) = [];
u = interp1(S.timespan, input_sig, t, "previous");
