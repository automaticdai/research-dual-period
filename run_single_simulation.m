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

close all; clc; clear;

% set environment (will be moved to main.m)
setenv('MW_MINGW64_LOC', 'C:\TDM-GCC-64')
%setenv('MW_MINGW64_LOC', 'C:\minGW64')

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
syscl = feedback(sys,1);
%bode(syscl)
bandwidth(syscl) % / (2 * pi) * 30


%% Task Parameters
afbs_params = [1000, 1000, 1000];


%% run simulation
sim('simulink_afbs_demo.slx');




%end