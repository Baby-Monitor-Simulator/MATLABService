% u_update
%
% output : updated properties
%          in arrays R, L, C, V0
%
% ------------------------------


if fdp(sfv)>0 
    fR(sfv)=fRv; 
else 
    fR(sfv)=fRv*facval;
end

if fdp(sfa)>0 
    fR(sfa)=fRa; 
else 
    fR(sfa)=fRa*facval;
end
fpext   = [0; 0];              % external pressures



if scen==1 && convf==3 
    ed
elseif scen==2 && convf==3
    ld
elseif scen==3 && convf==3
    vd
end