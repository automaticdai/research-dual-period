%% compile kernel
% use the following commands in MATLAB to set environment
% (change the path to your minGW installation path)
%setenv('MW_MINGW64_LOC', 'C:\mingw-w64\mingw64')
%mex -setup C++

clc; clear;

% for reproducability
rng(10, 'twister')

% add paths
addpath('afbs-kernel')
addpath('analysis')
addpath('result')
addpath('tasksets')

% compile and init the kernel
kernel_init()


%% main code for minimising via GA
% Ideal Point


% objective and constraint functions
objFcn = @myFitness;
ConsFcn = @myConstraints;

% Optimising variables
nVars = 9;
LB = [10      10     0      10   10     0     10    10    0];
UB = [200   200 100    200 200 100   200  200 100];

% Optimising options
opts = optimoptions('ga','PlotFcn',@gaplotbestf, 'PopulationSize', 50,'MaxGenerations',20,'Display','iter');

%,'CrossoverFcn',@crossoversinglepoint ,'CrossoverFraction',0.8,'MutationFcn',{@mutationuniform,0.2},

% GA main function
[x,fval,exitflag,output,population,scores] = ga(objFcn, nVars,[],[],[],[],LB,UB,ConsFcn, [1 2 3 4 5 6 7 8 9],opts);

final_config = x;
disp(final_config);

final_output = fval;
gaExit = exitflag;
