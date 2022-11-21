close all
clear

H_p2p = load('C:\Users\Bebi\Documents\MATLAB\Licenta\19.10.22\Identifications\pitch2pitch\H_p2p.mat').H_p2p;


% Td = a * Ti

a = 1/2;
wc = 1;

den = H_p2p.Denominator{1};
num = H_p2p.Numerator{1};

bode(H_p2p);
figure;

phase_margin = 70;
phase_Hp = -atan((den(2)*wc) / (den(3) - den(1)*wc^2)) - H_p2p.IODelay*wc;
phase_Hc = deg2rad(-180 + phase_margin) - phase_Hp;



t = tan(phase_Hc + pi/2);
Ti = roots([a*wc^2*t wc -t]);

ind = 1;
Ti_real = [];
for i=1:length(Ti)
    if(Ti(i) > 0) 
        Ti_real(ind) = real(Ti(i));
        ind = ind+1;
    end
end

Ti_real
Td = a * Ti_real

kp = Ti_real*wc * sqrt((den(3) - den(1)*wc^2)^2 + (den(2)*wc)^2) / (sqrt((num(3) - num(1)*wc^2)^2 + (num(2)*wc)^2) * sqrt((1 - a*Ti_real^2*wc^2)^2 + (Ti_real*wc)^2))


Hc_pitch = tf(kp*[Ti_real*Td Ti_real 1],[0 Ti_real 0])

figure;
bode(Hc_pitch*H_p2p)

 step(feedback(Hc_pitch*H_p2p,1));
% figure;

% t = 0:0.01:30;
% u = ones(length(t));
% comanda = lsim(feedback(Hc_pitch,H_p2p),u,t);
% 
% figure;
% plot(t,comanda)
% figure;
% plot(t,y)



save("Hc_pitch","Hc_pitch")
