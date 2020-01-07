library(viridisLite)
library(gridExtra)
library(lattice)
library(tidyverse)

# Question 1
nrm <- read.table("RSAlabassignment/NeuralResponses")

pa <- 12
pa_list <- list()
pa_dissimilarity_list <- list()

row <- nrow(nrm)
col <- ncol(nrm)
mean <- 0
sd <- 1

# neural responses data mixed with the random noise coming from the normal distribution by rnorm()
# pa_list is a list containing all the simulated 12 participants data
for(i in 1:pa) {
  noise <- matrix(rnorm(row * col, mean = mean, sd = sd), nrow = row, ncol = col);
  pa_list[[i]] <- nrm + noise;
}

# dissimilarity matrix is compuated by the formula as below:
# step 1: transpose the 92x100 matrix to 100x92 matrix
# step 2: calculate the correlation pairwise for every image, correlation = similarity
# step 3: 1 - cor() = dissimilarity
for(i in 1:length(pa_list)) {
  pa_dissimilarity_list[[i]] <- 1 - cor(t(pa_list[[i]]))
}

# Question 2
# plot for a simulated subject and for the original data
coul <- viridis(row * col)

# a random single simulated data from subject 1
subjectPlot <- levelplot(pa_dissimilarity_list[[1]], 
                   col.regions = coul, 
                   main = "Subject 12 with normally-distributed noise",
                   xlab = "images (1 - 92)",
                   ylab = "images (1 - 92)")

originalPlot <- levelplot(1 - cor(t(nrm)), 
                   main = "Original data",
                   col.regions = coul, 
                   xlab = "images (1 - 92)",
                   ylab = "images (1 - 92)")

grid.arrange(subjectPlot, originalPlot, ncol=2)

# Question 3

# average PP
avgPa <- matrix(data = 0, nrow = 92, ncol = 92);
for(i in 1:length(pa_dissimilarity_list)) {
  avgPa <- avgPa + pa_dissimilarity_list[[i]];
}
avgPa <- avgPa / pp

# Compare the averaged RDMs of 12 subjects to a single RDM
avgPlot <- levelplot(avgPa, 
                     col.regions = coul, 
                     main = "Averaged RDMs from all 12 subjects",
                     xlab = "images (1 - 92)",
                     ylab = "images (1 - 92)")

subjectPlot <- levelplot(pa_dissimilarity_list[[1]], 
                         col.regions = coul, 
                         main = "Subject 1 with normally-distributed noise",
                         xlab = "images (1 - 92)",
                         ylab = "images (1 - 92)")

grid.arrange(avgPlot, subjectPlot, ncol=2)

# Compare the averaged RDMs of 12 subjects to the original data
avgPlot <- levelplot(avgPa, 
                     col.regions = coul, 
                     main = "Averaged RDMs from all 12 subjects",
                     xlab = "images (1 - 92)",
                     ylab = "images (1 - 92)")

originalPlot <- levelplot(1 - cor(t(nrm)), 
                          main = "Original data",
                          col.regions = coul, 
                          xlab = "images (1 - 92)",
                          ylab = "images (1 - 92)")

grid.arrange(avgPlot, originalPlot, ncol=2)
