# Second )DE
#ref : https://github.com/lukepolson/youtube_channel/blob/main/Python%20Tutorial%20Series/odes1.ipynb
#ref solve_ipn: https://media.ed.ac.uk/media/Solving+Differential+Equations+in+PythonA+Higher+order+ODEs+with+solve_ivp/1_c8g7fwhw
import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
#Solve differential equation. There are two main solvers in scipy
from scipy.integrate import odeint #Pretty classic, uses a particular solve called lsoda from the FORTRAN library odepack
from scipy.integrate import solve_ivp #More customizable, can choose from a list of possible solvers
import time

def f(x, S):  #x' = v, v' = -v**2 + sin(x)
    x, v = S
    return [v,
           -v**2 + np.sin(x)]
    
x_0 = 0 #the initial condition
v_0 = 5 #the initial condition

t = np.linspace(0, 1, 100) #solve 100 ครั้งระหว่าง 0-1 เพื่อต้องการมา plot solution

#odeint method
start_odeint = time.time()
sol_m1 = odeint(f, y0= (x_0,v_0), t=t, tfirst=True) #y0 คือ initial condition เป็นพารามิเตอร์
x_sol_1 = sol_m1.T[0]
v_sol_1 = sol_m1.T[1]
end_odeint = time.time()

#solve_ipn method
start_ivp = time.time()
sol_m2 = solve_ivp(f, t_span=(0,max(t)), y0=[x_0,v_0], t_eval=t) #t_span คือเราจะใช้เวลาในการsolve เท่าไหร่ระหว่าง0-1
x_sol_2 = sol_m2.y[0]
v_sol_2 = sol_m2.y[1]
end_ivp = time.time()

print("Odeint uses time : {} s".format(end_odeint-start_odeint))
print("solve_ivp uses time : {} s".format(end_ivp-start_ivp))

#plot 2 methods
plt.plot(t, x_sol_1,label="odeint_x")
plt.plot(t, v_sol_1,label="odeint_v")
plt.plot(t, x_sol_2 ,'+',label="solve_ivp_x")
plt.plot(t, v_sol_2 , '+',label="solve_ivp_v")
plt.title("2method ode")
plt.legend() # Adding legend, which helps us recognize the curve according to it's color
plt.show()

#plot error
err1 = np.abs(x_sol_1-x_sol_2)
err2 = np.abs(v_sol_1-v_sol_2)
plt.ylabel("Error")
plt.xlabel("x,v")
plt.plot(t, err1,label="err_1")
plt.plot(t, err2,label="err_2")
plt.title("Error in ode")
plt.legend()
plt.show()
