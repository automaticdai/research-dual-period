# Dual Period Task Scheduling

MATLAB/Simulink simulation of the paper 'Exploiting a Dual-Mode Strategy for Performance-Maximization and Resource-Efficient CPS Design'.

## Requirements
1. Install MATLAB (c) R2017a or later
2. Install MinGW-w64 compiler (**DO NOT** include any space in the installation folder!)
  - for MATLAB R2015b, R2016a, R2016b, R2017a: MinGW GCC 4.9.2 from TDM (https://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%20Installer/Previous/1.1309.0/)
  - for MATLAB R2017b and beyond: MinGW GCC 6.3 from mingw-w64.org

## Instructions
In MATLAB, config the mex compiler using the following commands:

```
setenv('MW_MINGW64_LOC',<MinGW installation folder>)
mex -setup C++
```


## Edit & Run The Program
In MATLAB, `Home` -> `Open` -> 'path-to-repository'/main.c, then click `Run` on the top.


## Project Structure
- /afbs-kernel: the scheduler for Simulink
- /analysis: scripts for analysis results and generating figures in reports
- /experiments: early experiments
- /result: folder for saving experiment result data
- main.m: program starting point
- main_cost_space.m: evaluate the cost space
- run_single_simulation: single run of one instance
- rta.py: response time analysis
- ga_main.m: functions related to genetic algorithms
- UUnifast.m: UUnifast synthetic task generator
- *.slx: Simulink models


## Known Issues
- For dual-period tasks: switch back to T^H is not implemented
- EDF policy is not implemented
- There is a limitation on the simulation time (as kernel_cnt is long)
- For DUAL, control tasks have to be the highest priorities
