library(lubridate)

require(deSolve)
f <- function(t,y,parms) {  
      dydt <- c(y[2], sin(t)-c*y[1]-b*y[2])
      list(dydt)
}
b <- -2;c <- 1
y0 <- c(1,-0.5);
times <- seq(from=0,t=10,by=0.1)
coeff <- c(b,c)
start <- now()
sol <- ode(y0,times,f,parms=coeff)
end <- now()
print(sol[,2])
plot(times,sol[,2])
print(end-start)