library(lpSolveAPI)
library(extraDistr)
library(tidyverse)
library(numbers) #Kaui, I'm too lazy to find another way to do integer floor division. I'm sure you know the solution.

#choose parameters
n = 40
m = 10
h = m + n

alpha = 2
beta = 3

#fix m patients

sample.space <- seq(1, h)
fix <- sample(sample.space, m, FALSE) 

#simulate n patients
coefficients <- vector("double", (m+n)*h)
penalties <- rep(0, n)

for (i in 1:n)
{
  penalty <- rbeta(1, alpha, beta)
  penalties[i] <- penalty

  for (j in 1:h)
  {
    coefficients[(i-1)*h + j] <- penalty * (j-1)
  }
}

lp <- make.lp(2*m+n+h, (m+n)*h)
set.objfn(lp, coefficients)
set.type(lp, c(1:((m+n)*h)), "binary")

#set constraint that each patient must be seen
set.constr.type(lp, rep("=", m+n), 1:(m+n))

for (i in 1:(m+n))
{
  set.row(lp, i, rep(1, h), indices = ((i-1)*h+1):(i*h))
}

#set constraint that each position may only be occupied by one patient
set.constr.type(lp, rep("<=", h), (m+n+1):(m+n+h))

for (i in 1:h)
{
  set.row(lp, i+m+n, rep(1, m+n), indices = seq(i, i + (m+n-1)*h, h))
}

#set constraint that each fixed patient must occupy respective position
if (m > 0)
{
  set.constr.type(lp, rep("=", m), (m+n+h+1):(2*m+n+h))
  
  for (i in 1:m)
  {
    set.row(lp, m+n+h+i, 1, indices = n*h+(i-1)*h+fix[i])
  }
}

#get constraint matrix
colnames <- rep("", (m+n)*h)

for (i in 1:n)
{
  for (j in 1:h)
  {
    colnames[(i-1)*h+j] <- paste("n", i, "h", j, sep = "")
  }
}

if (m > 0)
{
  for (i in 1:m)
  {
    for (j in 1:h)
    {
      colnames[n*h+(i-1)*h+j] <- paste("f", i, "h", j, sep = "")
    }
  }
}

mat <- data.frame(matrix(0, 2*m+n+h, (m+n)*h))

for (i in 1:(2*m+n+h))
{
  for (j in 1:((m+n)*h))
  {
    mat[i, j] <- get.mat(lp, i, j)
  }
}

colnames(mat) <- colnames

#set rhs
set.rhs(lp, rep(1, 2*m+n+h), 1:(2*m+n+h))

solve(lp)
vals <- get.variables(lp)

sol <- data.frame(matrix(0, nrow = n, ncol = 2))
colnames(sol) <- c("penalty", "position")

sol[, 1] <- penalties

for (i in 1:n)
{
  days <- vals[((i-1)*h+1):(i*h)]
  sol[i, 2] <- which(days == 1)
}

sorted <- sol[order(sol$position), ]
rank <- sol[order(sol$penalty), ]
