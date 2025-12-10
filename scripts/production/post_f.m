% u_post
%
% postprocessing of output stored in arrays p, V and q
%
%-----------------------------------------------------

dd=60;
nj=j-1;
ico=ico-1;
tsav=tsav(1:nj)-dd;
fpsav=fpsav(:,1:nj)*1000/133;
fqsav=fqsav(:,1:nj);
fVsav=fVsav(:,1:nj);
tom=tom(1:ico);


time2=0;
for i=1:fcycle-2
time2=[time2, max(time2)+ftcycle(i)];
end
time2=time2-dd*1000;


fq = fq*60*1000;        % convert flows from ml/ms to ml/min
fqsav = fqsav*60*1000;    % convert flows from ml/ms to ml/min
if mother==0
    tsav = tsav/1000-dd;       % convert time from ms to s
end
tom=tom/1000-dd;

pao  = max(fp(nflv,:),fp(nfa,:));

%%% determine hemodynamics of last cycle

jmin    = j-1-floor(ftcycle(fcycle)/dt);
jmax    = j-1;

HR      = 60*1000/ftcycle(fcycle);
plvmin  = min(fpsav(nflv,jmin:jmax));
plvmax  = max(fpsav(nflv,jmin:jmax));
pamin   = min(fpsav(nfa,jmin:jmax));
pamax   = max(fpsav(nfa,jmin:jmax));
COsys   = mean(fqsav(sfa,jmin:jmax));
Vls     = max(fVsav(nflv,jmin:jmax))-min(fVsav(nflv,jmin:jmax));
Vlvmax  = max(fVsav(nflv,jmin:jmax));
Vlvmin  = min(fVsav(nflv,jmin:jmax));
ef      = Vls/Vlvmax;
qfmc    = mean(fqsav(sfp,jmin:jmax));
if umbilical==1; qumart  = mean(fqsav(summc,jmin:jmax)); end
if brain==1; qbrart  = mean(fqsav(sbrmc,jmin:jmax)); end

ftcycle=ftcycle(1:fcycle-1);
tm=nonzeros(tm)/1000-dd;
sim = 'normal fetus';

disp(' ')
disp(['Hemodynamics : ' sim ])
disp('--------------------------------------------------------- ')
disp(['Heart rate            : ' num2str( HR,'%10.0f' ) ' bpm ' ]);
disp(['LV pressure           : ' num2str( plvmin,'%10.0f' ) ' - ' num2str( plvmax,'%10.0f' ) ' mmHg'  ]);
disp(['Systemic pressure     : ' num2str( pamin,'%10.0f' ) ' - ' num2str( pamax,'%10.0f' ) ' mmHg'  ]);
disp(['Systemic CO           : ' num2str( COsys,'%10.0f' ) ' ml/min'  ]);
disp(['Vlv min               : ' num2str( Vlvmin,'%10.0f' ) ' ml '  ]);
disp(['Vlv max               : ' num2str( Vlvmax,'%10.0f' ) ' ml '  ]);
disp(['LV ef                 : ' num2str( ef )  ]);
disp(['Peripheral flow       : ' num2str( qfmc,'%10.0f' ) ' ml/min'  ]);
if umbilical==1; 
    disp(['Um art flow           : ' num2str( qumart,'%10.0f' ) ' ml/min'  ]);
end
if brain==1; 
    disp(['Br art flow           : ' num2str( qbrart,'%10.0f' ) ' ml/min'  ]);
end

figure
subplot(2,2,1)
hold on
plot(tsav,fpsav(nflv,:),tsav,fpsav(nfa,:))
legend('plv','psai')
xlabel('time [s]','FontSize',16);
ylabel('pressure [mmHg]','FontSize',16);
subplot(2,2,2)
hold on
plot(tsav,fqsav(sfv,:),tsav,fqsav(sfa,:),tsav,fqsav(sfp,:))
legend('qmv','qsai','qsp')
xlabel('time [s]','FontSize',16);
ylabel('flow [ml/min]','FontSize',16);
subplot(2,2,3)
hold on
plot(tsav,fVsav(nflv,:))
legend('Vlv')
xlabel('time [s]','FontSize',16);
ylabel('volume [ml]','FontSize',16);
subplot(2,2,4)
hold on
plot(fVsav(nflv,:),fpsav(nflv,:))
legend('LV')
xlabel('volume [ml]','FontSize',16);
ylabel('pressure [mmHg]','FontSize',16);

