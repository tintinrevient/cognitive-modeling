library(viridisLite)
library(lattice)
source("q4-5.R")

# Question 15
hMaxRDM <- read.table("RSAlabassignment/HmaxRDM", col.names = 1:92)

row <- nrow(hMaxRDM)
col <- ncol(hMaxRDM)

coul <- viridis(row * col)

# the model plot
modePlot <- levelplot(unname(as.matrix(hMaxRDM)),
          col.regions = coul,
          main = "Behaviour RDM",
          xlab = "images (1 - 92)",
          ylab = "images (1 - 92)")

# the human data from IT neural responses
humanPlot <- levelplot(avgPa, 
                       main = "Neuro RDM of human",
                       col.regions = coul, 
                       xlab = "images (1 - 92)",
                       ylab = "images (1 - 92)")

grid.arrange(modePlot, humanPlot, ncol=2)

# all data
hMaxRDM_filter <- lower.tri(hMaxRDM, diag = FALSE)
hMaxRDM_unique <- hMaxRDM[hMaxRDM_filter]

cor(hMaxRDM_unique, averageRDM_unique)
cor.test(hMaxRDM_unique, averageRDM_unique)

# animate objects
hMaxRDM_animate <- hMaxRDM[1:48, 1:48]
hMaxRDM_animate_filter <- lower.tri(hMaxRDM_animate, diag = FALSE)
hMaxRDM_animate_unique <- hMaxRDM_animate[hMaxRDM_animate_filter]

averageRDM_animate <- averageRDM_source[1:48,1:48]
averageRDM_animate_filter <- lower.tri(averageRDM_animate, diag = FALSE)
averageRDM_animate_unique <- averageRDM_animate[averageRDM_animate_filter]

cor(hMaxRDM_animate_unique, averageRDM_animate_unique)
cor.test(hMaxRDM_animate_unique, averageRDM_animate_unique)

#inanimate objects
hMaxRDM_inanimate <- hMaxRDM[49:92, 49:92]
hMaxRDM_inanimate_filter <- lower.tri(hMaxRDM_inanimate, diag = FALSE)
hMaxRDM_inanimate_unique <- hMaxRDM_inanimate[hMaxRDM_inanimate_filter]

averageRDM_inanimate <- averageRDM_source[49:92,49:92]
averageRDM_inanimate_filter <- lower.tri(averageRDM_inanimate, diag = FALSE)
averageRDM_inanimate_unique <- averageRDM_inanimate[averageRDM_inanimate_filter]

cor(hMaxRDM_inanimate_unique, averageRDM_inanimate_unique)
cor.test(hMaxRDM_inanimate_unique, averageRDM_inanimate_unique)

