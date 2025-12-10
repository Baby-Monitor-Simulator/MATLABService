% u_pcav
%
% output: npc cavity pressures 
%
% ---------------------------- 

if CAVmodel==1
    ts   = t(j)-tstart(icycle);
    [mpcav,fact] = cavmodel_m(mcavdata,mVc,ts,mtcycle(icycle));
    mpcav=mpcav*133/1000;
    act(j)=fact;
elseif CAVmodel==2
    [mpcav,ls,vs]   = onefiber_m(mcavdata,mVc,mdVcdt,tstart(icycle),t(j)); 
    ls2(j)=ls;
    vs2(j)=vs;
end
% end u_pcav