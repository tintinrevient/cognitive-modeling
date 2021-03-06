library(tidyverse)
load("keyPressDataWithLaneDeviation.Rdata")
# A
totalDialingTime <- function() {
  
  frame <- keyPressDataWithLaneDeviation #read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
  pp <- length(unique(frame$pp))

  frame <- frame %>% 
    filter(phoneNrLengthAfterKeyPress == 11, 
           typingErrorMadeOnTrial == 0, 
           partOfExperiment == "dualSteerFocus" | partOfExperiment == "dualDialFocus") %>% 
    group_by(partOfExperiment) %>% 
    summarise(mean = round(mean(timeRelativeToTrialStart) / 1000, digits = 1),
              sd = round(sd(timeRelativeToTrialStart) / 1000, digits = 1)) %>% 
    mutate(se = round(sd / sqrt(pp), digits = 1))
  
  View(frame)
}

# B
absoluteLaneDeviationByEachKeypress <- function() {
  frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
  pp <- length(unique(frame$pp))
  
  frame <- frame %>% 
    filter(typingErrorMadeOnTrial == 0, 
           partOfExperiment == "dualSteerFocus" | partOfExperiment == "dualDialFocus") %>% 
    select(partOfExperiment, pp, trial, phoneNrLengthAfterKeyPress, lanePosition)
  

  # ppn <- frame[i]$pp
  # tn <- frame[i]$trial
  # plp <- frame[i]$lanePostion
  ppn <- -1
  tn <- -1
  diff <- c()
  
  dataFrameFrame <- data.frame(frame)
  
  for(i in 1:nrow(frame)){
    
    newPp <- frame[i,]$pp
    newTn <- frame[i,]$trial
    
    if(ppn != newPp || tn != newTn){
      ppn <- newPp
      tn <- newTn
      ss <- subset(frame, pp == newPp & trial == newTn)
      diffDev <- diff(abs(ss$lanePosition))
      diffDev <- prepend(diffDev, 0.0)
      diff <- c(diff, abs(diffDev))
    }
    
  }
  
  View(diff)
  
  dataFrameFrame$diff <- diff
  View(dataFrameFrame)
  
  dataFrameFrameFrame <- dataFrameFrame %>% 
    group_by(partOfExperiment, pp, trial) %>% 
    summarise(totalDiffByTrial = sum(diff)) %>% 
    group_by(partOfExperiment) %>%
    summarise(mean = mean(totalDiffByTrial),
              sd = sd(totalDiffByTrial),
              se = sd / sqrt(12))
  
  
  View(dataFrameFrameFrame)
  
  #   mutate(diff = 0)
  #   
  # matrixFrame <- as.matrix(sapply(frame, as.numeric))
  # batch <- nrow(frame) / 13
  # for(i in 1:batch) {
  #   for(j in 1:13) {
  #     rowNo <- (i-1)*13 + j
  #     if(j == 1){
  #       matrixFrame[rowNo, 6] = 0
  #     } else {
  #       matrixFrame[rowNo, 6] = abs(matrixFrame[rowNo, 5] - matrixFrame[rowNo-1, 5])
  #     }
  #   }
  # }
  # 
  # dataFrame <- as_tibble(matrixFrame) %>% 
  #   mutate(partOfExperiment = ifelse(partOfExperiment == 1, "dualDialFocus", "dualSteerFocus")) %>% 
  #   filter(phoneNrLengthAfterKeyPress >= 1)
  
  View(dataFrame)
  
  resultFrame <- dataFrame %>% 
    group_by(partOfExperiment) %>% 
    summarise(mean = mean(diff),
              sd = sd(diff)) %>% 
    mutate(se = sd / sqrt(pp))
  
  View(resultFrame)
}

# B
absoluteLaneDeviationByAllKeypresses <- function() {
  frame <- keyPressDataWithLaneDeviation #read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
  pp <- length(unique(frame$pp))
  
  frame <- frame %>% 
    filter(typingErrorMadeOnTrial == 0, 
           partOfExperiment == "dualSteerFocus" | partOfExperiment == "dualDialFocus") %>% 
    select(partOfExperiment, pp, trial, phoneNrLengthAfterKeyPress, lanePosition) %>% 
    mutate(diff = 0)
  
  for(p in 1:pwrte){
    laneAbs
    dframe <- diff(lanAbs, 1)
  }
  
  matrixFrame <- as.matrix(sapply(frame, as.numeric))
  batch <- nrow(frame) / 2
  for(i in 1:batch) {
    for(j in 1:2) {
      rowNo <- (i-1)*2 + j
      if(j == 1){
        matrixFrame[rowNo, 6] = 0
      } else {
        matrixFrame[rowNo, 6] = abs(matrixFrame[rowNo, 5] - matrixFrame[rowNo-1, 5])
      }
    }
  }
  
  dataFrame <- as_tibble(matrixFrame) %>% 
    mutate(partOfExperiment = ifelse(partOfExperiment == 1, "dualDialFocus", "dualSteerFocus")) %>% 
    filter(phoneNrLengthAfterKeyPress == 12)
  
  View(dataFrame)
  
  resultFrame <- dataFrame %>% 
    group_by(partOfExperiment) %>% 
    summarise(mean = mean(diff),
              sd = sd(diff)) %>% 
    mutate(se = sd / sqrt(pp))
  
  View(resultFrame)
}

# C
plot <- function() {
  frame <- keyPressDataWithLaneDeviation #read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)

  frame <- frame %>%  filter(phoneNrLengthAfterKeyPress %in% c(1: 11), 
                             typingErrorMadeOnTrial == 0,
                             partOfExperiment == "dualSteerFocus" | partOfExperiment == "dualDialFocus") %>% 
    mutate(lanePosition = abs(lanePosition),
           Type = ifelse(partOfExperiment == "dualSteerFocus", "Steering-focus", "Dialing-focus")) %>% 
    group_by(phoneNrLengthAfterKeyPress, Type) %>% 
    summarise(laneDeviation = mean(lanePosition, na.rm = TRUE),
              dialingTime = mean(timeRelativeToTrialStart, na.rm = TRUE) / 1000,
              se = sd(lanePosition, na.rm = TRUE) / sqrt(11))
  
  ggplot(frame, mapping = aes(x = dialingTime, y = laneDeviation)) +
    geom_point(mapping = aes(color = Type)) +
    geom_line(mapping = aes(color = Type)) + 
    geom_errorbar(mapping = aes(ymin = laneDeviation-se, ymax = laneDeviation+se, color = Type), width = .1) +
    coord_cartesian(ylim = c(0, 1), xlim = c(0,  6)) +
    labs(title = "Lateral deviation by time per keypress", x = "Dialing Time (s)", y = "Lateral Deviation (m)")
}

plot()


