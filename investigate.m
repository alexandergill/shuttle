% Script to investigate the effectiveness of the `shuttle` function
% with different parameters
%
% Adapted by Alexander Gill. 

i=0; 
nx = 11:10:41; 
thick = 0.05; 
tmax = 2000; 
nt = 41:100:1041;
xmax = 0.05;
% for nt = 41:20:1001 
%     i=i+1; 
%     dt(i) = tmax/(nt-1); 
%     % disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s']) 
%     [~, ~, u] = shuttle(tmax, nt, thick, nx, 'forward', false); 
%     uf(i) = u(end, 1); 
%     [~, ~, u] = shuttle(tmax, nt, thick, nx, 'backward', false); 
%     ub(i) = u(end, 1); 
%     [~, ~, u] = shuttle(tmax, nt, thick, nx, 'c', false);
%     uc(i) = u(end, 1);
%     [~, ~, u] = shuttle(tmax, nt, thick, nx, 'd', false);
%     ud(i) = u(end, 1);
% end 
% plot(dt, [uf; ub; uc; ud]) 
% ylim([0 200]) 
% legend ('Forward', 'Backward', 'Crank-nicolson', 'Dufort-frankel')
execTime = zeros(numel(nt), numel(nx));  % execution time
% uInterior = zeros(1, numel(nt)); % temperature in the interior
h = waitbar(0, 'working');
for i = 1:numel(nt);
    for j = 1:numel(nx);
        f = @() shuttle(tmax, nt(i), xmax, nx(j), 'forward', false);
        execTime(i, j) = timeit(f);
%         [~, ~, u] = f();
%         uInterior(i) = u(end, 1);
        waitbar(j/ numel(nx));
    end
end
close(h);
surf(execTime);
xlabel('nx');
ylabel('nt');
zlabel('execution time / s');
    