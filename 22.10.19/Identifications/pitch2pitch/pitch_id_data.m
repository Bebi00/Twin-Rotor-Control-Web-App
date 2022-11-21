clear
close all

load('C:\Users\Bebi\Documents\MATLAB\Licenta\BratianPaul_11.07.22\Pitch_ID\Pitch_-0.2_1534.mat')

t = AngleCtrlPitch.time;
u_id = AngleCtrlPitch.signals(3).values(:,1);
pitch_id = AngleCtrlPitch.signals(3).values(:,2);
azimuth_id = AngleCtrlPitch.signals(3).values(:,3);


id = iddata(pitch_id,u_id,t(2));

load('C:\Users\Bebi\Documents\MATLAB\Licenta\BratianPaul_11.07.22\Pitch_ID\Pitch_0.4_1534.mat')
t = AngleCtrlPitch.time;
u_id = AngleCtrlPitch.signals(3).values(:,1);
pitch_id = AngleCtrlPitch.signals(3).values(:,2);
azimuth_id = AngleCtrlPitch.signals(3).values(:,3);

val = iddata(pitch_id,u_id,t(2));

data = [];
data.id = id;
data.val = val;

save('pitch2pitch_data','data')