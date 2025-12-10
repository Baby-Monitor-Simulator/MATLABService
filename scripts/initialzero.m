%initial zeros
if foetus==1
    omax=4*round(nmax/(120));
else
    omax=nmax;
end

%general parameters
t =zeros(1,nmax);
tsav =zeros(1,nmax);
tm=zeros(1,omax);
a=zeros(12,ncyclemax);
aa=zeros(1,ncyclemax);
if umbilical==2; a=zeros(15,ncyclemax); end

%maternal parameters
if mother==1
    mpsav =zeros(mnnod,nmax);
    mVsav =zeros(mnnod,nmax);
    mdVcdtsav=zeros(1,nmax);
    mqsav =zeros(mnseg,nmax);
    mpextsav=zeros(length(mpext),nmax);
    tstart=[tstart,zeros(1,omax)];
    jstart=[jstart,zeros(1,omax)];
    mtcycle=[mtcycle,zeros(1,omax)];
    mp_tm1=zeros(1,nmax);
    mR6=zeros(1,nmax);
    %regulation parameters mother
    if Reg==1
        for i=1:5
            mtheta(i,1:nmax)=mtheta0(i);
        end
    end
    mpart=zeros(1,nmax);
    mdRp=zeros(1,nmax);
    mRp_n=zeros(1,nmax);
    pin=zeros(5,nmax);
end

%fetal parameters
if foetus==1
    fpsav =zeros(fnnod,nmax);
    fpart=zeros(1,nmax);
    fVsav =zeros(fnnod,nmax);
    fqsav =zeros(fnseg,nmax);
    fpextsav=zeros(length(fpext),nmax);
    fjstart=[fjstart,zeros(1,omax)];
    ftstart=[ftstart,zeros(1,omax)];
    ftcycle=[ftcycle,zeros(1,omax)];
    fppers=zeros(1,nmax);

    %chemo parameters fetus
    WCL=zeros(1,omax);
    P_dak=zeros(1,omax);
    f_ac=zeros(1,omax);
    f_ac1=zeros(1,omax);
    chi_sp=zeros(1,omax);
    theta_sp=zeros(1,omax);
    chi_sh=zeros(1,omax);
    theta_sh=zeros(1,omax);
    f_sp=zeros(1,omax);
    f_sh=zeros(1,omax);
    f_sp1=zeros(1,omax);
    f_sh1=zeros(1,omax);
    f_ab=zeros(1,omax);
    f_ab1=zeros(1,omax);
    f_v=zeros(1,omax);
    f_v1=zeros(1,omax);
    f_v2=zeros(1,omax);
    sigma_Tv=zeros(1,omax);
    DeltaTv=zeros(1,omax);
    sigma_Ts=zeros(1,omax);
    DeltaTs=zeros(1,omax);
    sigma_Rp=zeros(1,omax);
    DeltaRp=zeros(1,omax);
    DeltaRb=zeros(1,omax);
    sigma_Vp=zeros(1,omax);
    DeltaVp=zeros(1,omax);
    sigma_Ta0=zeros(1,omax);
    DeltaTa0=zeros(1,omax);  
    sigma_br=zeros(1,omax);
    fT=zeros(1,omax);
    Ta0test=zeros(1,omax);
    vag_comp=zeros(1,nmax);
    vag_comp0=zeros(1,nmax);
    vag_comp1=zeros(1,nmax);
    fp_tm1=zeros(1,nmax);
    fp_br1=zeros(1,nmax);
    fR6=zeros(1,nmax);
    fR4=zeros(1,nmax);
    fR1=zeros(1,omax)+fRp;
    fRR=zeros(1,nmax);
    fRbr=zeros(1,omax);
    fRbr2=zeros(1,omax);
    fRvv=zeros(1,omax);
    Rp1=zeros(1,omax);
    pwig=zeros(1,omax);
    Rchyp=zeros(1,omax);
    Rumhyp=zeros(1,omax);
    Rphyp=zeros(1,omax);
    CAf=zeros(1,omax);
    CAum=zeros(1,omax);
    CAmix=zeros(1,omax);
    CAmix2=zeros(1,omax);
    dCAfdt=zeros(1,omax);
    dCAumdt=zeros(1,omax);
    dCAmixdt=zeros(1,omax);
    P=zeros(1,omax);
    Emix=zeros(1,omax);
    Ef=zeros(1,omax);
    qsys=zeros(1,omax);
    put=zeros(1,omax);
    s=zeros(omax,3);
    if fReg==1
        for i=1:5
            ftheta(i,1:nmax)=ftheta0(i);
        end
    end
    fdRp=zeros(1,nmax);
    fRp_n=zeros(1,nmax);
    ftcycleupdate=444+zeros(1,nmax);
end
ls1=zeros(1,nmax);
vs1=zeros(1,nmax);
ls2=zeros(1,nmax);
vs2=zeros(1,nmax);
%oxygen parameters
if mother==1 && foetus ==1
    Putven=zeros(1,omax); Cutven=zeros(1,omax);
    Pummc=zeros(1,omax); Cummc=zeros(1,omax);
    Puma=zeros(1,omax); Cuma=zeros(1,omax);
    PfO2=zeros(1,omax); Cfa=zeros(1,omax); SfO2=zeros(1,omax);
    Pfmc=zeros(1,omax); Cfcm=zeros(1,omax);
    Pfbrmc=zeros(1,omax); Cfbr=zeros(1,omax);
    tom=zeros(1,omax);
end

testa=zeros(1,omax);