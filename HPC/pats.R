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