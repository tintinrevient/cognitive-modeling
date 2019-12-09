#load("keyPressDataWithLaneDeviation.Rdata")
dfcFrame <- read.csv("tableOfDriftValuesCalibration.csv", header = TRUE)
plotA <- function(){  
  subFrame <- subset(dfcFrame, dfcFrame$trialTime >= 15000 & dfcFrame$trialTime <= 18000, select = c("trial", "posX", "trialTime"))
  plotFrame <- data.frame(
    trial = subFrame$trial,
    timeInSeconds = subFrame$trialTime / 1000,
    lanePosition = subFrame$posX
  )
  
  xrange <- range(plotFrame$timeInSeconds)
  yrange <- range(plotFrame$lanePosition)
  
  plot(xrange, yrange, type = "n", xlab = "Time (s)", ylab = "Deviation (m)")
  
  ntrial <- length(unique(plotFrame$trial))
  colors <- rainbow(ntrial)
  
  for(i in 1:ntrial){
    lines(plotFrame$timeInSeconds[plotFrame$trial == i], plotFrame$lanePosition[plotFrame$trial == i], 
          type = "l" , lwd=1.5, col=colors[i], lty = 1)
  }
  
  legend(xrange[1], yrange[2], 1:ntrial, cex=0.5, col=colors, lty=1, title="Trials")
  
  title("Deviation by time")
  plotFrame$lanePosition
}

plotB <- function(){
  subFrame <- subset(dfcFrame, dfcFrame$trialTime >= 15000 & dfcFrame$trialTime <= 18000, select = c("trial", "posX", "trialTime"))
  plotFrame <- data.frame(
    trial = subFrame$trial,
    timeInMs = subFrame$trialTime,
    lanePosition = subFrame$posX
  )
  
  ntrial <- 50#length(unique(plotFrame$trial))
  colors <- rainbow(ntrial)
  
  xrange <- range(0:3000)
  yrange <- range(-3:3)
  
  plot(xrange, yrange, type = "n", xlab = "Time (ms)", ylab = "Deviation (m)")
  # mean <- with(plotFrame, aggregate(lanePosition, list(trial), mean))
  # sd <- with(plotFrame , aggregate(lanePosition, list(trial), sd))
  
  allRn <- c()
  for(i in 1:ntrial){
    #trialData <- plotFrame[plotFrame$trial == i,]
    #mean <- with(trialData, aggregate(lanePosition, list(trial), mean))
    #sd <- with(trialData, aggregate(lanePosition, list(trial), sd))
    
    #rn <- rnorm(60, mean = mean$x, sd = sd$x)
    
    rn <- rnorm(3000 / 50, mean = 0, sd = 0.1)
    rn <- cumsum(rn)
    lines(seq(1, 3000, 50), rn, type = "l" , lwd=1.5, col=colors[i], lty = 1)
    for(v in rn)
      allRn <- c(allRn, v)
  }
  
  title("Simulated deviation by time")
  allRn
}

plotC <- function(dataReal, dataSim){
  xrange <- range(-4:4)
  hist(dataReal, xlim = xrange, breaks = seq(-4, 4, 0.25))
  hist(dataSim, xlim = xrange, breaks = seq(-4, 4, 0.25))
}

par(mfrow=c(2,2))
lda <- plotA()
ldb <- plotB()
plotC(lda, ldb)

sda <- sd(lda)
sda
sdb<- sd(ldb)
sdb
