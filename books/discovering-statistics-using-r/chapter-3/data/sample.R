# comment/uncomment in Mac: cmd + shift + c

frame <- read.csv('keyPressDataWithLaneDeviation.csv', header = TRUE)

# subset()
subsetFrame <- subset(frame, trial == 1, select = c('pp', 'lanePosition','partOfExperiment','timeRelativeToTrialStart'))
View(subsetFrame)

# as.matrix()
# matrix <- as.matrix(frame[frame$trial==9, c('pp', 'lanePosition','partOfExperiment','timeRelativeToTrialStart')])
# View(matrix)

# stack() & unstack()
# stackedFrame <- stack(frame, select = c('timeRelativeToTrialStart'))
# unstackedFrame <- unstack(stackedFrame, values ~ ind)
# View(stackedFrame)
# View(unstackedFrame)

# install.packages("reshape") 
# library(reshape)

# melt() & cast()
# meltedFrame <- melt.data.frame(frame, id = c('pp', 'partOfExperiment', 'trial'), measure = c('lanePosition', 'timeRelativeToTrialStart'))
# castedFrame <- cast(meltedFrame, pp ~ variable, mean)
# View(meltedFrame)
# View(castedFrame)

