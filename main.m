close all; clc; clear;


%% compile kernel (mex)
mex -g kernel.cpp


%% Define System Dynamics Model
% -40+80i, rising time 20ms
% sampling time 2ms
sys_zpk = zpk([], [-400+80i, -400-80i], [10000]);
sys = tf(sys_zpk);


%% Parameters
alpha = 99;
h_h = 100;
h_l = 200;

model_obj = get_param(bdroot,'Object');
model_obj.refreshModelBlocks


%% load and run simulation
sim('afbs_control.slx');


%% plot system response
f = figure();
plot(simout_y.time, simout_y.data);
legend('Task 0 (*)', 'Task 1', 'Task 2');


%% plot cpu schedule
f = figure();
%plot_scheduling(simout_schedule.data);


%% calculate utilization
u0 = sum(simout_schedule.data==0);
u1 = sum(simout_schedule.data==1);
u2 = sum(simout_schedule.data==2);
u3 = sum(simout_schedule.data==3);
u = u0 + u1 + u2 + u3;

f = figure();
barh([0 1 2 3],[u0/u; u1/u; u2/u; u3/u]);
a = gca;
a.YTick = ([0 1 2 3]);
a.YTickLabel = ({'Task 0 (*)','Task 1 (T_h)','Task 2 (T_l)', 'IDLE'});


%% plot period adapation
f = figure();
plot(simout_periods.data);


%% Save to PDF (optional)
h = gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
%print(gcf, '-dpdf', 'test.pdf');


%% output
sum((1 - simout_y.data(:,1)) .^2) / 990.7848
u0 / 6001