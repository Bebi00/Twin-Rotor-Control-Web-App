clear
close all

%% data load

load("azimuth2azimuth_data.mat")
id = data.id;
val = data.val;

n=30;
% for pow=1:n
sys = arx(id, [50 50 5]);
% lsim()
% end
% id
time = 0:val.Ts:val.Ts*(length(val.u)-1);
y_val = lsim(sys,val.u,time);
MSE = 1/length(y_val)*sum((y_val-val.y).^2);

plot(time,y_val)
%%
H = tf(sys.B,sys.A,id.Ts);
Hc = d2c(H);
[y_id,t_id] = step(Hc);

plot(t_id,y_id)
%%
K = mean(y_id(end-10:end));
M = (max(y_id)-K)/K;
zeta = log(1/M)/sqrt(pi^2+log(M)^2);
T0 = 2*(12.92-6.6);
wn = 2*pi/T0/sqrt(1-zeta^2);

H_aprox = tf(K*wn^2,[1 2*zeta*wn wn^2],'iodelay',0.25)

step(Hc,H_aprox)
legend
%%

y_aprox = lsim(H_aprox,val.u,time);
plot(time,y_val,time,y_aprox)
H_a2a = H_aprox;
save('H_a2a','H_a2a')