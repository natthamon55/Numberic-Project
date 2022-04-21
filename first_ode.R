require(lubridate)
require(deSolve)
f <- function(t,y,parms) {  
      dydt <- 3*y**2 - 5
      list(dydt)
}
y0 <- 0;
times <- seq(from=0,t=1,by=0.01)

start_odeint = now()
sol_odeint <- ode(y0,times,f,parms=NULL)
end_odeint = now()
par(mfrow = c(2, 1))
plot(times,sol_odeint[,2],type="l",main="First Order Differentation",xlab="t",ylab="Y")

start_ivp = now()
sol_ivp <- ode(y0,times,f,parms=NULL,method="rk4",)
end_ivp = now()

points(times,sol_ivp[,2],col="orange",pch=3)
legend("topright",legend=c("Odeint","IVP"),fill=c("black","orange"))

print(paste("Odeint R used in",end_odeint-start_odeint))
print(paste("Solve_ivp used in",end_ivp-start_ivp))

err = abs(sol_odeint[,2]-sol_ivp[,2])
plot(times,err,col="red",type="l",main="Error between in 2 method")
png("First_order.png")
dev.off()