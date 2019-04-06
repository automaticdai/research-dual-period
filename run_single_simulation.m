%%-------------------------------------------------------------------------
% Project:     Dual Period
% Author:      Xiaotian Dai
% Affiliation: University of York
% Created:     2019/04/06
%%-------------------------------------------------------------------------
% Filename:    run_single_simulation.m
% Description:
%   Run a single instance of simulation in Simulink and AFBS. This function
%   is called by GA in main.m.
%%-------------------------------------------------------------------------

%function[] = run_single_simulation(tau1, tau2, tau3)

% set environment (will be moved to main.m)
setenv('MW_MINGW64_LOC', 'C:\TDM-GCC-64')

% add paths
addpath('afbs-kernel')
addpath('analysis')
addpath('result')

% compile and init the kernel
kernel_init()

% passing parameters

%% Process System Model
sys_zpk = zpk([],[-400+80i, -400-80i], [1000]);
sys = tf(sys_zpk);


%% Parameters
T1 = 1000;
T2 = 1000;
T3 = 1000;


%% load and run simulation
sim('simulink_afbs_demo.slx');

% run






%end