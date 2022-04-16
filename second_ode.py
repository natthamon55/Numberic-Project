from scipy.integrate import odeint
import numpy as np
import matplotlib.pyplot as plt
import sympy
import time
# y'' - 2y' + y = sin(t), y(0)=1.0,y'(0)=-0.5
def f(y, t, b, c):#return y',y''
    dydt = [y[1], np.sin(t)-c*y[0]-b*y[1]] #y'' = sin(y)-y(t)+2y'(t)
    return dydt
b = -2
c = 1
y0 = [1, -0.5]
t_all = np.linspace(0, 10,101)
start_odeint = time.time()
sol = odeint(f, y0, t_all, args=(b, c))
end_odeint = time.time()

plt.xlabel("t")
plt.ylabel("y(t)")
plt.plot(t_all,sol[:,0])

t = sympy.symbols('t')
y = sympy.Function('y')

dydt = sympy.diff(y(t),t,1)
dy2dt2 = sympy.diff(y(t),t,2)
eqn = sympy.Eq(dy2dt2 - 2*dydt + y(t), sympy.sin(t) ) # define ODE
ics = {y(0): 1.0, y(t).diff(t).subs(t, 0): -0.5}

start_dsolve = time.time()
sol2 = sympy.dsolve(eqn,y(t),ics=ics)
end_dsolve = time.time()

f = sympy.lambdify(t,sol2.rhs,'numpy')
plt.plot(t_all,f(t_all))
plt.show()
print("Odeint uses time : {} s".format(end_odeint-start_odeint))
print("Odeint uses time : {} s".format(end_dsolve-start_dsolve))
