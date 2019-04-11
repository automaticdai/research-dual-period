function [U_dot, U, alpha_dot] = eval_dual_utilization(T_H, T_L, alpha, T_Gamma, C_i)

    U_H = C_i / T_H;
    U_L = C_i / T_L;
    
    % ideal utilization
    U = alpha * U_H + (1 - alpha) * U_L;
    
    % determine the actual alpha
    T_s = alpha * T_Gamma;
    T_s_dot = ceil(T_s / T_H) * T_H;
    alpha_dot = T_s_dot / T_Gamma;
    
    % calculate utilization
    U_dot = alpha_dot * U_H + (1 - alpha_dot) * U_L;
end