%Fetal cardiac check, see onefiber_f and _m for parameters ls and vs
% vs1=vs1(1:nj);
%  vs2=vs2(1:nj);
%  figure; plot(vs2)
%  hold on; plot(vs1,'r')
%   ls2=ls2(1:nj);
%  ls1=ls1(1:nj);
%   figure; plot(ls2)
%  hold on; plot(ls1,'r')
 
 

figure
set(gcf,'Paperposition',[ 0 0 8 16]);
subplot(2,1,1)
hold on
plot(tsav,fpsav(nflv,:),tsav,fpsav(nfa,:),tsav,fpsav(nfv,:))
legend('p_{lv}','p_{art}','p_{ven}')
xlabel('time [s]','FontSize',14);
ylabel('pressure [mmHg]','FontSize',14);
title('systemic circulation','FontSize',16)
subplot(2,1,2)
hold on
plot(tsav,fqsav(sfa,:),tsav,fqsav(nfv,:))
legend('q_{av}','q_{mv}')
xlabel('time [s]','FontSize',14);
ylabel('flow [ml/min]','FontSize',14);

if umbilical==1;
    figure
    set(gcf,'Paperposition',[ 0 0 8 16]);
    subplot(2,1,1)
    hold on
    plot(tsav,fpsav(num,:))
    legend('p_{um_{ven}}')
    xlabel('time [ms]','FontSize',14);
    ylabel('pressure [mmHg]','FontSize',14);
    title('umbilical circulation','FontSize',16)
    subplot(2,1,2)
    hold on
    plot(tsav,fqsav(sumv,:))
    legend('q_{um_{ven}}')
    xlabel('time [s]','FontSize',14);
    ylabel('flow [ml/min]','FontSize',14);
elseif umbilical==2;
    figure
    set(gcf,'Paperposition',[ 0 0 8 16]);
    subplot(2,1,1)
    hold on
    plot(tsav,fpsav(numa,:),tsav,fpsav(numv,:))
    legend('p_{um_{art}}','p_{um_{ven}}')
    xlabel('time [ms]','FontSize',14);
    ylabel('pressure [mmHg]','FontSize',14);
    title('umbilical circulation','FontSize',16)
    subplot(2,1,2)
    hold on
    plot(tsav,fqsav(suma,:),tsav,fqsav(sumv,:))
    legend('q_{um_{art}}','q_{um_{ven}}')
    xlabel('time [s]','FontSize',14);
    ylabel('flow [ml/min]','FontSize',14);
end

