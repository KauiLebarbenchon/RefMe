suppressMessages(source("ilp.R"))
suppressMessages(source("pats.R"))
suppressMessages(library(tidyverse))
suppressMessages(library(utils))

args = commandArgs()
args = args[6:length(args)]

positions = read_table("positions.txt")
fix = as.character(positions$pos) %>% as.integer %>% sapply(as.numeric)
print(fix)

score = as.numeric(args[[1]])
pos = as.numeric(args[[2]])
h = as.numeric(args[[3]])
shp1 = as.numeric(args[[4]])
shp2 = as.numeric(args[[5]])
type=args[[6]]

pats = pats(h-length(fix)-1, c(shp1,shp2), type)
print(pats)

obj = ilp(score, pos, h, fix, pats)