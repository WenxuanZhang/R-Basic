f <- function(x) 2*(x[1]-1)^2 + 5*(x[2]-3)^2 + 10

# put in starting value and optimization function
r<-optim(c(1,1),f)

# Linear Programming

# Typical scenario:
# 
library(lpSolve)
object.in <- c(25,20)
const.mat <- matrix(c(20,12,1/15,1/15),nrow = 2, byrow = TRUE)
const.rhs <- c(1800,8)
const.dir <- c("<=","<=")
optimum <- lp(direction = "max", object.in,
              const.mat,const.dir,const.rhs)
