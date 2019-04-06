
% Constraint Function
% x1x2 + x1 - x2 + 1.5 <= 0
% 10 -x1x2 <= 0
% 0 <= x1 <= 1 and 0 <= x2 <= 13

function [c,c_eq] = myConstraints(x)
c = [x(1)-x(2); x(2)-x(3)];
c_eq = [];
end