nrm <- as.matrix(read.table("RSAlabassignment/NeuralResponses"))

pa <- 12
row <- nrow(nrm)
col <- ncol(nrm)

nrmtotal <- matrix(nrow = row*pa, ncol = col)

for(i in 1:pa){
  nm <- matrix(rnorm(row*col, mean=0,sd=1), row, col)
  cm <- nrm + nm
  dim(rbind(nrmtotal, cm))
}

nrow(nrmtotal)