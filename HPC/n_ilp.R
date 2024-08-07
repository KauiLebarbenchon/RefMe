if(!exists("ilp", mode="function")) source("ilp.R")

#p0 := unit penalty for patient n0
#h0 := position of patient n0
#fix := vector of position of scheduled patients
#h := number of positions in time horizon
#lambda := parameter for rate of patient referrals
#alpha, beta := parameters for unit-penalty distribution
#n := number of samples for each position
n.ilp <- function(p0, h0, fix, h, lambda, alpha, beta, n)
{
  objective <- 0
  
  #simulate random posterior patients n times
  for (i in 1:n)
  {
    N <- rpois(1, lambda)
    
    if (N == 0)
    {
      objective <- objective + p0*h0
    }
    else
    {
      P <- rbeta(N, alpha, beta)
      
      objective <- objective + ilp(p0, h0, fix, h, P)
    }
  }
  
  #return average objective
  return(objective / n)
}