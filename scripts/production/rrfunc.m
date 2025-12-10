function error=rrfunc(kk)

global k1 k2 k3 k4 t C11 C1
k1=kk(1);
k3=kk(2);
k4=kk(3);

C1=k2-(k2-k1).*exp(k3.*exp(k4.*t));
%C1=110+365*(1-exp(-t./k1));
diff1=C1-C11;
error=[diff1];
