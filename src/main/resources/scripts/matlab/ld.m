% Update changes in Late Decelerations
Pfbrmc0=14.8;
Pfbrmc00=11;
k=1.7;
c1=40; %1.5 gebruikt voor no UPI, anders 40
c2=0.9;
fpmax=10;
reg=0;

if con==0
    con=1;
    %scaledepth(con)= 1;%normrnd(15,5)/30;                % Random normalised gaussian depth of decel 
    randinter(con)=1000*round(180/dt);           % Random gaussian contraction interval in ic's
    contrstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
    contrlength(con)=1000*round(60/dt);          % Random gaussian contraction length in ic's
    %rcon=normrnd([0,0],2000/dt);
    conrise(con)=round(0.5*contrlength(con));
    condecay(con)=round(0.5*contrlength(con));
    j_contrstart(con)=round(100*mtcycle(1));               % Start time of contraction after about 30 maternal beats
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction
end

% Uterine pressure (fpcon)
if duty==0
    if j>j_contrstart(con) && j<=j_contrstart(con)+conrise(con);%j_contrstop(con)
        %fpcon(j)=fprest+contrstrength(con)*sin(pi/(contrlength(con))*(j-j_contrstart(con))).^2;
        fpcon(j)=fprest+contrstrength(con)*sin(pi/(2*conrise(con))*(j-j_contrstart(con))).^2;
    elseif j>j_contrstart(con)+conrise(con) %&& j<j_contrstart(con)+conrise(con)+condecay(con)
        fpcon(j)=fprest+contrstrength(con)-contrstrength(con)*sin(pi/(2*condecay(con))*(j-(j_contrstart(con)+conrise(con)))).^2;
    end
end

Slope=5e3/dt;%15e3/dt;
if duty==1 && j>j_contrstart(con) && j<=j_contrstop(con)
    fpcon(j)=fprest+contrstrength(con);
end
if duty==2 && j>j_contrstart(con) && j<=j_contrstop(con)
    if j>j_contrstart(con) && j<=j_contrstart(con)+Slope
        fpcon(j)=fprest+(contrstrength(con)/Slope)*(j-j_contrstart(con));
    elseif j>j_contrstart(con)+Slope && j<=j_contrstop(con)-Slope
        fpcon(j)=fprest+contrstrength(con);
    elseif j>j_contrstop(con)-Slope
        fpcon(j)=fprest+contrstrength(con)-(contrstrength(con)/Slope)*(j-(j_contrstop(con)-Slope));   
    end
end

% Uterine resistance under influence of fpcon
mR(sutmc)=(Rutmc+c1*Rutmc0*exp((fpcon(j)-fpmax)/c2))/(1+exp((fpcon(j)-fpmax)/c2));
mR6(j)=mR(sutmc);

% Fetal systemic resistance (from regulation)
fRR(j)=fR1(ico-1);
if convf==3; fR(sfp)=fRR(j); end
    
% New compression calculation
if reg==0 && j==j_contrstop(con)
        con=con+1;                                              % Contraction number
        %scaledepth(con)=normrnd(scaledepth(1)*30,3)/30;                    % Random normalised gaussian depth of decel 
        randinter(con)=round(normrnd(randinter(1)*dt,10000)/dt);               % Random gaussian contraction interval in j's
        contrstrength(con)=normrnd(contrstrength(1),10*facHgkPa);  
        contrlength(con)=round(normrnd(contrlength(1)*dt,10000)/dt);          % Random gaussian contraction length in j's
        %rcon=normrnd([0,0],2000/dt);
        conrise(con)=round(0.5*contrlength(con));
        condecay(con)=round(0.5*contrlength(con));
        j_contrstart(con)=j_contrstart(con-1)+randinter(con); % Start time of contraction
        j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction                                       
elseif reg==1 && j==j_contrstop(con) && con<11
        con=con+1;                                              % Contraction number
        randinter(con)=1000*round(180/dt);           % Random gaussian contraction interval in ic's
        contrstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
        contrlength(con)=1000*round(90/dt);          % Random gaussian contraction length in j's
        conrise(con)=round(0.5*contrlength(con));
        condecay(con)=round(0.5*contrlength(con));
        j_contrstart(con)=100000000000000000;%j_contrstart(con-1)+randinter(con-1); % Start time of contraction
        j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction                                       
elseif reg==2 && j==j_contrstop(con)
        con=con+1;                                              % Contraction number
        randinter(con)=1000*round(120/dt);           % Random gaussian contraction interval in ic's
        if con>=7 && con<10; contrlength(con)=1000*round(120/dt); randinter(con)=1000*round(240/dt); end
        contrstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
        if con>=2 && con<4; contrstrength(con)=35*facHgkPa; end
        contrlength(con)=1000*round(60/dt);          % Random gaussian contraction length in j's
        if con>=10 && con<13; contrlength(con)=1000*round(120/dt); randinter(con)=1000*round(240/dt);end
        conrise(con)=round(0.5*contrlength(con));
        condecay(con)=round(0.5*contrlength(con));
        j_contrstart(con)=j_contrstart(con-1)+randinter(con-1); % Start time of contraction
        j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction                                       
end
    