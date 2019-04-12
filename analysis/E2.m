close all;
f=figure('Position', [100, 100, 450, 250]);

stage = input(1,:);
x = input(2,:);
y = input(3,:);
z = input(4,:);



plot(stage,x,'b-o',stage,y,'r-*',stage,z,'k-x')


xlim([1 11.5])
set(gca,'xtick',[ 1 2 3 4 5 6 7 8 9 10 11] );
set(gca,'xticklabel',{'0.10', '0.13', '0.16','0.19', '0.22', '0.25','0.28', '0.31', '0.34','0.37', '0.40'},'fontsize',14);

ylabel('Control Fitness','fontsize',14)
xlabel('Utilisation of Non-control Tasks','fontsize',14)

legend('DUAL-GA',  'DUAL-Rand','SINGLE');