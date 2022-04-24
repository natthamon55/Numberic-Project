library(lubridate)
library(stringr)
library(tidyverse)
require(deSolve)
png("Fisrt_order.png")
f <- function(t,y,parms) {
  with(as.list(parms),{
      dydt <- sapply(expr_arr,function(x)eval(x))
      list(dydt)
  })
}
prep_sw_side <- function(expr){
  if(str_detect(expr,"y")){
    diff = str_count(expr,"'")
    expr <- paste("y[",(diff+1),"]")
  }
  else if(str_detect(expr,"\\-")){
    expr <- "\\+"
  }
  else if(str_detect(expr,"\\+")){
    expr <- "-"
  }
  expr
}

eq <- "y'(t)=3*y**2-5"
#Seperate operator and variable
eq <- unlist(strsplit(eq,"(?=[\\+|\\-|\\=|\\*|\\/])",perl=TRUE))
diff <- str_which(eq,"'")
expr_arr <- c()
for (i in sort(diff,decreasing = TRUE)){
  #Seperate left side and right of equation
  form_eq = Filter(Negate(is.na),eq[i+1:length(eq)])
  left_side = form_eq[1:which(form_eq=="=")-1]
  right_side = Filter(Negate(is.na),form_eq[which(form_eq=="=")+1:length(form_eq)])
  
  left_expr <- map(.x=left_side,.f=prep_sw_side)
  left_expr = paste(left_expr,collapse ='')
  right_expr = paste(right_side,collapse ='')
  expr <- paste(right_expr,left_expr,collapse = '')
  expr_arr=append(expr_arr,(parse(text=expr)))
}
print(expr_arr)
parm <- expr_arr
y0 <- c(0);
times <- seq(from=0,t=1,by=0.01)

start_odeint = now()
sol_odeint <- ode(y0,times,f,parms=parm)
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

dev.off()