close all
clear all

global k1 k2 t C11 C22 C1

% Import data to MatLab
% data van wat ook alweer??
%reacdata(:,1)=[0,15,30,45,60,75,90,105,120];
%reacdata(:,2)=[0,0.9,2,2.6,3,3.4,3.7,3.9,4];

% data van catecholamines
reacdata(:,1)=[3 4.1 4.2 4.5 6.3 6.8 7 8.4 8.8 8.8 8.8 9.3 10.9 10.9 12 14.2 14.8 16.8 17 17.2 17.2 18.1 18.5 18.5 19 19 19.7 21 21.1];
reacdata(:,2)=[47300 11900 43600 6800 9200 5100 1250 3400 3500 700 300 1400 700 500 800 200 0 250 500 250 0 0 0 250 100 600 100 250 0];

% data van toegenomen pO2 bij de moeder
% reacdata(:,1)=[0,15,30,60,120,240,300];
% reacdata(:,2)=[112,260,345,385,380,440,475];
t=reacdata(:,1);
C11=reacdata(:,2);

% Plot data to screen
figure(1); semilogy(reacdata(:,1),reacdata(:,2),'b*'); 


% Time at which C1 has been reduced approximately 37% is k1:
k1=1/reacdata(find(reacdata(:,2)<reacdata(1,2)/exp(1),1),1);

[kk]=lsqnonlin(@rrfunc,[k1]);

figure(1); hold on; semilogy(t,C1(:,1))