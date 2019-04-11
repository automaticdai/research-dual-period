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
%setenv('MW_MINGW64_LOC', 'C:\TDM-GCC-64')
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
simu.taskset = [50,145,223,1,50,0,  50,200,219,239,65,1,  50,200,219,253,42,2,  50,220,220,-1,-1,-1,  50,250,250,-1,-1,-1];

% Ts reference
tsref1 = 2.0;
tsref2 = 2.0;
tsref3 = 2.0;

% Ts minimal requirement
tsmin1 = 1.2;
tsmin2 = 1.2;
tsmin3 = 1.2;


% Process System Model
sys_zpk = zpk([],[0.1+5i, 0.1-5i], 15);
sys = tf(sys_zpk);
syscl = feedback(sys,1);

bode(syscl)
fprintf("Highiest period: %f \r", (2 * pi) / (30 * bandwidth(syscl)))
fprintf("Lowest period: %f \r", (2 * pi) / (2 * bandwidth(syscl)))


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
sim('simu_afbs_control_2017.mdl');

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
        fitness = simu.time * 3
    else
        fitness = sum(settling_times)
    end
else
    fitness = simu.time * 5
end

fprintf("Fitness is: \r %0.3f \r",fitness)

% end of file