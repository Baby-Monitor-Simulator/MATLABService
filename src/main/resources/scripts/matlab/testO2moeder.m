close all
global k1 k2 t C11 C22 C0
 
% Import data to MatLab
reacdata(:,1)=[0,15,30,60,120,240,300];
reacdata(:,2)=[2400,1850,1150,950,710,650,605];
reacdata(:,3)=[112,260,345,385,380,440,475];
t=reacdata(:,1);
C11=reacdata(:,2);
C22=reacdata(:,3); 
 
% Plot data to screen
figure(1); plot(reacdata(:,1),reacdata(:,2),'b*'); 
hold on; plot(reacdata(:,1),reacdata(:,3),'ro');
xlabel('Time')
ylabel('Concentration')
 
% Time at which C1 has been reduced approximately 37% is k1:
k1=1/reacdata(find(reacdata(:,2)<reacdata(1,2)/exp(1),1),1);
 
% Arbitrary k2:
k2=0.25*k1;
 
% Solve data for arbitrary k's
[kk]=lsqnonlin(@rrfunc,[k1,k2]);
%[t0,C0]=ode45(@rr,t',[2400,112]); 
 
% Plot solution for arbitrary k's
figure(1); plot(t,C0(:,1),'--'); hold on; plot(t,C0(:,2),'r--')
legend('data r1','data r2','sol for k1','sol for k2')
pause
