% u_pext
%
% output : npe external pressures 
%
% ---------------------------- 

if fBreathing==1 && convf==2

    tr = t(j)-floor(t(j)/fTresp)*fTresp;

    % thoracic pressure

    if tr<=fTi
        fpth = fpthmax+(fpthmin-fpthmax)*(tr/fTi);
    elseif tr>fTi && tr<(fTi+fTe)
        fpth = fpthmax+(fpthmin-fpthmax)*((fTi+fTe-tr)/fTe);
    else
        fpth = fpthmax;
    end

    % abdominal pressure

    if tr <= fTi/2;
        fpab = fpabmax+2*(fpabmin-fpabmax)*(tr/mTi);
    elseif tr > fTi/2 && tr <= fTi
        fpab = fpabmin;
    elseif tr >= fTi && tr < fTi+fTe
        fpab = fpabmax+(fpabmin-fpabmax)*((fTi+fTe-tr)/fTe);
    else
        fpab = fpabmax;
    end

else

    fpth = fpthmax;
    fpab = fpabmax;


end

fpext = [ 0; 0 ];



% end u_pext