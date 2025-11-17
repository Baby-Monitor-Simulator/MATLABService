% Steady state values for Oxygen model
% SS-values are determined by the mean flows in SS-circulatory system
% Initial parameters for oxygen model
tic
SFm=        0.02;%0.2;           %[]
SFf=        0.02;%0.1;           %[]
Cm=         16e-2;        %[m3 gas/m3 blood] 0.12175; %is 40 mmHg bij moeder
Cfth=       6.8e-2;         %[m3 gas/m3 blood]
Cfbrth=     3.9e-2;         %[m3 gas/m3 blood]
dVfbrdt0=   0.12*21/60*1e-6;         %0.12*23.0/60*1e-6;%[m3 gas/s]
dVfdt0=     21.0/60*1e-6 -dVfbrdt0;   %[m3 gas/s]
D=          1.7/60*1e-6;   %(13*3/fackPaHg)(1.7)[(m3 gas/s)/mmHg O2] specific Dp according to Mayhew 1993 (bevestigd in review Mayhew 2006)
Ko=         5.6e-4/60;      %[m3 blood/s]
Hbm=        12e4;           %[g/m3]
Hbf=        17e4;           %[g/m3]
alfa=       1.34e-6;        %[m3 gas/g]
beta=       0.0031e-2;      %[(m3 gas/m3 blood)/mmHg O2]
tso=        dt*round(ftcycle(fcycle)/dt);           %[s] timestep in oxygen model
tom(ico)=   j*dt;
c1m=        10400;
c2m=        150;
c1f=        23400;
c2f=        150;

% SS flows
jsearch0=j;
jsearch1=round(jsearch0-mtcycle(icycle-2)/dt);

mqutven=mean(mqsav(sutmc,jsearch1:jsearch0))*1e-3;   %[m3 blood/s]

jsearch0=j;
jsearch1=round(jsearch0-ftcycle(fcycle-1)/dt);

mfqummc=mean(fqsav(summc,jsearch1:jsearch0))*1e-3;   %[m3 blood/s]
%mfqummc=mean(fqsav(sumv,jsearch1:jsearch0))*1e-3;   %[m3 blood/s]
mfqmc=mean(fqsav(sfp,jsearch1:jsearch0))*1e-3;   %[m3 blood/s]
mfqbr=mean(fqsav(sbrv,jsearch1:jsearch0))*1e-3;     %[m3 blood/s]

syms C1 C2 C3 C4 Cf Pf P1 P2 P3 P4 Pm

% Calculate Pm from Cm:
eq0=Cm == alfa*Hbm/(1+(23400/(Pm^3+150*Pm)))+beta*Pm;
solut=double(solve(eq0));
PmO2(ico)=solut(find(solut>0 & imag(solut)==0));

% Equations necessary to solve initial values
eq1 =(1-SFm)*mqutven*(Cm-C1) == D*(P1-P2);
eq2 =(1-SFf)*mfqummc*(Cf-C2) == -D*(P1-P2);
eq3 = mfqmc*(Cf-C3) == dVfdt0;
eq4 = mfqbr*(Cf-C4) == dVfbrdt0;
eq5 = Cf == (C4*mfqbr +C3*mfqmc +(1-SFf)*C2*mfqummc)/(mfqbr+mfqmc+(1-SFf)*mfqummc);
eq6 = Cf == alfa*Hbf/(1+(10400/(Pf^3+150*Pf)))+beta*Pf;
eq7 = C1 == alfa*Hbm/(1+(23400/(P1^3+150*P1)))+beta*P1;
eq8 = C2 == alfa*Hbf/(1+(10400/(P2^3+150*P2)))+beta*P2;
eq9 = C3 == alfa*Hbf/(1+(10400/(P3^3+150*P3)))+beta*P3;
eq10= C4 == alfa*Hbf/(1+(10400/(P4^3+150*P4)))+beta*P4;

if lamb==0
    Cutven(ico)  = 0.1294;
    Cummc(ico)   = 0.1766;
    Cfmc(ico)    = 0.0777;
    Cfa(ico)     = 0.0972;
    Cuma(ico)    = Cfa(ico);
    Cfbr(ico)    = 0.0783;
    Putven(ico)  = 43.6486;
    Pummc(ico)   = 31.1887;
    Pfmc(ico)    = 14.6486;
    PfO2(ico)    = 17.1866;
    Puma(ico)    = PfO2(ico);
    Pfbrmc(ico)  = 14.7276;
    disp('Initial oxygen values retrieved correctly')
    ox=1;
elseif lamb==1
    Cutven(ico)  = 0.1283;
    Cummc(ico)   = 0.1707;
    Cfmc(ico)    = 0.0866;
    Cfa(ico)     = 0.1157;
    Cfbr(ico)    = 0.0469;
    Putven(ico)  = 43.3034;
    Pummc(ico)   = 29.6170;
    Pfmc(ico)    = 15.8058;
    PfO2(ico)    = 19.7098;
    Pfbrmc(ico)  = 10.3824;
    disp('Initial oxygen values retrieved correctly')
    ox=1;
