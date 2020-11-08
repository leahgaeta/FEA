% Calculate element stiffness matrix

function K = festiff(xq,wq)

global nn ne xn conn nquad h rho E A;

K = zeros(2,2);

iJac = 2/h;                      % Inverse jacobian

for iq = 1:nquad
    K = K + A * E * dNfem(xq(iq))' * dNfem(xq(iq)) * wq(iq) * iJac;
end