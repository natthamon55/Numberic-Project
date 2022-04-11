# Replicate the function in R
library(lubridate)
start <- now()
require(pracma)
f <- function(x) {
  return(x * sin(x))
}

val <- trapzfun(f,0,10,maxit = 25, tol = 1e-07)
print(val)
end <- now()
print(end-start)