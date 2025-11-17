c1=2;
c2=0.4;
f_sp0=40;%5.6*c2+fprest;
%fpcon1=0:0.01:12;
%R2=(fRp+c1*fRp*exp((f_sp-fpmax)./c2))./(1+exp((f_sp-fpmax)./c2));
sigmaRp=(fRp+c1*fRp*exp((f_sp-f_sp0)./(c2)))./(1+exp((f_sp-f_sp0)./(c2)));
%sigmRp=(0.1*fRp+c_R1*fRp*exp((f_sp-f_sp0)./(c_R2*f_sp0)))./(1+exp((f_sp-f_sp0)./(c_R2*f_sp0)));

figure; plot(f_sp,sigmaRp,'k')
min(sigmaRp)
max(sigmaRp) 
figure; plot(sigmaRp)

