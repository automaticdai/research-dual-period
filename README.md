# Dual Period Task Scheduling

-------

Matlab Simulation of the paper 'A Dual-Mode Strategy for Performance-Maximization and Resource-Efficient CPS Design'.

## Requirements
1. Install MATLAB (c) R2017 or later
2. Install MinGW x86_64 compile at: https://sourceforge.net/projects/mingw-w64/. DO NOT include any space in the installation folder!


## Instructions
In MATLAB,

```
setenv('MW_MINGW64_LOC',<MinGW installation folder>)
mex -setup C++

```
## Edit & Run The Program
In MATLAB, Home -> Open -> 'path-to-repository'/main.c, then click 'Run' on the top.


## Project Structure
- /afbs-kernel: the scheduler for Simulink
- /analysis: scripts for generating figures in reports
- /experiments: early experiments
- /result: save experiment result data
- main.m: program starting point
- main_cost_space.m: evaluate the cost space
- run_single_simulation: single run of one instance
- rta.py: response time analysis
- ga.m: functions related to genetic algorithms
- simu_afbs_control.slx / simu_state_space_model.slx: Simulink models
