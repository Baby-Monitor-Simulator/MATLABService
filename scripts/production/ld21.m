% Update changes in Late Decelerations
Pfbrmc0=14.8;
Pfbrmc00=11;
k=1.7;
c1=40; %1.5 gebruikt voor no UPI, anders 40
c2=0.9;
fpmax=10;

if con==0
    con=1;
    randinter(con)=1000*round(180/dt);           % Random gaussian contraction interval in ic's
    contrstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
    contrlength(con)=1000*round(90/dt);          % Random gaussian contraction length in ic's
    j_contrstart(con)=round(60*mtcycle(1));               % Start time of contraction after about 30 maternal beats
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction
end

Slope=15e3/dt;
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
if con<=10
    if j==j_contrstop(con)
            con=con+1;                                              % Contraction number
            randinter(con)=1000*round(180/dt);           % Random gaussian contraction interval in ic's
            contrstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
            contrlength(con)=1000*round(90/dt);          % Random gaussian contraction length in j's
            j_contrstart(con)=j_contrstart(con-1)+randinter(con-1); % Start time of contraction
            j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction                                       
    end
end
    