function simTF = modelFit_1_2(params, timespan)
    % This script defines the model of a transfer function for the second stage of Approach 1

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
    input_sig(2:8) = 10e-9;

    sys = TF_part1 + TF_part2;
    simTF = lsim(sys, input_sig, timespan);
end
