% disturbance modelling
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
h_l   = 100;


open('afbs_control.slx');
model_obj = get_param(bdroot,'Object');
model_obj.refreshModelBlocks


%% load and run simulation
sim('afbs_control.slx');


%% plot system response
f = figure();
plot(simout_y.time, simout_y.data);
legend('Task 0 (*)', 'Task 1', 'Task 2');
xlabel('t')
ylabel('y(t)')

%% plot cpu schedule
f = figure();
h_plot_scheduling(simout_schedule.data);


%% calculate utilization
u0 = sum(simout_schedule.data==0);
u1 = sum(simout_schedule.data==1);
u2 = sum(simout_schedule.data==2);
u3 = sum(simout_schedule.data==3);
u = u0 + u1 + u2 + u3;

f = figure();
barh([0 1 2 3],[u3/u; u2/u; u1/u; u0/u]);
a = gca;
a.YTick = ([0 1 2 3]);
a.YTickLabel = ({'Task 3 (IDLE)', 'Task 2 (T = T^L)','Task 1 (T = T^H)', 'Task 0 (DUAL)'});
xlabel('utilization')

%% plot period variations
f = figure();
plot(simout_periods.data);


%% Save to PDF (optional)
h = gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
%print(gcf, '-dpdf', 'test.pdf');


%% Control performance output
% T = Th: 1.8943
% T = Tl: 3.7609
Q1  = 1;
Q12 = 0.1;
Q2  = 0.01;

x = simout_y.data(:,1);
u = simout_u.data(:,1);
Pc = (x' * Q1 * x + 2 * x' * Q12 * u + u' * Q2 * u) * 0.0001 %(kernel = 0.1ms)
Ps = u0
%sum((1 - simout_y.data(:,1)) .^2) / 109.7535
%u0 / 6001