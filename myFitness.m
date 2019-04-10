% Fitness function
% x = [T_H, T_L, alpha, ...]
function y = myFitness(x)

clear mex;

%[C, Th, Tl, alpha, D]
% taskset_nc = [500, 2500, 2500, -1, -1, -1; ...
%               500, 2400, 2400, -1, -1, -1; ...
%             ];
% 

%x = [2200 2800 50, 2200 2800 50, 2200 2800 50];

disp(x)

% unit: 10us
simu.time = 1.0;    % time of simulation
simu.afbs_params = [0];


% Ts reference
tsref1 = 2.0;
tsref2 = 2.0;
tsref3 = 2.0;

% Ts minimal requirement
tsmin1 = 5.0;
tsmin2 = 5.0;
tsmin3 = 5.0;

% Process System Model
sys_zpk = zpk([],[0.1+5i, 0.1-5i], 15);
sys = tf(sys_zpk);
syscl = feedback(sys,1);

%bode(syscl)
%fprintf("Highiest period: %f \r", (2 * pi) / (30 * bandwidth(syscl)))
%fprintf("Lowest period: %f \r", (2 * pi) / (2 * bandwidth(syscl)))

taskset_nc = [];

num_of_control = length(x) / 3;

x_decoded = reshape(x, num_of_control, 3);

if (num_of_control ~= 1)
    x_decoded = x_decoded';
end

control_index = 0:num_of_control - 1;
control_index = control_index';

x_c = ones(1,num_of_control) * 500; % C = 5ms
x_d = ones(1,num_of_control) * 2000;% D = 20ms

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

% call Simulink
assignin('base','simu',simu)
assignin('base','sys',sys)

mdl = 'simulink_afbs_disturbance_rejection.mdl';
%open_system(mdl);
%set_param(gcs,'SimulationCommand','Update')
simout = sim(mdl, 'SimulationMode','normal', 'SrcWorkspace','current');
simout_y = get(simout,'simout_y');
simout_status = get(simout,'simout_status');

% calculate fitness function
pi1 = stepinfo(simout_y.Data(:,1), simout_y.Time, 'SettlingTimeThreshold',0.02);
pi2 = stepinfo(simout_y.Data(:,2), simout_y.Time, 'SettlingTimeThreshold',0.02);
pi3 = stepinfo(simout_y.Data(:,3), simout_y.Time, 'SettlingTimeThreshold',0.02);

settling_times = [pi1.SettlingTime, pi2.SettlingTime, pi3.SettlingTime];

if (sum(simout_status.Data == -1) == 0)
    % minimal control requirement / instable
    if (sum(settling_times > 0.95 * simu.time) || pi1.SettlingTime > tsmin1 ...
        || pi2.SettlingTime > tsmin2 || pi3.SettlingTime > tsmin3)
        %fitness = 102;
        fitness = 100 - sum(1.0 ./ settling_times);
    else
        fitness = 100 - sum(1.0 ./ settling_times);
    end
else
    fitness = 101;
end

fprintf("Fitness is: \r %0.3f \r",fitness);

y = fitness;

end
