% u_pcav
%
% output: npc cavity pressures 
%
% ---------------------------- 

if CAVmodel==1
    [fpcav] = cavmodel_f(fcavdata,fVc,t(j),ftcycle(icycle))*133/1000; 
elseif CAVmodel==2
    [fpcav,ls,fl]= onefiber_f(fcavdata,fVc,fdVcdt,ftstart(fcycle),t(j)); 
    ls1(j)=ls;
    vs1(j)=fl;
end

% end u_pcav