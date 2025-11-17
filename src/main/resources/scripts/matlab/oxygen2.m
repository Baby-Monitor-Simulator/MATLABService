% Constant values
if ico==2; Dox=400*tso; end
Cm(ico)=0.16; 
PmO2(ico)=samcurve(Cm(ico));
if scen>4 && 1e-3*tom(ico)>Dox
    PmO2(ico)=98+365*(1-exp(-(1e-3*tom(ico)-Dox)/35));
    Cm(ico)=1.34e-006*120000/(1+(23400/(PmO2(ico)^3+150*PmO2(ico))))+3.1e-005*PmO2(ico);
end

if HES==1 && 1e-3*tom(ico-1)>240*tso;    
    Hbm=11.1;
end

% Calculate volume derivatives from peak blood volume per heart beat
jsearch0=round(sum(mtcycle(1:mcycle-1))/dt);
jsearch1=round(jsearch0-mtcycle(mcycle-2)/dt);
jsearch2=round(jsearch1-mtcycle(mcycle-3)/dt);

% blood flows over last period
mqutven=mean(mqsav(sutmc,jsearch1:jsearch0))*1e-3;    %[m3 blood/s]
% blood volumes over last period
mVivs1=mVivs;
mVivs=0.35*mean(mVsav(nutmc,jsearch1:jsearch0))*1e-6;      %[m3 blood]

% maternal blood volume changes over last period (mean of previous minus mean
% of current past period)
dVivsdto=0.35*(max(mVsav(nutmc,jsearch2:jsearch1))-max(mVsav(nutmc,jsearch1:jsearch0)))*1e-6/(mtcycle(mcycle)*dt*1e-3);

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
dfVbrdto=(max(fVsav(nbr,jsearch2:jsearch1))-max(fVsav(nbr,jsearch1:jsearch0)))*1e-6/(ftcycle(fcycle)*dt*1e-3);
dfVadto=(max(sum(fVsav(nflv:nfa,jsearch2:jsearch1)))-max(sum(fVsav(nflv:nfa,jsearch2:jsearch1))))*1e-6/(ftcycle(fcycle)*dt*1e-3);

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
mfVa=mean(sum(fVsav(nflv:nfa,jsearch1:jsearch0)))*1e-6;     %[m3 blood]

fjmin = j-ncycleplot*floor(ftcycle/dt);

if umbilical==1
    a(:,ico)=[dVivsdto;dfVummcdto;dfVmcdto;dfVbrdt;mqutven;mfqummc;mfqmc;mfqbr;mVivs;mfVummc;mfVmc;mfVbr];
elseif umbilical==2
    a(:,ico)=[dVivsdto;dfVumadto;dfVummcdto;dfVmcdto;dfVbrdt;mqutven;mfquma;mfqummc;mfqmc;mfqbr;mVivs;mfVuma;mfVummc;mfVmc;mfVbr];
end
aa(ico)=mfVa;

% Oxygen consumption is reduced linearly in case of hypoxia
if Cfa(ico-1)>=Cfth
    dVfdt=dVfdt0;
    dVfdt1=(10*mfqmc/(mfqmc+mfqbr+mfqummc))*3e-6/60-dVfbrdt0;
else
    dVfdt=max(0.2*dVfdt0,dVfdt0+Ko*(Cfa(ico-1)-Cfth));
    dVfdt1=(10*mfqmc/(mfqmc+mfqbr+mfqummc))*3e-6/60-dVfbrdt0;
end
s(ico,1)=10*mfqmc/(mfqmc+mfqbr+mfqummc);
s(ico,2)=dVfdt;
s(ico,3)=dVfdt1;


% Oxygen consumption is reduced linearly in case of hypoxia
%if Cfbr(ico-1)>=Cfbrth
    dVfbrdt=dVfbrdt0;
%else
    %dVfbrdt=dVfbrdt0+Ko*(Cfbr(ico-1)-Cfbrth);
%end

% Calculate new oxygen content in intervillous space
dCdt=-(Cutven(ico-1)/mVivs)*dVivsdto+(mqutven/mVivs)*(Cm(ico-1)-Cutven(ico-1))-(D/mVivs)*(Putven(ico-1)-Pummc(ico-1));
Cutven(ico)=Cutven(ico-1)+dCdt*tso;
Putven(ico)=samcurve(Cutven(ico));

% Calculate new oxygen content in umbilical cord
if umbilical==1
    dCdt=-(Cummc(ico-1)/mfVummc)*dfVummcdto+(mfqummc/mfVummc)*(Cfa(ico-1)-Cummc(ico-1))+(D/mfVummc)*(Putven(ico-1)-Pummc(ico-1));
    Cummc(ico)=Cummc(ico-1)+dCdt*tso;
    Pummc(ico)=sacurve(Cummc(ico));
elseif umbilical==2;
    dCdt=-(Cummc(ico-1)/mfVummc)*dfVummcdto+(mfqummc/mfVummc)*(Cuma(ico-1)-Cummc(ico-1))+(D/mfVummc)*(Putven(ico-1)-Pummc(ico-1));
    Cummc(ico)=Cummc(ico-1)+dCdt*tso;
    Pummc(ico)=sacurve(Cummc(ico));
end

% Calculate new oxygen content in fetal arteries
Cfa(ico)=(Cfbr(ico-1)*mfqbr+Cfmc(ico-1)*mfqmc+(1-SFf)*mfqummc*Cummc(ico))/(mfqbr+mfqmc+(1-SFf)*mfqummc);
PfO2(ico)=safcurve(Cfa(ico));

%if ico>100 && ico<400; PfO2(ico)=6.75; Cfa(ico)=0.026; end

if umbilical==2;
    % Calculate new oxygen content in fetal umbilical arteries
    dCdt=-(Cuma(ico-1)/mfVuma)*dfVumadto+(mfquma/mfVuma)*(Cfa(ico-1)-Cuma(ico-1));
    Cuma(ico)=Cuma(ico-1)+dCdt*tso;
    Puma(ico)=safcurve(Cuma(ico));
end

% Calculate new oxygen content in fetal microcirculation
dCdt=-(Cfmc(ico-1)/mfVmc)*dfVmcdto+(mfqmc/mfVmc)*(Cfa(ico-1)-Cfmc(ico-1))-(dVfdt/mfVmc);
Cfmc(ico)=Cfmc(ico-1)+dCdt*tso;
%Cfmc(ico)=(Cfmc(ico-1)+(mfqmc*Cfa(ico)-dVfdt)*tso/mfVmc)/(1+tso/mfVmc*(mfqmc+dfVmcdto));
if Cfmc(ico)>0
    [Pfmc(ico),SfO2(ico)]=safcurve(Cfmc(ico));
else
    Cfmc(ico)=0;
    Pfmc(ico)=0;
end

% Calculate new oxygen content in fetal brain circulation
dCdt=-(Cfbr(ico-1)/mfVbr)*dfVbrdto+(mfqbr/mfVbr)*(Cfa(ico-1)-Cfbr(ico-1))-(dVfbrdt/mfVbr);
Cfbr(ico)=Cfbr(ico-1)+dCdt*tso;

%Cfbr(ico)=(Cfbr(ico-1)+(mfqbr*Cfa(ico)-dVfbrdt)*tso/mfVbr)/(1+tso/mfVbr*(mfqbr+dfVbrdto));
Cfbr(ico)=max(Cfbr(ico),0);
Pfbrmc(ico)=safcurve(Cfbr(ico));

ico=ico+1;
catechol5