function [] = test(method)

if nargin == 0
    method = 'forward';
end

shuttle(4000, 501, 0.05, 21, method, 'true');