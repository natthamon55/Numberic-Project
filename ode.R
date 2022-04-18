library(lubridate)

require(deSolve)
f <- function(t,y,parms) {
  with(as.list(parms),{
      dydt <- c(y[1],sin(t)-c*y[1]-b*y[2])
      list(dydt)
  })
}
b <- -2;c <- 1;y0 <- c(-1,-0.5);
parms <- c(b,c);
times <- seq(from=0,t=10,by=0.1)
start <- now()
sol <- ode(y0,times,f,parms)
end <- now()
plot(times,sol[,2])
print(end-start)