/*  File    : kernel.cpp
 *  Abstract:
 *
 *      An example S-function illustrating multiple sample times by implementing
 *         integrator -> ZOH(Ts=1second) -> UnitDelay(Ts=1second) 
 *      with an initial condition of 1.
 *	(e.g. an integrator followed by unit delay operation).
 *
 *  Copyright 1990-2013 The MathWorks, Inc.
 */

#define S_FUNCTION_NAME kernel
#define S_FUNCTION_LEVEL 2

#include <iostream> // need redirect
#include <math.h>
#include "simstruc.h"

#define U(element) (*uPtrs[element])  /* Pointer to Input Port0 */

/*************************************************************************/
#define KERNEL_TIME             (0.0001)   /* 100us */
#define TASK_NUMBERS            (3)
#define AFBS_SAMPLING_PERIOD    (0.001)    /* 1ms   */
#define T_GAMMA                 (0.300)    /* 300ms */
#define TRIG_ERROR_THRESHOLD    (0.2)

/* these parameters will be later set in the simulink block */
int TASK_0_PERIOD = 100; // switch
int TASK_1_PERIOD = 100; // slowest
int TASK_2_PERIOD = 100; // fastest


float error[TASK_NUMBERS];      // current error
float error_p[TASK_NUMBERS];    // pervious error
float error_s[TASK_NUMBERS];    // sum of error
int param;

class PID_Controller {
    double Kp;
    double Ki;
    double Kd;
    double dt;              // sampling time
    double ref;
    double err_p;
    
    PID_Controller(double Kp_, double Ki_, double Kd_, double dt_) {
        this->Kp = Kp_;
        this->Ki = Ki_;
        this->Kd = Kd_;
        this->dt = dt_;
        ref = 1;
        err_p = 0;
    }
    
    double calc_output(double y_new) {
        double error = y_new - ref;
    }

};

/*************************************************************************/
/* AFBS Kernel */
using namespace std;
extern long kernel_cnt;

///////////////////////////////////////////////////////////////////////////////
/* Task Data Structure */
typedef void(*callback)(void);

typedef enum { ready, running, pending, waiting, deleted } enum_task_status;
char *task_status_literal[] = {
    { "ready" },
    { "running" },
    { "pending" },
    { "waiting" },
    { "deleted" }
};

typedef enum { fps, edf } enum_scheduling_policy;

class Task
{
public:
    int id_;
    int C_;
    int D_;
    int T_;
    int R_;
    int c_; // computation time countdown
    int d_; // deadline countdown
    int r_; // next release countdown
    int cnt_; // release count
   
    enum_task_status status_;
    callback onstart_;
    callback onfinish_;

public:
    Task(int id = 0, int Ci = 0, int Ti = 0, int Di = 0, int Ri = 0) :
        id_(id),
        C_(Ci),
        T_(Ti),
        D_(Di),
        R_(Ri) 
    {
        if (Di == 0) {
            D_ = Ti;
        }
        status_ = deleted;
        cnt_ = 0;
        onstart_ = NULL;
        onfinish_ = NULL;
    }

    ~Task() { ; }

    void on_task_ready(void) {
        c_ = C_;
        d_ = D_;
        r_ = T_;
        cnt_++;
    }

    void on_task_start(void) {
        cout << "t:" << kernel_cnt << ", r" << '(' << id_ << ',' << cnt_ << ')' << '\n';
        if (onstart_ != NULL) {
            onstart_();
        }
    }


    void on_task_finish(void) {
        cout << "t:" << kernel_cnt << ", f" << '(' << id_ << ',' << cnt_ << ')' << '\n';
        if (onfinish_ != NULL) {
            onfinish_();
        }
    }

    void set_onstart_hook(callback onstart)
    {
        onstart_ = onstart;
    }

    void set_onfinish_hook(callback onfinish)
    {
        onfinish_ = onfinish;
    }

    void repr()
    {
        std::cout << id_ << ":" << task_status_literal[status_] << " | " << c_ << " | " << d_<< " | " << r_ << "\n";
    }
};
typedef class Task CTask;



