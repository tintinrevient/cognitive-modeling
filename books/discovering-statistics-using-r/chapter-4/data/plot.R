library(ggplot2)

frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)

# steer focus frame with no error made + abs of lanePosition
steerFocusFrame <- frame[frame$typingErrorMadeOnTrial == 0 & frame$partOfExperiment == "dualSteerFocus",]
steerFocusFrame$absLanePosition <- abs(steerFocusFrame$lanePosition)

# dial focus frame with no error made + abs of lanePosition
dialFocusFrame <- frame[frame$typingErrorMadeOnTrial == 0 & frame$partOfExperiment == "dualDialFocus",]
dialFocusFrame$absLanePosition <- abs(dialFocusFrame$lanePosition)

# steer focus aggregated by pp and phoneNrLengthBeforeKeyPress
steerFocusFrameByPP <- with(steerFocusFrame, aggregate(absLanePosition, list(pp = pp, time = phoneNrLengthBeforeKeyPress), mean))

# dial focus aggregated by pp and phoneNrLengthBeforeKeyPress
dialFocusFrameByPP <- with(dialFocusFrame, aggregate(absLanePosition, list(pp = pp, time = phoneNrLengthBeforeKeyPress), mean))

# View(steerFocusFrameByPP) 
# View(dialFocusFrameByPP)

# result frame with Type = Steering-focus and Type = Dialing-focus
resultSteerFocusFrame <- subset(steerFocusFrameByPP, select = c(time, x))
resultSteerFocusFrame$Type <- c('Steering-focus')

resultDialFocusFrame <- subset(dialFocusFrameByPP, select = c(time, x))
resultDialFocusFrame$Type <- c('Dialing-focus')

# plot frame with above two result frames combined row by row
plotFrame <- rbind.data.frame(resultSteerFocusFrame, resultDialFocusFrame)
# View(plotFrame)

plot <- ggplot(plotFrame, aes(time, x, colour = Type))
plot + stat_summary(fun = "mean", geom = "point") + stat_summary(fun = "mean", geom = "line", aes(group = Type)) + stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2) + labs(x="Dialing Time (sec)", y="Lateral Deviation (m)")
ggsave("plot.png")

