clear
close all

load('C:\Users\Bebi\Documents\MATLAB\Licenta\BratianPaul_11.07.22\Azimuth_Id\Azimuth_-0.2_0.4_1534.mat')

t = AngleCtrl.time;
u_id = AngleCtrl.signals(3).values(:,1);
pitch_id = AngleCtrl.signals(3).values(:,3);
azimuth_id = AngleCtrl.signals(3).values(:,2);


id = iddata(azimuth_id,u_id,t(2));

load('C:\Users\Bebi\Documents\MATLAB\Licenta\BratianPaul_11.07.22\Azimuth_Id\Azimuth_0.2_1534.mat')
t = AngleCtrl.time;
u_val = AngleCtrl.signals(3).values(:,1);
pitch_val = AngleCtrl.signals(3).values(:,3);
azimuth_val = AngleCtrl.signals(3).values(:,2);

val = iddata(azimuth_val,u_val,t(2));

data = [];
data.id = id;
data.val = val;

save('azimuth2azimuth_data','data')