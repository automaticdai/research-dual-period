function [x] = gen_random_param()
%Generate a random parameters for dual period tasks
%   x = [T_H T_L alpha]
% Following constraints are used:
% LB = [200   200   0    200 200   0   200  200   0];
% UB = [500   500 100    500 500 100   500  500 100];
TL1 = randi([10 200], 1, 1);
TH1 = randi([10 TL1], 1, 1);
alpha1 = randi([0 100], 1, 1);

TL2 = randi([10 200], 1, 1);
TH2 = randi([10 TL2], 1, 1);
alpha2 = randi([0 100], 1, 1);

TL3 = randi([10 200], 1, 1);
TH3 = randi([10 TL3], 1, 1);
alpha3 = randi([0 100], 1, 1);

x = [TH1 TL1 alpha1 TH2 TL2 alpha2 TH3 TL3 alpha3];

end

