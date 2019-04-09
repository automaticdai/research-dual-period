%% initilize parameters
% unit: 10us
simu.time = 1.0;    % time of simulation

afbs_params = [0];

% [C, Th, Tl, alpha, D]
taskset = [ 50, 200, 1000, 0.5,  0 ...
                 50, 200, 1000, 0.5,  0 ...
                 50, 200, 1000, 0.5,  0 ...
                 50, 200,     -1,  -1, 200];

% Ts reference
tsref1 = 2.0;
tsref2 = 2.0;
tsref3 = 2.0;

% Ts minimal requirement
tsmin1 = 5.0;
tsmin2 = 5.0;
tsmin3 = 5.0;


%% main code for minimising via GA

% Ideal Point


% objective and constraint functions
objFcn = @myFitness;
ConsFcn  = @myConstraints;

% Optimising variables
nVars = 3;
LB = [0 0 0];
UB = [1000 1000 1000];

% Optimising options
opts = optimoptions('ga','PlotFcn',@gaplotbestf, 'PopulationSize',5,'MaxGenerations',5,'CrossoverFcn',@crossoversinglepoint ,'CrossoverFraction',0.8,'MutationFcn',{@mutationuniform,0.2},'Display','iter');

% GA main function
[x,fval,exitflag] = ga(objFcn, nVars,[],[],[],[],LB,UB,[], [1 2],opts);

final_config = sprintf('%d ', x);
final_output = 1000 - fval;
gaExit = exitflag;
