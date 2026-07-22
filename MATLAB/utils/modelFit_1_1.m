function simTF = modelFit_1_1(params, timespan)
    % This script defines the model of a transfer function for the first stage of Approach 1

    Kn1 = params(1);
    Kp1 = params(2);
    Kd1 = params(3);

    num_part1 = Kn1;
    den_part1 = [Kp1 1 0];
    TF_part1 = tf(num_part1, den_part1, 'InputDelay', Kd1);

    input_sig = zeros(size(timespan));
    input_sig(2:8) = 10e-9;

    simTF = lsim(TF_part1, input_sig, timespan);
end
