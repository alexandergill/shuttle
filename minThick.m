function [ thickness ] = minThick( maxTemp, plot )
%MINTHICK Function to find the minimum thickness for a desired maximum 
%temperature
%   uses the shooting method to find a tile thickness to deliver
%   a desired maximum interior temperature

% tollerance below maxTemp, in Celcius
% avoids ridiculously thick tiles
tol = 5;

% everything else
nx = 21; 
tmax = 4000; 
nt = 501;
method = 'forward';

% first arbitrary guess
g(1,1) = 0.05;
[~, ~, u] = shuttle(tmax, nt, g(1,1), nx, method, false); 
g(2,1) = max(u(:,1));

% second arbitrary guess
g(1,2) = 0.1;
[~, ~, u] = shuttle(tmax, nt, g(2,1), nx, method, false); 
g(2,2) = max(u(:,1));

n = 3;
while g(2, end) > maxTemp || g(2, end) < (maxTemp - tol)
    % y = mx + c
    % work out the gradient of the last two guesses
    m = (g(2, n-2) - g(2, n-1)) / (g(1,n-2) - g(1,n-1));
    
    % find c from the last point
    c = g(2, n-1) - m * g(1, n-1);
    
    % aiming for maxTemp
    g(1, n) = (maxTemp - c) / m;
    
    [~, ~, u] = shuttle(tmax, nt, g(1,n), nx, method, false);
    g(2, n) = max(u(:,1));
    
    n = n + 1;
end

thickness = g(1, end);

% plot if asked to
if nargin == 2 && plot
    shuttle(tmax, nt, g(1,end), nx, method, true);
end

end
