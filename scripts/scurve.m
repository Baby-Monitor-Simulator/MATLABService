function [x,y]=scurve(min,max,n,k,x);

y=(min+max*exp((x-n)./k))./(1+exp((x-n)./k));
figure(6); hold on;
plot(x,y,'g'); hold on;
    