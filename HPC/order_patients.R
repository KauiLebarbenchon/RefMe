if(!exists("place.patient", mode="function")) source("place_patient.R")

#P := vector of unit priorities
#lambda := parameter for rate of patient referrals
#alpha, beta := parameters for unit-penalty distribution
#n := number of samples for each position
order.patients <- function(P, h, lambda, alpha, beta, n)
{
  order <- rep(NA, length(P))
  fix <- c()
  
  #schedule each patient
  for (p in P)
  {
    index <- place.patient(p, fix, h, lambda, alpha, beta, n)
    order[index] <- p
    fix <- append(fix, index)
  }
  
  #return time horizon occupied by patients
  return(order)
}