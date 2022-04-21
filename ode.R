library(lubridate)

require(deSolve)
f <- function(y,t,parms) {  
      dydt <- 3*y**2 - 5
      list(dydt)
}

y0 <- 0;
parms <- c(b,c);
times <- seq(from=0,t=10,by=0.1)
start <- now()
sol <- lsoda(y0,times,f,parms=NULL)
end <- now()
print(sol[,2])
plot(times,sol[,2])
print(end-start)