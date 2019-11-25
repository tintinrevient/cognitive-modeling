library(ggplot2)

frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)
noOfPP <- length(unique(frame$pp))

# rescale the time to seconds
steerFocusFrame <- frame[frame$typingErrorMadeOnTrial == 0 & frame$partOfExperiment == "dualSteerFocus",]
steerFocusFrame$absLanePosition <- abs(steerFocusFrame$lanePosition)
steerFocusFrame$timeInSec <- steerFocusFrame$timeRelativeToTrialStart / 1000

dialFocusFrame <- frame[frame$typingErrorMadeOnTrial == 0 & frame$partOfExperiment == "dualDialFocus",]
dialFocusFrame$absLanePosition <- abs(dialFocusFrame$lanePosition)
dialFocusFrame$timeInSec <- dialFocusFrame$timeRelativeToTrialStart / 1000
# View(steerFocusFrame)
# View(dialFocusFrame)

# group by pp and time
steerFocusFrameByPP <- with(steerFocusFrame, aggregate(absLanePosition, list(pp = pp, time = timeInSec), mean))
dialFocusFrameByPP <- with(dialFocusFrame, aggregate(absLanePosition, list(pp = pp, time = timeInSec), mean))
# View(steerFocusFrameByPP)
# View(dialFocusFrameByPP)

# group by time
steerFocusFrameByTime <- with(steerFocusFrameByPP, aggregate(x, list(time = time), mean))
dialFocusFrameByTime <- with(dialFocusFrameByPP, aggregate(x, list(time = time), mean))

# Time is rounded to the variance of 1s
steerFocusFrameByTime$time <- round(steerFocusFrameByTime$time, digits = 0)
dialFocusFrameByTime$time <- round(dialFocusFrameByTime$time, digits = 0)

# Compute the mean & sd by time in the increment of 1s
steerFocusMeanByTime <- with(steerFocusFrameByTime, aggregate(x, list(time = time), mean))
steerFocusSEByTime <- with(steerFocusFrameByTime, aggregate(x, list(time = time), sd)) / sqrt(noOfPP)
dialFocusMeanByTime <- with(dialFocusFrameByTime, aggregate(x, list(time = time), mean))
dialFocusSEByTime <- with(dialFocusFrameByTime, aggregate(x, list(time = time), sd)) / sqrt(noOfPP)
# View(steerFocusMeanByTime)
# View(steerFocusSDByTime)
# View(dialFocusMeanByTime)
# View(dialFocusSDByTime)

# Combine mean and sd into result frames
resultSteerFocusFrame <- steerFocusMeanByTime
resultSteerFocusFrame$se <- steerFocusSEByTime$x
resultSteerFocusFrame$Type <- c('Steering-focus')

resultDialFocusFrame <- dialFocusMeanByTime
resultDialFocusFrame$se <- dialFocusSEByTime$x
resultDialFocusFrame$Type <- c('Dialing-focus')
# View(resultSteerFocusFrame)
# View(resultDialFocusFrame)

plotFrame <- rbind.data.frame(resultSteerFocusFrame, resultDialFocusFrame)
View(plotFrame)

# ??For error bar, what is used for the difference: sd? se? ci?
plot <- ggplot(plotFrame, aes(x=time, y=x, fill=Type)) + geom_line() + geom_point(size=2, shape=21) + geom_errorbar(aes(ymin=x-se, ymax=x+se), width=.1, position=position_dodge(.1)) + labs(x="Dialing Time (sec)", y="Lateral Deviation (m)")
print(plot)
# ggsave("smooth.png")

# View(steerFocusFrameByTime)
# plot <- ggplot(steerFocusFrameByTime, aes(x=time, y=x)) + stat_summary(fun.data = mean_cl_normal, geom = "pointrange", fill="White", colour="Black")
# print(plot)


