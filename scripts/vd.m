% Update changes in Variable Decelerations
fpcon0=11;% 70*facHgkPa;  %fpcon = externe druk
fpcon1=12; %100*facHgkPa;

c_R1=3e3; % max waarbij vat dicht zit.
Rumvmax=c_R1*Rumv;
Rumamax=c_R1*Ruma;
c_R2=0.5; %steilheid
DeltaRumv=0*Rumvmax;
DeltaRuma=0*Rumamax;

r=1/2;
d=1/r-1;
reg=2;
if con==0
    con=1;                                                  % Contraction number
    randinter(con)=1000*round(120/dt);           % Random gaussian contraction interval in ic's
    contrstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
    contrlength(con)=1000*round(60/dt);          % Random gaussian contraction length in ic's
    conrise(con)=round(r*contrlength(con));
    condecay(con)=d*conrise(con);%round(0.5*contrlength(con)+max(rcon));
    j_contrstart(con)=round(82.5e3/dt);%round(55*mtcycle(1));               % Start time of contraction after about 30 maternal beats
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction
    persinter(con)=1000*round(3/dt);           % Random gaussian contraction interval in ic's
    persstrength(con)=110*facHgkPa;                  % Random gaussian contraction strength in mmHg
    perslength(con)=1000*round(15/dt);          % Random gaussian contraction length in ic's
    persrise(con)=round(r*perslength(con));
    persdecay(con)=d*persrise(con);%round(0.5*contrlength(con)+max(rcon));
    j_persstart(con)=j_contrstart(con)+1000*round(8/dt);               % Start time of contraction after about 30 maternal beats
    j_persstop(con)=j_persstart(con)+perslength(con);  % Stop time of contraction
    fact=rand(1:2);
    %W_vd(con)=(round(fact(1)/.5)-1)*fact(2); %(value between -1 and 1)
    W_v=1;
    W_vd(con)=0.7; 
end
    %fprest=fpcon(1) fpcon = externe druk
    % Umbilical pressure 
if j>j_contrstart(con) && j<=j_contrstart(con)+conrise(con);%j_contrstop(con)
    %fpcon(j)=fprest+contrstrength(con)*sin(pi/(contrlength(con))*(j-j_contrstart(con))).^2;
    fpcon(j)=fprest+contrstrength(con)*sin(pi/(2*conrise(con))*(j-j_contrstart(con))).^2;
elseif j>j_contrstart(con)+conrise(con) && j<=j_contrstop(con)
    fpcon(j)=fprest+contrstrength(con)-contrstrength(con)*sin(pi/(2*condecay(con))*(j-(j_contrstart(con)+conrise(con)))).^2;
end

Slope=15e3/dt;
if duty==1 && j>j_contrstart(con) && j<=j_contrstop(con)
    fpcon(j)=fprest+contrstrength(con);
elseif duty==2 && j>j_contrstart(con) && j<=j_contrstop(con)
    if j>j_contrstart(con) && j<=j_contrstart(con)+Slope
        fpcon(j)=fprest+(contrstrength(con)/Slope)*(j-j_contrstart(con));
    elseif j>j_contrstart(con)+Slope && j<=j_contrstop(con)-Slope
        fpcon(j)=fprest+contrstrength(con);
    elseif j>j_contrstop(con)-Slope
        fpcon(j)=fprest+contrstrength(con)-(contrstrength(con)/Slope)*(j-(j_contrstop(con)-Slope));   
    end
end

if j>j_persstart(con) && j<=j_persstart(con)+persrise(con);%j_contrstop(con)
    %fpcon(j)=fprest+contrstrength(con)*sin(pi/(contrlength(con))*(j-j_contrstart(con))).^2;
    fppers(j)=persstrength(con)*sin(pi/(2*persrise(con))*(j-j_persstart(con))).^2;
elseif j>j_persstart(con)+persrise(con) && j<=j_persstop(con)
    fppers(j)=persstrength(con)-persstrength(con)*sin(pi/(2*persdecay(con))*(j-(j_persstart(con)+persrise(con)))).^2;
elseif j==j_persstop(con)+persinter(con) && j<=j_contrstop(con)-perslength(con)
    persinter(con)=1000*round(3/dt);           % Random gaussian contraction interval in ic's
    persstrength(con)=110*facHgkPa;                  % Random gaussian contraction strength in mmHg
    perslength(con)=1000*round(15/dt);          % Random gaussian contraction length in ic's
    persrise(con)=round(r*perslength(con));
    persdecay(con)=d*persrise(con);%round(0.5*contrlength(con)+max(rcon));
    j_persstart(con)=j_persstop(con)+persinter(con);               % Start time of contraction after about 30 maternal beats
    j_persstop(con)=j_persstart(con)+perslength(con);  % Stop time of contraction
end

if persen==1
    fpcon(j)=fpcon(j)+fppers(j);
end

    % New compression calculation
