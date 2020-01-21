library(ggplot2)
library(gridExtra)

data.survey <- read.csv(file="survey.csv", header=TRUE)[3:16,]
data.engagement <- data.survey[,c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8")]

plot1 <- ggplot(data.engagement, aes(x = factor(Q1))) +
  geom_bar(stat = "count", fill = "steelblue") + 
  coord_flip() + 
  ylab("Count of participants") +
  xlab("") +
  ggtitle("I think the system is easy to use.") 

plot1

plot2 <- ggplot(data.engagement, aes(x = factor(Q4))) +
  geom_bar(stat = "count", fill = "steelblue") + 
  coord_flip() + 
  ylab("Count of participants") +
  xlab("") +
  ggtitle("I would be comfortable using my phone to \n explore more while visiting a historical site.") 

plot2

plot3 <- ggplot(data.engagement, aes(x = factor(Q6))) +
  geom_bar(stat = "count", fill = "steelblue") + 
  coord_flip() + 
  ylab("Count of participants") +
  xlab("") +
  ggtitle("I feel more immersive without having to use my phone.") 

plot3


