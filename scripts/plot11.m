dat='v';
lin='k--';
LW=2;
nn=3;
n=3;


        figure(17)
        hold on;
        subplot(5,nn,n)
        hold on;
        plot(eval([dat '.tsav(1:' dat '.nj)/60']),eval([ dat '.fackPaHg*' dat '.fpcon(1:' dat '.nj)']), eval('lin'), 'LineWidth', LW)
        %ylabel('p_{ut} [mmHg]')
        axis([0,3,0,120])
        subplot(5,nn,nn+n)
        hold on;
        plot(eval([dat '.tom/60']),eval(['60e6*' dat '.a(5,:)']),eval('lin'), 'LineWidth', LW)
        %ylabel('q_{ut} [ml/min]')
        axis([0,3,0,1000])
        subplot(5,nn,2*nn+n)            
        hold on;
        plot(eval([dat '.tom/60']),eval([dat '.PfO2(1:' dat '.ico)']),eval('lin'), 'LineWidth', LW)
        %plot(eval([dat '.tom/60']),eval([dat '.Pfbrmc(1:' dat '.ico)']),eval('lin'), 'LineWidth', LW)
        %ylabel('p_aO_2 [mmHg]')
        axis([0,3,10,20])
        subplot(5,nn,3*nn+n)
        hold on;
        y=sffilt('mean',eval([dat '.mfpart(1:' dat '.ico)']),25);
        plot(eval([dat '.tom/60']),y,eval('lin'), 'LineWidth', LW)
        %ylabel('MAP [mmHg]')
        axis([0,3,36,43])
        subplot(5,nn,4*nn+n)
        hold on;
        plot(eval([dat '.tm/60']),eval(['60./(' dat '.ftcycle/1000)']),eval('lin'), 'LineWidth', LW)
        xlabel('time [min]')
        %ylabel('FHR [bpm]')
        axis([0,3,90,170])

