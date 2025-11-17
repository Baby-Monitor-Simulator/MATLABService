function [x,y]=ecurve(max,k,x);

y=max*(1-exp(-(x)./k));
figure(22)
plot(x,y); hold on;
    