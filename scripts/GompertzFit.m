close all
global k1 k2 k3 k4 t C11 C1
 
% Import data to MatLab
t=cO;
C11=q;
 


% Time at which C1 has been reduced approximately 37% is k1:
k1=100;%0.385;
k2=550;%3.32;
k3=-20;%72;
k4=-0.5;
C1=k2-(k2-k1).*exp(k3.*exp(k4.*t));

% Plot data to screen
figure(1); plot(cO,q,'b*',cO,C1,'r--'); 

xlabel('cO2')
ylabel('qbr')

% Solve data for arbitrary k's
[kk]=lsqnonlin(@rrfunc,[k1,k3,k4]);
%[t0,C0]=ode45(@rr,t',[2400,112]); 
 
% Plot solution for arbitrary k's
figure(2); plot(t,C11,'ro',t,C1,'--');
legend('data r1','sol for r1')


