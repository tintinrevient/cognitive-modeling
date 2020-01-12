source("q1-3.R")
source("q4-5.R")

# Question 11
# Plots of human and macaque monkey data

# macaque monkey data
neuroRDM <- read.table("RSAlabassignment/NeuroRDM")

row <- nrow(neuroRDM)
col <- ncol(neuroRDM)

coul <- viridis(row * col)

# the macaque monkey data from IT neural responses
monkeyPlot <- levelplot(unname(as.matrix(neuroRDM)), 
                         col.regions = coul, 
                         main = "Neuro RDM of macaque monkey",
                         xlab = "images (1 - 92)",
                         ylab = "images (1 - 92)")

# the human data from IT neural responses
humanPlot <- levelplot(avgPa, 
                          main = "Neuro RDM of human",
                          col.regions = coul, 
                          xlab = "images (1 - 92)",
                          ylab = "images (1 - 92)")

grid.arrange(monkeyPlot, humanPlot, ncol=2)

neuroRDM_filter <- lower.tri(neuroRDM, diag = FALSE)
neuroRDM_unique <- neuroRDM[neuroRDM_filter]
cor(neuroRDM_unique, averageRDM_unique)
cor.test(neuroRDM_unique, averageRDM_unique)

# Question 12
neuro_animate <- neuroRDM[1:48, 1:48]
neuro_animate_filter <- lower.tri(neuro_animate, diag = FALSE)
neuro_animate_unique <- neuro_animate[neuro_animate_filter]

averageRDM_animate <- averageRDM_source[1:48,1:48]
averageRDM_animate_filter <- lower.tri(averageRDM_animate, diag = FALSE)
averageRDM_animate_unique <- averageRDM_animate[averageRDM_animate_filter]

cor(neuro_animate_unique, averageRDM_animate_unique)
cor.test(neuro_animate_unique, averageRDM_animate_unique)

# comparison scatter plots

library(car)
# scatter plot for all the objects
scatterplot(averageRDM_unique ~ neuroRDM_unique, 
                           xlab = "Neuro RDM of macaque monkey", 
                           ylab = "Neuro RDM of human",
                           main = "Scatter Plot between macaque monkey and human")

# scatter plot for only the animate objects
scatterplot(averageRDM_animate_unique ~ neuro_animate_unique, 
            xlab = "Neuro animate RDM of macaque monkey", 
            ylab = "Neuro animate RDM of human",
            main = "Scatter Plot between macaque monkey and human")

# scatter plot for all the objects after the normalization
avg_mean <- mean(averageRDM_unique)
avg_sd <- sd(averageRDM_unique)
averageRDM_unique_norm <- (averageRDM_unique - avg_mean)/avg_sd

neuro_mean <- mean(neuroRDM_unique)
neuro_sd <- sd(neuroRDM_unique)
neuroRDM_unique_norm <- (neuroRDM_unique - neuro_mean)/neuro_sd

avg_animate_mean <- mean(averageRDM_animate_unique)
avg_animate_sd <- sd(averageRDM_animate_unique)
averageRDM_animate_unique_norm <- (averageRDM_animate_unique - avg_animate_mean)/avg_animate_sd

neuro_animate_mean <- mean(neuro_animate_unique)
neuro_animate_sd <- sd(neuro_animate_unique)
neuro_animate_unique_norm <- (neuro_animate_unique - neuro_animate_mean)/neuro_animate_sd

scatterplot(averageRDM_unique_norm ~ neuroRDM_unique_norm, 
            xlab = "Neuro RDM of macaque monkey", 
            ylab = "Neuro RDM of human",
            main = "Scatter Plot between macaque monkey and human")

scatterplot(averageRDM_animate_unique_norm ~ neuro_animate_unique_norm, 
            xlab = "Neuro animate RDM of macaque monkey", 
            ylab = "Neuro animate RDM of human",
            main = "Scatter Plot between macaque monkey and human")

# correlation after normalization
cor(neuroRDM_unique_norm, averageRDM_unique_norm)
cor.test(neuroRDM_unique_norm, averageRDM_unique_norm)
# euclidean distance
d <- sqrt(sum((neuroRDM_unique - averageRDM_unique)^2)) 
d_norm <- sqrt(sum((neuroRDM_unique_norm - averageRDM_unique_norm)^2))

cor(neuro_animate_unique_norm, averageRDM_animate_unique_norm)
cor.test(neuro_animate_unique_norm, averageRDM_animate_unique_norm)
# euclidean distance
d_animate <- sqrt(sum((neuro_animate_unique - averageRDM_animate_unique)^2))
d_animate_norm <- sqrt(sum((neuro_animate_unique_norm - averageRDM_animate_unique_norm)^2))

# Question 13
neuro_inanimate <- neuroRDM[49:92, 49:92]
neuro_inanimate_filter <- lower.tri(neuro_inanimate, diag = FALSE)
neuro_inanimate_unique <- neuro_inanimate[neuro_inanimate_filter]

averageRDM_inanimate <- averageRDM_source[49:92,49:92]
averageRDM_inanimate_filter <- lower.tri(averageRDM_inanimate, diag = FALSE)
averageRDM_inanimate_unique <- averageRDM_inanimate[averageRDM_inanimate_filter]

cor(neuro_inanimate_unique, averageRDM_inanimate_unique)
cor.test(neuro_inanimate_unique, averageRDM_inanimate_unique)
