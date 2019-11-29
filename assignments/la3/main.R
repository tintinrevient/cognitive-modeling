load("keyPressDataWithLaneDeviation.Rdata")

subframe <- subset(keyPressDataWithLaneDeviation, partOfExperiment =="singleDialing2" & typingErrorMadeOnTrial == 0)
keypressInterval <- diff(subframe$timeRelativeToTrialStart, 1)
keypressInterval <- keypressInterval[keypressInterval > 0]

meanKpi <- mean(keypressInterval)
meanKpi
meanKpi <- round(meanKpi / 10) * 10
meanKpi