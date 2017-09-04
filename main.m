close all; clc; clear;


%% compile kernel (mex)
mex -g kernel.cpp


%% Define System Dynamics Model
% -40+80i, rising time 20ms
% sampling time 2ms
sys_zpk = zpk([], [-40+20i, -40-20i], [200]);
sys = tf(sys_zpk);


%% Parameters
alpha = 50;
h_h   = 50;
h_l   = 50;
i     = 0;
learning_rate = 20;
offset = 0.05;
limit_delta = 5;
PI_p = 0;

while 1
    open('afbs_control.slx');
    model_obj = get_param(bdroot,'Object');
    model_obj.refreshModelBlocks

    %% load and run simulation
    sim('afbs_control.slx');

    %% plot system response
%     f = figure();
%     plot(simout_y.time, simout_y.data);
%     legend('Task 0 (*)', 'Task 1', 'Task 2');
%     xlabel('t')
%     ylabel('y(t)')

    %% calculate utilization
    u0 = sum(simout_schedule.data==0);
    u1 = sum(simout_schedule.data==1);
    u2 = sum(simout_schedule.data==2);
    u3 = sum(simout_schedule.data==3);
    u = u0 + u1 + u2 + u3;

    %% plot period variations

    %% Control performance output
    % T = Th: 1.8943
    % T = Tl: 3.7609
    Q1  = 10;
    Q12 = 0.1;
    Q2  = 1;

    x = simout_y.data(:,1);
    u = simout_u.data(:,1);
    Pc = (x' * Q1 * x + 2 * x' * Q12 * u + u' * Q2 * u) * 0.0001 %(kernel = 0.1ms)
    Ps = u0
    %sum((1 - simout_y.data(:,1)) .^2) / 109.7535
    %u0 / 6001
    
    % plot
    subplot(2,1,1)
    scatter(i, 1/Pc, 'r');
    xlabel('iteration');
    ylabel('PI');
    hold on;
    
    subplot(2,1,2)
    scatter(i, h_l, 'b');
    hold on;
    
    % adaptation
    PI = Pc;
    
    if (PI_p ~= 0)
        delta = PI - PI_p;
        delta = learning_rate * (delta + offset);
        
        if (delta > limit_delta)
            delta = limit_delta;
        end
        
        if (delta < -limit_delta)
            delta = -limit_delta;
        end
        
        h_l = h_l + delta;
    else
        h_l = h_l + 5;
    end
    
    PI_p = PI;
    
    i = i + 1;
    if (i > 80)
        break;
    end
end


