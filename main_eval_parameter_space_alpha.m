pca = [];
x_axis = [];

granularity = 10000;

for i = 0.10 : 1.0/granularity : 0.90
    x = [150 250 i * 100];
    fitness = myFitness_scalable(x);
    disp(fitness)
    x_axis = [x_axis i];
    pca = [pca fitness];
end


plot(x_axis, pca)