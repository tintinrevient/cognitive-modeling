source("q4-5.R")

# Question 11
neuroRDM <- read.table("RSAlabassignment/NeuroRDM")

row <- nrow(neuroRDM)
col <- ncol(neuroRDM)

coul <- viridis(row * col)

levelplot(unname(as.matrix(neuroRDM)),
          col.regions = coul,
          main = "Neuro RDM",
          xlab = "images (1 - 92)",
          ylab = "images (1 - 92)")

neuroRDM_filter <- lower.tri(neuroRDM, diag = FALSE)
neuroRDM_unique <- neuroRDM[neuroRDM_filter]
cor(neuroRDM_unique, averageRDM_unique)
cor.test(neuroRDM_unique, averageRDM_unique)

library(car)
scatterplot(averageRDM_unique, neuroRDM_unique)

# Question 12
neuro_animate <- neuroRDM[1:48, 1:48]
neuro_animate_filter <- lower.tri(neuro_animate, diag = FALSE)
neuro_animate_unique <- neuro_animate[neuro_animate_filter]

averageRDM_animate <- averageRDM_source[1:48,1:48]
averageRDM_animate_filter <- lower.tri(averageRDM_animate, diag = FALSE)
averageRDM_animate_unique <- averageRDM_animate[averageRDM_animate_filter]

cor(neuro_animate_unique, averageRDM_animate_unique)
cor.test(neuro_animate_unique, averageRDM_animate_unique)

# Question 13
neuro_inanimate <- neuroRDM[49:92, 49:92]
neuro_inanimate_filter <- lower.tri(neuro_inanimate, diag = FALSE)
neuro_inanimate_unique <- neuro_inanimate[neuro_inanimate_filter]

averageRDM_inanimate <- averageRDM_source[49:92,49:92]
averageRDM_inanimate_filter <- lower.tri(averageRDM_inanimate, diag = FALSE)
averageRDM_inanimate_unique <- averageRDM_inanimate[averageRDM_inanimate_filter]

cor(neuro_inanimate_unique, averageRDM_inanimate_unique)
cor.test(neuro_inanimate_unique, averageRDM_inanimate_unique)
