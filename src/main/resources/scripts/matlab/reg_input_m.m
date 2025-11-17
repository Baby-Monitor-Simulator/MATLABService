% u_reg_input
%
% input for regulatory model: Table 1, Ursino 2003
%
%-----------------------------------------------------

% --- Rep

mfac_Rp     = 0.35*mRp;         % [kPa.s/ml] - amplitude of max and min mRp
mGa_Rp      = 0.1/facHgkPa;     % [kPa^-1] intact
mGp_Rp      = 0.33*facHgkPa;    % [l^-1]
mmin_Rp     = mRp-mfac_Rp;      % [kPa*ms/ml]
mmax_Rp     = mRp+mfac_Rp;      % [kPa*ms/ml]
mD_Rp       = 3000;             % [ms]
mtau_Rp     = 1500;             % [ms]

if Vagatomy==1; 
    mGa_Rep  = 0.04*facHgkPa;   % [mmHg^-1] vagatomized
    mGp_Rep  = 0;               % [l^-1]
end

% --- Vuv

mfac_Vuv    = 0.22*mVv0;        % [ml] - amplitude of max and min mVv
mGa_Vuv     = 10.8/facHgkPa;    % [kPa^-1]
mGp_Vuv     = 0;                % [l^-1]
mmin_Vuv    = mVv0-mfac_Vuv;    % [ml]
mmax_Vuv    = mVv0+mfac_Vuv;    % [ml]
mD_Vuv      = 5*1000;           % [ms]
mtau_Vuv    = 10*1000;          % [ms]

if CAVmodel==1
    
    % --- Emaxlv: NB in mmHg instead of kPa

    mGa_Emaxlv   = 0.012;       % [mmHg^-1]
    mGp_Emaxlv   = 0;           % [l^-1]
    mmin_Emaxlv  = 1.0;         % [mmHg/ml]
    mmax_Emaxlv  = 3.0;         % [mmHg/ml]
    mD_Emaxlv    = 2000;        % [ms]
    mtau_Emaxlv  = 1500;        % [ms]
elseif CAVmodel==2
    
    % --- Ta0, now referred to as Emax_lv to build mtheta
    
    mfac_Emaxlv  = 0.17*mTa0;   % [kPa] - amplitude of max and min mTa0
    mGa_Emaxlv   = 4;           % [kPa^-1] empirically determined: fluctuations +6% and -12%
    mGp_Emaxlv   = 0;           % [l^-1]
    mmin_Emaxlv  = mTa0-mfac_Emaxlv;   % [-]
    mmax_Emaxlv  = mTa0+mfac_Emaxlv;   % [-]
    mD_Emaxlv    = 2000;        % [ms]
    mtau_Emaxlv  = 1500;        % [ms]
end

% --- T

mGa_Tv       = 0.028/facHgkPa;  % [kPa^-1]
mGp_Tv       = .25;             % [l^-1]
mD_Tv        = 500;             % [ms]
mtau_Tv      = 800;             % [ms]

mGa_Ts       = 0.015/facHgkPa;  % [kPa^-1]
mGp_Ts       = 0;               % [l^-1]
mD_Ts        = 3000;            % [ms]
mtau_Ts      = 1800;            % [ms]


mfac_T       = 375;             % [ms] - amplitude of max and min mTa0
mmin_T       = mtcycle(1)-mfac_T-100;   % [ms]
mmax_T       = mtcycle(1)+mfac_T-100;   % [ms]
mkT          = (mmax_T-mmin_T)/4000;% [ms]

if Vagatomy==1
    mGa_Tv   = 0;            % [mmHg^-1]
    mGa_Ts   = 0.006;        % [mmHg^-1]
end

% store feedback parameters: note negative value inserted for Gp_Tv !

mGa_theta    = [ mGa_Rp          mGa_Vuv          mGa_Emaxlv      mGa_Ts   mGa_Tv  ];
mGp_theta    = [ mGp_Rp          mGp_Vuv          mGp_Emaxlv      mGp_Ts   mGp_Tv  ];
mmax_theta   = [ mmax_Rp         mmax_Vuv         mmax_Emaxlv     0        0  ];
mmin_theta   = [ mmin_Rp         mmin_Vuv         mmin_Emaxlv     0        0  ];
mD_theta     = [ mD_Rp           mD_Vuv           mD_Emaxlv       mD_Ts    mD_Tv   ];
mtau_theta   = [ mtau_Rp         mtau_Vuv         mtau_Emaxlv     mtau_Ts  mtau_Tv ];

% --- derived quantities

mk_theta     = (mmax_theta-mmin_theta)/4;
mk_theta(1)  = -mk_theta(1)/1000;    % decreasing R sigmoid; from s to ms
mk_theta(3)  = -mk_theta(3);         % decreasing Emax sigmoid; from s to ms

mtheta0      = (mmax_theta+mmin_theta)/2;

% --- setpoints

mpsan        = 60*facHgkPa;           % [mmHg]
mVLn         = 2.3;          % [l]

% --- end u_reg_input