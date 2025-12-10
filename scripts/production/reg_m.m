% u_regulation
%
% output : model parameters adapted 
%          in response to regulatory system
%
% ---------------------------- 

n1      = [1:3];                % Vu, R and Emax    
n2      = [4:5];                % Tv and Ts

jD      = mD_theta/dt;           % delay in time increments

pin     = mpart(j-1-jD)-mpsan;      % relevant deviation in p, accounting for delay
pein    = mpextsav(1,j-1-jD);       %pext for every node at time of t-delay
VL      = 1.9 - 0.1*pein;
Vin     = VL-mVLn;               % relevant deviation in V, accounting for delay

x       = 0;
if BaroReg==1
    x   = mGa_theta.*pin;
end
if LungReg==1
    x   = x+mGp_theta.*mVin;
end

% Vu, R and Emax feedback

xk1         = x(n1)./mk_theta(n1);
sig1        = (mmin_theta(n1)+mmax_theta(n1).*exp(xk1))./(1+exp(xk1));
dthetadt    = (1./mtau_theta(n1)).*(sig1-(mtheta(n1,j-1))');

mtheta(n1,j) = mtheta(n1,j-1)+dthetadt'*dt;

% T feedback  

dxdt            = (1./mtau_theta(n2)).*((x(n2))-(mtheta(n2,j-1))');
mtheta(n2,j)    = mtheta(n2,j-1)+dxdt'*dt;
xT              = sum(mtheta(n2,j));
mTT             = (mmin_T+mmax_T*exp(xT/mkT))/(1+exp(xT/mkT));
mtcycle(icycle) = dt*round(mTT/dt);

% superimposed variation of R_ep, white noise between fRepmin and fRepmax
% NOTE: noise is not stored in used in theta(1,j) and therefore 
% does not enter feedback at next time step!

mRp_new=mR(smp);
if RpVar==1
    mdRp(j)=mRp1*sum(sin(2*pi*mfRp.*t(j)/1000+mphiRp))/mnRp;
    mRp_new=mtheta(1,j)+mdRp(j); 
    if mRp_new>mmax_Rp
        mRp_new=mmax_Rp;
    elseif mRp_new<mmin_Rp
        mRp_new=mmin_Rp;
    end
end

% update segment and cavity properties
mRp_n(j)=mRp_new;
mR(smp)       = mRp_n(j);%theta(1,j);
mR(sutmc)     = 7.5*mRp_n(j);%theta(1,j);
mV0(nmv)      = mtheta(2,j);
if CAVmodel==1
    mcavdata(1,5) = mtheta(3,j);
elseif CAVmodel==2 && (t(j)-tstart(icycle))>mtcycle(icycle)
    mcavdata(1,9) = mtheta(3,j);
end

% end u_reg