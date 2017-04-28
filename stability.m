% Script to investigate the stability and accuracy of different 
% time steps with different methods
clear i nx thick tmax nt dt uf ub uc ud;
i=0;
nx = 21;
thick = 0.05;
tmax = 4000;
for nt = 41:20:1001
    i=i+1;
    dt(i) = tmax/(nt-1);
    disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s'])
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'f', false);
    uf(i) = u(end, 1);
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'b', false);
    ub(i) = u(end, 1);
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'c', false);
    uc(i) = u(end, 1);
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'd', false);
    ud(i) = u(end, 1);
end
plot(dt, [uf; ub; uc; ud])
ylim([0 400])
legend ('Forward', 'Backward', 'Crank', 'Dufort')
xlabel('dt');
ylabel('Final temperature / C');
