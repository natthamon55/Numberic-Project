library(gWidgets2)
library(gWidgets2tcltk)
w <- gwindow("Order differentiation", visible=FALSE)       ## a parent container
g <- ggroup (cont = w)                        ## A box container
b <- gbutton("Click me for a message", cont=g, expand=TRUE)  ## some control
e <- gedit(cont=g)
addHandlerClicked(b, function(...) {          ## adding a callback to an event
  gmessage("Hello world!", parent=w)          ## a dialog		    
})

visible(w) <- TRUE                            ## a method call