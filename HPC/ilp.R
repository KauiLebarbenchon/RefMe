library(lpSolveAPI)

#p0 := unit penalty for patient n0
#h0 := position for patient n0
#h := superfluous
#fix := vector of position of scheduled patients
#P := vector of unit penalty for patients yet to be scheduled (sans patient n0)
ilp <- function(p0, h0, h, fix, P)
{
  #fix patient n0 at time h0
  fix <- append(fix, h0)
  
  m <- length(fix)
  n <- length(P)
  h <- max(c(m+n, max(fix)))
  
  #create objective function
  coefficients <- rep(0.0, (m+n)*h)
  
  for (i in 1:n)
  {
    for (j in 1:h)
    {
      coefficients[(i-1)*h + j] <- P[i] * (j-1)
    }
  }
  
  for (j in 1:h)
  {
    coefficients[n*h+(m-1)*h+j] <- p0 * (j-1)
  }
  
  #initialize lpSolve object
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
  set.constr.type(lp, rep("=", m), (m+n+h+1):(2*m+n+h))
  
  for (i in 1:m)
  {
    set.row(lp, m+n+h+i, 1, indices = n*h+(i-1)*h+fix[i])
  }
  
  #set rhs
  set.rhs(lp, rep(1, 2*m+n+h), 1:(2*m+n+h))
  
  #solve ilp
  solve(lp)
  
  #return objective function per patient
  return((get.objective(lp) / (n+1)))
}