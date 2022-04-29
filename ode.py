from math import *
import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
# Solve differential equation. There are two main solvers in scipy
# Pretty classic, uses a particular solve called lsoda from the FORTRAN library odepack
from scipy.integrate import odeint
# More customizable, can choose from a list of possible solvers
from scipy.integrate import solve_ivp
import time
import re
def cal(t,y,expr):
    return eval(expr)
def f(t,y,all_result):

    val = list(map(lambda x:cal(t=t,y=y,expr=x),all_result))
    return val
def prep_sw_side(variable=''):
    if("y" in variable):
        order = variable.count("\'")
        with_order = "y[{}]".format(order)
        return variable[0:variable.index("y")]+with_order+variable[variable.index("y")+1+order:len(variable)]
    elif(variable=="+"):
        return "-"
    elif(variable=="-"):
        return "+"
    else:
        return variable
def calculate(expr='', cond='', time_start=0,time_end=1,points=100):
    expr = np.array(list(filter(len,re.split(r'(\-|\+|\/|\=)', expr))))
    #diff = np.where("y\'" in expr)
    diff = np.where(np.char.find(expr,"\'")>0)
    all_result = []
    for i in np.sort(diff)[0][::-1].tolist():
        form_eq = expr[i+1:expr.size]
        left_expr = form_eq[0:np.where(form_eq=="=")[0][0]]
        right_expr = form_eq[np.where(form_eq=="=")[0][0]+1:expr.size]
        new_left_expr = list(map(prep_sw_side,left_expr))
        result_expr = right_expr.tolist()
        result = (''.join(result_expr))+(''.join(new_left_expr))
        all_result.append(result)
    all_result = np.array(all_result)
    print(all_result)
    cond = tuple(np.array(cond.split(','),dtype='f'))
    t = np.linspace(float(time_start),float(time_end),points)
    start_odeint = time.time()
    sol_m1 = odeint(f, cond, t=t, tfirst=True, args=(all_result,)) #y0 คือ initial condition เป็นพารามิเตอร์
    end_odeint = time.time()

    #solve_ipn method
    start_ivp = time.time()
    sol_m2 = solve_ivp(lambda t,y,all_result:f(t=t,y=y,all_result=all_result), t_span=(0,max(t)), y0=cond, t_eval=t,args=(all_result,)) #t_span คือเราจะใช้เวลาในการsolve เท่าไหร่ระหว่าง0-1
    end_ivp = time.time()

    print("Odeint uses time : {} s".format(end_odeint-start_odeint))
    #print("solve_ivp uses time : {} s".format(end_ivp-start_ivp))

    #plot 2 methods
    plt.figure(figsize=(4,3))
    for i in range(len(sol_m1.T)):
        plt.plot(t, sol_m1.T[i], label="odeint order {}".format(i))
        plt.plot(t, sol_m2.y[i], '+',label="solve_ivp order {}".format(i))
    plt.ylabel('y(t)', fontsize=22)
    plt.xlabel('t', fontsize=22)
    plt.legend()
    plt.savefig('ode_method.png')
    
    plt.clf()
    #plot error
    plt.figure(figsize=(4,3))
    for i in range(len(sol_m1.T)):
        err = np.abs(sol_m1.T[i]-sol_m2.y[i])
        plt.semilogy(t,err)
        plt.plot(t, err,label="err order {}".format(i))
    plt.ylabel("Error")
    plt.xlabel("v")
    plt.title("Error in ode")
    plt.legend()
    plt.savefig('ode_err.png')
    
    plt.clf()

    return (str(end_odeint-start_odeint),str(end_ivp-start_ivp))
calculate(expr="y'-3*y**2=-5",cond="0")