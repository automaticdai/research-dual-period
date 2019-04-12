% load datasets
load('./result/exp_1_2_dual_alpha_0.5.mat')
load('./result/exp_1_2_single_alpha_0.5.mat')

boxplot(1 - results(:,8), results(:,1));

hold on 

scatter(results_single(:,1), 1 - results_single(:,3), 'kd');
line(results_single(:,1), 1 - results_single(:,3), 'Color', 'magenta')

set(gca,'xticklabel', results_single(:,2) / 10.0,'fontsize',10)
xlabel('Control Task Period (ms)','fontsize',10)
ylabel('Control Fitness','fontsize',10)