Breathing  = 0;             % breathing (1) or not (0)
BaroReg    = 0;             % baroreceptors on (1) or off (0)
LungReg    = 0;             % lung stretch receptors on (1) or off (0)
Vagatomy   = 0;             % vagatomy (1) or not (0)
RpVar      = 0;             % 'random' variation of Rep (1) or not (0)

facHgkPa=133/1000;
fackPaHg=1/facHgkPa;

mp_ref=[];
Reg        = 0;
if BaroReg==1 || LungReg ==1
    Reg=1;
end
Reg=0;                      %omdat moeder nu nog niet gereguleerd wordt
pregnant = 1;               %1=pregnant
pregfac  = 1.4;             %vaste parameter: 40% verandering

mHR          = 65;               % [bpm] - heart rate
if pregnant==1
    mHR = 80;
end


% --- timing and convergence

mtcycle     = ceil(1000*60/mHR);    % [ms] - cycle time
dt          = 2;                    % [ms] - time step
ncycleplot  = 2;                    % [-] - number of cycles to be plotted
Verrormax   = 0.000001;             % [-] - maximum relative volume error allowed
Verrormax2  = 0.00001;
nmax        = ceil(1.4*ncyclemax*mtcycle/dt);         % [-] - number of increments

mVw=140;                            % [ml]  - LV wall volume
if pregnant==1
    mVw = mVw*pregfac;
end   
mV0lv=mVw/3;                        % [ml] - LV reference cavity volume
mClv     = 1.0;                     % [ml/kPa] - 'dummy' compliance

% left ventricle
if CAVmodel==1
    
    mV0lv       = 16.77;            % [ml]      - intercept volume LV
    mp0lv       = 3.5;              % [mmHg]    - parameter passive pV-relation
    mkElv       = 0.009;            % [ml^-1]   - parameter passive pV-relation                       
    mE_maxlv0   = 2;                % [ml/mmHg] - maximum elastance
    mkRlv       = 0.375;            % [ms/ml]   - parameter outflow resistance   
    
    mT0         = round(60e3/92);           % [ms]      - duration cardiac cycle
    mTsys0      = 500;           % [ms]      - parameter for tact
    mksys       = 75000;         % [ms^2]    - parameter for tact

elseif CAVmodel==2
    % material properties

    mls0     = 2.0;     % [um] - reference sarcomere length
    msf0     = 0.6;     % [kPa] - reference passive fiber stress
    msr0     = 0.15;    % [kPa] - reference passive cross-fiber stress
    mcf      = 12;    	% [-] - curvature of fiber stress-length relation
    mcc      = 9;    	% [-] - curvature of cross-fiber stress-length relation

    mTa0     = 150.;    % [kPa] - scaling parameter for active stress
    mca      = 1.0;     % [-] - curvature of active stress-length relation
    mlsa0    = 1.5;     % [um] - sarcomere length with zero active stress
    mlsa1    = 2.0;     % [um] - reference sarcomere length for active stress
    mtaur1   = 150; 	% [ms] - 'rise time' active stress for ls = lsa1
    mtaud1   = 250; 	% [ms] - 'decay time' active stress for ls = lsa1
    mar      = 100;     % [ms/um] - length dependence of rise time
    mad      = 400;     % [ms/um] - length dependence of decay time
    mbd      = 0.07;    % [s.s] - frequency dependence of decay time
    mHR0     = 0.5;     % [1/s] - reference frequency for freq dependence
    mv0      = 0.01; 	% [um/ms] - unloaded shortening velocity
    mcv      = 0.0;	 	% [-] - curvature of stress-velocity relation
end

% --- circulation volumes en vessel properties

mVtotal  = 5000;            % [ml]      - total blood volume 
mVv0     = 3000;            % [ml] - venous blood volume at zero pressure
mVa0     = 500;             % [ml] - arterial blood volume at zero pressure

mRa      = 7;     	 mRa0=mRa;% [kPa.ms/ml] - characteristic impedance
mRp      = 75;       % [kPa.ms/ml] - peripheral resistance
mRv      = 3.;       % [kPa.ms/ml] - inflow resistance
mCa      = 30;       % [ml/kPa]    - arterial compliance
mCv      = 600;      % [ml/kPa]    - venous compliance
mLa      = 30;       % [kPa.ms^2/ml] - arterial inertance
mLv      = 30;       % [kPa.ms^2/ml] - venous inertance

if pregnant==1
    mRp     = mRp*0.8;
    mVtotal = mVtotal*pregfac;
    mCa     = mCa*pregfac;
    mCv     = mCv*pregfac;
    mVv0    = mVv0*pregfac;
    mVa0    = mVa0*pregfac;
    mLa     = mLa*pregfac;
    mLv     = mLv*pregfac;
end

mfacval    = 10^6;           % factor of resistance increase to backflow in valve

mfRpmin   = 0.01;           % minimum frequency of Rep variation
mfRpmax   = 0.40;           % maximum frequency of Rep variation
mfRpstep  = 0.01;
mRp1      = mRp/2;         % amplitude of Rep variation
mfRp      = mfRpmin:mfRpstep:mfRpmax;
mnRp      = length(mfRp);
mphiRp    = 2*pi*randn(1,mnRp);

% --- external pressures
fpcon  = zeros(1,nmax)+20*facHgkPa;      % [kPa] - IU pressure (0+20 mmHg converted to kPa)
fprest = fpcon(1);
mpth   = 0;                % [mmHg] - external thoracic pressure


