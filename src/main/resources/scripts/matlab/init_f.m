% u_init
%
% output: initial values p, V and q arrays
%
% ----------------------------------------

fV0tot   = sum(fV0);               % total unstressed volume 
fCtot    = sum(fC);                % total compliance
fVeff    = fVtotal-fV0tot;          % effective blood volume
fpeq     = fVeff / fCtot;           % equilibrium pressure
fp       = ones(fnnod,1)*fpeq;      % preliminary nodal pressures
fV       = fC.*fp+fV0;               % nodal volumes

fpe      = flpe'*fpext;
fp       = fp + fpe;                    % add external pressures

fq       = zeros(fnseg,1);

% end u_init