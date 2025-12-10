%FMPmodel
clear all; close all;
%aan het eind opslaan: als mat
%ophalen als data=load('*.mat');

% === FMP body parts options
mother    =1;
uterus    =1;
foetus    =1;
umbilical =2; if umbilical==1; disp('alleen NS vene'); elseif umbilical==2; disp('PAS OP: NS vene en arterieën'); end
brain     =1;
CAVmodel  =2; %1=TVE, 2=1fiber 3=testcombi 5=1fibernew
scen      =3; if scen==0; disp('normaal CTG'); elseif scen==1; disp('vroege decels'); elseif scen==2; disp('late decels'); elseif scen==3||scen==3.1; disp('variabele decels'); umbilical=2; end
ncyclemax = 400;                  % [-] - maximum number of (maternal) cycles
lamb      =0; if lamb==0; disp('Het is een foetus'); else disp('PAS OP: lammetje'); end


% === initialise simulation

j           = 1;                % increment counter                    
ico         = 1;                % oxygen increment counter
con         = 0;                % contraction counter
t(j)        = 0;                % increment time 
tstart(1)   = 0;                % start current cycle
jstart(1)   = 1;                % cycle 1 starts at time step 1
ncycleconv  = 0;                % number of cycles to reach convergence
icycle      = 1;
oxcycle     = 15;
convm       = 0;
convf       = 0;
kwart       = 8;


% === input & input processing
if mother==1
    input_m % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
    init_m  % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
end

if foetus==1 && lamb==0
    input_f4 % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
    init_f  % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
elseif foetus==1 && lamb==1
    input_flamb % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
    init_f  % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
end
initialzero2   % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
j8=1; j7=1; j6=1; j5=1; j4=1; j3=1; j2=1+1*round(ftcycle(1)/4); j1=1+2*round(ftcycle(1)/4); j0=1+3*round(ftcycle(1)/4);

while icycle<=ncyclemax
    j      = j+1;
    t(j)   = j*dt;

    % MATERNAL SIMULATION
    if mother==1;
        mVp   = mV;                 % volumes previous time step
        mpp   = mp;                 % pressures previous time step
        mqp   = mq;                 % flows previous time step;

        mdVdt = mlio'*mq;           % rate of nodal volume change
        mV    = mVp + mdVdt*dt;     % new nodal volumes
        mp    = (mV-mV0)./mC;       % preliminary nodal pressures

        mVc   = mlpc*mV;            % select cavity volumes
        mdVcdt = mlpc*mdVdt;        % select cavity volume change

        pcav_m % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file      
        pext_m % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file

        mpe   = mlpe'*mpext;        % external pressure array
        mpc   = mlpc'*mpcav';       % cavity pressures in global nodes array
        mpn   = (1-mllpc)'.*mp;     % 'non-cavity' nodal pressures in global nodes array
        mp    = mpc + mpn + mpe;    % final nodal pressures
        mdp   = mp(msegdata(:,2))-mp(msegdata(:,3));   % segment pressure gradient

        update_m % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file

        mq  = (mdp+mLt.*mqp)./(mR+mLt);               % segment flows

        % --- save hemodynamic output
        tsav(j) = t(j);
        mpsav(:,j) = mp;
        mpart(j)=max(mp(1),mp(2));
        mVsav(:,j) = mV;
        mdVcdtsav(1,j)=mdVcdt;
        mqsav(:,j) = mq;
        mpextsav(:,j)=mpext;

        % === update parameters via regulation
        if Reg==1
            if convm==2
                reg_m % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
            else
                mtheta(:,j)=mtheta(:,j-1);
            end
        end

        % === check convergence
        if (t(j)-tstart(icycle))>mtcycle(icycle)
            if convm<2
                conv_m  % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
            elseif convm==2 && Reg==1
                disp(['RegCycle ' num2str(icycle-convcycle,'%6.0f' ) ' - T = ' num2str(mtcycle(icycle),'%6.0f' ) ' ms' ])
            end
            icycle          = icycle+1;
            mcycle          = icycle;
            mtcycle(icycle) = mtcycle(icycle-1);
            jstart(icycle)  = j+1;
            tstart(icycle)  = t(j)+dt;  
            if CAVmodel==2 || CAVmodel==3
                mcntr=0;
            end
        end
    end

    % FETAL SIMULATION
    if foetus==1;
        fVp   = fV;                 % volumes previous time step
        fpp   = fp;                 % pressures previous time step
        fqp   = fq;                 % flows previous time step;

        fdVdt = flio'*fq;           % rate of nodal volume change
        fV    = fVp + fdVdt*dt;     % new nodal volumes
        fp    = (fV-fV0)./fC;       % preliminary nodal pressures

        fVc   = flpc*fV;            % select cavity volumes
        fdVcdt = flpc*fdVdt;        % select cavity volume change

        pcav_f % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
        pext_f % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file

        fpe   = flpe'*fpext;        % external pressure array
        fpc   = flpc'*fpcav';       % cavity pressures in global nodes array
        fpn   = (1-fllpc)'.*fp;     % 'non-cavity' nodal pressures in global nodes array
        fp    = fpc + fpn + fpe;    % final nodal pressures
        fdp   = fp(fsegdata(:,2))-fp(fsegdata(:,3));   % segment pressure gradient

        update_f % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
        
        fq  = (fdp+fLt.*fqp)./(fR+fLt);               % segment flows

        % --- save hemodynamic output
        if mother==0; tsav(j) = t(j); end
        fpsav(:,j) = fp;
        fpart(j)=max(fp(1),fp(2));
        fVsav(:,j) = fV; 
        fqsav(:,j) = fq;
        fpextsav(:,j)=fpext;
        if convf==3
            % store requested ouput data
            jmin = j-floor(ftcycle(fcycle)/dt);
            if mother==0; t   = t(jmin:j)-t(jmin); end

            clear fp1;
            clear fV1;
            clear fq1;

            fp1 = fpsav(:,jmin:j);
            fV1 = fVsav(:,jmin:j);
            fq1 = mean(fqsav(sfa,jmin:j));
        end
        
        
        % === update parameters via regulation
        if fReg==1
            if 1<convf<2
                reg_f % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
            else
                ftheta(:,j)=ftheta(:,j-1);          
            end
        end

        % === check convergence     
        if j==round(sum(ftcycle(1:fcycle-1))/dt+kwart*ftcycle(fcycle)/(8*dt)) && j>=ftcycle(1)/dt ;
            % in case of fetus without mother, also update icycle 
            j8=j7; j7=j6; j6=j5; j5=j4; j4=j3; j3=j2; j2=j1; j1=j0; j0=j;
            if kwart==8
                if mother==0 && convf==0        
                    conv_f  % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
                    icycle = icycle+1;                
                elseif mother==0 && convf==2    
                    disp(['RegCycle ' num2str(icycle-convcycle,'%6.0f' ) ' - T = ' num2str(ftcycle(icycle),'%6.0f' ) ' ms' ])
                    icycle = icycle+1;
                % in case with mother, only check convergence
                elseif mother==1 && convf<2
                    conv_f
                            
                % === oxygen calculation
                % SS + update convergence by convergence M+F
                elseif foetus==1 && convf==2 && convm==2
                    disp('Calculation of SS oxygen values, please wait')
                    oxygenss
                    oxygenss1
                    tso=(round(ftcycle(fcycle-1))+round(ftcycle(fcycle)))*dt*1e-3; % tijd van afgelopen 2 periodes;
                    tom(ico-1)=j*dt;
                    oxcycle=fcycle;
                    convf=3;
                    tox=t(j);
                    tic
                    regulation;
                % oxygen calculation after each cycle; chemoreceptor update
                elseif convf==3 && mother==1;
                    tom(ico)=j*dt;
                    tso=(tom(ico)-tom(ico-1))*1e-3;%(j0-j1)*dt*1e-3;
                    oxygen;
                    %oxygen2;   % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
                    regulation;
                end
            end
            if fcycle>1 && convf==3 && mother==1 && kwart~=8
