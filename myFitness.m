
% Fitness function
% min f(x) = 100 (x1^2 - x2)^2 + (1-x1)^2

function y = myFitness(x)
y = 100 * (x(1)^2  - x(2))^2 + (1-x(1))^2 + x(3);
end

