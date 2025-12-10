% u_conv
%
% output: parameter convergence = 1 (yes) or 0 (no)
%
% -------------------------------------------------

jmin          = j-floor(ftcycle/dt)+1;
fVlvs(fcycle)  = max(fVsav(nflv,jmin:j))-min(fVsav(nflv,jmin:j));  % LV stroke volume for the last cycle

if icycle>2
    Vdif = fVlvs(fcycle)-fVlvs(fcycle-1);
    Vdif2 = fVlvs(fcycle)-fVlvs(fcycle-2);

    Verror=max(abs(Vdif))/fVlvs(fcycle);
    Verror2=max(abs(Vdif2))/fVlvs(fcycle);
    disp(['fCycle: ' num2str( fcycle,'%6.0f' ) ' - Error: ' num2str( Verror,'%10.5f' ) ]);
    if Verror<Verrormax && convf==0
        convf = 1;
        disp('fEquilibrium has been reached.')
        disp('Start of regulation.')
        disp(' ')
        convcycle=fcycle;
        fcount=0;
    elseif Verror2<Verrormax && convf==0
        convf = 1;
        disp('fEquilibrium has been reached.')
        disp('Start of regulation.')
        disp(' ')
        convcycle=fcycle;
        fcount=0;
    elseif Verror<Verrormax2 && convf==1
        fcount=fcount+1;
        if fcount==5
            convf = 2;
            disp('fEquilibrium with regulation has been reached.')
            disp(' ')
            convcycle=fcycle;
        end
    elseif Verror2<Verrormax2 && convf==1
        fcount=fcount+1;
        if fcount==5
            convf = 2;
            disp('fEquilibrium with regulation has been reached.')
            disp(' ')
            convcycle=fcycle;
        end
    end
elseif fcycle==ncyclemax
    disp('>>> No equilibrium has been reached.')
end

% end u_conv