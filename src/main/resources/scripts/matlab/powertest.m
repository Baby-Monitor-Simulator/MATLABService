function N=powertest(P1,P2,alpha,beta)

q1=(1-P1);
q2=(1-P2);
k=1;
P=(P1+P2)/2;
q=1-P;
za=norminv(alpha/2);
zb=norminv(beta);

N=(sqrt(P*q*(1+1/k))*za+sqrt(P1*q1+P2*q2/k)*zb)^2/(P1-P2)^2;