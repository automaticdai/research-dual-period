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

close all; clc; clear;

% !!!important, do not delete
clear mex;

% use the following commands in MATLAB to set environment
% (change the path to your minGW installation path)
%setenv('MW_MINGW64_LOC', 'C:\mingw-w64\mingw64')
%mex -setup C++

 % add paths
addpath('afbs-kernel')
addpath('analysis')
addpath('result')

% compile and init the kernel
kernel_init()

% passing parameters
% unit: 10us
afbs_params = [0];

taskset = [ 50, 200, 1000, 2000, 0.5, ...
            50, 200, 1000, 2000, 0.5, ...
            50, 200, 1000, 20000, 0.5, ...
            50, 200, 2000, -1, -1];


%% Process System Model
sys_zpk = zpk([],[-20+10i, -20-10i], 100);
sys = tf(sys_zpk);
syscl = feedback(sys,1);
%bode(syscl)
fprintf("Highiest period: %f \r", (2 * pi) / (30 * bandwidth(syscl)))
fprintf("Lowest period: %f \r", (2 * pi) / (2 * bandwidth(syscl)))

%% run simulation
sim('simulink_afbs_disturbance_rejection.slx');

%end