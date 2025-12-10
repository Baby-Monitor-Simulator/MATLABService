%DIT KOPIËREN!!!!
%     p=3:0.05:20;
%   y=15e-1*p.^-2.74+12e0*p.^-4.54;
%   figure(22); plot(p,y,'co'); hold on;
%   for p=2:0.5:20
%     PfO2(1:800)=p;
%     for ico=4:800;
%     catechol3
%     end
%     figure(22); hold on; plot(p,NEa(800),'rx')
%     end

qfet0=18.25e-6;
if ico==3
    CAum(1:2)=0.89e-3;
    CAf(1:2)=1.0e-3;
    CAmix(1:2)=0.97e-3;
    CAmix2(1:2)=0.97e-3;

    facgm3ngml=10^3;
    qfet0=mfqmc+mfqbr;
    qum0=mfqummc;
    qut0=mqutven;
end

tau_P=5; %schatting van onszelf

Eummax=0.9e-8;
kCA=3e-3;
Prodn=0.5*85e-9*3/60; %[ng/s] gedeeld door 2 vanwege verrekening Ef met P
facEum=0.45;%1/6; %fraction of clearance flow from umbilical flow% 
qfet=mfqmc+mfqbr;%2.42e-5; %mean(fqsav(sfa,jmin:jmax)); % umbilical flow [m^3/s]
qum=mfqummc;%2.42e-5; %mean(fqsav(sumv,jmin:jmax)); % umbilical flow [m^3/s]
qut=mqutven;
qCO=qfet+qum;

kProd=1.5977;
Prod0=3.0873e+05;

%Volumes
mVf1= 220e-6;%mVv;
mVum1= 110e-6;%mVa;
mVf= 220e-6;%if umbilical==1; mVv=(fV(num)); else  mVv=sum(fV([numa,numv])); end% fetal venous volume
mVum= 110e-6;%sum(fV)-mVv; % fetal venous volume

dfVumdto =(mVum1-mVum)/tso; %fetal venous volume change
dfVfdto =(mVf1-mVf)/tso; %fetal venous volume change

%Elimination and production rates [g/s]
%Eum(ico)=CLum*CAmix(ico-1);%*(qut/qut0); %totale afbraaksnelheid
Efac=min(qum/qum0,1);  % factor van huidige flow tov normaal flow
Eum(ico)=Efac*Eummax*(1-exp(-CAmix(ico-1)/kCA));
pOCA(ico)=PfO2(ico-1)-3.5;
if pOCA(ico)<12
    Pdak(ico)=1e-6*qfet*Prod0*exp(-pOCA(ico)/kProd); %gefit op data van Cohen, omgerekend naar g/s: netto-verschil tussen aanmaak/afbraak in foetale en mix compartiment
else
    Pdak(ico)=Prodn;
end

P(ico)=(P(ico-1)*tau_P+Pdak(ico)*tso)/(tau_P+tso);

    
%CA concentrations [g/m3]
CAmix(ico)=(qfet/qCO)*CAf(ico-1)+(qum/qCO)*CAum(ico-1);

dCAfdt(ico)=-(CAf(ico-1)/mVf)*dfVfdto+(qfet/mVf)*(CAmix(ico-1)-CAf(ico-1))+(P(ico)/mVf);
CAf(ico)=CAf(ico-1)+dCAfdt(ico)*tso;

dCAumdt(ico)=-(CAum(ico-1)/mVum)*dfVumdto+(qum/mVum)*(CAmix(ico-1)-CAum(ico-1))-(Eum(ico)/mVum);
CAum(ico)=CAum(ico-1)+dCAumdt(ico)*tso;

%CAf(ico)=(CAf(ico-1)+(qfet*CAmix(ico)+P(ico)-0)*tso/mVf)/(1+tso/mVf*(qfet+dfVfdto));
%CAum(ico)=max(0,(CAum(ico-1)+(qum*CAmix(ico)+E(ico))*tso/mVum)/(1+tso/mVum*(qum+dfVumdto)));
