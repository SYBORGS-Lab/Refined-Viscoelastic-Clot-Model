% This function is a TEG model incorporating CAT model and a time varying
% parameter
function simTF = TEGModelTimeVaryingCATFitting(params, timespan)
S.kn = params(1)*1e9;
S.k0 = params(2);
S.k1 = params(3);
S.k2 = params(4);
S.kd = params(5);
S.knc = params(6);
S.kpc = params(7);
S.kdc = params(8);
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

% Fibrin model
sys_fib = tf(S.kn, [1, 0]);
% 
% CAT model
sys_CAT = tf(1, [1, S.k2, S.k1, S.k0], 'InputDelay', S.kd);

% Fibrinolysis model
% sys_lysis = (1+S.knc*(1+tanh(S.kpc*t-S.kdc))) .* (1 - S.kn2./(1+exp(-S.kp2*t+S.kd2)));
sys_lysis = (1+S.knc*(1+tanh(S.kpc*t-S.kdc))) .* (1-S.kn2*(1+tanh(S.kp2*(t-S.kd2))));

% Generate simulated TEG trajectory
% sys = tf(S.kn, [1, S.k2, S.k1, S.k0, 0], 'InputDelay', S.kd);
sys = sys_fib * sys_CAT;
simTF_temp = lsim(sys,input_sig, timespan);
simTF = simTF_temp.*sys_lysis';
end