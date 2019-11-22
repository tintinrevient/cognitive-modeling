load("keyPressDataWithLaneDeviation.Rdata")

dialingTime <- function() {
  frame <- data.frame(
    participant = keyPressDataWithLaneDeviation$pp,
    keypress = keyPressDataWithLaneDeviation$phoneNrLengthAfterKeyPress,
    type = keyPressDataWithLaneDeviation$partOfExperiment,
    dialingTime = keyPressDataWithLaneDeviation$timeRelativeToTrialStart,
    error = keyPressDataWithLaneDeviation$typingErrorMadeOnTrial
  )
  
  mean <- with(frame[(frame$keypress == 11) & (frame$error == 0) & (frame$type == "dualSteerFocus" | frame$type == "dualDialFocus"),], aggregate(dialingTime, list(Type=type), mean))
  sd <- with(frame[(frame$keypress == 11) & (frame$error == 0) & (frame$type == "dualSteerFocus" | frame$type == "dualDialFocus"),], aggregate(dialingTime, list(Type=type), sd))
  se <- sd / sqrt(length(unique(frame$participant)))
  
  endFrame <- data.frame(
    Type = c('Dual dial ocus', 'Dual steer focus'),
    Mean = round(mean$x / 1000, digits = 1),
    SD = round(sd$x / 1000, digits = 1),
    SE = round(se$x / 1000, digits = 1)
  )
  
  endFrame
}

lateralDeviation <- function() {
  frame <- data.frame(
    participant = keyPressDataWithLaneDeviation$pp,
    event1 = keyPressDataWithLaneDeviation$Event1,
    type = keyPressDataWithLaneDeviation$partOfExperiment,
    position = keyPressDataWithLaneDeviation$lanePosition,
    error = keyPressDataWithLaneDeviation$typingErrorMadeOnTrial
  )
  
  frame1 <- frame[(frame$event1 == 'Start') & (frame$error == 0) & (frame$type == "dualSteerFocus" | frame$type == "dualDialFocus"),]
  frame2 <- frame[(frame$event1 == 'Correct') & (frame$error == 0) & (frame$type == "dualSteerFocus" | frame$type == "dualDialFocus"),]
  lateralDeviation <- frame2$position - frame1$position
  endFrame <- cbind(frame1, lateralDeviation)
  
  mean <- with(endFrame, aggregate(lateralDeviation, list(Type=type), mean))
  sd <- with(endFrame, aggregate(lateralDeviation, list(Type=type), sd))
  se <- sd$x / sqrt(length(unique(frame$participant)))
  
  endFrame <- data.frame(
    Type = c('Dual dial ocus', 'Dual steer focus'),
    Mean = mean$x,
    SD = sd$x,
    SE = se
  )
  
  endFrame
}

lateralDeviation()