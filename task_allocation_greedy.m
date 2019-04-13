% allocate tasks into an optimal system
% display how many tasks can be additional added
function [] = task_allocation_greedy(experiment)

%experiment = 1; % 1 for single, 2 for dual
if (experiment == 1)
    util_candidates = [0.10 0.13 0.16 0.19]; 
else
    util_candidates = [0.10 0.13 0.16 0.19 0.22]; 
end
    
single_best_x = [170,170,100,220,220,100,200,200,100; ...
                170,170,100,220,220,100,200,200,100; ...
                170,170,100,220,220,100,200,200,100; ...
                170,170,100,220,220,100,200,200,100];

dual_best_x = [ ...
209	232	63	178	247	18	210	235	46; ...
161	237	13	231	240	61	196	222	13; ...
157	240	13	215	249	39	180	250	0; ...
175	236	14	234	244	52	201	244	51; ...
199	249	51	205	238	55	201	241	0
];

for idx = 1:numel(util_candidates)
    fprintf("\r Util:%0.2f \r", util_candidates(idx))
    % taskset_nc.util
    filename = sprintf("taskset_u_%0.2f.mat", util_candidates(idx));
    load(filename); % taskset_nc, the 5 non-control tasks
    
    if (experiment == 1)
        x = single_best_x(idx,:);
    else
        x = dual_best_x(idx,:);
    end
    
    for taskset_idx = 1:10
        fprintf("Takset #: %d ", taskset_idx)
        % read taskset(taskset_idx)
        % taskset_db: database of 20 candidate taskss 
        filename = sprintf("taskset_db_%d.mat", taskset_idx);
        load(filename); % taskset_db, the 20 candidate tasks       
        
        taskset_nc_temp = taskset_nc;
        
        % iterative each task in taskset.db
        % try to fit into the original taskset
        num_addition = 0;
        fit_best = 1.0;
        total_util = util_candidates(idx) ;
        
        for i = 1:20
            % get *one* task candidate
            new_task = taskset_db(i, :);
            new_util = new_task(1) / new_task(2);
            total_util = total_util + new_util;
            
            % fit into the overall taskset
            taskset_nc_temp = [taskset_nc_temp; new_task];
            
            % save dataset to the automation task queue.file
            % by saving it to taskset_u_0.00.mat
            save('taskset_u_0.00.mat', 'taskset_nc')
            
            % find run fitness function
            fit = myFitness_lamba_u_e3(x, total_util);
            
            % if unschedulable, break, and ignore the rest candidates
            if (fit >= 1.0)
                break
            else
                fit_best = fit;
            end
            
            num_addition = num_addition + 1;
            
        end
        
        fprintf("Fitable tasks: %d penalty %0.3f \r", num_addition, fit_best);
        
    end

end

end
