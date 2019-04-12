% searching for the loweset single period task
% for benchmark purpose

LB = 150;
UB = 250;

for i = LB:UB
    Ti = i;
    x = [Ti+1 Ti+1 100   Ti-1 Ti-1 100   Ti Ti 100];

    fit = myFitness(x);

    scatter(i, fit, 'rx');

    hold on;
end