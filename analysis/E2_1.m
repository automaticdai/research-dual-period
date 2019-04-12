close all;
f=figure('Position', [100, 100, 450, 250]);

stage = sample_even(input(1,:));


subplot(2,1,1)
x = sample_even(input(2,:));
y = sample_even(input(3,:));
plot(stage,x,'b-o',stage,y,'r-x')

ylabel('Control Fitness','fontsize',12)
xlabel('# of Iterations with U = 0.19 ','fontsize',12)
legend('DUAL-GA','DUAL-rand');



subplot(2,1,2)
z = sample_even(input(4,:));
k = sample_even(input(5,:));
plot(stage,z,'b-o',stage,k,'r-x')

ylabel('Control Fitness','fontsize',12)
xlabel('# of Iterations with U = 0.31','fontsize',12)




% ylim([0.6 1.5])
% xlim([1 50.1])

% x = [10 20 30 40 50 60];
% 
% set(gca,'xtick',x );
% set(gca,'XTickLabel',x,'fontsize',12)


% set(gca,'xtick',stage );
% set(gca,'xticklabel',{'0.10', '0.13', '0.16','0.19', '0.22', '0.25','0.28', '0.31', '0.34','0.37', '0.40'});

