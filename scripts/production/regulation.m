%Chemo Ursino am j heart circ physiol 2000;279:H149-165
    c_R1=5;
    c_R2=0.12;
    c_V1=1.15;
    f_sp0=12;
    k=1.3;
if ico==2
    facmin=         1.16;   %[spikes/s]
    facmax=         17.07;  %[spikes/s]
    pO2n=           10.9;       %45/95= pO2n/23 [mmHg]
    if lamb==1; pO2n=20; end
    k_ac=           7.24;   %29.27/95= k_ac/23[mmHg]
    tau_c=          2;  disp('tau c te hoog terug naar 2')     %[s]
    f_esinf=        2.1;   %[spikes/s]
    f_es0=          16.11;   %[spikes/s]
    f_esmin=        2.66;  %[spikes/s]
    f_espmin=       13;
    f_espmin1=      1;
    f_esmax=        60;    %[spikes/s]
    k_es=           0.0675;   %[s]
    f_evinf=        6.3;   %[spikes/s]
    f_ev0=          3.2;     %[spikes/s]
    f_ab0=          25;      %[spikes/s]
    f_abmin=        2.52;   %[spikes/s]
    f_abmax=        47.78;  %[spikes/s]
    pn=             40;          %[mmHg]
    if lamb==1; pn=43; end
    k_ab=           4.09;      %[11.76/92=k_ab/32 mmHg]
    k_ev=           7.06;    %[spikes/s]
    W_v=            1;
    W_bsp=          1;   
    W_csp=          5;
    W_psp=          0.34;
    W_bsh=          1;   
    W_csh=          1;   
    W_cv=           0.2;
    W_pv=           0.103;
    theta_v=        -0.68;   %[spikes/s]
    fi_ac0=         (facmax+facmin*exp(0))/(1+exp(0));
    chi_minsp=      7.33;    %[spikes/s]
    chi_maxsp=      13.32;   %[spikes/s]
    tau_isc=        30;        %[s]
    k_iscsp=        2;         %[mmHg]
    pO2nsp=         7.57;%5.6842;       %30/95 = 7.58/24 [mmHg] 
    chi_minsh=      -49.38;  %[spikes/s]
    chi_maxsh=      3.59;    %[spikes/s]
    k_iscsh=        6;         %[mmHg]
    pO2nsh=         11.36;%8.5266;      %45/95 = 11.13/24 [mmHg]
    chi_sp0=        (chi_minsp+chi_maxsp*exp((pO2n-pO2nsp)/k_iscsp))/(1+exp((pO2n-pO2nsp)/k_iscsp));
    chi_sp(1:3)=    13.3;
    theta_sp(1:3)=  chi_sp(1);
    chi_sh0=        (chi_minsh+chi_maxsh*exp((pO2n-pO2nsh)/k_iscsh))/(1+exp((pO2n-pO2nsh)/k_iscsh));
    chi_sh(1:3)=    -10.45;
    theta_sh(1:3)=  chi_sh(1);
    tau_pb=         2.076;      %[s]
    tau_zb=         8;%6.37;       %[s]
    pwig(1:3)=      pn;         %[mmHg] is ss pwig, which equals MAP
    tau_Ts=         2;          %[s]
    tau_Tv=         1.5;        %[s]
    tau_Rp=         10;   disp('tau rp te hoog terug naar 6')       %[s]
    %tau_Rc=         10;          %[s]
    %tau_Rum=        10;           %[s]
    tau_V=          20;         %[s]
    tau_Ta0=        8;          %[s]
    tau_ox=         10; disp('tau ox te hoog terug naar 10')        %[s]
    D_Ts=           2;            %[s]
    D_Tv=           0.2;          %[s]
    D_Rp=           2;        %[s]
    D_V=            5;            %[s]
    D_Ta0=          2;          %[s]
    G_Ts=           -0.13;       %[s^2/spikes] van -0.13
    G_Tv=           0.09;%         %[s^2/spikes]
    G_Rp=           15;         %[kPa.ms/ml/spikes] .144 bij 47%
    G_Rc=           3;
    G_Rum=          3; 
    G_Rb=           1.4e5;
    G_Vp=           -0.32*fVv0/2.12;%0.115*0.72*fV0(nfv);
    G_Ta0=          0.2*0.68*fTa0; %kPa relation in acc. with Emax/Epas gain Ursino
    G_ox=           45;
    fRp0=           0;      %[kPa.ms/ml] 
    T0=             0.25;%0.5*0.58;%         %[s]
    if lamb==1; T0=0.15; end
    sigma_Ts(1:3)=  -0.176;%-0.2392;
    sigma_Tv(1:3)=  0.310;%0.5269;
    sigma_Rp(1:3)=  200;
    sigma_br(1:3)=  Rbrmc;
    fRbr2(1:3)=      sigma_br(1);
    DeltaTs(1:3)=   sigma_Ts(1);
    DeltaTv(1:3)=   sigma_Tv(1);
    DeltaRp(1:3)=   sigma_Rp(1);
    DeltaRb(1:3)=   G_Rb*Cfa(1)^2;
    DeltaVp(1:3)=   -32;
    DeltaTa0(1:3)=  23.5;
    fT(1:3)=        sigma_Ts(1)+sigma_Tv(1)+T0;
    f_sp(1:3)=      8.3;   %SS at pO2n
    f_sh(1:3)=      11;    %SS at pO2n
    f_v(1:3)=       5;     %SS at pO2n
    f_ac(1:3)=      6;%9.4;%fi_ac0; 
    f_ab(1:omax)=   23;     %[spikes/s] is SS
    f_ap(1:omax)=   0.583*23.29;  %[spikes/s] is SS from VT0 and G_ap 
    pO5n=11;
    

