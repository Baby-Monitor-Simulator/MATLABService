dat='nl';
lin='k';
LW=1;
nn=3;
n=1;
            
figure(18)

subplot(3,nn,n)
hold on; 
plot(eval([dat '.tom(1:' dat '.ico-1)/60']),eval([dat '.Putven(1:' dat '.ico-1)']), eval('lin'), 'LineWidth', LW+3)
plot(eval([dat '.tom(1:' dat '.ico-1)/60']),eval([dat '.Pummc(1:' dat '.ico-1)']), eval('lin'), 'LineWidth', LW+2)
axis([0,3,20,50])
%ylabel('pO_2 [mmHg]')
%legend('intervillous space','villous capillaries')

subplot(3,nn,nn+n)
hold on;
plot(eval([dat '.tom(1:' dat '.ico-1)/60']),eval([dat '.PfO2(1:' dat '.ico-1)']), eval('lin'), 'LineWidth', LW+1.5)
plot(eval([dat '.tom(1:' dat '.ico-1)/60']),eval([dat '.Pfbrmc(1:' dat '.ico-1)']), eval('lin'), 'LineWidth', LW+1)
plot(eval([dat '.tom(1:' dat '.ico-1)/60']),eval([dat '.Pfmc(1:' dat '.ico-1)']), eval('lin'), 'LineWidth', LW)
axis([0,3,6,19])
%ylabel('pO_2 [mmHg]')
%legend('fetal arteries','fetal cerebral circulation','fetal microcirculation')


subplot(3,nn,2*nn+n)
hold on;
plot(eval([dat '.tom/60']),eval(['60e6*' dat '.a(6,:)']),eval('lin'), 'LineWidth', LW+2)
plot(eval([dat '.tom/60']),eval(['60e6*' dat '.a(8,:)']),eval('lin'), 'LineWidth', LW+1)
plot(eval([dat '.tom/60']),eval(['60e6*' dat '.a(7,:)']),eval('lin'), 'LineWidth', LW)
%ylabel('q_{ut} [ml/min]')
axis([0,3,0,1000])
%legend('umbilical circulation','cerebral circulation','systemic circulation')