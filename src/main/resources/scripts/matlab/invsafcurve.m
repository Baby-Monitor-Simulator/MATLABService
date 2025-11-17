clear all
close all
global k1 k2 k3 t C11 C1
 
% Import data to MatLab
reacdata(:,1)=[1:0.1:85]';
reacdata(:,2)=(1./(1+2.34e4./(reacdata(:,1).^3+150*reacdata(:,1))));
reacdata(:,3)=0.385*log((reacdata(:,2).^-1-1).^-1)+3.32-(72*reacdata(:,2)).^-1-(reacdata(:,2).^6)./6;
t=reacdata(:,1);
C11=reacdata(:,2);
 
% Plot data to screen
figure(1); plot(reacdata(:,1),reacdata(:,2),'b*'); 
%hold on; plot(reacdata(:,2),reacdata(:,3),'r'); 

xlabel('pO2')
ylabel('sO')

% Time at which C1 has been reduced approximately 37% is k1:
k1=0.4;%0.385;
k2=3.4;%3.32;
k3=70;%72;
 
% Solve data for arbitrary k's
[kk]=lsqnonlin(@rrfunc,[k1,k2,k3]);
%[t0,C0]=ode45(@rr,t',[2400,112]); 
 
% Plot solution for arbitrary k's
figure(1); plot(C1(:,1),C11,'--');
legend('data r1','sol for r1')