if brain==1;
    figure
    set(gcf,'Paperposition',[ 0 0 8 16]);
    subplot(2,1,1)
    hold on
    plot(tsav,fpsav(nbr,:))
    legend('p_{br_{ven}}')
    xlabel('time [s]','FontSize',14);
    ylabel('pressure [mmHg]','FontSize',14);
    title('brain circulation','FontSize',16)
    subplot(2,1,2)
    hold on
    plot(tsav,fqsav(sbrv,:))
    legend('q_{br_{ven}}')
    xlabel('time [s]','FontSize',14);
    ylabel('flow [ml/min]','FontSize',14);
    
    if convf==3
        if mother==1
            if umbilical==1
                figure; plot(tom(1:ico-1),PmO2(1:ico-1),tom(1:ico-1),Putven(1:ico-1),tom(1:ico-1),Pummc(1:ico-1),tom(1:ico-1),PfO2(1:ico-1),tom(1:ico-1),Pfbrmc(1:ico-1),tom(1:ico-1),Pfmc(1:ico-1),'g')
                legend('maternal arteries','intervillous space','villous capillaries','fetal arteries','fetal cerebral circulation','fetal microcirculation')
            elseif umbilical==2
                figure; plot(tom(1:ico-1),PmO2(1:ico-1),tom(1:ico-1),Putven(1:ico-1),tom(1:ico-1),Pummc(1:ico-1),tom(1:ico-1),PfO2(1:ico-1),tom(1:ico-1),Puma(1:ico-1),tom(1:ico-1),Pfbrmc(1:ico-1),tom(1:ico-1),Pfmc(1:ico-1),'g')
                legend('maternal arteries','intervillous space','villous capillaries','fetal arteries','fetal umbilical arteries','fetal cerebral circulation','fetal microcirculation')
            end
            title('Oxygen tensions')
            xlabel('Time [s]')
            ylabel('Oxygen pressure [mmHg]')
        end

        figure;
        plot(tm/60,60./(ftcycle/1000),'k')        
        title('fetal heart rate')
        xlabel('Time [s]')
        ylabel('FHR [bpm]')

        %CTG zonder variabiliteit
        figure
        subplot(2,1,1)
        hold on
        plot(tm/60,60./(ftcycle/1000),'k')
        xlabel('time [min]')
        ylabel('FHR [bpm]')
        set(gca,'xtick',[0:tsav(end)/60+1])
        set(gca,'ytick',[60:30:210])
        axis([0,tsav(end)/60,60,210])
        daspect([0.5,20,1])
        grid on
        title('CTG')
        subplot(2,1,2)
        plot(tsav(1:nj)/60,fackPaHg*fpcon(1:nj),'k')
        xlabel('time [min]')
        ylabel('uterine pressure [mmHg]')
        set(gca,'xtick',[0:tsav(end)/60+1])
        set(gca,'ytick',[0:20:120])
        axis([0,tsav(end)/60,0,120])
        daspect([0.5,50,1])
        grid on

        if scen==1
            figure
            subplot(4,1,1)
            hold on;
            plot(tsav(1:nj)/60,fackPaHg*fpcon(1:nj),'k')
            ylabel('uterine pressure [mmHg]')
            axis([0,3,0,120])
            subplot(4,1,2)
            plot(tom/60,60e6*a(8,:),'k')
            ylabel('cerebral flow [ml/min]')
            axis([0,3,0,200])
            subplot(4,1,3)
            plot(tom/60,Pfbrmc(1:ico),'k')
            ylabel('cerebral pO_2 [mmHg]')
            axis([0,3,10,17])
            subplot(4,1,4)
            plot(tm/60,60./(ftcycle/1000),'k')
            xlabel('time [min]')
            ylabel('FHR [bpm]')
            axis([0,3,60,210])
        elseif scen==2
            figure
            subplot(5,1,1)
            hold on;
            plot(tsav(1:nj)/60,fackPaHg*fpcon(1:nj),'k')
            ylabel('p_{uterus} [mmHg]')
            axis([0,3,0,120])
            subplot(5,1,2)
            plot(tom/60,60e6*a(5,1:ico),'k')
            ylabel('q_{uterus} [ml/min]')
            axis([0,3,0,1000])
            subplot(5,1,3)
            plot(tom/60,PfO2(1:ico),'k')
            ylabel('p_aO_2 [mmHg]')
            axis([0,3,10,20])
            subplot(5,1,4)
            plot(tom/60,mfpart(1:ico),'k')
            ylabel('MAP [mmHg]')
            axis([0,3,35,55])
            subplot(5,1,5)
            plot(tm/60,60./(ftcycle/1000),'k')
            xlabel('time [min]')
            ylabel('FHR [bpm]')
            axis([0,3,60,210])
       elseif scen==2.1
            figure
            subplot(5,1,1)
            hold on;
            plot(tm/60,60./(ftcycle/1000),'k')
            xlabel('time [min]')
            ylabel('FHR [bpm]')
            axis([-1,10,100,150])
            subplot(5,1,2)
            plot(tom/60,nonzeros(100./(1+(10400./(PfO2.^3+150*PfO2)))),'k')
            ylabel('SaO_{2} [%]')
            axis([-1,10,0,100])
            subplot(5,1,3)
            plot(tom/60,60e6*a(7,:),'k')
            ylabel('q_{peripheral} [ml/min]')
            axis([-1,10,800,1000])
            subplot(5,1,4)
            plot(tom/60,Pfmc(1:ico),tom/60,PfO2(1:ico),'k')
            ylabel('peripheral pO_2 [mmHg]')
            axis([-1,10,0,20])
            subplot(5,1,5)
            plot(tsav(1:nj)/60,round(fackPaHg*fpcon(1:nj)./max(fackPaHg*fpcon)),'k')
            ylabel('uterine flow stagnation on/off')
            axis([-1,10,0,2])
        elseif scen==3||scen==3.1
            figure
            subplot(7,1,1)
            hold on;
            plot(tsav(1:nj)/60,fackPaHg*fpcon(1:nj),'k')
            ylabel('p_{uterus} [mmHg]')
            axis([0,3,0,120])
            subplot(7,1,2)
            plot(tom/60,60e6*a(7,:)',tom/60,60e6*a(8,:)')
            legend('q_{um,a}','q_{um,v}')
            ylabel('q_{um} [ml/min]')
            axis([0,3,0,1000])
            subplot(7,1,3)
            plot(tom/60,1e6*a(14,:)','k')
            ylabel('V_{ven} [ml]')
            axis([0,3,130,170])
            subplot(7,1,4)
            plot(tom/60,mfpart(1:ico),'k')
            ylabel('MAP [mmHg]')
            axis([0,3,30,45])
            subplot(7,1,5)
            plot(tom/60,Puma(1:ico),tom/60,Pummc(1:ico))
            legend('pO_{um,a}','pO_{um,v}')
            ylabel('p_{um,a}O_2 [mmHg]')
            axis([0,3,0,50])
            subplot(7,1,6)
            plot(tom/60,1e3*CAf(1:ico))
            ylabel('CA_a [ng/ml]')
            axis([0,3,0,20])
            subplot(7,1,7)
            plot(tm/60,60./(ftcycle/1000),'k')
            xlabel('time [min]')
            ylabel('FHR [bpm]')
            axis([0,3,60,210])
        end

        figure
        subplot(2,2,2)
        hold on;
        plot(fVsav(nflv,jmin-2:jmax),fpsav(nflv,jmin-2:jmax),'k')
        ylabel('cardiac pressure [mmHg]')
        xlabel('ventricular volume [ml]')
        axis([0,20,0,70])
        subplot(2,2,1); hold on;
        plot(mVlv,mplv,'k')
        ylabel('cardiac pressure [mmHg]')
        xlabel('ventricular volume [ml]')
        axis([0,200,-10,120])
        subplot(2,2,4)
        plot(ls1(jmin-2:jmax),fackPaHg*vs1(jmin-2:jmax),'k')
        ylabel('cardiac stress [mmHg]')
        xlabel('l_s [um]');  
        axis([1.7,2.7,0,180]);
        subplot(2,2,3)
        plot(mls,mvs,'k')
        ylabel('cardiac stress [mmHg]')
        xlabel('l_s [um]')
        axis([1.7,2.7,0,320])

%         load 'hrv'
%         load 'toco'
%         toco=1.9*[toco,toco];
%         hrv=1*[hrv,hrv];
%         time2spline = 0:250:1000*tsav(nj);
%         HFTspline = spline(time2,ftcycle/1000,time2spline);
%         HFTspline(1:7)=HFTspline(8);
%         Ffilthrv=fft(hrv);
%         Fwn=fft(rand(length(hrv),1));
%         hrv_new=ifft(Fwn'.*Ffilthrv);
%         factor=std(hrv)/std(hrv_new);
%         hrv=factor*hrv_new;
%         Ffilttoco=fft(toco);
%         Fwn=fft(rand(length(toco),1));
%         toco_new=ifft(Fwn'.*Ffilttoco);
%         factor=std(toco)/std(toco_new);
%         toco=factor*toco_new;
%         tocospline = spline(time2spline,toco(1:length(time2spline)),1000*tsav(1:nj));
% 
%         
%         figure
%         subplot(2,1,1)
%         hold on
%         plot(time2spline/60e3,60./(HFTspline+hrv(1:length(HFTspline))),'k')
%         xlabel('time [min]')
%         ylabel('FHR [bpm]')
%         set(gca,'xtick',[0:time2(end)/60e3+1])
%         set(gca,'ytick',[60:20:210])
%         axis([0,time2spline(end)/60e3,60,210])
%         daspect([0.5,20,1])
%         grid on
%         title('CTG')
%         subplot(2,1,2)
%         plot(tsav(1:nj)/60,tocospline+fackPaHg*fpcon(1:nj),'k')
%         xlabel('time [min]')
%         ylabel('UP [mmHg]')
%         set(gca,'xtick',[0:time2(end)/60e3+1])
%         set(gca,'ytick',[0:25:100])
%         axis([0,time2spline(end)/60e3,0,100])
%         daspect([0.5,50,1])
%         grid on
        
        load 'hr3'
        load 'toco3'
        toco=1*[toco3;toco3]';
        hrv=0.4*[hr3;hr3]';
        time2spline = 0:250:1000*tsav(nj);
        HFTspline = spline(time2,ftcycle/1000,time2spline);
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
        tocospline = spline(time2spline,toco(1:length(time2spline)),1000*tsav(1:nj));
        
        figure
        subplot(2,1,1)
        hold on
        plot(time2spline/60e3,60./(HFTspline)+hrv(1:length(HFTspline)),'k')
        xlabel('time [min]')
        ylabel('FHR [bpm]')
        set(gca,'xtick',[0:time2(end)/60e3+1])
        set(gca,'ytick',[60:20:210])
        axis([0,time2spline(end)/60e3,60,210])
        daspect([0.5,20,1])
        grid on
        title('CTG')
        subplot(2,1,2)
        plot(tsav(1:nj)/60,tocospline+fackPaHg*fpcon(1:nj),'k')
        xlabel('time [min]')
        ylabel('UP [mmHg]')
        set(gca,'xtick',[0:time2(end)/60e3+1])
        set(gca,'ytick',[0:25:100])
        axis([0,time2spline(end)/60e3,0,100])
        daspect([0.5,50,1])
        grid on
        
        ft=nonzeros(ftcycle)/1000;
        nT=length(ft);
        for k=1:nT
            tT(k)=sum(ft(1:k));      % 'sample times' of T
        end
        ft=60./(nonzeros(ftcycle)/1000)-135;
        Fs  = 4;                    % sample frequency
        ts  = 1:1/Fs:(tT(nT));      % new sample times
        Ts  = interp1(tT,ft,ts);     % resampled T
        nTs = length(Ts);
        % -- Fourier analysis
        NFFT = 2^nextpow2(nTs);
        Y    = fft(Ts,NFFT);
        f    = Fs/2*linspace(0,1,NFFT/2);
        % -- Hanning window
        L        = 60*Fs;           % length (60s) of subset on which FFT is calculated
        window   = hann(L);         % standard Hanning window
        noverlap = 0.5*L;           % 75% overlap
        S        = spectrogram(Ts-mean(Ts),window,noverlap,NFFT,Fs);
        Smean    = mean(abs(S'));     % mean amplitude over time
        Spower   = mean(abs(S').^2);  % power of mean amplitude over time
        figure
        plot(f,Spower(1:end-1))
        xlabel('Frequency (Hz)','FontSize',16)
        ylabel('PSD T_{cycle}','FontSize',16)
        xlim([0,1.5])
    end
end

% figure;
% plot(tom(1:ico-1),Cm(1:ico-1),'m',tom(1:ico-1),Cutven(1:ico-1),'r'); hold on; plot(tom(1:ico-1),Cummc(1:ico-1),'k'); plot(tom(1:ico-1),Cfa(1:ico-1)); plot(tom(1:ico-1),Cfbr(1:ico-1),'c'); plot(tom(1:ico-1),Cfmc(1:ico-1),'g')
% title('Oxygen tensions')
% xlabel('Time [s]')
% ylabel('Oxygen pressure [mmHg]')
% legend('maternal arteries','intervillous space','villous capillaries','fetal arteries','fetal cerebral circulation','fetal microcirculation')
% 

% --- end u_post