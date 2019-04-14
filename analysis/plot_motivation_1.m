% load single
load("motivation_single.mat")
u1 = u;
y1 = y;

% load dual
load("motivation_dual_new.mat")
u2 = u;
y2 = y;



% plot system response
subplot(2,1,1)
plot(t,y1, 'LineWidth', 1.3)
hold on
plot(t,y2, 'LineWidth', 1.3)

xlim([0 0.6])
ylabel("y(t)",'FontSize',12)
title("System Response",'FontSize',12)

legend("Single", "Dual")


% plot control inputs
subplot(2,1,2)
plot(t,u1, 'LineWidth', 1.3)
hold on
plot(t,u2, 'LineWidth', 1.3)

xlim([0 0.6])
ylabel("u(t)",'FontSize',12)
title("Control Efforts",'FontSize',12)
xlabel("Time (seconds)",'FontSize',12)

