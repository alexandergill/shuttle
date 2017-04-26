% Script to investigate the effect that nx and nt has on execution time
%
% Adapted by Alexander Gill. 

% initialise everything
i=0; 
nx = 11:5:61; 
thick = 0.05; 
tmax = 2000; 
nt = 41:20:1041;
xmax = 0.05;

% execution time matrix (2d)
xTime = zeros(numel(nt), numel(nx));

% keep the user updated
h = waitbar(0, 'working', 'Position', [100 100 300 100]);
for i = 1:numel(nt);
    h2 = waitbar(0, 'calculating execution times', 'Position', [400 100 300 100]);
    for j = 1:numel(nx);
        f = @() shuttle(tmax, nt(i), xmax, nx(j), 'forward', false);
        xTime(i, j) = timeit(f);
        waitbar(j / numel(nx), h2);
    end
    close(h2);
    waitbar(i/ numel(nt), h);
end
close(h);
surf(xTime);
xlabel('nx');
ylabel('nt');
zlabel('execution time / s');
