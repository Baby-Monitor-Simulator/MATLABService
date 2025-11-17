% u_regulation
%
% output : model parameters adapted 
%          in response to regulatory system
%
% ---------------------------- 

n1      = [1:3];                % Vu, R and Emax    
n2      = [4:5];                % Tv and Ts

jD      = fD_theta/dt;           % delay in time increments

if j>max(jD)+2
    pin     = fpart(j-1-jD)-fpsan;      % relevant deviation in p, accounting for delay
    pein    = fpextsav(1,j-1-jD);       %pext for every node at time of t-delay
    VL      = 1.9 - 0.1*pein;
    Vin     = VL-fVLn;               % relevant deviation in V, accounting for delay

    x       = 0;
    if fBaroReg==1
        x   = fGa_theta.*pin;
    end
    if fLungReg==1
        x   = x+fGp_theta.*Vin;
    end

    % Vu, R and Emax feedback

    xk1         = x(n1)./fk_theta(n1);
    sig1        = (fmin_theta(n1)+fmax_theta(n1).*exp(xk1))./(1+exp(xk1));
    dthetadt    = (1./ftau_theta(n1)).*(sig1-(ftheta(n1,j-1))');
    ftheta(n1,j) = ftheta(n1,j-1)+dthetadt'*dt;


    % T feedback  

    dxdt            = (1./ftau_theta(n2)).*((x(n2))-(ftheta(n2,j-1))');
    ftheta(n2,j)    = ftheta(n2,j-1)+dxdt'*dt;
    xT              = sum(ftheta(n2,j));
    fTT             = (fmin_T+fmax_T*exp(xT/fkT))/(1+exp(xT/fkT));
    ftcycleupdate(j)= dt*round(fTT/dt);

    % superimposed variation of R_ep, white noise between fRepmin and fRepmax
    % NOTE: noise is not stored in used in theta(1,j) and therefore 
    % does not enter feedback at next time step!

    fRp_new=fR(sfp);
    if fRpVar==1 && icycle>oxcycle
        fdRp(j)=fRp1*sum(sin(2*pi*ffRp.*t(j)/1000+fphiRp))/fnRp;
        fRp_new=fRp+fdRp(j); 
        if fRp_new>fmax_Rp
            fRp_new=fmax_Rp;
        elseif fRp_new<fmin_Rp
            fRp_new=fmin_Rp;
        end
    end

    % update segment and cavity properties
    fRp_n(j)=ftheta(1,j);%fRp_new;
    fR(sfp)       = fRp_n(j);%theta(1,j);
    fR(sfa)       = 0.05*fR(sfp);%theta(1,j);
    fR(sfv)       = 0.02*fR(sfp);%theta(1,j);
    fR(suma)      = 3.49*fR(sfp);%theta(1,j);
    fR(summc)     = 0.01*fR(sfp);%theta(1,j);
    fR(sbra)      = 6.99*fR(sfp);%theta(1,j);
    fR(sbrmc)     = 0.01*fR(sfp);%theta(1,j);
    fV0(nfv)      = ftheta(2,j);
    
    if CAVmodel==1
        fcavdata(1,5) = ftheta(3,j);
    elseif CAVmodel==2 && (t(j)-ftstart(fcycle))>ftcycle(fcycle)
        fcavdata(1,9) = ftheta(3,j);
    end
end
% end u_reg