% main code for minimising via GA

% Ideal Point


% objective and constraint functions
objFcn = @myFitness;
ConsFcn  = @myConstraints;

% Optimising variables
nVars = 3;
LB = [0 0 0];
UB = [1000 1000 1000];

% Optimising options
opts = optimoptions('ga','PlotFcn',@gaplotbestf, 'PopulationSize',100,'MaxGenerations',300,'CrossoverFcn',@crossoversinglepoint ,'CrossoverFraction',0.8,'MutationFcn',{@mutationuniform,0.2},'Display','iter');

% GA main function
[x,fval,exitflag] = ga(objFcn, nVars,[],[],[],[],LB,UB,[], [1 2],opts);

final_config = sprintf('%d ', x);
final_output = 1000 - fval;
gaExit = exitflag;
