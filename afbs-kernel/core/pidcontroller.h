#ifndef __PID_CONTROLLER_H_
#define __PID_CONTROLLER_H_

/* PID Controller implmentation */
class PID_Controller {
public:
    double Kp;
    double Ki;
    double Kd;
    double Ts;              // sampling time
    double ref;
    double error_i;
    double error_last;
public:
    PID_Controller(double Kp_, double Ki_, double Kd_, double Ts_) {
        this->Kp = Kp_;
        this->Ki = Ki_;
        this->Kd = Kd_;
        this->dt = dt_;
        ref = 1;
        err_p = 0;
    }

    double output(double ref, double y) {
        double error = ref - y;
        u_p = this->Kp * error;
        u_i = this->Ki * error_i; 
        u_d = this->Kd * ((error - error_last) / Ts);       
        
        u = u_p + u_i + u_d;
        
        error_i += error_i * Ts;
        error_last = error;
                
        return u;
    }

};

#endif
