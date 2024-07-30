library(lpSolveAPI)

#h0 := penalty for patient n0
#fix := vector of fixed positions for patients m
#lambda := rate of patient referrals
ilp <- function(h0, fix, lambda)
{
  #fix patient n0 at time h0
  fix <- append(fix, n0)
  
  m = length(fix)
  n <- rpois(1, lambda)
  h = m + n
  
  alpha = 2
  beta = 3
  
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
  
  #set rhs
  set.rhs(lp, rep(1, 2*m+n+h), 1:(2*m+n+h))
  
  #solve ilp
  solve(lp)
  
  #return penalty
  return(get.objective(lp))
}
