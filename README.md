# Dual-Period Task Scheduling

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
- /analysis: scripts for analysis results and ploting figures in reports
- /experiments: early experiments
- /result: folder for saving experiment result data
- /tasksets: everything related to taksets
- /tasksets/UUnifast.m: UUnifast synthetic task generator
- main_ga.m: implementations of genetic algorithms
- main_random.m: implementations of random search
- main_cost_space.m: evaluate the cost space
- main_single_period_brute.m: solve the optimal single period using brute force
- main_task_allocation_greedy.m: allocation additional tasks to a non-control taskset
- run_single_simulation: single run of one instance
- rta.py: response time analysis of dual period (in Python)
- .slx: Simulink model files


## Known Issues
- EDF policy is not implemented
- There is a limitation on the simulation time (as kernel_cnt is long)
- For DUAL, control tasks have to be the highest priorities
- For DUAL, the deadline is not equal to DUAL
- For DUAL, the switching back too T_i^H is not implemented
- For DUAL, the switch will be deferred to the next release

## Citation
```text
@article{dai2019dual,
  title={A dual-mode strategy for performance-maximisation and resource-efficient CPS design},
  author={Dai, Xiaotian and Chang, Wanli and Zhao, Shuai and Burns, Alan},
  journal={ACM Transactions on Embedded Computing Systems (TECS)},
  volume={18},
  number={5s},
  pages={1--20},
  year={2019},
  publisher={ACM New York, NY, USA}
}
```
