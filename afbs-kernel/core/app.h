#ifndef __APP_H_
#define __APP_H_

#define TASK_NUMBERS             (3)
#define CONTROL_TASK_NUMBERS     (3)
#define CONTROL_INPUT_NUMBERS    (3)
#define CONTROL_OUTPUT_NUMBERS   (3)

//#define STATES_REF_NUM         (3)
//#define STATES_IN_NUM          (3)
//#define STATES_OUT_NUM         (3)
//#define PARAM_NUM              (12)

void app_init(void);

void afbs_start_hook(void);

void task_1_start_hook(void);
void task_1_finish_hook(void);

void task_2_start_hook(void);
void task_2_finish_hook(void);

void task_3_start_hook(void);
void task_3_finish_hook(void);

#endif
