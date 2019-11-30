library(tidyverse)

lateralPositionOverTrialTime <- function() {
  frame <- read.csv("tableOfDriftValuesCalibration.csv", header = TRUE)
  frame %>% 
    filter(trialTime >= 15000, trialTime <= 18000) %>% 
    mutate(trialTime = trialTime / 1000,
           trial = factor(trial)) %>% 
    group_by(trial) %>% 
    ggplot(mapping = aes(x = trialTime, y = posX)) + 
    geom_line(mapping = aes(color = trial)) +
    geom_point(mapping = aes(color = trial, shape = trial)) + 
    scale_shape_manual(values = 1:20) + 
    labs(title = "Human Data (based on experiment)", 
         x = "Trial time (s)", y = "Lateral Position (m)")
}

lateralPositionOverTrialTimeHistogram <- function() {
  frame <- read.csv("tableOfDriftValuesCalibration.csv", header = TRUE)
  frame %>% 
    filter(trialTime >= 15000, trialTime <= 18000) %>% 
    mutate(trialTime = trialTime / 1000,
           trial = factor(trial)) %>% 
    group_by(trial) %>% 
    ggplot(mapping = aes(x = posX)) + 
    geom_histogram(fill = "white", color = "black", binwidth = 0.2) +
    coord_cartesian(xlim = c(-4, 4)) +
    labs(title = "Human Data (based on experiment)", 
         x = "posX (m)")
}

gaussianDistribution <- function() {
  trials <- 20
  samples <- 3000 / 50
  mean <- 0
  sd <- 0.13
  frame <- tibble()
  for(i in 1:trials) {
    simulatedData <- rnorm(samples, mean, sd) %>% 
      prepend(0.0) %>% 
      cumsum()
    subFrame <- tibble(trial = i, trialTime = seq(0, 3000, 50), posX = simulatedData)
    frame <- rbind(frame, subFrame)
  }
  
  frame <- frame %>% 
    mutate(trial = factor(trial))
  
  View(frame)
  
  # line
  ggplot(data = frame, mapping = aes(x = trialTime, y = posX)) + 
    geom_line(mapping = aes(color = trial)) +
    labs(title = "Simulated Data (based on original model)", 
         x = "Trial time (ms)", y = "Lateral Position (m)")
  
  # histogram
  ggplot(data = frame, mapping = aes(x = posX)) + 
    geom_histogram(fill = "white", color = "black", binwidth = 0.2) +
    coord_cartesian(xlim = c(-4, 4)) +
    labs(title = "Simulated Data (based on original model)", 
         x = "posX (m)")
}


