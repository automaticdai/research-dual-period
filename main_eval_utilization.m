T_H = 100;
T_L = 200;
T_Gamma = 10000;
C_i = 50;

granularity = 10000;

t = [];
U_a = [];
U_dot_a = [];

for i = 1:granularity
    alpha = i / granularity;
    [U_dot, U, alpha_dot] = eval_dual_utilization(T_H, T_L, i / granularity, T_Gamma, C_i);
    t = [t alpha];
    
    U_a = [U_a, U];
    U_dot_a = [U_dot_a, U_dot];
end


plot(t, U_a)
hold on;
plot(t, U_dot_a)