///////////////////////////////////////////////////////////////////////////////
/* Scheduler Kernel Variables */
#define TASK_MAX_NUM        (TASK_NUMBERS)
#define IDLE_TASK_IDX       (TASK_MAX_NUM)

CTask TCB[TASK_MAX_NUM];
//enum_task_status task_status_list[TASK_MAX_NUM];

//bool ready_q[TASK_MAX_NUM];
//bool pending_q[TASK_MAX_NUM];

long kernel_cnt;
long idle_cnt;
int  tcb_running_id;

/* Scheduler Kernel Functions */
void afbs_initilize(enum_scheduling_policy sp);

void afbs_create_task(CTask t, callback task_main, callback on_start, callback on_finish);
void afbs_delete_task(int task_id);
void afbs_create_job(CTask j, int prio, callback job_main, callback on_start, callback on_finish);
void afbs_delete_job(int job_id);

void afbs_update(void);
void afbs_schedule(void);
void afbs_run(void);
void afbs_idle(void);
void afbs_dump_information(void);

/// function implementation
void afbs_initilize(enum_scheduling_policy sp) 
{ 
    int i = 0;
    for (; i < TASK_MAX_NUM; i++) {
        TCB[i].id_ = i;
        TCB[i].status_ = deleted;
    }
    tcb_running_id = IDLE_TASK_IDX;
}

void afbs_create_task(CTask t, callback task_main, callback on_start, callback on_finish) 
{ 
    if (t.R_ == 0) {
        t.status_ = ready;
        t.on_task_ready();
    }
    else {
        t.r_ = t.R_;
        t.status_ = waiting;
    }
    
    t.set_onstart_hook(on_start);
    t.set_onfinish_hook(on_finish);

    TCB[t.id_] = t;
}

void afbs_delete_task(int task_id) 
{
    ; 
}

void afbs_create_job(CTask j, int prio, callback job_main, callback on_start, callback on_finish) 
{ 
    ; 
}

void afbs_delete_job(int job_id) 
{
    ; 
}


int step_count = 0;
double alpha = 0;
void afbs_update(void) 
{ 
    kernel_cnt++;

    for (int i = 0; i < TASK_MAX_NUM; i++) {
        if (TCB[i].status_ != deleted) {
            if (--TCB[i].r_ == 0) {
                TCB[i].status_ = ready;
                TCB[i].on_task_ready();
            }
        }
    }

    // if current task is finished, set current task to IDLE
    if (TCB[tcb_running_id].c_ == 0) 
    {
        tcb_running_id = IDLE_TASK_IDX;
    }

    // feedback scheduling handler
    // a little bit hacking
    if (kernel_cnt % (int)(AFBS_SAMPLING_PERIOD / KERNEL_TIME) == 0) {
        // state feedback
        //TCB[1].T_ = floor(TASK_1_PERIOD * pow(exp(1.0), (-10.0 * error[1])) + TASK_1_PERIOD);
        
        // Dual-period model
        //if (error[2] > 0.3) {
        if (step_count <= alpha * (int)(T_GAMMA / AFBS_SAMPLING_PERIOD)) {
            /*
            if (TCB[2].T_ != 20) {
                TCB[2].r_ = 1;
            }*/
            TCB[0].T_ = TASK_1_PERIOD;
        }
        else {
            TCB[0].T_ = TASK_2_PERIOD;
            
            /* event detection */
            if (step_count > (int)(T_GAMMA / AFBS_SAMPLING_PERIOD) 
                && abs(error[0]) > TRIG_ERROR_THRESHOLD) {
                TCB[0].T_ = TASK_1_PERIOD;
                step_count = 0;
            }
            
        }
        step_count += 1;
    }

}

void  afbs_schedule(void) {
    int task_to_be_scheduled = IDLE_TASK_IDX;

    for (int i = 0; i < TASK_MAX_NUM; i++) 
    {
        if ((TCB[i].status_ == ready) || (TCB[i].status_ == pending)) {
            task_to_be_scheduled = i;
            break;
        }
    }

    if ((task_to_be_scheduled != IDLE_TASK_IDX)) {
        for (int i = task_to_be_scheduled + 1; i < TASK_MAX_NUM; i++) {
            if (TCB[i].status_ == ready) { 
                TCB[i].status_ = pending;
            }
        }
    }

    // task scheduled hook
    if ((task_to_be_scheduled != tcb_running_id) && 
       (TCB[task_to_be_scheduled].c_ == TCB[task_to_be_scheduled].C_)) {
        TCB[task_to_be_scheduled].on_task_start();
    }

    TCB[task_to_be_scheduled].status_ = ready;
    tcb_running_id = task_to_be_scheduled;
}

