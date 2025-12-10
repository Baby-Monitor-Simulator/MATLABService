% Update changes in Early Decelerations
fpcon0=100*facHgkPa;
Pfbrmc0=14.8;
Pfbrmc00=11;
k=1.3;
c_R1=7;
c_R2=0.1;
c_R3=2;
c_R4=0.1;

if con==0
    con=1;                                                  % Contraction number
    randdelay(con)=2500; %1000*round(12*rand/dt);                       % Random delay of 0-12 seconds
    scaledepth(con)= 1;%normrnd(15,7)/30;                % Random normalised gaussian depth of decel 
    randinter(con)=1000*round(180/dt);           % Random gaussian contraction interval in ic's
    contrstrength(con)=70*facHgkPa;                  % Random gaussian contraction strength in mmHg
    contrlength(con)=1000*round(60/dt);          % Random gaussian contraction length in ic's
    j_contrstart(con)=round(43*mtcycle(1));               % Start time of contraction after about 30 maternal beats
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction
    W_v=1;
end

% Brain pressure & vagal compression
if j>j_contrstart(con) && j<=j_contrstop(con)
    fpcon(j)=fprest+contrstrength(con)*sin(pi/(contrlength(con))*(j-j_contrstart(con))).^2;
end

% Fetal systemic resistance (from regulation)
fRR(j)=fR1(ico-1);
if convf==3; fR(sfp)=fRR(j); end

% New compression calculation
if j==j_contrstop(con)+randdelay(con)
    con=con+1;                                              % Contraction number
    randdelay(con)=1000*round(12*rand/dt);                       % Random delay of 0-12 seconds in j's
    scaledepth(con)=min(1,normrnd(scaledepth(1)*30,1)/30);                    % Random normalised gaussian depth of decel 
    randinter(con)=round(normrnd(randinter(1)*dt,10000)/dt);               % Random gaussian contraction interval in j's
    contrstrength(con)=contrstrength(con-1);%normrnd(contrstrength(1),5*facHgkPa);  
    contrlength(con)=contrlength(con-1);%round(normrnd(contrlength(1)*dt,5000)/dt);          % Random gaussian contraction length in j's
    j_contrstart(con)=j_contrstart(con-1)+randinter(con); % Start time of contraction
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction                                       
    W_v=1;
end

if j>ftcycle(1)/dt+1
     % Update of brain resistance due to caput compression at contraction
    fR(sbrmc)=(Rbrmc+(c_R1*scaledepth(con))*Rbrmc*exp((fpcon(j)-fpcon0)./(c_R2*fpcon0)))./(1+exp((fpcon(j)-fpcon0)./(c_R2*fpcon0)));
    fR6(j)=fR(sbrmc);
end