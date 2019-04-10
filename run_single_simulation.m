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

% passing parameters and configurations
% unit: 10us
simu.time = 1.0;    % time of simulation

simu.afbs_params = [0];

%               [C, D, Th, Tl, alpha, idx]
simu.taskset = [5,2000,2200,3100,50,0,     5,2000,2200,3200,50,1,   5,2000,2200,3300,50,2,   5,2200,2200,-1,-1,-1,   5,2500,2500,-1,-1,-1];

% Ts reference
tsref1 = 2.0;
tsref2 = 2.0;
tsref3 = 2.0;

% Ts minimal requirement
tsmin1 = 1.2;
tsmin2 = 1.2;
tsmin3 = 1.2;


init();


%% run simulation
% log
log_file_name = sprintf('./log.txt');
if (exist(log_file_name, 'file') == 2)
    diary off;
    delete(log_file_name);
end

diary(log_file_name);
diary on;

% run simulink
sim('simulink_afbs_disturbance_rejection.mdl');

diary off;

% calculate response time
pi1 = stepinfo(simout_y.Data(:,1), simout_y.Time, 'SettlingTimeThreshold',0.02);
pi2 = stepinfo(simout_y.Data(:,2), simout_y.Time, 'SettlingTimeThreshold',0.02);
pi3 = stepinfo(simout_y.Data(:,3), simout_y.Time, 'SettlingTimeThreshold',0.02);

settling_times = [pi1.SettlingTime, pi2.SettlingTime, pi3.SettlingTime]

if (sum(simout_status.Data == -1) == 0)
    % minimal control requirement / instable
    if (sum(settling_times > 0.95 * simu.time) || pi1.SettlingTime > tsmin1 ...
        || pi2.SettlingTime > tsmin2 || pi3.SettlingTime > tsmin3)
        fitness = -2
    else
        fitness = sum(1.0 ./ settling_times)
    end
else
    fitness = -1
end

fprintf("Fitness is: \r %0.3f \r",fitness)

% end of file