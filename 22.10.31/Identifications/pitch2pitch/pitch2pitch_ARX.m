clear
close all

%% data load

load("pitch2pitch_data.mat")
id = data.id;
val = data.val;

n=30;
% for pow=1:n
sys = arx(id, [15 15 10]);
% lsim()
% end
% id
time = 0:val.Ts:val.Ts*(length(val.u)-1);
y_val = lsim(sys,val.u,time);
MSE = 1/length(y_val)*sum((y_val-val.y).^2);

% plot(time,y_val)

H = tf(sys.B,sys.A,id.Ts);
Hc = d2c(H);
y_id = step(Hc)


K = mean(y_id(end-10:end));
M = (max(y_id)-K)/K;
zeta = log(1/M)/sqrt(pi^2+log(M)^2);
T0 = 10-3.34;
wn = 2*pi/T0/sqrt(1-zeta^2);

H_aprox = tf(K*wn^2,[1 2*zeta*wn wn^2],'iodelay',0.08)

% step(Hc,H_aprox)


y_aprox = lsim(H_aprox,val.u,time);
plot(time,y_val,time,y_aprox)
H_p2p = H_aprox;
save('H_p2p','H_p2p')