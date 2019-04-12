% task_generator.m
% generate synthetic task sets for E.3
% U = 1.0

%%
format long g

rng(5)

% parameters
NUM_OF_DATASETS = 10;

N = 20;                              % number of tasks
U_bound = N * (power(2, 1/N) - 1);   % utilization boundary
U_bar = 1.0;                         % desired utilization
Ti_lower = 200;                      % taskset period upper bound (unit:100us)
Ti_upper = 10000;                    % taskset period lower bound (unit:100us)


% start to generate
for taskset_idx = 1:NUM_OF_DATASETS

    disp(taskset_idx)
    
    % Generate task utilization with UUnifast
    % sort by utilization
    Ui = sort(UUniFast(N, U_bar));
    Ui = Ui';
    
    % Generate task periods with log-uniformed distribution
    LA = log10(Ti_lower);
    LB = log10(Ti_upper);
    Ti = 10 .^ (LA + (LB-LA) * rand(1, N));
    Ti = Ti';
    
    % Calculate task computation times
    Ci = floor(Ui .* Ti);
    Ti = floor(Ti);
    Ci(Ci == 0) = 1;
    
    % Put everything into taskset[], truncate and sort with RM
    Di = Ti;
    
    TiL = ones(N, 1) * -1;
    alpha = ones(N, 1) * -1;
    idx = ones(N,1) * -1;
    
    taskset = [Ci, Di, Ti, TiL, alpha, idx];
    
    % print info
    fprintf('\r Generated Taskset (Ci, Di == Ti, Ti, TiL, alpha, idx): \r\r');
    disp(taskset);
    
    fprintf('The actual task total utilization is: %0.3f \r', sum(taskset(:,1) ./ taskset(:,2)));

    % save dataset
    filename = sprintf("taskset_db_%d.mat", taskset_idx);
    taskset_db = taskset;
    save(filename, 'taskset_db');
    
end
