% Steady state values for Oxygen model
% SS-values are determined by the mean flows in SS-circulatory system
% Initial parameters for oxygen model
tic
SFm=        0.02;%0.2;           %[]
SFf=        0.02;%0.1;           %[]
Cm=         16e-2;        %[m3 gas/m3 blood] 0.12175; %is 40 mmHg bij moeder
Cfth=       6.8e-2;         %[m3 gas/m3 blood]
Cfbrth=     3.9e-2;         %[m3 gas/m3 blood]
cOmetbr=   0.12*21/60*1e-6;         %0.12*23.0/60*1e-6;%[m3 gas/s]
cOmetsys0=  21.0/60*1e-6 -cOmetbr;   %[m3 gas/s]
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
eq0=[num2str(Cm) '=' num2str(alfa) '*' num2str(Hbm) '/(1+(23400/(Pm^3+150*Pm)))+' num2str(beta) '*Pm'];
solut=double(solve(eq0));
PmO2(ico)=solut(find(solut>0 & imag(solut)==0));

% Equations necessary to solve initial values
eq1 =['(1-' num2str(SFm) ')*(' num2str(mqutven) ')*(' num2str(Cm) '-C1)=' num2str(D) '*(P1-P2)'];
eq2 =['(1-' num2str(SFf) ')*(' num2str(mfqummc) ')*(Cf-C2)=-' num2str(D) '*(P1-P2)'];
eq3 =[num2str(mfqmc) '*(Cf-C3)=' num2str(dVfdt0)];
eq4 =[num2str(mfqbr) '*(Cf-C4)=' num2str(dVfbrdt0)];
eq5 =['Cf=(C4*' num2str(mfqbr) '+C3*' num2str(mfqmc) '+(1-' num2str(SFf) ')*C2*' num2str(mfqummc) ')/(' num2str(mfqbr) '+' num2str(mfqmc) '+(1-' num2str(SFf) ')*' num2str(mfqummc) ')'];
eq6 =['Cf=' num2str(alfa) '*' num2str(Hbf) '/(1+(10400/(Pf^3+150*Pf)))+' num2str(beta) '*Pf'];
eq7 =['C1=' num2str(alfa) '*' num2str(Hbm) '/(1+(23400/(P1^3+150*P1)))+' num2str(beta) '*P1'];
eq8 =['C2=' num2str(alfa) '*' num2str(Hbf) '/(1+(10400/(P2^3+150*P2)))+' num2str(beta) '*P2'];
eq9 =['C3=' num2str(alfa) '*' num2str(Hbf) '/(1+(10400/(P3^3+150*P3)))+' num2str(beta) '*P3'];
eq10=['C4=' num2str(alfa) '*' num2str(Hbf) '/(1+(10400/(P4^3+150*P4)))+' num2str(beta) '*P4'];

if lamb==0
    cO(1)   = 0.16;
    cO(3)   = 0.1294;
    cO(4)   = 0.1766;
    cO(7)   = 0.0777;
    cO(2)   = 0.0972;
    cO(6)   = cO(2);
    cO(5)   = 0.0783;
    pO(1)   = samcurve(cO(1));
    pO(3)   = 43.6486;
    pO(4)   = 31.1887;
    pO(7)   = 14.6486;
    pO(2)   = 17.1866;
    pO(6)   = pO(2);
    pO(5)   = 14.7276;
    disp('Initial oxygen values retrieved correctly')
    ox=1;
elseif lamb==1
    cO(1)   = 0.16;
    cO(3)   = 0.1283;
    cO(4)   = 0.1707;
    cO(7)   = 0.0866;
    cO(2)   = 0.1157;
    cO(6)   = cO(2);
    cO(5)   = 0.0469;
    pO(1)   = samcurve(cO(1));
    pO(3)   = 43.3034;
    pO(4)   = 29.6170;
    pO(7)   = 15.8058;
    pO(2)   = 19.7098;
    pO(6)   = pO(2);
    pO(5)   = 10.3824;
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
        cO(1)    = 0.16;
        cO(3)    = O(1); 
        cO(4)    = O(2); 
        cO(7)    = O(3); 
        cO(2)    = O(4); 
        cO(6)    = cO(2); 
        cO(5)    = O(5); 
        pO(1)    = samcurve(cO(1));
        pO(3)    = O(6); 
        pO(4)    = O(7); 
        pO(7)    = O(8); 
        pO(2)    = O(9); 
        pO(2)    = pO(2); 
        pO(5)    = O(10);
        disp('Initial oxygen values retrieved correctly')
        ox=1;
    elseif size(O)>[1 10]
        disp('There is not a unique solution for the initial oxygen values');
    else
        disp('There is no solution for the initial oxygen values');
    end