%                 tom(ico)=j*dt;
%                 tso=(tom(ico)-tom(ico-1))*1e-3;
%                 oxygen2; 
%                 regulation
           end
% %                     
            if kwart==8
                fcycle = fcycle+1;
                % update fetal heart rate
                if fReg==1 && convf>1
                    jsearch0=j;
                    jsearch1=round(jsearch0-ftcycle(fcycle-1)/dt);
                    if round(mean(ftcycleupdate(jsearch1:jsearch0)))>0 && 1000*(fT(ico))/2>0
                        ftcycle1(fcycle)= round((ftcycle(1)-mean(ftcycleupdate(jsearch1:jsearch0))+1000*(fT(ico))));
                        %ftcycle(fcycle)=round((mean(ftcycleupdate(jsearch1:jsearch0))+1000*(fT(ico)))/2);
                        ftcycle(fcycle)=1000*(fT(ico));
                        %ftcycle(fcycle)=ftcycle(fcycle-1);
                        %ftcycle(fcycle)=round(mean(ftcycleupdate(jsearch1:jsearch0))); %deze aanzetten
                    else
                        ftcycle(fcycle)=ftcycle(fcycle-1);
                    end
                elseif convf==3
                    ftcycle(fcycle)=fT(ico)*1000;
                    
                else
                    ftcycle(fcycle)=ftcycle(fcycle-1);
                end
                fjstart(fcycle)  = j+1;
                ftstart(fcycle)  = t(j)+dt;  
                fTvs=0.3*ftcycle+160;   % [ms] - duration activation ventricle
                tm(fcycle)=j*dt;
                if CAVmodel==2
                    fcntr=0;
                end
            end
            kwart=kwart+1; 
            if kwart>8; kwart=1; end
        end
        
    end  
end
toc
if convf>=3
    fprintf('Ratio realtime vs. simulation time is %d\n',toc/(t(j-1)-tox)*1e3)
end

if mother==1
    % store requested ouput data

    jmin = j-ncycleplot*floor(mtcycle(icycle)/dt);

    t   = t(jmin:j)-t(jmin);

    clear mp;
    clear mV;
    clear mq;

    mp = mpsav(:,jmin:j);
    mV = mVsav(:,jmin:j);

    mq = mqsav(:,jmin:j);

    post_m % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
end

if foetus==1
    % store requested ouput data
    jmin = j-ncycleplot*floor(ftcycle(fcycle)/dt);
    if mother==0; t   = t(jmin:j)-t(jmin); end
    
    clear fp;
    clear fV;
    clear fq;

    fp = fpsav(:,jmin:j);
    fV = fVsav(:,jmin:j);
    fq = fqsav(:,jmin:j);
    plot_f % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user m-file
end