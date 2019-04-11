% Fitness function
% x = [T_H, T_L, alpha, ...]
function y = myFitness(x)

clear mex;

% --------------------------
% Parameters
% --------------------------

%x = [2200 2800 50, 2200 2800 50, 2200 2800 50];
%disp(x)

% unit: 10us
simu.time = 1.2;    % time of simulation
simu.afbs_params = [0];

U_bar = 0.00;

% Ts reference
tsrefs = [1.0];

% Ts minimal requirement
tsmins = [1.0];

% Process System Model
sys_zpk = zpk([],[0.1+5i, 0.1-5i], 15);
sys = tf(sys_zpk);

% --------------------------
% Generate Taskset
% --------------------------
% generate non-control tasks
% [C, Th, Tl, alpha, D]
% load non-control tasks
filename = sprintf("taskset_u_%0.2f.mat", U_bar);
load(filename);

num_of_control = length(x) / 3;

x_decoded = reshape(x, 3, num_of_control);
x_decoded = x_decoded';

control_index = 0:num_of_control - 1;
control_index = control_index';

x_c = ones(1,num_of_control) * 50;   % C = 0.5ms
x_d = ones(1,num_of_control) * 150;  % D = 0.2ms

taskset_c  = [x_c' x_d' x_decoded, control_index];

if isempty(taskset_nc)
    taskset = [taskset_c];
else
    taskset = [taskset_c; taskset_nc];
end


% sort taskset
taskset = sortrows(taskset, 2);
taskset_inv = taskset';
simu.taskset = taskset_inv(:);

%disp(simu.taskset)

% --------------------------
% Run Simulink
% --------------------------
assignin('base','simu',simu)
assignin('base','sys',sys)

mdl_name = 'simu_afbs_control_2017.mdl';
%open_system(mdl);
%set_param(gcs,'SimulationCommand','Update')
simout = sim(mdl_name, 'SimulationMode','normal', 'SrcWorkspace','current');

simout_y = get(simout,'simout_y');
simout_status = get(simout,'simout_status');

% --------------------------
% Calculate fitness function
% --------------------------
control_info_a = [];
settling_times = [];
for i = 1:num_of_control
    control_info = stepinfo(simout_y.Data(:,i), simout_y.Time, 'SettlingTimeThreshold',0.02);
    control_info_a = [control_info_a control_info];
    
    pi = control_info.SettlingTime;
    settling_times = [settling_times pi];
end

%pi1 = stepinfo(simout_y.Data(:,1), simout_y.Time, 'SettlingTimeThreshold',0.02);
%pi2 = stepinfo(simout_y.Data(:,2), simout_y.Time, 'SettlingTimeThreshold',0.02);
%pi3 = stepinfo(simout_y.Data(:,3), simout_y.Time, 'SettlingTimeThreshold',0.02);
%settling_times = [pi1.SettlingTime, pi2.SettlingTime, pi3.SettlingTime];

% if no exception (scheduable)
if (sum(simout_status.Data == -1) == 0)
    % minimal control requirement / instable
    if (sum(settling_times > 0.95 * simu.time) || sum(settling_times > tsmins))
        fitness = 0; 
    else
        fitness = sum((tsmins - settling_times) ./ tsmins) / num_of_control;
    end
else
    fitness = 0.0;
end

%fprintf("Fitness is: \r %0.3f \r",fitness);


y = 1.0 - fitness;

end