if reg==0 && j==j_contrstop(con)+randinter(con)
    con=con+1;                                              % Contraction number
    randinter(con)=round(abs(normrnd(randinter(1)*dt,10000)/dt));               % Random gaussian contraction interval in j's
    contrstrength(con)=normrnd(contrstrength(1),15*facHgkPa);  
    contrlength(con)=round(normrnd(contrlength(1)*dt,8000)/dt);          % Random gaussian contraction length in j's
    conrise(con)=round(r*contrlength(con));
    condecay(con)=d*conrise(con);%round(0.5*contrlength(con)+max(rcon));
    j_contrstart(con)=j+1;
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction                                       
    persinter(con)=1000*round(3/dt);           % Random gaussian contraction interval in ic's
    persstrength(con)=110*facHgkPa;                  % Random gaussian contraction strength in mmHg
    perslength(con)=1000*round(15/dt);          % Random gaussian contraction length in ic's
    persrise(con)=round(r*perslength(con));
    persdecay(con)=d*persrise(con);%round(0.5*contrlength(con)+max(rcon));
    if 0.5*con/round(0.5*con)==1
        j_persstart(con)=j_contrstart(con)+1000*round(8/dt);               % Start time of contraction after about 30 maternal beats
        j_persstop(con)=j_persstart(con)+perslength(con);  % Stop time of contraction
    else
        j_persstart(con)=0;
        j_persstop(con)=0;
    end
    W_v=1;
    W_vd(con)=normrnd(W_vd(1),0.1);
elseif reg==1 && j==j_contrstop(con)+randinter(con)
    %HIER VERANDEREN
    con=con+1;                                              % Contraction number
    randinter(con)=1000*round(120/dt);              % Random gaussian contraction interval in j's
    contrstrength(con)=70*facHgkPa;
    contrlength(con)=1000*round(60/dt);          % Random gaussian contraction length in j's
    conrise(con)=round(r*contrlength(con));
    condecay(con)=d*conrise(con);%round(0.5*contrlength(con)+max(rcon));
    j_contrstart(con)=1i+1;
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction                                       
    persinter(con)=1000*round(3/dt);           % Random gaussian contraction interval in ic's
    persstrength(con)=110*facHgkPa;                  % Random gaussian contraction strength in mmHg
    perslength(con)=1000*round(15/dt);          % Random gaussian contraction length in ic's
    persrise(con)=round(r*perslength(con));
    persdecay(con)=d*persrise(con);%round(0.5*contrlength(con)+max(rcon));
    if 0.5*con/round(0.5*con)==1
        j_persstart(con)=j_contrstart(con)+1000*round(8/dt);               % Start time of contraction after about 30 maternal beats
        j_persstop(con)=j_persstart(con)+perslength(con);  % Stop time of contraction
    else
        j_persstart(con)=0;
        j_persstop(con)=0;
    end
    W_v=1;
    W_vd(con)=0.7;%DEZE AANPASSEN, NIET DIE HIERBOVEN max(0,W_vd(con-1)-0.2*W_vd(1));
elseif reg==2 && j==j_contrstop(con)
    con=con+1;                                              % Contraction number
    randinter(con)=1000*round(150/dt);           % Random gaussian contraction interval in ic's
    if con==2; randinter(con)=1000*round(150/dt);  
    contrstrength(con)=56*facHgkPa;
    contrlength(con)=1000*round(48/dt);
    W_vd(con)=0.6010;
    end
    if con==3; randinter(con)=1000*round(150/dt); 
    contrstrength(con)=65*facHgkPa;
    contrlength(con)=1000*round(64/dt);
    W_vd(con)=0.7278;
    end
    if con==4; contrstrength(con)=64*facHgkPa; 
    contrlength(con)=1000*round(60/dt);          % Random gaussian contraction length in j's
    W_vd(con)=0.5420;
    end
    if con==5; contrlength(con)=1000*round(49/dt);
    contrstrength(con)=56*facHgkPa;  
    W_vd(con)=0.7770;
    end
    if con>5; contrlength(con)=1000*round(65/dt);
    contrstrength(con)=43*facHgkPa;  
    W_vd(con)=0.7270;
    end
    conrise(con)=round(0.5*contrlength(con));
    condecay(con)=round(0.5*contrlength(con));
    j_contrstart(con)=j_contrstart(con-1)+randinter(con-1); % Start time of contraction
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction                                       
    persinter(con)=1000*round(3/dt);           % Random gaussian contraction interval in ic's
    persstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
    perslength(con)=1000*round(15/dt);          % Random gaussian contraction length in ic's
    persrise(con)=round(r*perslength(con));
    persdecay(con)=d*persrise(con);%round(0.5*contrlength(con)+max(rcon));
    if 0.5*con/round(0.5*con)==1
        j_persstart(con)=j_contrstart(con)+1000*round(8/dt);               % Start time of contraction after about 30 maternal beats
        j_persstop(con)=j_persstart(con)+perslength(con);  % Stop time of contraction
    else
        j_persstart(con)=0;
        j_persstop(con)=0;
    end
    W_v=1;
    W_vd(con)=0.7;
end

% Fetal systemic resistance (from regulation)
fRR(j)=fR1(ico-1);
if convf==3; fR(sfp)=fRR(j); end
    
fR(sumv)= (Rumv+(W_vd(con)*Rumvmax)*exp((fpcon(j)-fpcon0)./(c_R2)))./(1+exp((fpcon(j)-fpcon0)./(c_R2))); %venen
fR(suma)= (Ruma+(W_vd(con)*Rumamax)*exp((fpcon(j)-fpcon1)./(c_R2)))./(1+exp((fpcon(j)-fpcon1)./(c_R2))); %arterien

fR6(ico)=fR(sumv);
fR4(ico)=fR(suma);