void afbs_run(void) { 
    if (tcb_running_id != IDLE_TASK_IDX) {
        if (--TCB[tcb_running_id].c_ == 0) {
            TCB[tcb_running_id].status_ = waiting;
            TCB[tcb_running_id].on_task_finish();
            //cout << 'f';
        }
    }
    else {
        afbs_idle();
    }
}

void afbs_idle(void) 
{ 
    idle_cnt++;
}

void afbs_dump_information(void) 
{
    cout << "t: " << kernel_cnt << '\n';
    cout << "Current Task: " << tcb_running_id;
    cout << '\n';
    cout << "Task TCB: \n";
    for (int i = 0; i < TASK_MAX_NUM; i++) {
        TCB[i].repr();
    }
    cout << '\n';
}

/*************************************************************************/

/*====================*
 * S-function methods *
 *====================*/

#define PARAM1(S) ssGetSFcnParam(S,0)
#define MDL_CHECK_PARAMETERS   /* Change to #undef to remove function */
#if defined(MDL_CHECK_PARAMETERS) && defined(MATLAB_MEX_FILE)
static void mdlCheckParameters(SimStruct *S)
{
//   if (mxGetNumberOfElements(PARAM1(S)) != 1) {
//     ssSetErrorStatus(S,"Parameter to S-function must be a scalar");
//     return;
//   } else if (mxGetPr(PARAM1(S))[0] < 0) {
//     ssSetErrorStatus(S, "Parameter to S-function must be nonnegative");
//     return;
//   }
	alpha = mxGetPr(ssGetSFcnParam(S, 0))[0] / 100.0;
    TASK_1_PERIOD = mxGetPr(ssGetSFcnParam(S, 1))[0];
    TASK_2_PERIOD = mxGetPr(ssGetSFcnParam(S, 2))[0];
    TASK_0_PERIOD = TASK_1_PERIOD;
}
#endif /* MDL_CHECK_PARAMETERS */


/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
    /* check parameters */
    ssSetNumSFcnParams(S, 3);  /* Number of expected parameters */
    
    if(ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
        mdlCheckParameters(S);
        if(ssGetErrorStatus(S) != NULL) return;
    } else {
        return; /* The Simulink engine reports a mismatch error. */
    }
    
    
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);
    
    ssSetNumRWork(S, 0);  /* for zoh output feeding the delay operator */
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);

    /* config inputs */
    if (!ssSetNumInputPorts(S, 2)) return;
    
    // reference
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortSampleTime(S, 0, KERNEL_TIME);
    ssSetInputPortOffsetTime(S, 0, 0.0);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortRequiredContiguous(S, 0, 1);
    
    // adc
    ssSetInputPortWidth(S, 1, TASK_NUMBERS);
    ssSetInputPortSampleTime(S, 1, KERNEL_TIME);
    ssSetInputPortOffsetTime(S, 1, 0.0);
    ssSetInputPortDirectFeedThrough(S, 1, 1);
    ssSetInputPortRequiredContiguous(S, 1, 1);
    
    
    /* config outputs */
    if (!ssSetNumOutputPorts(S, 3)) return;
    ssSetOutputPortWidth(S, 0, 3);
    ssSetOutputPortSampleTime(S, 0, KERNEL_TIME);
    ssSetOutputPortOffsetTime(S, 0, 0.0);

    ssSetOutputPortWidth(S, 1, 1);
    ssSetOutputPortSampleTime(S, 1, KERNEL_TIME);
    ssSetOutputPortOffsetTime(S, 1, 0.0);
    
    ssSetOutputPortWidth(S, 2, TASK_NUMBERS);
    ssSetOutputPortSampleTime(S, 2, KERNEL_TIME);
    ssSetOutputPortOffsetTime(S, 2, 0.0);    
    
    ssSetNumSampleTimes(S, PORT_BASED_SAMPLE_TIMES);

    /* specify the sim state compliance to be same as a built-in block */
    ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);

    ssSetOptions(S, (SS_OPTION_EXCEPTION_FREE_CODE |
                     SS_OPTION_PORT_SAMPLE_TIMES_ASSIGNED));

    
    /* initialize kernel */
    afbs_initilize(fps);
    
    /* create task list */
    class Task a(0,  20,   TASK_0_PERIOD,  0,  0);
    class Task b(1,  20,   TASK_1_PERIOD,  0,  0);
    class Task c(2,  20,   TASK_2_PERIOD,  0,  0);

    afbs_create_task(a, NULL, NULL, NULL);
    afbs_create_task(b, NULL, NULL, NULL);
    afbs_create_task(c, NULL, NULL, NULL);
    
    step_count = 0;
} /* end mdlInitializeSizes */


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Two tasks: One continuous, one with discrete sample time of 1.0.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, KERNEL_TIME);
    ssSetOffsetTime(S, 0, 0.0);

    ssSetModelReferenceSampleTimeDefaultInheritance(S);
} /* end mdlInitializeSampleTimes */



