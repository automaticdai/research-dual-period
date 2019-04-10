%% compile kernel
% use the following commands in MATLAB to set environment
% (change the path to your minGW installation path)
%setenv('MW_MINGW64_LOC', 'C:\mingw-w64\mingw64')
%mex -setup C++

clc; clear;

 % add paths
addpath('afbs-kernel')
addpath('analysis')
addpath('result')

% compile and init the kernel
kernel_init()


%% initilize parameters
init();


%% main code for minimising via GA
% Ideal Point


% objective and constraint functions
objFcn = @myFitness;
ConsFcn  = @myConstraints;

% Optimising variables
nVars = 9;
LB = [1000  1000  0 1000 1000 0 1000 1000 0];
UB = [5000 5000 100 5000 5000 100 5000 5000 100];

% Optimising options
opts = optimoptions('ga','PlotFcn',@gaplotbestf, 'PopulationSize',100,'MaxGenerations',50,'Display','iter');

%,'CrossoverFcn',@crossoversinglepoint ,'CrossoverFraction',0.8,'MutationFcn',{@mutationuniform,0.2},

% GA main function
[x,fval,exitflag] = ga(objFcn, nVars,[],[],[],[],LB,UB,ConsFcn, [1 2 3 4 5 6 7 8 9],opts);

final_config = sprintf('%d ', x);
final_output = 100 - fval;
gaExit = exitflag;
