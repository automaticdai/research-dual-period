
LB = 150;
UB = 250;
steps = 100;

step_size = (UB - LB) / steps;
alpha = 30;


pca = -1 * ones(steps + 1, steps + 1);

i = 1;
j = 1;

for TH = LB:step_size:UB
    for TL = TH:UB
        x = [TH TL alpha];
        fitness = myFitness_scalable(x);
        pca(j, i) = fitness;
        
        i = i + 1;
    end
    i = 1;
    j = j + 1;
end
