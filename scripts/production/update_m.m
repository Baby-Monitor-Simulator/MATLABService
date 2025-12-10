% u_update
%
% output : updated properties
%          in arrays R, L, C, V0
%
% ------------------------------


if mdp(sma)>0
    mR(sma)=mRa;
else
    mR(sma)=mRa*mfacval;
end

if mdp(smv)>0
    mR(smv)=mRv;
else
    mR(smv)=mRv*mfacval;
end
mpext  = [ mpth; fpcon(j-1) ];       % array of external pressures
% end u_update