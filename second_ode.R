library(lubridate)
library(stringr)
library(tidyverse)
require(deSolve)
png("second_order.png")
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

b <- -2;c <- 1;y0 <- c(-1,-0.5);
eq <- "y''(t)+2*y'(t)+y(t)=sin(t)"
eq <- unlist(strsplit(eq,"(?=[\\+|\\-|\\=|\\*|\\/])",perl=TRUE))
diff <- str_which(eq,"'")
expr_arr <- c()
for (i in sort(diff,decreasing = TRUE)){
  form_eq = Filter(Negate(is.na),eq[i+1:length(eq)])
  left_side = form_eq[1:which(form_eq=="=")-1]
  right_side = Filter(Negate(is.na),form_eq[which(form_eq=="=")+1:length(form_eq)])
  
  left_expr <- map(.x=left_side,.f=prep_sw_side)
  
  left_expr = paste(left_expr,collapse ='')
  right_expr = paste(right_side,collapse ='')
  expr <- paste(right_expr,left_expr,collapse = '')
  expr_arr=append(expr_arr,(parse(text=expr)))
}

parms <- c(b,c,expr_arr);
times <- seq(from=0,t=10,by=0.1)
start <- now()
sol <- ode(y0,times,f,parms)
end <- now()
plot(times,sol[,2])
print(end-start)
dev.off()