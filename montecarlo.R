source("ilp.R")
library(tidyverse)
library(truncnorm)


# Base Functions ----------------------------------------------------------

#generate a vector of patients
#n := number of patients
#x := a vector of parameters for score distribution
#type := the score distribution
pats = function(n,x,type){
  
  #beta distribution
  if (type == "b"){
    return(rbeta(n,x[1],x[2]))
  }
  
  #normal distribution
  if (type == "n"){
    return(rtruncnorm(n,x[1],x[2],0,1))
  }
  
  #uniform distribution
  if(type == "u"){
    return(runif(n,0,1))
  }
}

#simulate a given position for a patient
#p0 := unit penalty for patient n0
#h0 := position for patient n0
#h :=number of slots in the horizon
#fix := vector of positions of scheduled patients
#shape := vector of parameters for the distribution of patients penalties
#type := type of distribution of scores
#i := number of iterations
sim_pos = function(p0,h0,h,fix,shape,type,i){
  res = c()
  for (j in 1:i){
    P = pats((h-length(fix)-1),shape,type)
    res = append(res,ilp(p0,h0,h,fix,P))
  }
  return(mean(res))
}


#simulate all positions available
#p0 := unit penalty for patient n0
#h := number of slots in the horizon
#fix := vector of positions of scheduled patients
#shape := vector of parameters for the distribution of patients penalties
#type := type of distribution of scores
#i := number of iterations
sim_all = function(p0,h,fix,shape,type,i){
  
  unnoc = (1:h)
  if (!length(fix)==0){
    unnoc = (1:h)[-fix]
  }
  df = data.frame(position = unnoc[1],
                  avg = sim_pos(p0,unnoc[1],h,fix,shape,type,i))
  
  for (j in 2:length(unnoc)){
    df2 = data.frame(
      position = unnoc[j],
      avg = sim_pos(p0,unnoc[j],h,fix,shape,type,i)
    )
    df = bind_rows(df,df2)
  }
  return(df)
}

# Comparison Functions ----------------------------------------------------

#place a list of incoming patients, compares score to optimal
#h := slots in the hospital
##shape := vector of parameters for the distribution of patients penalties
#type := type of distribution of scores
#pts := ordered vector of patient scores to be placed
#i := number of iterations on Monte Carlo
place_pats = function(h,shape,type,pts,i){
  pos = c()
  for (j in 1:(length(pts)-1)){
    df = sim_all(pts[j],h,pos,shape,type,i)
    new_pos = df[which(df$avg==min(df$avg)),]$pos
    pos = append(pos,new_pos)
  }
  pos = append(pos,(1:h)[-pos])
  return(pos)
}
