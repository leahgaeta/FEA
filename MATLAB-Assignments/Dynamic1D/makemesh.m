function [xn,conn] = makemesh(xmin,xmax,nn)

xn = linspace(xmin,xmax,nn);
nelt = nn-1;

for i = 1:nelt
  conn(i,1) = i;
  conn(i,2) = i+1;
end

h = (xmin-xmax)/nelt;