#define MDL_INITIALIZE_CONDITIONS
/* Function: mdlInitializeConditions ==========================================
 * Abstract:
 *    Initialize both continuous states to one.
 */
static void mdlInitializeConditions(SimStruct *S)
{

} /* end mdlInitializeConditions */

/* Function: mdlOutputs =======================================================
 * Abstract:
 *      y = xD, and update the zoh internal output.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    int_T nOutputPorts = ssGetNumOutputPorts(S);
    
    const real_T *ref = ssGetInputPortRealSignal(S, 0);
    const real_T *y   = ssGetInputPortRealSignal(S, 1);
    real_T *u         = ssGetOutputPortRealSignal(S, 0);
    real_T *schedule  = ssGetOutputPortRealSignal(S, 1);
    real_T *periods   = ssGetOutputPortRealSignal(S, 2);
   // g_timer = g_timer + KERNEL_TIME;
    
    afbs_schedule();
    afbs_run();

    switch (tcb_running_id) {
        case 0:
            error[0] = abs(ref[0] - y[0]);
            u[0] = 145 * (ref[0] - y[0]) + 0 * error_s[0] + 0 * error_p[0] / (TCB[0].T_ / 10000.0);
            /* integrate error, but ignore change of reference! */
            if (error[0] < 0.5) {
                error_s[0] += error[0] * (TCB[0].T_ / 10000.0);
            }
            if (error_s[0] > 1) {
                error_s[0] = 1;
            }
            error_p[0] = error[0];
            break;

        case 1:
            error[1] = abs(ref[0] - y[1]);
            u[1] = 125 * (ref[0] - y[1]);
            error_p[1] = error[1];
            break;

        case 2:
            error[2] = abs(ref[0] - y[2]);
            u[2] = 125 * (ref[0] - y[2]);
            error_p[2] = error[2];
            break;
            
        case IDLE_TASK_IDX:
            break;
            
        default:
            ;
    }
    *schedule = tcb_running_id;
    
    // afbs_dump_information();
    afbs_update();
    
    for (int i = 0; i < TASK_NUMBERS; i++) {
        periods[i] = TCB[i].T_;
    }
} /* end mdlOutputs */



#define MDL_UPDATE
/* Function: mdlUpdate ======================================================
 * Abstract:
 *      xD = xC
 */
static void mdlUpdate(SimStruct *S, int_T tid)
{

} /* end mdlUpdate */



#define MDL_DERIVATIVES
/* Function: mdlDerivatives =================================================
 * Abstract:
 *      xdot = U
 */
static void mdlDerivatives(SimStruct *S)
{

} /* end mdlDerivatives */



/* Function: mdlTerminate =====================================================
 * Abstract:
 *    No termination needed, but we are required to have this routine.
 */
static void mdlTerminate(SimStruct *S)
{
    UNUSED_ARG(S); /* unused input argument */
    
 //   g_timer = 0;

}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
