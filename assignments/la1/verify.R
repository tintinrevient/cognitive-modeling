library(ggplot2)

dialingTimeV1 <- function() {
  
  frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
  
  frame <- frame[(frame$Event1 == 'Correct') 
                 & (frame$typingErrorMadeOnTrial == 0) 
                 & (frame$partOfExperiment == "dualSteerFocus" | frame$partOfExperiment == "dualDialFocus"),]
  
  mean <- with(frame, aggregate(timeRelativeToTrialStart, list(Type=partOfExperiment), mean))
  sd <- with(frame, aggregate(timeRelativeToTrialStart, list(Type=partOfExperiment), sd))
  se <- sd$x / sqrt(length(unique(frame$pp)))
  
  resultFrame <- data.frame(
    Type = mean$Type,
    Mean = round(mean$x / 1000, digits = 1),
    SD = round(sd$x / 1000, digits = 1),
    SE = round(se / 1000, digits = 1)
  )
  resultFrame
}

print(dialingTimeV1())

dialingTimeV2 <- function() {
  
  frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
  
  frame <- frame[(frame$Event1 == 'Correct') 
                 & (frame$typingErrorMadeOnTrial == 0) 
                 & (frame$partOfExperiment == "dualSteerFocus" | frame$partOfExperiment == "dualDialFocus"),]
  
  mean <- with(frame, aggregate(timeRelativeToTrialStart, list(Type=partOfExperiment), mean))
  sd <- with(frame, aggregate(timeRelativeToTrialStart, list(Type=partOfExperiment), sd))
  se <- c(0, 0)
  
  for(pp in seq(length(unique(frame$pp)))) {
    framePP <- frame[frame$pp == pp,]
    meanPP <- with(framePP, aggregate(timeRelativeToTrialStart, list(Type=partOfExperiment), mean))
    se <- (meanPP$x - mean$x)**2 + se
  }
  
  se <- sqrt(se/(length(unique(frame$pp)) - 1))
  
  resultFrame <- data.frame(
    Type = mean$Type,
    Mean = round(mean$x / 1000, digits = 1),
    SD = round(sd$x / 1000, digits = 1),
    SE = round(se / 1000, digits = 1)
  )
  resultFrame
}

print(dialingTimeV2())

lateralDeviationV1 <- function() {
  
  frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
  
  startFrame <- frame[(frame$Event1 == 'Start')
                 & (frame$typingErrorMadeOnTrial == 0) 
                 & (frame$partOfExperiment == "dualSteerFocus" | frame$partOfExperiment == "dualDialFocus"),]
  
  endFrame <- frame[(frame$Event1 == 'Correct')
                      & (frame$typingErrorMadeOnTrial == 0) 
                      & (frame$partOfExperiment == "dualSteerFocus" | frame$partOfExperiment == "dualDialFocus"),]
  
  steps <- unique(endFrame$phoneNrLengthAfterKeyPress)
  lateralDeviation <- abs((endFrame$lanePosition * 1000 - startFrame$lanePosition * 1000) / steps)
  combinedFrame <- cbind(startFrame, lateralDeviation)
  #View(combinedFrame)
  
  mean <- with(combinedFrame, aggregate(lateralDeviation, list(Type=partOfExperiment), mean))
  sd <- with(combinedFrame, aggregate(lateralDeviation, list(Type=partOfExperiment), sd))
  se <- sd$x / sqrt(length(unique(combinedFrame$pp)))
  
  resultFrame <- data.frame(
    Type = mean$Type,
    Mean = mean$x,
    SD = sd$x,
    SE = se
  )
  
  resultFrame
}

print(lateralDeviationV1())

lateralDeviationV2 <- function() {
  
  frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
  
  startFrame <- frame[(frame$Event1 == 'Start')
                      & (frame$typingErrorMadeOnTrial == 0) 
                      & (frame$partOfExperiment == "dualSteerFocus" | frame$partOfExperiment == "dualDialFocus"),]
  
  endFrame <- frame[(frame$Event1 == 'Correct')
                    & (frame$typingErrorMadeOnTrial == 0) 
                    & (frame$partOfExperiment == "dualSteerFocus" | frame$partOfExperiment == "dualDialFocus"),]
  
  steps <- unique(endFrame$phoneNrLengthAfterKeyPress)
  lateralDeviation <- abs((endFrame$lanePosition * 1000 - startFrame$lanePosition * 1000) / steps)
  combinedFrame <- cbind(startFrame, lateralDeviation)
  
  mean <- with(combinedFrame, aggregate(lateralDeviation, list(Type=partOfExperiment), mean))
  sd <- with(combinedFrame, aggregate(lateralDeviation, list(Type=partOfExperiment), sd))
  se <- c(0, 0)
  
  for(pp in seq(length(unique(combinedFrame$pp)))) {
    framePP <- combinedFrame[combinedFrame$pp == pp,]
    meanPP <- with(framePP, aggregate(lateralDeviation, list(Type=partOfExperiment), mean))
    se <- (meanPP$x - mean$x)**2 + se
  }
  
  se <- sqrt(se/(length(unique(combinedFrame$pp)) - 1))
  
  resultFrame <- data.frame(
    Type = mean$Type,
    Mean = mean$x,
    SD = sd$x,
    SE = se
  )
  
  resultFrame
}

print(lateralDeviationV2())
