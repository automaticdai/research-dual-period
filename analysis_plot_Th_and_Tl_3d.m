load('./result/stat_sym_50_100_50.mat')

[h_h_a, h_l_a] = meshgrid(50:5:100, 50:5:100);

figure()
surf(h_h_a, h_l_a, z_c)

figure()
surf(h_h_a, h_l_a, z_u)


