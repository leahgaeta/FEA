function N = Nfem(x)
% 1D FEM shape function in parent (psi) domain

global nn ne xn conn h;

N = [.5*(1-x) .5*(1+x)];    % FEM linear shape functions in 1D isoparametric parent domain
