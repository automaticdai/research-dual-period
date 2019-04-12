close all;
f=figure('Position', [100, 100, 450, 250]);

stage = input(1,:);
x = input(2,:);
y = input(3,:);
z = input(4,:);
k = input(5,:);



plot(stage,x,'b-o',stage,y,'b-x',stage,z,'r-o',stage,k,'r-x')

ylim([0.5 1.5])
xlim([1 50.1])

x = [10 20 30 40 50 60];

set(gca,'xtick',x );
set(gca,'XTickLabel',x,'fontsize',12)


% set(gca,'xtick',stage );
% set(gca,'xticklabel',{'0.10', '0.13', '0.16','0.19', '0.22', '0.25','0.28', '0.31', '0.34','0.37', '0.40'});

ylabel('Control Fitness','fontsize',12)
xlabel('# of Iterations','fontsize',12)

legend('DUAL-GA best',  'DUAL-GA mean','DUAL-rand best','DUAL-rand mean');