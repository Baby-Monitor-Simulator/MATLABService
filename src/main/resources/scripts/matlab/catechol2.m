if ico==3
    NEv(1:2)=0;
    NEa(1:2)=0;
    facgm3ngml=10^3;
    qfet0=mfqmc;
    qum0=mfqummc;
    qut0=mqutven;
end

PfO2_th=12.5;%8; %threshold for extra catecholamine secretion
CL_NE= (300e-6)/60; %total NE clearance [m3/s]
CL_E= (300e-6)/60; %total E clearance [m3/s]
dNEadt0=4.25e-9; %basal secretion [g/s]
dNEadtmax=5*4.25e-7;%max secretion [g/s]
ka=1;

mVv1= 298e-6;%mVv;
mVa1= 32e-6;%mVa;
mVv= 298e-6;%if umbilical==1; mVv=(fV(num)); else  mVv=sum(fV([numa,numv])); end% fetal venous volume
mVa= 32e-6;%sum(fV)-mVv; % fetal venous volume

dfVvdto =(mVv1-mVv)/tso; %fetal venous volume change
dfVadto =(mVa1-mVa)/tso; %fetal venous volume change

%ka=1e-8; %secretion constant: hypoxia increases secretion linearly
%PfO2_th=12; %threshold for extra catecholamine secretion

%jmin    = j-1-floor(ftcycle(fcycle)/dt);
%jmax    = j-1;
qfet=mfqmc;%2.42e-5; %mean(fqsav(sfa,jmin:jmax)); % umbilical flow [m^3/s]
qum=mfqummc;%2.42e-5; %mean(fqsav(sumv,jmin:jmax)); % umbilical flow [m^3/s]
qut=mqutven;

dNEvdt(ico)=0.2*qum*dt*1e-3*NEa(ico-1)*(qut/qut0); %totale afbraaksnelheid
% if PfO2(ico-1)>PfO2_th
%      dNEadt=dNEadt0; %NE secretion rate
% else
%     dNEadt=dNEadt0+ka*(PfO2_th-PfO2(ico-1)); %NE secretion rate
% end

dNEadt(ico)=(dNEadtmax+dNEadt0*exp((PfO2(ico-1)-PfO2_th)./ka))./(1+exp((PfO2(ico-1)-PfO2_th)./ka));

NEa(ico)=(NEa(ico-1)+(qfet*NEv(ico-1)+dNEadt(ico)-0.5*CL_NE*NEa(ico-1))*tso/mVa)/(1+tso/mVa*(qfet+dfVadto));
NEv(ico)=max(0,(NEv(ico-1)+(qum*NEa(ico)-dNEvdt(ico))*tso/mVv)/(1+tso/mVv*(qum+dfVvdto)));
