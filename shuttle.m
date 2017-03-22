function [x t u] = shuttle(tmax, nt, xmax, nx, method, doplot)
% Function for modelling temperature in a space shuttle tile
% D N Johnston  23/1/17
%
% Input arguments:
% tmax   - maximum time
% nt     - number of timesteps
% xmax   - total thickness
% nx     - number of spatial steps
% method - solution method ('forward', 'backward' etc)
% doplot - true to plot graph; false to suppress graph.
%
% Return arguments:
% x      - distance vector
% t      - time vector
% u      - temperature matrix
%
% For example, to perform a  simulation with 501 time steps
%   [x, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', true);
%

% Set tile properties
thermcon = 0.141; % W/(m K)
density  = 351; % 22 lb/ft^3
specheat = 1257; % ~0.3 Btu/lb/F at 500F


% Some crude data to get you started:
timedata = [0  60 250 500  1000 1250 1500 1750 2000 4000];
tempdata = [60 60 800 1500 1400 1000 830  0    60   60];

% Better to load surface temperature data from file.
% (you need to have modified and run plottemp.m to create the file first.)
% Uncomment the following line.
% load temp597.mat

% Initialise everything.
dt = tmax / (nt-1);
t = (0:nt-1)*dt;
dx = xmax/(nx-1);
x = (0:nx-1)*dx;
u = zeros(nt, nx);

alpha = thermcon /(density * specheat);
p = alpha * dt / dx^2;

% Vector of indices for internal points
ivec = 2:nx-1;

% set initial conditions to 60F throughout.
% Do this for first two timesteps.
u([1 2], :) = (60-32)*5/9;

% Main timestepping loop.
for n = 2:nt - 1
    
    % LHS boundary condition: inner surface
    L = 0;
    
    % RHS boundary condition: outer surface
    R = surftemp(t(n+1), timedata, tempdata);
    
    % Select method.
    switch method
        case 'forward'
            % LHS Dirichlet boundary condition; need to change this.
            u(n+1, 1) = L;
            % Internal points
            u(n+1, ivec) = (1 - 2 * p) * u(n, ivec) + ...
                p * (u(n, ivec-1) + u(n, ivec+1));
            % RHS Dirichlet boundary condition
            u(n+1, nx) = R;
            
        case 'dufort-frankel'

        otherwise
            error (['Undefined method: ' method])
            return
    end
end

if doplot
    % Surface plot - you need to add labels etc.
    figure (1)
    surf(x, t, u);
    shading interp
end
% End of shuttle function

% =========================================================================
function tempC = surftemp(t, timedata, tempdata)
% Do linear interpolation to get temperature at time t in degrees F.
tempF = interp1(timedata, tempdata, t, 'linear', 'extrap');

% Convert to degrees C
tempC = (tempF - 32) * 5 / 9;

% =========================================================================
% Tri-diagonal matrix solution 
function x = tdm(a,b,c,d)
n = length(d);

% Eliminate a terms
for i = 2:n
    factor = a(i) / b(i-1);
    b(i) = b(i) - factor * c(i-1);
    d(i) = d(i) - factor * d(i-1);
end

x(n) = d(n) / b(n);

% Loop backwards to find other x values by back-substitution
for i = n-1:-1:1
    x(i) = (d(i) - c(i) * x(i+1)) / b(i);
end
% =========================================================================

    