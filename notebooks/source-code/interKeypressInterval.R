library(tidyverse)

interKeypressInterval <- function() {
  frame <- read.csv("keyPressDataWithLaneDeviation.csv", header = TRUE)
  
  frame <- frame %>% 
    filter(partOfExperiment == "singleDialing2",
           typingErrorMadeOnTrial == 0,
           !(pp == 12 & trial == 41),
           !(pp == 2 & trial == 32),
           !(pp == 8 & trial == 41),
           !(pp == 10 & trial == 48)) %>% 
    select(pp, trial, phoneNrLengthAfterKeyPress, timeRelativeToTrialStart) %>% 
    mutate(diff = 0)
  
  matrixFrame <- as.matrix(sapply(frame, as.numeric))
  
  batch <- nrow(frame) / 13
  for(i in 1:batch) {
    for(j in 1:13) {
      rowNo <- (i-1)*13 + j
      if(j != 1)
        matrixFrame[rowNo, 5] <- matrixFrame[rowNo, 4] - matrixFrame[rowNo-1, 4]
    }
  }
  
  dataFrame <- as_tibble(matrixFrame)
  
  # View(dataFrame)
  
  resultFrame <- dataFrame %>% 
    group_by(pp) %>% 
    summarise(mean = mean(diff))
  
  View(resultFrame)
  
  totalMean <- mean(resultFrame$mean)
  print(totalMean)
    
}

interKeypressInterval()