elseif ico>3
%     jsearch0=j0;
%     jsearch1=j8;
    jsearch0=j0;
    jsearch1=j8;%round(jsearch0-ftcycle(fcycle-1)/dt);
    jsearch2=round(jsearch1-ftcycle(fcycle-2)/dt);
    mfpart(ico)=mean(fpart(jsearch1:jsearch0))*fackPaHg;
  
    if ico==4
        mfpart(1:3)=mfpart(ico);
    end
    %Calculate fire rate chemo from current PfO2
    fi_ac(1:3)=f_ac(1:3);
    fi_ac(ico)=(facmax+facmin*exp((pOp(2)-pO2n)/k_ac))/(1+exp((pOp(2)-pO2n)/k_ac));
    f_ac(ico)=(f_ac(ico-1)*tau_c+fi_ac(ico)*tso)/(tau_c+tso);

    %CNS hypoxic response
    chi_sp(ico)=(chi_minsp+chi_maxsp*exp((pOp(2)-pO2nsp)/k_iscsp))/(1+exp((pOp(2)-pO2nsp)/k_iscsp));
    theta_sp(ico)=(theta_sp(ico-1)*tau_isc+chi_sp(ico)*tso)/(tau_isc+tso);
    chi_sh(ico)=(chi_minsh+chi_maxsh*exp((pOp(2)-pO2nsh)/k_iscsh))/(1+exp((pOp(2)-pO2nsh)/k_iscsh));
    theta_sh(ico)=(theta_sh(ico-1)*tau_isc+chi_sh(ico)*tso)/(tau_isc+tso);
    
    %Local effect of O2 in cerebral circulation: combi Peeters & Ursino!!
    sigma_br(ico)=(500+3*Rbrmc*exp((cOp(2)-0.12)./0.018))./(1+exp((cOp(2)-0.12)./0.018));
    fRbr2(ico)=min(Rbrmc,(fRbr2(ico-1)*tau_ox+sigma_br(ico)*tso)/(tau_ox+tso));
    fR(sbrmc)=fRbr2(ico);
    
    %Calculate fire rate baro from mean arterial pressure
    pwig(ico)=mfpart(ico);%(pwig(ico-1)*tau_pb+mfpart(ico)*tso+mfpart(ico)*tau_zb-tau_zb*mfpart(ico-1))/(tau_pb+tso);
    f_ab1(ico)=(f_abmin+f_abmax*exp((pwig(ico)-pn)/k_ab))/(1+exp((pwig(ico)-pn)/k_ab));
    f_ab(ico)=(f_ab1(ico-1)*tau_zb+f_ab(ico)*tso)/(tau_zb+tso);
    
    
    f_v(ico)=(f_ev0+f_evinf*exp((f_ab(ico)-f_ab0)/k_ev))/(1+exp((f_ab(ico)-f_ab0)/k_ev))+W_cv*f_ac(ico)-W_pv*f_ap(ico)-theta_v;
    vag_comp0(ico)=(-0.1+6*exp((pO5n-pOp(5))./k))./(1+exp((pO5n-pOp(5))./k));
    vag_comp(ico)=W_v*(vag_comp(ico-1)*tau_Tv+vag_comp0(ico)*dt)/(tau_Tv+dt);
    if scen==1||2||3 && convm==2 && con>0
        %Vagal compression during early deceleration: addition of vag fire rate due
        %to vagal hypoxia
        f_v1(ico)=f_v(ico);
        f_v2(ico)=vag_comp(ico);
        f_v(ico)=f_v1(ico)+f_v2(ico);
    end
    
    %Calculate fire rate OS and PS
    f_sp(ico)=f_esinf+(f_es0-f_esinf)*exp(k_es*(-W_bsp*f_ab(ico)+W_csp*f_ac(ico)-W_psp*f_ap(ico)-theta_sp(ico)));
    if f_sp(ico)>=f_esmax; f_sp(ico)=f_esmax; end
    f_sh(ico)=f_esinf+(f_es0-f_esinf)*exp(k_es*(-W_bsh*f_ab(ico)+W_csh*f_ac(ico)-theta_sh(ico)));
    if f_sh(ico)>=f_esmax; f_sh(ico)=f_esmax; end

    f_sp1(ico)=(0+40*exp((NEa(ico)-50e-3)./1.5e-2))./(1+exp((NEa(ico)-50e-3)./1.5e-2));
    f_sh1(ico)=(0+40*exp((NEa(ico)-50e-3)./1.5e-2))./(1+exp((NEa(ico)-50e-3)./1.5e-2));
        
    
