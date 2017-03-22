% Script to plot image of measured temperature, and trace it using the mouse.
%
% Image from http://www.columbiassacrifice.com/techdocs/techreprts/AIAA_2001-0352.pdf
% Now available at 
% http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.26.1075&rep=rep1&type=pdf
%
% D N Johnston 23/01/17

name = 'temp597';
img=imread([name '.jpg']);

figure (4);
image(img);
hold on
% You can adapt the following code to enter data interactively or automatically.

timedata = [];
tempdata = [];

axes = zeros(2,2);

fprintf('Click at the end of each axis.\n');

% get position of axes
for i = 1:2 % take two points
    [x, y, button] = ginput(1); % get one pooint using mouse
    plot(x, y, 'xr') % plot red cross
    
    axes(i,1) = x;
    axes(i,2) = y;
end

% ignore the order the user clicked in
axes = sortrows(axes, 1)

x0 = axes(1,1);
xmax = axes(2,1);
y0 = axes(2,2);
ymax = axes(1,2);

% plot the origin
plot(x0, y0, 'xb');

% map input points to actual points using y=mx+c
% % x coordinates
m = 2000 / (xmax - x0);
c = x0 * (1 - m);

% % y coordinates
n = 2000 / (ymax - y0);
d = y0 * (1 - n);

while 1 % infinite loop
    [x, y, button] = ginput(1); % get one point using mouse
    if button ~= 1 % break if anything except the left mouse button is pressed
        break
    end
    plot(x, y, 'og') % 'og' means plot a green circle.
    
    % Add data point to vectors. Note that x and y are pixel coordinates.
    % You need to locate the pixel coordinates of the axes, interactively
    % or otherwise, and scale the values into time (s) and temperature (F, C or K).
    timedata = [timedata, x];
    tempdata = [tempdata, y];
end
hold off

% sort data and remove duplicate points.
[timedata, index] = unique(timedata);
tempdata = tempdata(index);

% apply mapping
timedata = m * timedata + c;
tempdata = n * tempdata + d;

% save data to .mat file with same name as image file
save(name, 'timedata', 'tempdata')

% plot saved data for user's inspection
plot(timedata, tempdata)

