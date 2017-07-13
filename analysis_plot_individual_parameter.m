

%% plot T^H
load('./result/stat_sym_50_100_50.mat')

subplot(3,2,1)
scatter(50:5:100, z_c(1,:), 'b')

subplot(3,2,2)
scatter(50:5:100, z_u(1,:), 'r')

%% plot T^L
load('./result/stat_sym_50_100_50.mat')

subplot(3,2,3)
scatter(50:5:100, z_c(:,1)', 'b')

subplot(3,2,4)
scatter(50:5:100, z_u(:,1)', 'r')

%% plot alpha
for i = 0:5:100
    data_filename = sprintf('./result/stat_sym_50_100_%d.mat', i);
    load(data_filename)
    subplot(3,2,5)
    scatter(i / 100.0, z_c(11,1), 'b')
    hold on;
    subplot(3,2,6)
    scatter(i / 100.0, z_u(11,1), 'r')
    hold on;
end
