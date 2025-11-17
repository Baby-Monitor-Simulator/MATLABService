% u_conv
%
% output: parameter convergence = 1 (yes) or 0 (no)
%
% -------------------------------------------------

jmin          = jstart(icycle);
Vlvs(icycle)  = max(mVsav(nmlv,jmin:j))-min(mVsav(nmlv,jmin:j));  % LV stroke volume for the last cycle

if icycle>1 
    Vdif(1) = Vlvs(icycle)-Vlvs(icycle-1);
    Verror=max(abs(Vdif))/Vlvs(icycle);
    disp(['mCycle: ' num2str( icycle,'%6.0f' ) ' - Error: ' num2str( Verror,'%10.5f' ) ]);
    if Verror<Verrormax && convm==0
        convm = 1; 
        disp('mEquilibrium has been reached.')
        disp('Start of regulation.')
        disp(' ')
        convcycle=icycle;
        mcount=0;
    elseif Verror<Verrormax2 && convm==1
        mcount=mcount+1;
        if mcount==5
            convm = 2;
            disp('mEquilibrium with regulation has been reached.')
            disp(' ')
            convcycle=icycle;
        end
    elseif icycle==ncyclemax
        disp('>>> mNo equilibrium has been reached.')
    end
end
% end u_conv