if(!exists("n.ilp", mode="function")) source("n_ilp.R")

#p0 := unit penalty for patient n0
#fix := vector of position of scheduled patients
#h := number of positions in time horizon
#lambda := parameter for rate of patient referrals
#alpha, beta := parameters for unit-penalty distribution
#n := number of samples for each position
place.patient <- function(p0, fix, h, lambda, alpha, beta, n)
{
  objectives <- rep(0, h)
  
  #compute expected objective for each position
  for (i in 1:h)
  {
    if (!(i %in% fix))
    {
      objectives[i] <- n.ilp(p0, i, fix, h, lambda, alpha, beta, n)
    }
  }

  #return argmin_{h} for the objective function
  objectives[fix] <- NA
  
  return(which.min(objectives))
}