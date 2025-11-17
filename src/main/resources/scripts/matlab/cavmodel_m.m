function [p,fact] = cavmodel_m(cavdata,Vc,ts,T)

Vc0   = cavdata(:,2);
p0    = cavdata(:,3);
kE    = cavdata(:,4);
Emax  = cavdata(:,5);
kR    = cavdata(:,6);
%T     = cavdata(:,8);
Tsys0 = cavdata(:,9);
ksys  = cavdata(:,10);

npc   = length(Vc);

tact  = Tsys0-ksys/T;  % [ms]      - during activation at the beginning

for ipc=1:npc
    act  = 0;
    tact = Tsys0(ipc)-ksys(ipc)/T;
    if ts<tact
        act=(sin(pi*ts/tact))^2;
    end
    p(ipc) = act*Emax(ipc)*(Vc(ipc)-Vc0(ipc))+(1-act)*p0(ipc)*(exp(kE(ipc)*Vc(ipc))-1);
    cavdata(ipc,7) = p(ipc)*kR(ipc);
    fact=Emax;
end

% end function cavmodel
