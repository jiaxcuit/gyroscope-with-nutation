"""
Created on Thu Jun 16 14:39:21 2022
@author: River
"""
# python code to solve for the angle theta (or a), which is between the gyroscope axis and the vertical, as a function of time. 
# this is to describe nutation.
# complementary to the main simulation code. output from this file will need to be manually added to file 'simulation.m'
import numpy as np
import matplotlib.pyplot as plt
a=0.161
omega0=60 #rate of spin
I0=0.05  #MOI around spin axis
Ip=0.023   #around diameter
omegap=a*2.295*9.81/(I0*omega0)
L=I0*omega0*a    
def odeEuler(f,y0,t):

    y2 = np.zeros(len(t))
    y2[0] = y0
    for n in range(0,len(t)-1):
        y2[n+1] = y2[n] + f(y2[n],t[n])*(t[n+1] - t[n])
    return y2

t = np.linspace(0,0.1,600)
y0 = np.pi/24
f = lambda y2,t: (1/I0)*np.sqrt(abs(L**2+omegap*a*(Ip-(Ip-I0)*np.sin(y2)**2)**2-2*L*omegap*a*(Ip-(Ip-I0)*np.sin(y2)**2)*np.cos(y2)))
y2 = odeEuler(f,y0,t)
y=np.array(y2)

print(y)
m, b = np. polyfit(t, y, 1)
print(m,b)
plt. plot(t, m*t + b)
plt.plot(t,y)
plt.xlabel('t')
plt.ylabel('a')
plt.show()
