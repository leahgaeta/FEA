function dN = dNfem(x)
% 1D FEM shape function

global nn nelt xn conn h;

dN = [-.5 .5];    % Shape function derivatives in (-1,1) isoparametric parent domain
