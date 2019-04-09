#include "afbs.h"
#include "app.h"
#include "pidcontroller.h"

int task_numbers = 4;

int TASK_1_PERIOD = 1500;
int TASK_2_PERIOD = 2000;
int TASK_3_PERIOD = 2500;

// int TASK_1_IDX = 0;
// int TASK_2_IDX = 1;
// int TASK_3_IDX = 2;

// PID Controllers
PID_Controller controllers[CONTROL_TASK_NUMBERS];

/* task configurations */
// c, th, tl, alpha, d, ri
int task_config[TASK_MAX_NUM][6] = {
    {500,   1000,  2000,   50,  0, 0},
    {500,   1000,  2000,   50,  0, 0},
    {500,   1000,  2000,   50,  0, 0},
    {200,  10000, 10000,   -1,  0, 0}
};

void app_loadtaskset(void) {
    ;
}

void app_init(void) {
    /* read parameters */
    //TASK_1_PERIOD = afbs_get_param(0) / KERNEL_TICK_TIME;
    //TASK_2_PERIOD = afbs_get_param(1) / KERNEL_TICK_TIME;
    //TASK_3_PERIOD = afbs_get_param(2) / KERNEL_TICK_TIME;

    /* initialize taskset */
    for (int i = 0; i < task_numbers; i++) {
        // pi, ci, ti, di, ri
        class Task tau_i(i, task_config[i][0], task_config[i][1],
                    task_config[i][4], task_config[i][5]);
        afbs_create_task(tau_i, NULL, NULL, NULL);
    }

    /* override some tasks for control tasks */
    // pi, ci, ti, di, ri
    class Task tau1(0, 500, TASK_1_PERIOD, 0, 0);
    class Task tau2(1, 500, TASK_2_PERIOD, 0, 0);
    class Task tau3(2, 500, TASK_3_PERIOD, 0, 0);

    afbs_create_task(tau1, NULL, task_1_start_hook, task_1_finish_hook);
    afbs_set_as_dual_period(0, 1500, 2000, 50, 100000);

    afbs_create_task(tau2, NULL, task_2_start_hook, task_2_finish_hook);
    afbs_create_task(tau3, NULL, task_3_start_hook, task_3_finish_hook);

    afbs_dump_information();

    /* initilize controllers */
    for (int i = 0; i < CONTROL_TASK_NUMBERS; i++){
        controllers[i].set_parameters(1.646, 6.228, 0.1087, TASK_1_PERIOD * KERNEL_TICK_TIME);
    }
    return;
}


/*-- control tasks -----------------------------------------------------------*/
void task_1_start_hook(void) {
    int idx = 0;

    // sample inputs
    controllers[idx].sampling(afbs_state_ref_load(idx), afbs_state_in_load(idx));

    //mexPrintf("[%0.4f] [0] Sampling\r", afbs_get_current_time());

    return;
}

void task_1_finish_hook(void) {
    int idx = 0;

    /* Calculate Outputs */
    double u = controllers[idx].output();

    /* Send output to Simulink */
    afbs_state_out_set(idx, u);

    //mexPrintf("[%0.4f] [0] Control\r", afbs_get_current_time());

    return;
}

void task_2_start_hook(void) {
    int idx = 1;

    // sample inputs
    controllers[idx].sampling(afbs_state_ref_load(idx), afbs_state_in_load(idx));

    //mexPrintf("[%0.4f] [0] Sampling\r", afbs_get_current_time());

    return;
}

void task_2_finish_hook(void) {
    int idx = 1;

    /* Calculate Outputs */
    double u = controllers[idx].output();

    /* Send output to Simulink */
    afbs_state_out_set(idx, u);

    //mexPrintf("[%0.4f] [0] Control\r", afbs_get_current_time());

    return;
}

void task_3_start_hook(void) {
    int idx = 2;

    // sample inputs
    controllers[idx].sampling(afbs_state_ref_load(idx), afbs_state_in_load(idx));

    //mexPrintf("[%0.4f] [0] Sampling\r", afbs_get_current_time());

    return;
}

void task_3_finish_hook(void) {
    int idx = 2;

    /* Calculate Outputs */
    double u = controllers[idx].output();

    /* Send output to Simulink */
    afbs_state_out_set(idx, u);

    //mexPrintf("[%0.4f] [0] Control\r", afbs_get_current_time());

    return;
}
