#include "afbs.h"
#include "app.h"
#include "pidcontroller.h"

int TASK_1_PERIOD = 1000;
int TASK_2_PERIOD = 1000;
int TASK_3_PERIOD = 1000;

int TASK_1_IDX = 0;
int TASK_2_IDX = 1;
int TASK_3_IDX = 2;

//PID_Controller controller_1(6.704, 205.6, 0.05301, TASK_1_PERIOD * KERNEL_TICK_TIME);
PID_Controller controller_1(15.8, 1.0, 0.2388, TASK_1_PERIOD * KERNEL_TICK_TIME);

// 261.5
// 0.2388

/* task configurations */
// pi, ci, ti, di, ri
int task_config[TASK_NUMBERS][5] = {
    {0,   50,   1000,   0, 0},
    {1,   50,   1000,   0, 0},
    {2,   50,   1000,   0, 0}
};

void app_init(void) {
    /* read parameters */
    //TASK_1_PERIOD = afbs_get_param(0) / KERNEL_TICK_TIME;
    //TASK_2_PERIOD = afbs_get_param(1) / KERNEL_TICK_TIME;
    //TASK_3_PERIOD = afbs_get_param(2) / KERNEL_TICK_TIME;

    /* initialize taskset */
    for (int i = 0; i < TASK_NUMBERS; i++) {
        class Task tau_i(task_config[i][0], task_config[i][1], task_config[i][2],
                    task_config[i][3], task_config[i][4]);
        afbs_create_task(tau_i, NULL, NULL, NULL);
    }

    /* override some tasks for control tasks */
    class Task tau1(TASK_1_IDX, 200, TASK_1_PERIOD, 0, 0);
    class Task tau2(TASK_2_IDX, 200, TASK_2_PERIOD, 0, 0);
    class Task tau3(TASK_3_IDX, 200, TASK_3_PERIOD, 0, 0);

    afbs_create_task(tau1, NULL, task_1_start_hook, task_1_finish_hook);
    afbs_create_task(tau2, NULL, task_2_start_hook, task_2_finish_hook);
    afbs_create_task(tau3, NULL, task_3_start_hook, task_3_finish_hook);

    afbs_dump_information();

    return;
}


/*-- control tasks -----------------------------------------------------------*/
void task_1_start_hook(void) {
    int idx = 0;

    // sample inputs
    controller_1.sampling(afbs_state_ref_load(idx), afbs_state_in_load(idx));

    mexPrintf("1: Sampling\r");

    return;
}

void task_1_finish_hook(void) {
    int idx = 0;

    /* Calculate Outputs */
    double u = controller_1.output();

    /* Send output to Simulink */
    afbs_state_out_set(0, u);

    mexPrintf("1: Control\r");
/*
    t_refer = ref[0];
    t_error = ref[0] - y[0];
    error[0] = abs(ref[0] - y[0]);
    u[0] = 75 * (t_error) + 80 * error_s[0] + 0.036 * error_p[0] / (TCB[0].T_ / 10000.0);
    error_s[0] += t_error * (TCB[0].T_ / 10000.0);
    error_p[0] = t_error;
    u[0] = 1;
*/

    return;
}

void task_2_start_hook(void) {
    mexPrintf("2: Sampling\r");
    return;
}

void task_2_finish_hook(void) {
    afbs_state_out_set(1, 10);
    mexPrintf("2: Control\r");
    return;
}

void task_3_start_hook(void) {
    mexPrintf("3: Sampling\r");
    return;
}

void task_3_finish_hook(void) {
    afbs_state_out_set(2, 10);
    mexPrintf("3: Control\r");
    return;
}
