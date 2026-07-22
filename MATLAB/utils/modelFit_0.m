function simTF = modelFit_0(params, timespan)
% This script defines the model of a transfer function. This function will
% be called by the lsqcurvefit to estimate the coefficients of the transfer
% function. Modify this script if it is used to estimate other TF model.
% Aim: the function contains the transfer function for the whole blood TEG
% model.
% Input: params - parameters that will be estimated;
%        timespan - timescale the is same as the experimental data.
% Output: simTF - simulated TEG profile that will be compared with the
%                 experimental TEG by the lsqcurvefit.


Kn1 = params(1);
Kp1 = params(2);
Kd1 = params(3);
Kn2 = params(4);
Kp2 = params(5);
Kd2 = params(6);

num_part1 = Kn1;
den_part1 = [Kp1 1 0];
num_part2 = -Kn2;
den_part2 = [Kp2 1 0];
TF_part1 = tf(num_part1, den_part1, 'InputDelay', Kd1);
TF_part2 = tf(num_part2, den_part2, 'InputDelay', Kd2);

input_sig = zeros(size(timespan));
input_sig(2:8) = 10e-9 ;

sys = TF_part1 + TF_part2;
% simTF = 10e-9 * impulse(sys,timespan);
simTF = lsim(sys,input_sig, timespan);

end