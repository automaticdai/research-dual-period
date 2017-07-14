close all

%% plot T^H
load('./result/stat_sym_50_100_50.mat')

figure()
subplot(1,2,1)
scatter(50:10:100, z_c(6,:), 'b^')
axis([50 100 0.8 3])
xlabel('T^H')
ylabel('P_c')

subplot(1,2,2)
scatter(50:10:100, z_u(6,:), 'r^')
axis([50 100 0.4 1])
xlabel('T^H')
ylabel('P_s')

%% plot T^L
load('./result/stat_sym_50_100_50.mat')

figure()
subplot(1,2,1)
scatter(50:10:100, z_c(:,1)', 'b^')
axis([50 100 0.8 3])
xlabel('T^L')
ylabel('P_c')

subplot(1,2,2)
scatter(50:10:100, z_u(:,1)', 'r^')
axis([50 100 0.4 1])
xlabel('T^L')
ylabel('P_s')

figure()
%% plot alpha
for i = 0:10:100
    data_filename = sprintf('./result/stat_sym_50_100_%d.mat', i);
    load(data_filename)
    
    subplot(1,2,1)
    scatter(i / 100.0, z_c(6, 1), 'b^')
    axis([0 1 0.8 3])
    xlabel('\alpha')
    ylabel('P_c')
    hold on;
    
    subplot(1,2,2)
    scatter(i / 100.0, z_u(6, 1), 'r^')
    axis([0 1 0.4 1])
    xlabel('\alpha')
    ylabel('P_c')
    hold on;
end
