function [mpcav,ls,yo] = onefiber_m(cavdata,Vcav,dVcavdt,tstart,t);

npc = length(Vcav);

for ipc = 1:npc

    Vw      = cavdata(ipc,2);
    Vc0     = cavdata(ipc,3);
    ls0     = cavdata(ipc,4);
    sf0     = cavdata(ipc,5);
    sc0     = cavdata(ipc,6);
    cf      = cavdata(ipc,7);
    cc      = cavdata(ipc,8);
    Ta0     = cavdata(ipc,9);
    ca      = cavdata(ipc,10);
    lsa0    = cavdata(ipc,11);
    lsa1    = cavdata(ipc,12);
    taur1   = cavdata(ipc,13);
    taud1   = cavdata(ipc,14);
    ar      = cavdata(ipc,15);
    ad      = cavdata(ipc,16);
    bd      = cavdata(ipc,17);
    HR      = cavdata(ipc,18);
    HR0     = cavdata(ipc,19);
    v0      = cavdata(ipc,20);
    cv      = cavdata(ipc,21);

    Vc      = Vcav(ipc);
    dVdt    = dVcavdt(ipc);
    
    x0  =   (1+3*(Vc0/Vw));        % help variable
    x   =   (1+3*(Vc/Vw));         % help variable

    ls  =   ls0*((x/x0)^(1/3));    % sarcomere length
    dlsdt = (ls/x)*(dVdt/Vw);      % sarcomere lengthening velocity
    vs  =  -dlsdt;                 % sarcomere shortening velocity

    %ts = t-floor(t/tcycle)*tcycle; % time elapsed since start current cycle
    ts = t-tstart; % time elapsed since start current cycle
    % --- passive stress

    laf = ls/ls0;
    lar = 1/laf^2;
    sf = sf0*(exp(cf*(laf-1))-1);
    sr = sc0*(exp(cc*(lar-1))-1);
    sf = max(0,sf);
    sr = max(0,sr);

    % --- active stress

    fl = 0;
    if ls>lsa0
        fl = Ta0*(tanh(ca*(ls-lsa0)).^2);
    end;

    taur  = taur1 + ar*(ls-lsa1);
    taud  = taud1 + ad*(ls-lsa1) - bd*(HR-HR0);
    if ts < 0
        gt=0;
    elseif ts < taur
        gt=(sin(pi*ts/(2*taur)))^2;
    elseif ts < taur + taud
        gt=1-(sin(pi*(ts-taur)/(2*taud)))^2;
    else
        gt=0;
    end

    vr = vs/v0;
    hv = (1-vr)/(1+cv*vr);

    Ta = fl*gt*hv;
    sa = laf*Ta;

    % --- total stress

    mpcav(ipc) = (sf+sa-2*sr)/x;
    yo=(sf+sa-2*sr);
%    pause
    
end

% end function onefiber


