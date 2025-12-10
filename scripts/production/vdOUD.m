% Update changes in Variable Decelerations
fpconv=13.5;% 70*facHgkPa;  %fpcon = externe druk
fpcona=14.5; %100*facHgkPa;
fpconv2=3.5;% 70*facHgkPa;  %fpcon = externe druk
fpcona2=3.5; %100*facHgkPa;
Pfbrmc0=14.8;
Pfbrmc00=11;
k=1.7;
c_R1=1e4; % max waarbij vat dicht zit.
c_R2=0.5; %steilheid
c_R3=1e4;
c_R4=.01;
r=1/2;
d=1/r-1;
reg=1;
if con==0
    con=1;                                                  % Contraction number
    randinter(con)=1000*round(1800/dt);           % Random gaussian contraction interval in ic's
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
    W_v=1;
    W_vd(con)=0.7; 
    fpcon0=fpconv-1*W_vd(1)*fpconv2
    fpcon1=fpcona-1*W_vd(con)*fpcona2
end
    %fprest=fpcon(1) fpcon = externe druk
    % Umbilical pressure 
if j>j_contrstart(con) && j<=j_contrstart(con)+conrise(con);%j_contrstop(con)
    %fpcon(j)=fprest+contrstrength(con)*sin(pi/(contrlength(con))*(j-j_contrstart(con))).^2;
    fpcon(j)=fprest+contrstrength(con)*sin(pi/(2*conrise(con))*(j-j_contrstart(con))).^2;
elseif j>j_contrstart(con)+conrise(con) && j<=j_contrstop(con)
    fpcon(j)=fprest+contrstrength(con)-contrstrength(con)*sin(pi/(2*condecay(con))*(j-(j_contrstart(con)+conrise(con)))).^2;
end
% disp('tijdelijk')
% if fpcon(j)<fpcon(j-1)
%     fpcon(j)=fpcon(j-1);
% end

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
    contrstrength(con)=normrnd(contrstrength(1),10*facHgkPa);  
    contrlength(con)=round(normrnd(contrlength(1)*dt,8000)/dt);          % Random gaussian contraction length in j's
    conrise(con)=round(r*contrlength(con));
    condecay(con)=d*conrise(con);%round(0.5*contrlength(con)+max(rcon));
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
    W_vd(con)=0.7;%0.5*W_vd(1)+0.5*rand(1);
    fpcon0=fpconv-1*W_vd(con)*fpconv2
    fpcon1=fpcona-1*W_vd(con)*fpcona2
elseif reg==1 && j==j_contrstop(con)+randinter(con)
    con=con+1;                                              % Contraction number
    randinter(con)=1000*round(180/dt);              % Random gaussian contraction interval in j's
    contrstrength(con)=70*facHgkPa;
    contrlength(con)=1000*round(120/dt);          % Random gaussian contraction length in j's
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
    W_vd(con)=0.7;%max(0,W_vd(con-1)-0.2*W_vd(1));
    fpcon0=fpconv-1*W_vd(con)*fpconv2
    fpcon1=fpcona-1*W_vd(con)*fpcona2
elseif reg==2 && j==j_contrstop(con)
    con=con+1;                                              % Contraction number
    randinter(con)=1000*round(240/dt);           % Random gaussian contraction interval in ic's
    if con==2; randinter(con)=1000*round(60/dt); end
    contrstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
    if con==4; contrstrength(con)=35*facHgkPa; end
    contrlength(con)=1000*round(60/dt);          % Random gaussian contraction length in j's
    if con==5; contrlength(con)=1000*round(120/dt); end
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
    W_vd(con)=rand(1);
    fpcon0=fpconv-1*W_vd(con)*fpconv2
    fpcon1=fpcona-1*W_vd(con)*fpcona2
end

% Fetal systemic resistance (from regulation)
fRR(j)=fR1(ico-1);
if convf==3; fR(sfp)=fRR(j); end

%fpcon0=fpconv-1*W_vd(con)*fpconv2;
%fpcon1=fpcona-1*W_vd(con)*fpcona2;
%Update of brain resistance due to caput compression at contraction
    
% if j>j_contrstart(con) && j<=j_contrstart(con)+0.5*conrise(con);
%     fR(sumv)=Rumv+ (j-j_contrstart(con))/3;
%     fR(suma)=Ruma+ (j-j_contrstart(con))/6;
%     Rumvmax=fR(sumv);
%     Rumamax=fR(suma);
% elseif j>j_contrstart(con)+0.5*conrise(con) && j<j_contrstart(con)+conrise(con)
%     fR(sumv)=max(Rumv,Rumvmax-(j-j_contrstart(con)-0.5*conrise(con))/3);
%     fR(suma)=max(Ruma,Rumamax-(j-j_contrstart(con)-0.5*conrise(con))/6);
% end
    
    fR(sumv)= (Rumv+W_vd(con)*(c_R1)*Rumv*exp((fpcon(j)-fpcon0)./(c_R2)))./(1+exp((fpcon(j)-fpcon0)./(c_R2))); %venen
    %fR(suma)= (Ruma+W_vd(con)*(c_R1)*Ruma*exp((fpcon(j)-fpcon1)./(c_R2)))./(1+exp((fpcon(j)-fpcon1)./(c_R2))); %arterien
   

