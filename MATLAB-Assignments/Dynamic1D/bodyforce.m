% Subroutine to generate element body force

function f = bodyforce(b,xq,wq)
global nn ne xn conn nquad h E A;

f = zeros(2,1);
Jac = h/2;                     % Jacobian
for i = 1:length(xq)
    f = f + Nfem(xq(i))' * b * A * wq(i) * Jac;
end