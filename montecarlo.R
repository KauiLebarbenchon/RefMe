library(lpSolveAPI)

#p0 := unit penalty for patient n0
#h0 := position for patient n0
#fix := vector of position of scheduled patients
#P := vector of unit penalty for patients yet to be scheduled (sans patient n0)
ilp <- function(p0, h0, h, fix, P)
{
  # print(p0)
  # print(h0)
  # print(h)
  # print(fix)
  # print(P)
  
  #fix patient n0 at time h0
  fix <- append(fix, h0)
  
  m <- length(fix)
  n <- length(P)
  h <- max(c(m+n, h0))
  
  #simulate n patients
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
  
  return((get.objective(lp) / (m+n)))
}

#p0 := unit penalty for patient n0
#fix := vector of position of scheduled patients
#h := number of positions in time horizon
#lambda := parameter for rate of patient referrals
#alpha, beta := parameters for unit-penalty distribution
#n := number of iterations per position for Monte Carlo
place.patient <- function(p0, fix, h, lambda, alpha, beta, n)
{
  # res <- data.frame(matrix(0, nrow = 9, ncol = h))
  # nums <- seq(1, 5, 0.5)
  
  objectives <- rep(0.0, h)
  
  for (i in 1:h)
  {
    # k = 1
    if (!(i %in% fix))
    {
      for (j in 1:n)
      {
        #generate random patients
        N <- rpois(1, lambda)
        
        if (N == 0)
        {
          objectives[i] <- objectives[i] + (p0*i / (length(fix) + 1))
        }
        else
        {
          P <- rbeta(N, alpha, beta)
          objectives[i] <- objectives[i] + ilp(p0, i, h, fix, P)
          
        # if (j == floor(10 ^ nums[k]))
        # {
        #   res[k, i] <- objectives[i] / j
        #   k <- k + 1
        # }
        }
      }
    }
  }
  
  objectives <- objectives / n
  print(objectives)
  
  # print(res)
  
  #return argmin_{h} for the objective function
  objectives[fix] <- NA
  
  return(which.min(objectives))
}
