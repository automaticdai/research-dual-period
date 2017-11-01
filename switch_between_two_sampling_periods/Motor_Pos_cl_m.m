%% parameters for motor
J = 3.2284E-6;
b = 3.5077E-6;
K = 0.0274;
R = 4;
L = 2.75E-6;

s = tf('s');
P_motor = K/(s*((J*s+b)*(L*s+R)+K^2));
zpk(P_motor)


%% parameters for the controller
T0 = 0.01;
T1 = 0.02;


%% Controller Model
kp = 0.4;
ki = 0;
kd = 0.0001;