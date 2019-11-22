load("keyPressDataWithLaneDeviation.Rdata")

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
print(mean)

sd <- aggregate(subFrame$dialingTime, by=list(subFrame$type), FUN=sd)
print(sd)

amountOfParticipants <- length(unique(frame$participant))
print(amountOfParticipants)

se <- sd$x / sqrt(amountOfParticipants)
print(se)

endFrame <- data.frame(
  Type = unique(subFrame$type),
  Mean = round(mean$x / 1000, digits = 1),
  SD = round(sd$x / 1000, digits = 1),
  SE = round(se / 1000, digits = 1)
)
view(endFrame)

