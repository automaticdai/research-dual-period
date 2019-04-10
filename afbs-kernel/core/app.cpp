#include "afbs.h"
#include "app.h"
#include "pidcontroller.h"

int TASK_1_IDX = 0;
int TASK_2_IDX = 1;
int TASK_3_IDX = 2;

// PID Controllers
PID_Controller controllers[CONTROL_TASK_NUMBERS];

void app_init(void) {

    int task_numbers = afbs_get_param_num() / 6;

    /* initialize taskset */
    int j = 0;

    for (int i = 0; i < task_numbers; i++) {
        /* read parameters */
        int Ci = afbs_get_param(j);
        int Di = afbs_get_param(j+1);
        int TH = afbs_get_param(j+2);
        int TL = afbs_get_param(j+3);
        int alpha = afbs_get_param(j+4);
        int idx = afbs_get_param(j+5);

        //mexPrintf("%d,%d,%d,%d,%d,%d\r", Ci, Di, TH, TL, alpha, idx);
        class Task tau(i, Ci, TH, Di, 0);

        /* control tasks */
        if (i < CONTROL_TASK_NUMBERS) {
            if (i == TASK_1_IDX) {
                afbs_create_task(tau, NULL, task_1_start_hook, task_1_finish_hook);
            } else if (i == TASK_2_IDX) {
                afbs_create_task(tau, NULL, task_2_start_hook, task_2_finish_hook);
            } else {
                afbs_create_task(tau, NULL, task_3_start_hook, task_3_finish_hook);
            }
            controllers[i].set_parameters(26.35, 66.09, 2.064, TH * KERNEL_TICK_TIME);
            afbs_set_as_dual_period(i, TH, TL, alpha, 10000);  // switching period = 1s
        } else {
            afbs_create_task(tau, NULL, NULL, NULL);
        }

        j = j + 6;
    }

    //afbs_dump_information();

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
