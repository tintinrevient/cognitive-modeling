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
  subFrame <- frame[frame$type == "dualSteerFocus" | frame$type == "dualDialFocus",]
  
  mean <- aggregate(subFrame$deveation, by=list(subFrame$type), FUN=mean)
  sd <- aggregate(subFrame$deveation, by=list(subFrame$type), FUN=sd)
  
  amountOfSteerFocus <- nrow(subFrame[subFrame$type == "dualSteerFocus", ])
  amountOfDialFocus <- nrow(subFrame[subFrame$type == "dualDialFocus", ])
  
  print(amountOfDialFocus) #5
  print(amountOfSteerFocus)
  
  se <- sd$x / sqrt(12)
  
  endFrame <- data.frame(
    #Type = subFrame$type,
    Mean = mean$x,
    SD = sd$x,
    SE = se
  )
  return(endFrame)
}

plotDeviation <- function(){ 
  frame <- data.frame(
    keypress = keyPressDataWithLaneDeviation$phoneNrLengthAfterKeyPress,
    participant = keyPressDataWithLaneDeviation$pp,
    dialingTime = round(keyPressDataWithLaneDeviation$timeRelativeToTrialStart / 1000, digits = 1),
    deveation = abs(keyPressDataWithLaneDeviation$lanePosition),
    type = keyPressDataWithLaneDeviation$partOfExperiment,
    error = keyPressDataWithLaneDeviation$typingErrorMadeOnTrial
  )
  
  subFrame <- frame[frame$error == 0,]
  subFrame <- subFrame[subFrame$keypress >= 1 & subFrame$keypress <= 11,]
  View(subFrame)
  subFrameSF <- subFrame[subFrame$type == "dualSteerFocus",]
  subFrameDF <- subFrame[subFrame$type == "dualDialFocus",]
  
  #per participant per key per per condiciotn
  meanPerKeySF <- aggregate(subFrameSF[3:4], by=list(subFrameSF$keypress), FUN = mean)
  meanPerKeyDF <- aggregate(subFrameDF[3:4], by=list(subFrameDF$keypress), FUN = mean)
  
  xrange <- range(0:6)
  yrange <- range(0:1)
  
  plot(xrange, yrange, type = "n", xlab = "Dailing Time (s)", ylab = "Lateral Deviation (m)")
  
  colors <- rainbow(2)
  linetype <- c(1:2)
  plotchar <- seq(18,18+2,1)
  
  
  lines(meanPerKeySF$dialingTime, meanPerKeySF$deveation, type = "b" , lwd=1.5,
        lty=linetype[1], col=colors[1], pch=plotchar[1])
  lines(meanPerKeyDF$dialingTime, meanPerKeyDF$deveation, type = "b", lwd=1.5,
        lty=linetype[2], col=colors[2], pch=plotchar[2])
  
  title("Lateral Deviation by time per keypress")
  
  legend(xrange[1], yrange[2], c("Steering focus", "Dailing Focus"), cex=0.8, col=colors,
         pch=plotchar, lty=linetype, title="Stuff")
}

plot <- function() {
  
  frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
  
  frame <- frame %>%  filter(phoneNrLengthAfterKeyPress %in% c(1: 11), 
                             typingErrorMadeOnTrial == 0,
                             partOfExperiment == "dualSteerFocus" | partOfExperiment == "dualDialFocus") %>% 
    mutate(lanePosition = abs(lanePosition),
           Type = ifelse(partOfExperiment == "dualSteerFocus", "Steering-focus", "Dialing-focus")) %>% 
    group_by(phoneNrLengthAfterKeyPress, Type) %>% 
    summarise(laneDeviation = mean(lanePosition, na.rm = TRUE),
              dialingTime = mean(timeRelativeToTrialStart, na.rm = TRUE) / 1000,
              se = sd(lanePosition, na.rm = TRUE) / sqrt(12))
  
  ggplot(frame, mapping = aes(x = dialingTime, y = laneDeviation)) +
    geom_point(mapping = aes(color = Type)) +
    geom_line(mapping = aes(color = Type)) + 
    geom_errorbar(mapping = aes(ymin = laneDeviation-se, ymax = laneDeviation+se, color = Type), width = .1) +
    coord_cartesian(ylim = c(0, 1), xlim = c(0,  6)) +
    labs(title = "Lateral deviation by time per keypress", x = "Dialing Time (s)", y = "Lateral Deviation (m)")
}

print(timeMeans())
print(deviationMean())
plotDeviation()

options(scipen = 999)
wilcox.test(timeRelativeToTrialStart~partOfExperiment, data = frame)
wilcox.test(lanePosition~partOfExperiment, data = frame)



