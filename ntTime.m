% script to plot the effect nt has on execution times of the shuttle
% function.

% clear relevant variables without clearing whole workspace
clear nt dt uc f xtntTime;
i=0;
nx = 21;
thick = 0.05;
tmax = 4000;

% try each value of nt
for nt = 41:20:1001
    i=i+1;
    dt(i) = tmax/(nt-1);
    disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s'])
    f = @() shuttle(tmax, nt, thick, nx, 'c', false);
    % time execution
    time(i) = timeit(f);
end

% plot results as a graph
plot(dt, time)
xlabel('dt');
ylabel('Execution time / s');
