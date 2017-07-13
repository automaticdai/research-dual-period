
close all;

figure
hold on;
grid on;

% Compile kernel
%mex -g kernel.cpp

% cost
P_c0 = 109.7535;
P_s0 = 1;

% system model
sys_zpk = zpk([], [-40+20i, -40-20i], [200]);
sys = tf(sys_zpk);

% meshgrid
[h_h_a, h_l_a] = meshgrid(50:5:100, 50:5:100);

z_c = zeros(size(h_h_a));
z_u = zeros(size(h_h_a));


%%
for alpha = 0:5:100
    for j = 1:size(h_h_a,1)
        for i = 1:size(h_h_a,1)
            h_h = h_h_a(i,j); 
            h_l = h_l_a(i,j);
            disp([h_h, h_l, alpha])

            %load_system('afbs_control')
            %set_param('afbs_control', 'SimulationCommand','update')
            %Simulink.BlockDiagram.getSampleTimes('afbs_control');
            %set_param('afbs_control/A-FBS Kernel/AFBS Kernel', 'S-function parameters', alpha)

            sim('afbs_control.slx');

            c_factor = sum((1 - simout_y.data(:,1)) .^2) / P_c0;

            u0 = sum(simout_schedule.data==0);
            u1 = sum(simout_schedule.data==1);
            u2 = sum(simout_schedule.data==2);
            u3 = sum(simout_schedule.data==3);
            u = u0 + u1 + u2 + u3;

            u_factor = u0 / u;

            z_c(i,j) = c_factor;
            z_u(i,j) = u_factor;

            %f = figure();
            %plot(simout_y.time, simout_y.data);
            %legend('Task 0 (*)', 'Task 1', 'Task 2');
        end
    end

    data_filename = sprintf('./result/stat_sym_50_100_%d.mat', alpha);
    save(data_filename, 'z_c', 'z_u');
end