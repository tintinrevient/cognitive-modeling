library(viridisLite)
library(lattice)
source("q1-3.R")

# Question 14
behaviourRDM <- read.table("RSAlabassignment/BehaviourRDM", col.names = 1:92)

row <- nrow(behaviourRDM)
col <- ncol(behaviourRDM)

coul <- viridis(row * col)

behaviourPlot <- levelplot(unname(as.matrix(behaviourRDM)),
          col.regions = coul,
          main = "Behaviour RDM",
          xlab = "images (1 - 92)",
          ylab = "images (1 - 92)")

avgPlot <- levelplot(avgPa, 
                     col.regions = coul, 
                     main = "Averaged RDMs from all 12 subjects",
                     xlab = "images (1 - 92)",
                     ylab = "images (1 - 92)")

grid.arrange(avgPlot, behaviourPlot, ncol=2)

# all data
behaviourRDM_filter <- lower.tri(behaviourRDM, diag = FALSE)
behaviourRDM_unique <- behaviourRDM[behaviourRDM_filter]

cor(behaviourRDM_unique, averageRDM_unique)
cor.test(behaviourRDM_unique, averageRDM_unique)

# animate objects
behaviourRDM_animate <- behaviourRDM[1:48, 1:48]
behaviourRDM_animate_filter <- lower.tri(behaviourRDM_animate, diag = FALSE)
behaviourRDM_animate_unique <- behaviourRDM_animate[behaviourRDM_animate_filter]

averageRDM_animate <- averageRDM_source[1:48,1:48]
averageRDM_animate_filter <- lower.tri(averageRDM_animate, diag = FALSE)
averageRDM_animate_unique <- averageRDM_animate[averageRDM_animate_filter]

cor(behaviourRDM_animate_unique, averageRDM_animate_unique)
cor.test(behaviourRDM_animate_unique, averageRDM_animate_unique)

#inanimate objects
behaviourRDM_inanimate <- behaviourRDM[49:92, 49:92]
behaviourRDM_inanimate_filter <- lower.tri(behaviourRDM_inanimate, diag = FALSE)
behaviourRDM_inanimate_unique <- behaviourRDM_inanimate[behaviourRDM_inanimate_filter]

averageRDM_inanimate <- averageRDM_source[49:92,49:92]
averageRDM_inanimate_filter <- lower.tri(averageRDM_inanimate, diag = FALSE)
averageRDM_inanimate_unique <- averageRDM_inanimate[averageRDM_inanimate_filter]

cor(behaviourRDM_inanimate_unique, averageRDM_inanimate_unique)
cor.test(behaviourRDM_inanimate_unique, averageRDM_inanimate_unique)

