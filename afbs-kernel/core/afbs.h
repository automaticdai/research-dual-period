#ifndef __AFBS_H_
#define __AFBS_H_

#include "mex.h"

#include "types.h"
#include "configs.h"
#include "utils.h"
#include "task.h"
#include "app.h"

/* Scheduler Kernel Variables */
#define KERNEL_TICK_TIME     (0.000010)                // 10 us by default
#define TASK_MAX_NUM         (15)
#define IDLE_TASK_IDX        (TASK_MAX_NUM)
#define AFBS_PERIOD          (0.010)
#define PARAM_MAX_NUM        (100)

typedef enum {fps, edf} enum_scheduling_policy;

/* Scheduler Kernel Functions */
void   afbs_initilize(enum_scheduling_policy sp);

void   afbs_create_task(CTask t, callback task_main, callback on_start, callback on_finish);
void   afbs_delete_task(int task_id);

int    afbs_get_task_period(int task_id);
void   afbs_set_task_period(int task_id, int new_period);

int    afbs_get_running_task_id(void);
int    afbs_get_execution_time_left(int task_id);

void   afbs_create_job(CTask j, int prio, callback job_main, callback on_start, callback on_finish);
void   afbs_delete_job(int job_id);

void   afbs_update(void);
void   afbs_schedule(void);
void   afbs_run(void);
void   afbs_idle(void);
void   afbs_dump_information(void);

long   afbs_get_kernel_cnt(void);
long   afbs_get_idle_cnt(void);
double afbs_get_current_time(void);

void   afbs_set_status(int);
int    afbs_get_status(void);

void   afbs_state_in_set(int, double);
double afbs_state_in_load(int);
void   afbs_state_ref_set(int, double);
double afbs_state_ref_load(int);
void   afbs_state_out_set(int, double);
double afbs_state_out_load(int);

void   afbs_set_param(int, double);
double afbs_get_param(int);
void   afbs_set_param_num(int);
int    afbs_get_param_num(void);

void   afbs_performance_monitor(void);
long   afbs_report_task_last_response_time(int task_id);

void   afbs_set_as_dual_period(int i, int TH, int TL, int alpha, int TGamma);

#endif
