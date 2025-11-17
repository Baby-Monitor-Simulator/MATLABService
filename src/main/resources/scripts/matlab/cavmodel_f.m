function [p] = cavmodel_f(cavdata,Vc,t,tcycle);

Emax = cavdata(:,2);
Emin = cavdata(:,3);
Vc0  = cavdata(:,4);
Ts   = cavdata(:,5);
Td   = cavdata(:,6);

npc  = length(Vc);

ts = t-floor(t/tcycle)*tcycle;
%if ts==0; fcyc=fcyc+1; end

for ipc=1:npc
    act = 0;
    if ts<(Ts(ipc)+Td(ipc)) && ts>Td(ipc)
        act=(sin(pi*(ts-Td(ipc))/Ts(ipc)))^2;
    end
    p(ipc) = (Emin(ipc) + act*(Emax(ipc)-Emin(ipc)))*(Vc(ipc)-Vc0(ipc));
end


