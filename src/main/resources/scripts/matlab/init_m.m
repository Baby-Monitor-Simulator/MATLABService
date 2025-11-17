% u_init
%
% output: initial values p, V and q arrays
%
% ----------------------------------------

mp(1)    = 0;
mp(2)    = 12;

mV(1)    = mV0lv;
mV(2)    = mCa*mp(2)+mVa0;

mV(3)    = mVtotal-mV(1)-mV(2);
mp(3)    = (mV(3)-mVv0)/mCv;

if Reg==1
   mtheta(:,j) = mtheta0;
end

% end u_init