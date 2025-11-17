% x0=pom(1,1);
% if x0<0
%     pom(:,1)=pom(:,1)-x0;
%     pof(:,1)=pof(:,1)-x0;
%     fhr2(:,1)=fhr2(:,1)-x0;
%     toc2(:,1)=toc2(:,1)-x0;
% end

fhr3=60*fhr2(:,1);
fhr4=60e3*fhr2(:,1);
load 'hr3'
load 'toco3'
toco=2.5*[toco3;toco3]';
hrv=0.4*[hr3;hr3]';
time2spline = 0:250:1000*fhr3(end,1);
HFTspline = spline(fhr4(:,1),60./fhr2(:,2),time2spline);
HFTspline(1:7)=HFTspline(8);
Ffilthrv=fft(hrv);
Fwn=fft(rand(length(hrv),1));
hrv_new=ifft(Fwn'.*Ffilthrv);
factor=std(hrv)/std(hrv_new);
hrv=factor*hrv_new-factor*mean(hrv_new);
Ffilttoco=fft(toco);
Fwn=fft(rand(length(toco),1));
toco_new=ifft(Fwn'.*Ffilttoco);
factor=std(toco)/std(toco_new);
toco=factor*toco_new-factor*mean(toco_new);
tocospline = spline(time2spline,toco(1:length(time2spline)),60e3*toc2(:,1));

figure
subplot(2,1,1)
hold on
plot(time2spline/60e3,60./(HFTspline)+hrv(1:length(HFTspline)),'k')
xlabel('time [min]')
ylabel('FHR [bpm]')
set(gca,'xtick',[0:fhr3(end,1)/60e3+1])
set(gca,'ytick',[60:20:210])
axis([0,time2spline(end)/60e3,60,210])
daspect([0.5,20,1])
grid on
title('CTG')
subplot(2,1,2)
plot(toc2(:,1),tocospline+toc2(:,2),'k')
xlabel('time [min]')
ylabel('UP [mmHg]')
set(gca,'xtick',[0:fhr3(end,1)/60e3+1])
set(gca,'ytick',[0:25:100])
axis([0,time2spline(end)/60e3,0,100])
daspect([0.5,50,1])
grid on
% 
% figure; subplot(2,1,1)
% hold on; plot(pom(:,1),pom(:,2),'k')
% subplot(2,1,2)
% hold on; plot(pof(:,1),pof(:,2),'k')
