function [fsf,fsr,fsa] = fmat_model1(flaf,flar,dflafdt,ftss,fcontrac,ftact)

% PASSIVE STRESSES
% 2/3* stresses according to ventricular stress ratio
ii=1.8;
jj=1.6;

fsf0     = ii*0.9e3;    % [Pa] unloaded fiber stress (along fiber direction)
fcf      = jj*12;     	% [-] fitting constant for passive fiber stress along fiber direction
fcr      = jj*9;        % [-] fitting constant for passive transverse stress (radial fiber direction)
fsr0     = ii*0.3e3;    % [Pa] unloaded fiber stress (radial =transverse direction)

% Passive fiber stress along fiber direction
if flaf >= 1
   fsf = fsf0*(exp(fcf*(flaf - 1)) - 1);
else
   fsf = 0;
end
% Passive fiber stress in transverse direction
if flar >= 1
    fsr = fsr0*(exp(fcr*(flar - 1)) - 1);
else
    fsr =0;
end

% ACTIVE STRESSES
% Ratio sarcomere length mother/foetus: 1.30; according to Arts (1.44/1.10)
fsa0   =  125e3;    	% [Pa]  scaling constant for active fiber stress
fla0   =  1.5e-6;    % [m]   sarcomere length at point were active stress becomes zero
flsref =  2e-6;      % [m]   sarcomere length at reference stress sa0
fv0    =  1e-5; 		% [m/s] unloaded sarcomere shortening velocity (same as maternal assumed)
fc2    =  0;         % [-]   fitting constant for stress-velocity relation (shape)
fls0   =  1.9e-6;    % [m]   sarcomere length at zero transmural pressure arts table3

fls2   = flaf*fls0;    % [m] current sarcomere length blz. 12 H4 Bov
fvs    = -dflafdt*fls0;% [m/s] current sarcomere shortening velocity

% length dependency for active stress
ffl  = 0;
if fls2 > fla0
    ffl = (fls2 - fla0)/(flsref - fla0);
end;
% time dependency for active stress
if ftss < 0
   fgt = 0;
elseif ftss < ftact
   fgt = (sin(pi*ftss/ftact))^2;
else
   fgt = 0;
end
% velocity dependency for active stress
fvr = fvs/fv0;
fhv = (1 - fvr)/(1 + fc2*fvr);

% total active stress
fsa = fcontrac*fsa0*fhv*ffl*fgt;