library(gWidgets2)
library(gWidgets2tcltk)
library(lubridate)
library(stringr)
library(tidyverse)
library(randomcoloR)
require(deSolve)
f <- function(t,y,parms) {
  with(as.list(parms),{
      dydt <- sapply(parms,function(x)eval(x))
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
    expr <- "\\-"
  }
  expr
}
cal = function(eq,cond,t,npoint){
  png("result.png")
  points <- npoint
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
    expr <- gsub("([\\])","",expr)

    expr_arr=append(expr_arr,(parse(text=expr)))
  }
  print(expr_arr)
  y0 <- cond;
  times <- t
  start_odeint = now()
  sol_odeint <- ode(y0,times,f,parms=expr_arr)
  end_odeint = now()


  start_ivp = now()
  sol_ivp <- ode(y0,times,f,parms=expr_arr,method="rk4",)
  end_ivp = now()
  
  firstPlot <- TRUE
  colors <- c()
  name_title <- c()
  num_col <- ncol(sol_odeint)
  for(idx in 2:num_col){
    color <- randomColor()
    if(firstPlot){
      plot(times,sol_odeint[,idx],type="l",main=paste("Order Differentation"),xlab="t",ylab="Y",col=color)
      firstPlot <- FALSE
    }
    else{
      lines(times,sol_odeint[,idx],type="l",col=color)
    }
    name_title <- append(name_title,paste("Odeint Order",idx-1,collapse = ''))
    colors <- append(colors,color)
    print(length(title))
  
  }
  for(idx in 2:num_col){
    color <- randomColor()
    points(times,sol_ivp[,idx],col=color,pch=3)
    name_title <- append(name_title,paste("IVP Order",idx-1,collapse = ''))
    colors <- append(colors,color)
  }
  legend("topright",legend=name_title,fill=colors)
  dev.off()
  firstPlot <- TRUE
  colors <- c()
  name_title <- c()
  png("error.png")
  for(idx in 2:num_col){
    color <- randomColor()
    err = abs(sol_odeint[,idx]-sol_ivp[,idx])
    if(firstPlot){
      plot(times,err,type="l",main="Error between 2 method",xlab="t",ylab="Y",col=color,log='y')
      firstPlot <- FALSE
    }
    else{
      lines(times,err,type="l",col=color)
    }
    name_title <- append(name_title,paste("Order",idx-1,collapse = ''))
    colors <- append(colors,color)
  }
  legend("topright",legend=name_title,fill=colors)
  
  print(paste(points,"Points",collapse = " "))
  print(paste("Odeint R used in",end_odeint-start_odeint))
  print(paste("Solve_ivp used in",end_ivp-start_ivp))
  dev.off()
  c(end_odeint-start_odeint,end_ivp-start_ivp)
}


w <- gwindow("Order differentiation", visible=FALSE)       ## a parent container
g <- ggroup (cont = w,horizontal=FALSE,vertical=TRUE)                        ## A box container

row0 <- ggroup(cont=g)
title_f <- glabel('Enter your function',cont = row0)
insert_f <- gedit(cont=row0)
init_cond <- glabel('Initial condition :',cont = row0)
insert_cond <- gedit(cont=row0)

row1 <- ggroup(cont=g)
t_start_title <- glabel('Start time :',cont = row1)
start_t <- gedit(cont=row1)
t_end_title <- glabel('End time :',cont = row1)
end_t <- gedit(cont=row1)
point_title <- glabel('Point to point :',cont = row1)
point <- gedit(cont=row1)

row2 <- ggroup(cont=g)
bt <- gbutton(container=row2,text = "Calculate")

row3 <- ggroup(cont=g)
img <- gimage(filename = "",cont=row3)
err_img <- gimage(filename = "",cont=row3)
addHandlerClicked(bt, function(...) {          ## adding a callback to an event
  expr <- svalue(insert_f)
  cond <- as.numeric(unlist(strsplit(svalue(insert_cond),",")))
  start <- as.numeric(svalue(start_t))
  stop <- as.numeric(svalue(end_t))
  step <- (stop-start)/as.numeric(svalue(point))
  time_range <- seq(from=start, to=stop, by=step)
  time_result <- cal(expr,cond,time_range,npoint=as.numeric(svalue(point)))
  img$set_value("result.png")
  err_img$set_value("error.png")
  t_odeint$set_value(as.character(time_result[1]))
  t_solveivp$set_value(as.character(time_result[2]))
})

row4 <- ggroup(cont=g)
t_odeint_title <- glabel('Odeint :',cont = row4)
t_odeint<- glabel('0',cont = row4)
t_solveivp_title <- glabel('Solve ivp :',cont = row4)
t_solveivp<- glabel('0',cont = row4)
visible(w) <- TRUE                            ## a method call
