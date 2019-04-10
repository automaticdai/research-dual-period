% task_generator.m
% generate synthetic task sets
format long g
rng('default')


%% Parameters
N = 5;                              % number of tasks
U_bound = N * (power(2, 1/N) - 1);  % utilization boundary
U_bar = 0.25;                        % desired utilization
Ti_lower = 200;                     % taskset period upper bound (unit:100us)
Ti_upper = 10000;                   % taskset period lower bound (unit:100us)

Ui = zeros(N, 1);
Ci = zeros(N, 1);
Ti = zeros(N, 1);
Di = zeros(N, 1);


%% Generate task utilization with UUnifast
Ui = UUniFast(N, U_bar);
Ui = Ui';

% f1 = figure();
% histogram(Ui, 'Normalization', 'Probability')
% title('Utilization')


%% Generate task periods with log-uniformed distribution
LA = log10(Ti_lower);
LB = log10(Ti_upper);
Ti = 10 .^ (LA + (LB-LA) * rand(1, N));
Ti = Ti';

% f2 = figure();
% histogram(Ti, 'Normalization', 'Probability')
% title('Periods')


%% Calculate task computation times
Ci = Ui .* Ti;


%% Put everything into taskset[], truncate and sort with RM
Di = Ti;
TiL = ones(N, 1) * -1;
alpha = ones(N, 1) * -1;
idx = ones(N,1) * -1;
taskset = [floor(Ci), floor(Di), floor(Ti), TiL, alpha, idx];


% print
fprintf('\r Generated Taskset (Ci, Di == Ti, Ti, TiL, alpha, idx): \r\r');
disp(taskset);

fprintf('The actual task total utilization is: %0.3f \r', sum(taskset(:,1) ./ taskset(:,2)));

% save dataset
filename = sprintf("taskset_u_%0.2f.mat", U_bar);

taskset_nc = taskset;
save(filename, 'taskset_nc');