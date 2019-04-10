#ifndef __TASK_H_
#define __TASK_H_

#include <random>

using namespace std;

extern long kernel_cnt;
/* Task states:

 */
typedef enum {ready, running, pending, waiting, deleted} e_task_status;

/* Task types:
 * periodic
 * sporadic
 * run_once (not yet implemented)
 * dual: Dual Period Task
 */
typedef enum {PERIODIC, SPORADIC, RUN_ONCE, DUAL} e_task_type;

class Task
{
public:
    int id_;
    int C_;
    int D_;
    int T_;
    int R_;

    bool rand_C;
    int C_this_;    // computation time of this release (because it is random)

    int c_;         // computation time countdown
    int d_;         // deadline countdown
    int r_;         // next release countdown
    int cnt_;       // release count


    e_task_type type_; // task type

    /* variables used for calc response time */
    long release_time_cnt;
    long start_time_cnt;
    long finish_time_cnt;

    /* statistics */
    int BCRT_; // task best-case response time
    int WCRT_; // task worst-case response time

    /* dual related */
    int TH_;
    int TL_;
    int alpha_;
    int TGamma_;
    int task_mode;
    int tick_to_switch;

    e_task_status status_;
    callback onstart_hook_;
    callback onfinish_hook_;

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
        onstart_hook_ = NULL;
        onfinish_hook_ = NULL;

        type_ = PERIODIC;   // periodic by default

        release_time_cnt = 0;
        start_time_cnt = 0;
        finish_time_cnt = 0;

        BCRT_ = 100000;
        WCRT_ = 0;

        rand_C = false;
    }

    ~Task() { ; }

    void on_task_ready(void);
    void on_task_start(void);
    void on_task_finish(void);
    void on_task_missed_deadline(void);
    void set_onstart_hook(callback onstart);
    void set_onfinish_hook(callback onfinish);
    void repr(void);

    void set_task_type(e_task_type type){type_ = type;}
};

typedef class Task CTask;

#endif
