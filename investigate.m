i=0; 
nx = 21; 
thick = 0.05; 
tmax = 4000; 
for nt = 41:20:1001 
    i=i+1; 
    dt(i) = tmax/(nt-1); 
    % disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s']) 
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'forward', false); 
    uf(i) = u(end, 1); 
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'backward', false); 
    ub(i) = u(end, 1); 
end 
plot(dt, [uf; ub]) 
ylim([0 200]) 
legend ('Forward', 'Backward')