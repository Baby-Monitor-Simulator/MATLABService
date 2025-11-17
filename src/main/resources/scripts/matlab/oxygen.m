cOlio = [1 0 -1 0 0 0 0
    0 0 0 -1 0 1 0
    0 1 0 0 -1 0 0
    0 1 0 0 0 -1 0
    0 1 0 0 0 0 -1];

cOp=cO;
pOp=pO;

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

%% Oxygen diffusion
cOdiff = [0 0 -D/Vmean(3)*(pOp(3)-pOp(4)) D/Vmean(4)*(pOp(3)-pOp(4)) 0 0 0]';

%% Metabolic oxygen consumption
if cOp(2)>=Cfth
    cOmetsys=cOmetsys0;
else
    cOmetsys=max(0.2*cOmetsys0,cOmetsys0+Ko*(cOp(2)-Cfth));
end

cOmet = [0 0 0 0 cOmetbr/Vmean(5) 0 cOmetsys/Vmean(7)]';

%%
dcOdt(3:7) = -cOp(3:7)./Vmean(3:7).*dVmeandt(3:7)+qmean(3:7)./Vmean(3:7).*(cOlio*cOp')'+cOdiff(3:7)'-cOmet(3:7)';

%  qmean(3:7)./Vmean(3:7)
%  (cOlio*cOp')'
%  %-cOdiff(3:7)'
%  %-cOmet(3:7)'

cO(1) = 0.16;
cO(2) = (cOp(5)*qmean(5)+cOp(7)*qmean(7)+(1-SFf)*cOp(4)*qmean(4))/((1-SFf)*qmean(4)+qmean(5)+qmean(7));
cO(3:7) = cOp(3:7)+dcOdt(3:7)*tso;

pO([1;3]) = samcurve1(cO([1;3]));
pO([2,4:7]) = safcurve1(cO([2,4:7]));


cOsav(:,ico)=cO;
pOsav(:,ico)=pO;

ico=ico+1;
catechol3