end

%% Calculate volume derivatives from peak blood volume per heart beat in mother
jsearch0=round(sum(mtcycle(1:mcycle-1))/dt);
jsearch1=round(jsearch0-mtcycle(mcycle-2)/dt);
jsearch2=round(jsearch1-mtcycle(mcycle-3)/dt);

% Maternal
qmean(1)=0;
qmean(3)=mean(mqsav(sutmc,jsearch1:jsearch0))*1e-3;    %[m3 blood/s]
Vmean(1)=0;
Vmean(3)=0.35*mean(mVsav(nutmc,jsearch1:jsearch0))*1e-6;      %[m3 blood]
dVmeandt(1)=0;
dVmeandt(3)=0.35*(max(mVsav(nutmc,jsearch2:jsearch1))-max(mVsav(nutmc,jsearch1:jsearch0)))*1e-6/(mtcycle(mcycle)*dt*1e-3);

%% Calculate volume derivatives from peak blood volume per heart beat in fetus
jsearch0=j;
jsearch1=round(jsearch0-ftcycle(fcycle-1)/dt);
jsearch2=round(jsearch1-ftcycle(fcycle-2)/dt);

% Fetal

dVmeandt(2)=(max(sum(fVsav(nflv:nfa,jsearch2:jsearch1)))-max(sum(fVsav(nflv:nfa,jsearch2:jsearch1))))*1e-6/(ftcycle(fcycle)*dt*1e-3);
dVmeandt(4)=(max(fVsav(numv,jsearch2:jsearch1))-max(fVsav(numv,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);
dVmeandt(5)=(max(fVsav(nbr,jsearch2:jsearch1))-max(fVsav(nbr,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);
dVmeandt(6)=(max(fVsav(numa,jsearch2:jsearch1))-max(fVsav(numa,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);
dVmeandt(7)=(max(fVsav(nfv,jsearch2:jsearch1))-max(fVsav(nfv,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);

qmean(2)=0;
qmean(4)=mean(fqsav(sumv,jsearch1:jsearch0))*1e-3;  %[m3 blood/s]
qmean(5)=mean(fqsav(sbrv,jsearch1:jsearch0))*1e-3; if qmean(5)<5e-8; qmean(5)=0; end
qmean(6)=mean(fqsav(suma,jsearch1:jsearch0))*1e-3;  %[m3 blood/s]
qmean(7)=mean(fqsav(sfp,jsearch1:jsearch0))*1e-3;    %[m3 blood/s]

Vmean(2)=mean(sum(fVsav(nflv:nfa,jsearch1:jsearch0)))*1e-6;     %[m3 blood]
Vmean(4)=mean(fVsav(numv,jsearch1:jsearch0))*1e-6;  %[m3 blood]
Vmean(5)=mean(fVsav(nbr,jsearch1:jsearch0))*1e-6;     %[m3 blood]
Vmean(6)=mean(fVsav(numa,jsearch1:jsearch0))*1e-6;  %[m3 blood]
Vmean(7)=mean(fVsav(nfv,jsearch1:jsearch0))*1e-6;    %[m3 blood]

a2(:,ico)=[dVmeandt(3);dVmeandt(6);dVmeandt(4);dVmeandt(7);dVmeandt(5);qmean(3);qmean(6);qmean(4);qmean(7);qmean(5);Vmean(3);Vmean(6);Vmean(4);Vmean(7);Vmean(5)];

% Calculate volume derivatives from peak blood volume per heart beat
%ico=ico+1;
toc