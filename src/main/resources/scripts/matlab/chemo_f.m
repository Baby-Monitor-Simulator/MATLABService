%Chemo Ursino am j heart circ physiol 2000;279:H149-165

if ico==3
    %constants
    %ts= 0.5557;     %[s] zou tso moeten zijn
    facmin= 1.16;   %[spikes/s]
    facmax= 17.07;  %[spikes/s]
    PO2n= 22.7;       %45[mmHg]
    k_ac= 7.4801;   %29.27/90= k_ac/23[mmHg]
    tau_c= 2;       %[s]
    f_esinf= 2.1;   %[spikes/s]
    f_es0= 16.11;   %[spikes/s]
    f_esmin= 2.66;  %[spikes/s]
    f_esmax= 60;    %[spikes/s]
    k_es= 0.0675;   %[s]
    f_evinf= 6.3;   %[spikes/s]
    f_ev0= 3.2;     %[spikes/s]
    f_ab0= 25;      %[spikes/s]
    k_ev= 7.06;    %[spikes/s]
    W_bsp= 1;   
    W_csp= 5;
    W_psp= 0.34;
    W_bsh= 1;   
    W_csh= 1;   
    W_cv= 0.2;
    W_pv= 0.103;
    theta_v= -0.68;   %[spikes/s]
    fi_ac0=(facmax+facmin*exp(0))/(1+exp(0));
    f_ac(1)=fi_ac0; 
    f_ab(1:nmax)= 25;     %[spikes/s] is SS
    f_ap(1:nmax)= 0.583*23.29;  %[spikes/s] is SS from VT0 and G_ap 
    chi_minsp= 7.33;    %[spikes/s]
    chi_maxsp= 13.32;   %[spikes/s]
    tau_isc= 30;        %[s]
    k_iscsp= 2;         %[mmHg]
    PO2nsp= 7.5;        %30/92 = 7.5/23 [mmHg]
    chi_minsh= -49.38;  %[spikes/s]
    chi_maxsh= 3.59;    %[spikes/s]
    k_iscsh= 6;         %[mmHg]
    PO2nsh= 11.25;       %45/92 = 11.25/23 [mmHg]
    PfO20= 23;           %[mmHg]
    chi_sp0=(chi_minsp+chi_maxsp*exp((PfO20-PO2nsp)/k_iscsp))/(1+exp((PfO20-PO2nsp)/k_iscsp));
    theta_sp(1)=chi_sp0;
    chi_sh0=(chi_minsh+chi_maxsh*exp((PfO20-PO2nsh)/k_iscsh))/(1+exp((PfO20-PO2nsh)/k_iscsh));
    theta_sh(1)=chi_sh0;
    tau_Ts= 2;          %[s]
    tau_Tv= 1.5;        %[s]
    D_Ts= 2;            %[s]
    D_Tv= 0.2;          %[s]
    G_Ts= -0.13;        %[s^2/spikes]
    G_Tv= 0.09;         %[s^2/spikes]
    T0= 0.16;           %[s]
    sigma_Ts(1)= -0.2392;
    sigma_Tv(1)= 0.5269;
    DeltaTs(1)= sigma_Ts(1);
    DeltaTv(1)= sigma_Tv(1);
    T(1)= sigma_Ts(1)+sigma_Tv(1)+T0;
    f_sp(1)= 18.8440;   %SS at PfO20
    f_sh(1)= 7.9551;    %SS at PfO20
    f_v(1)= 5.8545;     %SS at PfO20
end 

%Calculate fire rate chemo from current PfO2
fi_ac=(facmax+facmin*exp((PfO2(ico-1)-PO2n)/k_ac))/(1+exp((PfO2(ico-1)-PO2n)/k_ac));
f_ac(j)=(f_ac(j-1)*tau_c+fi_ac*dt)/(tau_c+dt);

%CNS hypoxic response
chi_sp(j)=(chi_minsp+chi_maxsp*exp((PfO2(ico-1)-PO2nsp)/k_iscsp))/(1+exp((PfO2(ico-1)-PO2nsp)/k_iscsp));
theta_sp(j)=(theta_sp(j-1)*tau_isc+chi_sp(j)*dt)/(tau_isc+dt);
chi_sh(j)=(chi_minsh+chi_maxsh*exp((PfO2(ico-1)-PO2nsh)/k_iscsh))/(1+exp((PfO2(ico-1)-PO2nsh)/k_iscsh));
theta_sh(j)=(theta_sh(j-1)*tau_isc+chi_sh(j)*dt)/(tau_isc+dt);

%Calculate fire rate OS and PS 
f_sp(j)=f_esinf+(f_es0-f_esinf)*exp(k_es*(-W_bsp*f_ab(j)+W_csp*f_ac(j)-W_psp*f_ap(j)-theta_sp(j)));
if f_sp(j)>=f_esmax; f_sp(j)=f_esmax; end

f_sh(j)=f_esinf+(f_es0-f_esinf)*exp(k_es*(-W_bsh*f_ab(j)+W_csh*f_ac(j)-theta_sh(j)));
if f_sh(j)>=f_esmax; f_sh(j)=f_esmax; end
%f_sh(j)=f_sh(j-1);

%constant baro rate: f_ab(j)=f_ab SS
f_ab(j)=25;
f_v(j)=(f_ev0+f_evinf*exp((f_ab(j)-f_ab0)/k_ev))/(1+exp((f_ab(j)-f_ab0)/k_ev))+W_cv*f_ac(j)-W_pv*f_ap(j)-theta_v;

if scen==-1
    %Vagal compression during early deceleration: addition of vag fire rate due
    %to vagal hypoxia
    f_v1(j)=f_v(j);
    f_v2(j)=1.3*scaledepth(con)*vag_comp(j); 
    f_v(j)=f_v1(j)+f_v2(j);
end

if j<=round(D_Ts/dt)+1
    sigma_Tv(j)=sigma_Tv(1);
    DeltaTv(j)=sigma_Tv(j);
    sigma_Ts(j)=sigma_Ts(1);
    DeltaTs(j)=sigma_Ts(j);
elseif j<=round(D_Tv/dt)+1
    sigma_Tv(j)=sigma_Tv(1);
    DeltaTv(j)=sigma_Tv(j);
else
    %Heart rate
    if f_sh(j)>+f_esmin
        sigma_Ts(j)=G_Ts*log(f_sh(j-round(D_Ts/dt))-f_esmin+1);
    else
        sigma_Ts(j)=0;
    end
    DeltaTs(j)=(DeltaTs(j-1)*tau_Ts+sigma_Ts(j)*dt)/(tau_Ts+dt);
    sigma_Tv(j)=G_Tv*f_v(j-round(D_Tv/dt));
    DeltaTv(j)=(DeltaTv(j-1)*tau_Tv+sigma_Tv(j)*dt)/(tau_Tv+dt);
end

fT(j)=DeltaTs(j)+DeltaTv(j)+T0;

