load("keyPressDataWithLaneDeviation.Rdata")


timeMeans <- function(){ 
  frame <- data.frame(
    participant = keyPressDataWithLaneDeviation$pp,
    keypress = keyPressDataWithLaneDeviation$phoneNrLengthAfterKeyPress,
    type = keyPressDataWithLaneDeviation$partOfExperiment,
    dialingTime = keyPressDataWithLaneDeviation$timeRelativeToTrialStart,
    error = keyPressDataWithLaneDeviation$typingErrorMadeOnTrial
    )
  
  subFrame <- frame[frame$keypress == 11,]
  subFrame <- subFrame[subFrame$error == 0,]
  subFrame <- subFrame[subFrame$type == "dualSteerFocus" | subFrame$type == "dualDialFocus",]
  
  mean <- aggregate(subFrame$dialingTime, by=list(subFrame$type), FUN=mean)
  
  sd <- aggregate(subFrame$dialingTime, by=list(subFrame$type), FUN=sd)
  
  amountOfParticipants <- length(unique(frame$participant))
  print(amountOfParticipants)
  
  se <- sd$x / sqrt(amountOfParticipants)
  
  endFrame <- data.frame(
    Type = unique(subFrame$type),
    Mean = round(mean$x / 1000, digits = 1),
    SD = round(sd$x / 1000, digits = 1),
    SE = round(se / 1000, digits = 1)
  )
  return(endFrame)
}

deviationMean <- function(){ 
  frame <- data.frame(
    type = keyPressDataWithLaneDeviation$partOfExperiment,
    deveation = abs(keyPressDataWithLaneDeviation$lanePosition)
  )
  subFrame <- subFrame[subFrame$type == "dualSteerFocus" | subFrame$type == "dualDialFocus",]
  
  mean <- aggregate(subFrame$dialingTime, by=list(subFrame$type), FUN=mean)
  sd <- aggregate(subFrame$dialingTime, by=list(subFrame$type), FUN=sd)
  
  amountOfSteerFocus <- length(subFrame[subFrame$type == "dualSteerFocus", ])
  amountOfDialFocus <- length(subFrame[subFrame$type == "dualDialFocus", ])
  
  print(amountOfDialFocus) #5
  print(amountOfSteerFocus)
  
  se <- sd$x / sqrt(amountOfDialFocus)
  
  endFrame <- data.frame(
    Type = unique(subFrame$type),
    Mean = mean$x,
    SD = sd$x,
    SE = se
  )
  return(endFrame)
}

print(timeMeans())
print(deviationMean())

