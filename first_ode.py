#ref : https://github.com/lukepolson/youtube_channel/blob/main/Python%20Tutorial%20Series/odes1.ipynb
import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
#Solve differential equation. There are two main solvers in scipy
from scipy.integrate import odeint #Pretty classic, uses a particular solve called lsoda from the FORTRAN library odepack
from scipy.integrate import solve_ivp #More customizable, can choose from a list of possible solvers
import time

def f(t, v):
  dydt = 3*v**2 - 5 #y' = 3v**2-5
  return dydt
  
v0 = 0 #the initial condition
t = np.linspace(0, 1, 100) #solve 100 ครั้งระหว่าง 0-1 เพื่อต้องการมา plot solution

start_odeint = time.time()
sol_m1 = odeint(f, y0=v0, t=t, tfirst=True) #y0 คือ initial condition เป็นพารามิเตอร์
v_sol_m1 = sol_m1.T[0]
end_odeint = time.time()

start_ivp = time.time()
sol_m2 = solve_ivp(f, t_span=(0,max(t)), y0=[v0], t_eval=t) #t_span คือเราจะใช้เวลาในการsolve เท่าไหร่ระหว่าง0-1
v_sol_m2 = sol_m2.y[0]
end_ivp = time.time()

print("Odeint uses time : {} s".format(end_odeint-start_odeint))
print("solve_ivp uses time : {} s".format(end_ivp-start_ivp))


print('odeint ans : ',v_sol_m1)
print('-------------------------------------------------------------------------------------')
print('solve_ivp ans  : ',v_sol_m2)

#plot 2 methods
plt.plot(t, v_sol_m1, label="odeint")
plt.plot(t, v_sol_m2, '+',label="solve_ivp")
plt.ylabel('y(t)', fontsize=22)
plt.xlabel('t', fontsize=22)
plt.legend()
plt.show()

#plot error
err = np.abs(v_sol_m1-v_sol_m2)
plt.ylabel("Error")
plt.semilogy(t,err)
plt.xlabel("v")
plt.plot(t, err)
plt.title("Error in ode")
plt.show()