else
    % Solution of initial values
    A=solve(eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8,eq9,eq10);

    % Retrieve physiological initial values (delete neg or imag solutions)
    O=double([A.C1,A.C2,A.C3,A.Cf,A.C4,A.P1,A.P2,A.P3,A.Pf,A.P4]); 
    test=[]; for i=1:numel(A(:,1)); if isempty(nonzeros(imag(O(i,:))))==1; test=[test,i]; end; end
    test1=[]; for i=1:numel(test); if min(O(test(i),:))>0; test1=[test1,test(i)]; end; end
    O=O(test1,:);

    % Assign SS-values to arrays 
    % (due to 'sym' problems, an extra 'double' conversion is necessary)
    if size(O)==[1 10]
        O=double(O);
        Cutven(ico)  = O(1); Cutven  =double(Cutven);
        Cummc(ico)   = O(2); Cummc   =double(Cummc);
        Cfmc(ico)    = O(3); Cfmc    =double(Cfmc);
        Cfa(ico)     = O(4); Cfa     =double(Cfa);
        if umbilical==2; Cuma(ico)=Cfa(ico); end
        Cfbr(ico)    = O(5); Cfbr    =double(Cfbr);
        Putven(ico)  = O(6); Putven  =double(Putven);
        Pummc(ico)   = O(7); Pummc   =double(Pummc);
        Pfmc(ico)    = O(8); Pfmc    =double(Pfmc);
        PfO2(ico)    = O(9); PfO2    =double(PfO2);
        if umbilical==2; Puma(ico)=PfO2(ico); end
        Pfbrmc(ico)  = O(10);Pfbrmc  =double(Pfbrmc);
        disp('Initial oxygen values retrieved correctly')
        ox=1;
    elseif size(O)>[1 10]
        disp('There is not a unique solution for the initial oxygen values');
    else
        disp('There is no solution for the initial oxygen values');
    end
end

% Calculate volume derivatives from peak blood volume per heart beat
jsearch0=round(sum(mtcycle(1:mcycle-1))/dt);
jsearch1=round(jsearch0-mtcycle(mcycle-2)/dt);
jsearch2=round(jsearch1-mtcycle(mcycle-3)/dt);

% blood flows over last period
mqutven=mean(mqsav(sutmc,jsearch1:jsearch0))*1e-3;    %[m3 blood/s]
% blood volumes over last period
mVivs=mean(mVsav(nutmc,jsearch1:jsearch0))*1e-6;      %[m3 blood]

% maternal blood volume changes over last period (mean of previous minus mean
% of current past period)
dVivsdto=(max(mVsav(nutmc,jsearch2:jsearch1))-max(mVsav(nutmc,jsearch1:jsearch0)))*1e-6/(mtcycle(mcycle)*dt*1e-3);

jsearch0=j;
jsearch1=round(jsearch0-ftcycle(fcycle-1)/dt);
jsearch2=round(jsearch1-ftcycle(fcycle-2)/dt);

% fetal blood volume changes over last period (mean of previous minus mean
% of current past period)
if umbilical==1
    dfVummcdto=(max(fVsav(num,jsearch2:jsearch1))-max(fVsav(num,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);
elseif umbilical==2
    dfVumadto=(max(fVsav(numa,jsearch2:jsearch1))-max(fVsav(numa,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);
    dfVummcdto=(max(fVsav(numv,jsearch2:jsearch1))-max(fVsav(numv,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);
end
dfVmcdto=(max(fVsav(nfv,jsearch2:jsearch1))-max(fVsav(nfv,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);
dfVbrdt=(max(fVsav(nbr,jsearch2:jsearch1))-max(fVsav(nbr,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);

if umbilical==2
    mfquma=mean(fqsav(suma,jsearch1:jsearch0))*1e-3;  %[m3 blood/s]
end
mfqummc=mean(fqsav(sumv,jsearch1:jsearch0))*1e-3;  %[m3 blood/s]
mfqmc=mean(fqsav(sfp,jsearch1:jsearch0))*1e-3;    %[m3 blood/s]
mfqbr=mean(fqsav(sbrv,jsearch1:jsearch0))*1e-3;     %[m3 blood/s]
if mfqbr<5e-8; mfqbr=0; end

% blood volumes over last period
if umbilical==1
    mfVummc=mean(fVsav(num,jsearch1:jsearch0))*1e-6;  %[m3 blood]
elseif umbilical==2
    mfVuma=mean(fVsav(numa,jsearch1:jsearch0))*1e-6;  %[m3 blood]
    mfVummc=mean(fVsav(numv,jsearch1:jsearch0))*1e-6;  %[m3 blood]
end
mfVmc=mean(fVsav(nfv,jsearch1:jsearch0))*1e-6;    %[m3 blood]
mfVbr=mean(fVsav(nbr,jsearch1:jsearch0))*1e-6;     %[m3 blood]

fjmin = j-ncycleplot*floor(ftcycle/dt);

if umbilical==1
    a(:,ico)=[dVivsdto;dfVummcdto;dfVmcdto;dfVbrdt;mqutven;mfqummc;mfqmc;mfqbr;mVivs;mfVummc;mfVmc;mfVbr];
elseif umbilical==2
    a(:,ico)=[dVivsdto;dfVumadto;dfVummcdto;dfVmcdto;dfVbrdt;mqutven;mfquma;mfqummc;mfqmc;mfqbr;mVivs;mfVuma;mfVummc;mfVmc;mfVbr];
end

% Calculate volume derivatives from peak blood volume per heart beat
ico=ico+1;
toc