%if ico<400 && ico>100; NEa1=10e-3; else NEa1=1e-3; end
%PAS OP AANGEPAST
%     f_sp1(ico)=(0+150*exp((NEa1-8e-3)./1e-3))./(1+exp((NEa1-8e-3)./1e-3));
%     f_sh1(ico)=(0+40*exp((NEa1-30e-3)./1.5e-2))./(1+exp((NEa1-30e-3)./1.5e-2));
    
    
    if ico>3
        f_sp(ico)=f_sp(ico);%+f_sp1(ico);%1e4*NEa(ico);
        f_sh(ico)=f_sh(ico);%+f_sh1(ico);%+2e4*NEa(ico);
    end
   
    %Effectors: Rp
    if ico>round(D_Rp/tso)
        sigma_Rp(ico)=(0.8*fRp+c_R1*fRp*exp((f_sp(ico-round(D_Rp/tso))-f_sp0)./(c_R2*f_sp0)))./(1+exp((f_sp(ico-round(D_Rp/tso))-f_sp0)./(c_R2*f_sp0)));
    else
        sigma_Rp(ico)=sigma_Rp(ico-1);
    end
    DeltaRp(ico)=(DeltaRp(ico-1)*tau_Rp+sigma_Rp(ico)*tso)/(tau_Rp+tso);
    fR1(ico)=max(fRp,DeltaRp(ico));

    % Effectors: V0
    if ico>ceil(D_V/tso) && f_sp(ico-round(D_V/tso))>f_espmin1
        sigma_Vp(ico)=G_Vp*log(f_sp(ico-round(D_V/tso))-f_espmin1+1);
        DeltaVp(ico)=(DeltaVp(ico-1)*tau_V+sigma_Vp(ico)*tso)/(tau_V+tso);
        fV0(nfv)=DeltaVp(ico)+1.32*fVv0;
        
    else
        DeltaVp(ico)=DeltaVp(ico-1);
    end
    testa(ico)=fV0(nfv);
    
    fR6(ico)=fR(sumv);
    if umbilical==1
        fRvv(ico)=1/(1/(fR(sbrmc)+fR(sbrv))+1/(fR(summc)+fR(sumv))+1/fR(sfp));
    elseif umbilical==2
        fR4(ico)=fR(suma); 
        fRvv(ico)=1/(1/(fR(sbrmc)+fR(sbrv))+1/(fR(suma)+fR(summc)+fR(sumv))+1/fR(sfp));
    end
    qsys(ico)=fq1;
    
    
        
    % Effectors: T and fTa0
    if ico<=ceil(D_Ts/tso)
        sigma_Tv(ico)=sigma_Tv(1);
        DeltaTv(ico)=sigma_Tv(ico);
        sigma_Ts(ico)=sigma_Ts(1);
        DeltaTs(ico)=sigma_Ts(ico);
        DeltaTa0(ico)=DeltaTa0(ico-1);
    else
        if f_sh(ico)>+f_esmin
            sigma_Ts(ico)=G_Ts*log(f_sh(ico-round(D_Ts/tso))-f_esmin+1);
            sigma_Ta0(ico)=G_Ta0*log(f_sh(ico-round(D_Ta0/tso))-f_esmin+1);
        else
            sigma_Ts(ico)=0;
            sigma_Ta0(ico)=0;
        end
        DeltaTs(ico)=(DeltaTs(ico-1)*tau_Ts+sigma_Ts(ico)*tso)/(tau_Ts+tso);
        DeltaTa0(ico)=(DeltaTa0(ico-1)*tau_Ta0+sigma_Ta0(ico)*tso)/(tau_Ta0+tso);
        sigma_Tv(ico)=G_Tv*f_v(ico-round(D_Tv/tso));
        DeltaTv(ico)=(DeltaTv(ico-1)*tau_Tv+sigma_Tv(ico)*tso)/(tau_Tv+tso);
    end  

    fT(ico)=DeltaTs(ico)+DeltaTv(ico)+T0;
    fcavdata(9)=DeltaTa0(ico)+0.67*fTa0;

    Ta0test(ico)=fcavdata(9);
end
