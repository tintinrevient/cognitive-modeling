library(tidyverse)
library(lattice)
library(viridisLite)
library(gridExtra)

table <- read.table("NeuralResponses")
row <- nrow(table)
col <- ncol(table)
mean <- 0
sd <- 1

pp <- 12
pp_list <- list()
for(i in 1:pp) {
  noise <- matrix(rnorm(row * col, mean = mean, sd = sd), nrow = row, ncol = col);
  pp_list[[i]] <- table + noise;
}

pp_dissimilarity_list <- list()
for(i in 1:length(pp_list)) {
  pp_dissimilarity_list[[i]] <- 1 - cor(t(pp_list[[i]]))
}

View(pp_list[[1]])

# average PP
avgPP <- matrix(data = 0, nrow = 92, ncol = 92);
for(i in 1:length(pp_dissimilarity_list)) {
  avgPP <- avgPP + pp_dissimilarity_list[[i]];
}
avgPP <- avgPP / pp

# plot

coul <- viridis(row * col)

plot1 <- levelplot(pp_dissimilarity_list[[12]], 
          col.regions = coul, 
          main = "Subject 12 with normally-distributed noise",
          xlab = "images (1 - 92)",
          ylab = "images (1 - 92)")

plot2 <- levelplot(1 - cor(t(table)), 
          main = "Original data",
          col.regions = coul, 
          xlab = "images (1 - 92)",
          ylab = "images (1 - 92)")

grid.arrange(plot1, plot2, ncol=2)

# Compare averaged RDMs with a random single RDM

avgPlot <- levelplot(avgPP, 
                     col.regions = coul, 
                     main = "Averaged RDMs from all 12 subjects",
                     xlab = "images (1 - 92)",
                     ylab = "images (1 - 92)")

singlePlot <- levelplot(pp_dissimilarity_list[[1]], 
                   col.regions = coul, 
                   main = "Subject 1 with normally-distributed noise",
                   xlab = "images (1 - 92)",
                   ylab = "images (1 - 92)")

grid.arrange(avgPlot, singlePlot, ncol=2)

# playfield for question 1
ttable <- t(table)
# more similar
subtable1 <- ttable[,c(60, 70)]
# more dissimilar
subtable2 <- ttable[, c(20, 70)]

# euclidean distance
d1 <- sqrt(sum((subtable1[,1] - subtable1[,2])^2)) # more similar
d2 <- sqrt(sum((subtable2[,1] - subtable2[,2])^2)) # more dissimilar

# scatterplot
library(car)
scatterplot(subtable1[,1] ~ subtable1[,2], data=subtable1, xlab = "Sample No. 60", ylab = "Sample No. 70", main = "Sample No. 60 vs Sample No. 70") # more similar
scatterplot(subtable2[,1] ~ subtable2[,2], data=subtable2, xlab = "Sample No. 20", ylab = "Sample No. 70", main = "Sample No. 20 vs Sample No. 70") # more dissimilar

# correlation
# more silimar
co1 <- sum((subtable1[,1] - mean(subtable1[,1]))*(subtable1[,2] - mean(subtable1[,2]))) / sqrt((sum((subtable1[,1] - mean(subtable1[,1]))^2))*(sum((subtable1[,2] - mean(subtable1[,2]))^2)))
cor(subtable1)
# more dissimilar
co2 <- sum((subtable2[,1] - mean(subtable2[,1]))*(subtable2[,2] - mean(subtable2[,2]))) / sqrt((sum((subtable2[,1] - mean(subtable2[,1]))^2))*(sum((subtable2[,2] - mean(subtable2[,2]))^2)))
cor(subtable2)
