% random search method for benchmark

clc; clear;

rng(20, 'twister')

num_of_iteration = 30;
num_of_population = 100;

result_fitness_best = [];
result_fitness_mean = [];

fitness_best = 1.0;

for iter = 1:num_of_iteration
    
    fprintf("iteration: %d \r", iter);
    
    fitness_sum = 0;
    
    for i = 1:num_of_population
        % call fitness function
        x = gen_random_param();
        fitness = myFitness_lamba_u(x);
        fitness_sum = fitness_sum + fitness;
        if (fitness < fitness_best) 
            fitness_best = fitness;
            x_best = x;
        end
    end

    result_fitness_best = [result_fitness_best fitness_best];
	result_fitness_mean = [result_fitness_mean fitness_sum / num_of_population];
end

result_fitness_best
result_fitness_mean
x_best

beep;