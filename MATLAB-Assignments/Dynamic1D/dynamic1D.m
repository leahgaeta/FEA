clear variables; 
close all;
format long;

% 1D dynamic FEM code.  Apply initial heaviside load with one end fixed.

% Global variables
%----------------------
global nn ne xn conn nquad h E rho A;

% User-defined parameters
%--------------------------
rho = .000724; % Density for steel?
E = 30e6;   % Young's modulus for steel?
A = 1;		% Cross sectional area

% Geometry parameters
xmin = 0;		% left end of domain
xmax = 100;	    % right end of domain
xplotmax = xmax;  % Plotting parameter
xplotmin = 0.0;        % Plotting parameter

% FEM description
ne = 20;				% number of finite elements between xmin and xmax
mid = ne/2;				% make sure this is an even number
nn = ne+1;				% number of nodes
h  = (xmax-xmin)/ne;	% nodal spacing
nquad = 2;				% number of integration points/cell
b = 0;                  % magnitude of constant body force
nsd = 1;                % number of space dimensions

% Timestep control
nts = 400;                      % # of timesteps for gaussian wave (140)  
Dt = 0.5*h/sqrt(E/rho);        % time step

% Plotting and output parameters
xminplot =  xplotmin;	% left boundary of plot
xmaxplot =  xplotmax;	% right boundary of plot
yminplot = -2e-3;	% bottom boundary of plot gaussian wave
ymaxplot =  2e-2;	% top boundary of plot
movieout = 0;		% number of time steps between movie outputs (40)
pause_time = 0.01;	% time to pause after each plot

% Define FEM mesh
[xn,conn] = makemesh(xmin,xmax,nn);		
BigK = zeros(nn,nn);    % Global stiffness matrix
M = zeros(nn,nn);       % Global mass matrix
fint = zeros(nn,1);       % Global internal force vector
fext = zeros(nn,1);     % Global external force vector
f = zeros(nn,1);        % Global total force vector
ifix = zeros(nn,1);     % Fixes
ifix(nn) = 1;

% Set quadrature rules
[wq,xq] = quadrature(nquad,'GAUSS',nsd);

% Calculate element stiff, assemble into global stiffness matrix
for i = 1:ne
    K = festiff(xq,wq);
    econn = conn(i,:);
    BigK(econn,econn) = BigK(econn,econn) + K;
end

% Create and assemble body force
for i = 1:ne
    fb = bodyforce(b,xq,wq);	% Initial FEM nodal forces
    econn = conn(i,:);
    fext(econn) = fext(econn) + fb;
end

% Assemble force vector (body + external)
fext(1) = ;  % Initial heaviside loading - ensure it stays a heaviside load throughout!

% Calculate element mass, assemble into global mass matrix - implement
for i = 1:ne
    Ma = femass(xq,wq);
    econn = conn(i,:);
    M() = ;
end

% Initialize FEM
dI = zeros(nn,1);
vI = zeros(nn,1);					% Initial FEM velocities
fint = ;        % Implement

% Implement f (total force = external - internal)
f = ;

aI = ;							% Initial FEM acceleration
count = 1;
out(count) = dI(mid); % Middle node (x=50) displacement
out2(count) = vI(mid):	% Middle node (x=50) velocity
time(count) = 0;
count = count + 1;

% Plot initial conditions
plot(xn,dI,'bs-'); 
axis([xminplot xmaxplot yminplot ymaxplot]);
hold off;
if (movieout ~= 0)
  mov = avifile('pulse.avi');
  mov.Fps = 5;
  framenum = getframe(gca)
  mov = addframe(mov,framenum)
end
pause(pause_time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin time step loop                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = 0;
for its = 1:nts
  
  % Finite element update via central difference time integration
  % I.e. update dI, vI and aI, along with boundary conditions at each time
  % step

  t = t + Dt;
  time(count) = t;
  out(count) = dI(mid);   
  out2(count) = vI(mid);
  count = count + 1;
  
  % plot
  plot(xn,dI,'bs-'); 
  axis([xminplot xmaxplot yminplot ymaxplot]);
  hold off;
  if (mod(its,movieout)==0)
    framenum = getframe(gca)
    mov = addframe(mov,framenum)
  end
  pause(pause_time);

end
figure (1)
plot(time,out);
xlabel('Time');ylabel('Displacement');

figure (2)
plot(time,out2);
xlabel('Time');ylabel('Velocity');