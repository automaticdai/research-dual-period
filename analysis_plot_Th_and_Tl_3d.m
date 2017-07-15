load('./result/stat_sym_50_100_50.mat')

[h_h_a, h_l_a] = meshgrid(50:10:100, 50:10:100);

figure()
surf(h_h_a, h_l_a, z_c)
xlabel('T^H')
ylabel('T^L')
zlabel('P_c')

figure()
surf(h_h_a, h_l_a, z_u)
xlabel('T^H')
ylabel('T^L')
zlabel('P_s')