mpext  = [ mpth; fpcon(j) ];         % array of external pressures

% --- nodal data in mandatory format [ inod C V0 ipc ipe ] with
% ipc = 1 (plv), 2 (prv), or 0
% ipe = 1 (pth), 2 (pab), or 0
% cavities should be given a non-zero compliance

mnoddata = [
    1  mClv  mV0lv  1  1 ;
    2  mCa   mVa0   0  1 ;
    3  mCv   mVv0   0  1
    ] ;

nmlv   =  1;       % LV node
nma    =  2;       % arterialnode
nmv    =  3;       % venous node

% --- segment data [ iseg nod1 nod2 R L ]

msegdata = [
    1  1  2  mRa  mLa ;
    2  2  3  mRp  0  ;
    3  3  1  mRv  0
    ];

sma =  1;           % arterial segment
smp =  2;           % peripheral segment
smv =  3;           % venous segment

nnodes=  max(mnoddata(:,1));
nseg  =  max(msegdata(:,1));

% --- cavity (ventricle) data in user defined format dependent
%     on cavity model, to be used in user m-file u_pcav. 
%     Format: [ icav p0 kE E_max T Tsys0 ksys ]

if CAVmodel==1
    mcavdata = [
     1  mV0lv  mp0lv  mkElv  mE_maxlv0  mkRlv  mRa  mT0  mTsys0  mksys ;
     ];
elseif CAVmodel==2
    mcavdata = [
    1  mVw  mV0lv mls0 msf0 msr0 mcf mcc mTa0 mca mlsa0 mlsa1 mtaur1 mtaud1 mar mad mbd mHR/60 mHR0 mv0 mcv
    ];
end

% --- scenarios
if pregnant==1
    if scen==2; Vut0     = 250; mVv0=mVv0+500-Vut0; else Vut0=500; end
  
    Cut      = 0.75;
    Rutmc    = 7.5*mRp; Rutmc0=7.5*mRp;% 16.5*mRp; Rutmc0=16.5*mRp;% 
    Rutv     = 1.5*mRp; Rutv0=1.5*mRp;

    % extend segdata
    msegdata = [msegdata;
        nseg+1  nma        nnodes+1  Rutmc  0 ;
        nseg+2  nnodes+1   nmv        Rutv 0 ;
        ];

    % extend segment nrs
    sutmc  = nseg+1;
    sutv = nseg+2;

    nseg  =  max(msegdata(:,1));

    % extend noddata
    mnoddata = [ mnoddata;
        nnodes+1  Cut  Vut0  0  2 ;
        ] ;

    % extend node nrs
    nutmc = nnodes+1;

    nnodes=  max(mnoddata(:,1));
end

% --- breathing

mTresp   = 5000;     % [ms]      - respiratory period, adult 5s
mTi      = 2000;     % [ms]      - inspiration duration, adult 2s?
mTe      = 2000;     % [ms]      - expiration duration, adult 2s?
mpthmin  = -9*facHgkPa;       % [mmHg]    - minimum thoracic pressure
mpthmax  = -4*facHgkPa;       % [mmHg]    - maximum thoracic pressure   
mpabmin  = -2.5*facHgkPa;     % [mmHg]    - minimum abdominal pressure  
mpabmax  = 0;        % [mmHg]    - minimum abdominal pressure  

% --- regulation 

if Reg==1 && CAVmodel==1
    mtheta     = [ mRp  mVv0  mE_maxlv0    0  0 ];
    reg_input_m
elseif Reg==1 && CAVmodel==2
    mtheta     = [ mRp  mVv0  mTa0    0  0 ];
    reg_input_m
end

% process input

mnseg = size(msegdata,1);     % number of segments
mnnod = size(mnoddata,1);     % number of nodes
mnpc  = size(mcavdata,1);     % number of cavity pressures
mnpe  = size(mpext,1);        % number of external pressures

if Reg==1
    mntheta = size(mtheta,2); % number of regulated quantities
end

mp    = zeros(mnnod,1);       % set pressure array
mV    = zeros(mnnod,1);       % set volume array
mq    = zeros(nseg,1);       % set flow array

mR    = msegdata(:,4);        % segment resistances
mLt   = msegdata(:,5)/dt;        % segment inertances 

mC    = mnoddata(:,2);        % nodal complances
mV0   = mnoddata(:,3);        % nodal unstresses volumes

mlio = zeros(mnseg,mnnod);     % logical input-output matrix for determining nodal flow

for inod=1:mnnod
    for iseg=1:mnseg
        if msegdata(iseg,2)==inod
            mlio(iseg,inod)=-1;
        end
        if msegdata(iseg,3)==inod
            mlio(iseg,inod)=1;
        end
    end
end

mlpc = zeros(mnpc,mnnod); % logical cavity pressure selection matrix

for inod = 1:mnnod
    for ipc = 1:mnpc
        if mnoddata(inod,4)==ipc
            mlpc(ipc,inod)=1;
        end
    end
end

mllpc=sum(mlpc,1);

mlpe = zeros(mnpe,mnnod); % logical external pressure selection matrix

for inod = 1:mnnod
    for ipe = 1:mnpe
        if mnoddata(inod,5)==ipe
            mlpe(ipe,inod)=1;
        end
    end
end

if Reg==1
    mtheta = zeros(mntheta,nmax);
end