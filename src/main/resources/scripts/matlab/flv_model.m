function fplv = flv_model(fVlv,fVlv_old,fVw,fVlv0,fcontrac,ts,fcntr,ic,ftact,ftcycle)

% Help variables for fiber stretch ratio calculation
fVr      = fVlv/fVw;
fVr2     = fVlv_old/fVw;
fVr0     = fVlv0/fVw;

% Fiber stretch ratio (previous & current longitudinal; current radial)
flaf     = ((1 + 3*fVr)/(1 + 3*fVr0))^(1/3); %blz. 12 Bov H4
flaf2    = ((1 + 3*fVr2)/(1 + 3*fVr0))^(1/3); %(8) uit Bov 2006 (Intram. press. corr flow)
flar     = 1/flaf^2;                         %(9) uit Bov 2006 (Intram. press. corr flow)

% Time derivative of fiber stretch ratio, necessary for active stress time dependency
if ic >= 1
    dflafdt  = (flaf - flaf2)/ts; 
end

% Saw-tooth generator: cardiac cycle
ftss     = fcntr - 0.25*ftcycle;

% Calculate active and passive stress contributions
[fsf,fsr,fsa] = fmat_model1(flaf,flar,dflafdt,ftss,fcontrac,ftact);

% Left ventricular pressure based on active and passive and radial stress
fplv     = (1/3)*(fsa + fsf-2*fsr)*log(1 + (1/fVr)); 

% Wall positions used to calculate intramyocardial pressure
frepi    = ((3/(4*pi))*(fVlv + fVw))^(1/3);    % outer surface position
frendo   = ((3/(4*pi))*fVlv)^(1/3);           % inner surface position
frbar    = ((3/(4*pi))*(fVlv + fVw/3))^(1/3);  % representative position
fbeta2   = (frepi - frbar)/(frepi - frendo);     % relative position of rbar according to repi & rendo

fpim     = fsr + fbeta2*fplv;  % intramyocard. pressure as function of relative position

