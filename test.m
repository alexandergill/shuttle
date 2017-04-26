% function to test the `shuttle` function with sane defaults. Saves
% typing in the same parameters every time.
% Created by Alexander Gill
function test(method)

if nargin == 0
    method = 'forward';
end

shuttle(2000, 501, 0.05, 21, method, 'true');
