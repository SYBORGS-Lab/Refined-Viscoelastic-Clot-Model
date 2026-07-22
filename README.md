# Refined-Viscoelastic-Clot-Model
This repository contains MATLAB scripts, experimental data, and processed data asscoiated with the paper "A Refined Phenomenological Model of Viscoelastic Clot Formation and Lysis in Trauma-Induced Coagulopathy".

## System Requirements
### Hardware Requirements
The MATLAB files only require a standard computer with enough RAM to support in-memory operations.
### Software Requirements
The MATLAB scripts were created using MATLAB R2023a. Therefore, MATLAB R2023a and newer versions are recommended.

## Initializing and User Instructions
1. Clone this repository.
2. Open MATLAB.
3. Run desired MATLAB scripts. Note: our MATLAB scripts will automatically loaded dependent directories on their own, so no need to manually add folders to MATLAB workspace.

## Files Info
### Fitting Algorithms
The fitting algorithm scripts are used to compute the model parameters by running `lsqcurvefit` function on the experimental data. The paper introduced three different model: six-parameter TEG model (the original model), nine-parameter TEG model (the refined version, main focus of this paper), and the CAT-TEG infused model. We developed three MATLAB scripts dedicated to each one of them:
- Six-parameter TEG model: `TEG_6model_params_fitting_main.m`. Note that the fitting algorithm of this script has two fitting logit named Method 1 and Method 2. Method 2 is the same fitting logit that has been used in paper "Quick model-based viscoelastic clot strength predictions from blood protein concentrations for cybermedical coagulation control." All model parameters are fitted simultaneously. This logit can generate simulated TEG trajectories with high coefficient of determination, but it leads to three limitations as documented in the paper. To overcome these limitations, Method 1 was developed by splitting an experimental TEG trajectory into two parts and running the fitting algorithm separately. 
- Nine-parameter TEG model: `TEG_9model_params_fitting_main.m`
- CAT-TEG infused model: `CAT_TEG_params_fitting_main.m`

### TEG Parameter Prediction Scripts
To compare the predictive performance of our refined nine-parameter TEG model with the original six-parameter one, we have developed two scripts for these two models to predict the static TEG parameters (R, K, MA, TMA, Angle, Ly30, Ly60) using the simulated TEG profiles. The prediction errors were also computed.
- Six-parameter TEG model: `TEG_params_prediction_6param.m`
- Nine-parameter TEG model: `TEG_params_prediction_9param.m`
Note: The means and standard deviations (SDs) of the prediction errors were further analyzed in spreadsheets `Prediction Errors of tPATXA dataset 9params vs 6params Method2.xlsx`, `TEG_params_prediction_ACIT_6params_Method2.xlsx`, and `TEG_params_prediction_ACIT_9params.xlsx`. Hence, the values reported by the MATLAB scripts are not final ones. The values reported in paper were contained in those spreadsheets. 

### ACIT Dataset
ACIT dataset is available upon request!

## Software License
@Copyright 2026 University of Florida Research Foundation, Inc. All Commercial Rights Reserved.
