function  feature = TEG_feature_prediction(t, simTEG, modelParams)

simTEG(simTEG<0) = 0;
[R, K] = TEG_RK_Prediction(t, simTEG, modelParams(3), modelParams(2));
[MA, TMA] = TEG_MA_Prediction(t, simTEG, R, K);
Alpha = TEG_Angle_Prediction(t, simTEG, 'Kn1', modelParams(1), 'Kp1', ...
            modelParams(2), 'Kd1', modelParams(3), 'a3', modelParams(6));
[Ly30, Ly60] = TEG_LY_Prediction(t, simTEG, MA, TMA);
feature = [R, K, MA, TMA, Alpha, Ly30, Ly60];
end