#!/bin/bash
#SBATCH --mem=2G
module load conda_R/4.3

#input parameters
pat_score=$1
pos=$2
it=$3

#general/hospital parameters
h=20
l=16
shp1=3
shp2=4
type="b"

Rscript test_pos.R $pat_score $pos $h $shp1 $shp2 $type
