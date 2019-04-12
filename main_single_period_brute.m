% find equivalent solution for single period
% and its fitness (change parameters in fitness functions)
% used by expirment 2 and 3
% return a best value, and its task parameters

clc; clear; 

% Parameters
bd = [150 250  150 250  150 250];   % searching bounds, [LB1 UB1   LB2 UB2   LB3 UB3]
td = 10;                            % searching step
best_score = 1.0;                   % final score (lowest)
best_x = [0 0 0  0 0 0  0 0 0];     % final solution

T1_a = bd(1):td:bd(2);
T2_a = bd(3):td:bd(4);
T3_a = bd(5):td:bd(6);

% Iterates through all *possible* solutions
% (and find feasible and best)
for T1 = T1_a
    for T2 = T2_a
        for T3 = T3_a
            % encode gene
            x = [T1 T1 100  T2 T2 100  T3 T3 100];
            
            % call fitness function
            if ((T1 ~= T2) && (T2 ~=T3))
                fit = myFitness_lamba_u(x);
                %fit = myFitness(x);
                
                % better than the best?
                if fit < best_score
                    best_score = fit;
                    best_x = x;
                end
            end
        end
    end
end

% print result
disp(best_score);
disp([best_x(1) best_x(4) best_x(7)]);
