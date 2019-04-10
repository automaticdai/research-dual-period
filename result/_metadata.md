# MATLAB Data Result

## Objective
Explore the state space formed by h_high, h_low and alpha ratio.


## The System
### Control System
- sys_zpk = zpk([],[-400+80i, -400-80i],[10000]);
- sys = tf(sys_zpk);
- P controller, Kp = 500;

### Scheduling System
- C1 = C2 = C3 = 20us;
- Kernel time = 1us;
- T(Feedback Scheduler) = 30us;


## The Data
Each simulation runs 30ms, roughly 30000 kernel steps, and 1000 afbs periods.


### Experiment 1
filename: matlab_(h_high)-(h_low)-(alpha)
- h_high = 100:5:200
- h_low = h_high:5:200
- use h_high as relative baseline


### Experiment 2
filename: stat_(h_high)-(h_low)-(alpha)
- h_high = 100:5:200
- h_low = h_high:5:200
- use h_high = h_low = 100 as absolute baseline


### Experiment 3
filename: stat_sym_(h_high)-(h_low)-(alpha x 100)
- h_high = 100:5:200
- h_low = 100:5:200
- output: z_c, z_u as grids
