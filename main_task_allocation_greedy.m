clear;clc;

addpath('tasksets')

disp("   SINGLE:")
task_allocation_greedy(1);

disp("\r\r   DUAL:")
task_allocation_greedy(2);