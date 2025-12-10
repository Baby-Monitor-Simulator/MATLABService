% u_pext
%
% output : npe external pressures 
%
% ---------------------------- 

if Breathing==1 && convm==1

    tr = t(j)-floor(t(j)/mTresp)*mTresp;

    % thoracic pressure

    if tr<=mTi
        mpth = mpthmax+(mpthmin-mpthmax)*(tr/mTi);
    elseif tr>mTi && tr<(mTi+mTe)
        mpth = mpthmax+(mpthmin-mpthmax)*((mTi+mTe-tr)/mTe);
    else
        mpth = mpthmax;
    end

    % abdominal pressure

    if tr <= mTi/2;
        mpab = mpabmax+2*(mpabmin-mpabmax)*(tr/mTi);
    elseif tr > mTi/2 && tr <= mTi
        mpab = mpabmin;
    elseif tr >= mTi && tr < mTi+mTe
        mpab = mpabmax+(mpabmin-mpabmax)*((mTi+mTe-tr)/mTe);
    else
        mpab = mpabmax;
    end

else

    mpth = mpthmax;
    mput = mpabmax;


end

mpext = [ mpth; fpcon(j-1) ];

% end u_pext