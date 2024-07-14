library(tidyverse)

#parameters
doc_par = c("location","cost","insurance","availability")
ins = c("A","B","C","D")

pat_par = c("location", "max_cost","insurance","minimize")
minimize = c("time","distance", "null")

#generates doctor
doc = function(){
  data.frame(
    location = paste(floor(runif(2,0.0,10001.0)),collapse=","),
    cost = floor(runif(1,100.0,501.0)),
    insurance = paste(sample(ins,sample(1:4,1)),collapse=","),
    availability = sample(1:100,1)
  )
}

#generates patient
pat = function(){
  data.frame(
    location = paste(floor(runif(2,0.0,10001.0)),collapse=","),
    max_cost = floor(runif(1,200.0,501.0)),
    insurance = sample(ins,1),
    minimize = sample(minimize,1)
  )
}

#generates matrix n doctors
doc_space = function(n){
  s = doc()
  for (x in 1:(n-1)){
    s=bind_rows(s,doc())
  }
  s
}
