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
    double x;
    double error_i;
    double error_last;

public:
    PID_Controller(void){
      ;
    }

    PID_Controller(double Kp_, double Ki_, double Kd_, double Ts_) {
        this->Kp = Kp_;
        this->Ki = Ki_;
        this->Kd = Kd_;
        this->Ts = Ts_;
        ref = 0;
        error_i = 0;
        error_last = 0;
    }

    double set_parameters(double Kp_, double Ki_, double Kd_, double Ts_) {
      this->Kp = Kp_;
      this->Ki = Ki_;
      this->Kd = Kd_;
      this->Ts = Ts_;
    }

    double reset(void) {
        error_i = 0;
        error_last = 0;
    }

    void sampling(double ref_, double x_) {
        ref = ref_;
        x = x_;
        //mexPrintf("%f, %f\r", ref_, x_);
    }

    double output(void) {
        double error; 
        double u_p, u_i, u_d, u;
        
        error = ref - x;
        
        u_p = this->Kp * error;
        u_i = this->Ki * this->error_i;
        u_d = this->Kd * ((error - this->error_last) / this->Ts);
        u = u_p + u_i + u_d;

        this->error_i += error * this->Ts;
        this->error_last = error;

        return u;
    }
};

#endif
