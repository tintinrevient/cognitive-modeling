
library(ggplot2)

# we will work with points 1 to 250 (cm)
scale.points <- c(1:250) 

# we create a dataframe for plotting
example.height <- data.frame(x=scale.points) 

# we use sapply, which is a vectorized function application; see help if you don't understand it

# we add y, which is just the probability density function described above (normal distribution)
example.height$y <- sapply(example.height$x, function(x) {dnorm(x, mean=180, sd=10)}) 

# this starts the plot creation
g1 <- ggplot(example.height, aes(x=x, y=y)) 

# we make the plot more pretty: we specify it should fill in area and add labels
g1 <- g1 + geom_area(fill="green", alpha=.4)  + xlab("height") + ylab("P") + theme_gray(20) 

g1

literal.listener <- function(x, threshold, densityf, cumulativef) {

                ifelse(
                     x>=threshold,
                     densityf(x)/(1-cumulativef(threshold)),
                     0
                              )

}

threshold <- 170

example.height$updated <- sapply(example.height$x, function(x) {literal.listener(x=x, threshold=threshold, densityf=function(x) {dnorm(x, 180, 10)}, cumulativef=function(x) {pnorm(x, 180, 10)} )}) 

# this starts the plot creation
g1 <- ggplot(example.height, aes(x=x, y=y)) 
g1 <- g1 + geom_area(fill="green", alpha=.4) 

# we add the result of updated belief
g1 <- g1 + geom_area(aes(y=updated),fill="steelblue", alpha=.4) 
g1 <- g1 + xlab("height") + ylab("P") + theme_gray(20) 


g1

expected.success <- function(threshold, scale.points, densityf, cumulativef) {

    ifelse(threshold>min(scale.points), sum(sapply(scale.points[scale.points<threshold], function(x) {densityf(x) * densityf(x)})), 0) + 
        sum(sapply(scale.points[scale.points>=threshold], function(x) {densityf(x) * literal.listener(x, threshold, densityf, cumulativef)}))

}

#Task 1

utility <- function(threshold, scale.points, coverage.parameter, densityf, cumulativef) {
    expected.success(threshold, scale.points, densityf, cumulativef) + coverage.parameter * 
        sum(sapply(threshold:max(scale.points), function(x){densityf(x)}))
}


probability.threshold <- function(threshold, scale.points, lambda, coverage.parameter, densityf, cumulativef, denominator = NULL) {
    if(is.null(denominator)){
        denominator = sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, coverage.parameter, densityf, cumulativef))}))
    }
    exp(lambda * utility(threshold, scale.points, coverage.parameter, densityf, cumulativef)) / denominator
        
}

use.adjective <- function(degree, scale.points, lambda, coverage.parameter, densityf, cumulativef) {
    denominator = sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, coverage.parameter, densityf, cumulativef))}))
    mem <- c(mem, probability.threshold(t, scale.points, lambda, coverage.parameter, densityf, cumulativef, denominator))
    sum(mem)
}

View(mem)

# use.adjective <- function(degree, scale.points, lambda, coverage.parameter, densityf, cumulativef) {
#     denominator = sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, coverage.parameter, densityf, cumulativef))}))
#     sum(sapply(min(scale.points):degree, function(x){probability.threshold(x, scale.points, lambda, coverage.parameter, densityf, cumulativef, denominator)}))
# }

mem <- c()
task1.height <- data.frame(x=scale.points)
task1.height$y <- sapply(task1.height$x, function(x) {dnorm(x, mean=180, sd=10)}) 
task1.height$pt <- sapply(task1.height$x, function(x) {probability.threshold(x, scale.points, 50, 0, densityf=function(x) {dnorm(x, 180, 10)}, cumulativef=function(x) {pnorm(x, 180, 10)} )})
task1.height$ua <- sapply(task1.height$x, function(x) {use.adjective(x, scale.points, 50, 0, densityf=function(x) {dnorm(x, 180, 10)}, cumulativef=function(x) {pnorm(x, 180, 10)} )})

gt1 <- ggplot(task1.height, aes(x=x, y=pt)) 
#gt1 <- gt1 + geom_area(fill="green", alpha=.4) 

gt1 <- gt1 + geom_area(aes(y=pt),fill="steelblue", alpha=.4) 
#gt1 <- gt1 + geom_area(aes(y=ua),fill="red", alpha=.4) 
gt1 <- gt1 + xlab("height (cm)") + ylab("P") + ggtitle("Threshold probability") + theme_gray(20) 
gt1

ggplot(task1.height, aes(x, ua)) + geom_line() + xlab("height (cm)") + ylab("P") + ggtitle("Use adjective") + theme_gray(20)


ptmax <- max(task1.height$pt)
uamaxlope <- max(diff(task1.height$ua))
uamaxlopeindex <- which(diff(task1.height$ua) == max(diff(task1.height$ua)))
uamax <- task1.height[uamaxlopeindex,]$ua

subset(task1.height, pt == ptmax)$x
subset(task1.height, ua == uamax)$x

# data <- sapply(1:10, function(x) {use.adjective(x, scale.points, 50, 0, function(x) {dnorm(x, 180, 10)}, function(x) {pnorm(x, 180, 10)})})
# plot(data)

# Help - tests you should pass

#probability.threshold is a probability, so if you sum up all values it generates, the result should be 1
round(sum(sapply(1:10, function(x) {probability.threshold(x, 1:10, 50, 0, function(x) {dnorm(x, 5, 1)}, function(x) {pnorm(x, 5, 1)})}))) == 1

#for narrow normal distribution, prob. threshold should be max just one value above the average
which(sapply(1:10, function(x) {probability.threshold(x, 1:10, 50, 0, function(x) {dnorm(x, 5, 1)}, function(x) {pnorm(x, 5, 1)})})==max(sapply(1:10, function(x) {probability.threshold(x, 1:10, 50, 0, function(x) {dnorm(x, 5, 1)}, function(x) {pnorm(x, 5, 1)})}))) == 6

#use.adjective should be very unlikely on values 5 and smaller and very likely afterwards
round(sapply(1:10, function(x) {use.adjective(x, 1:10, 50, 0, function(x) {dnorm(x, 5, 1)}, function(x) {pnorm(x, 5, 1)})})[5], 3) == 0.005
round(sapply(1:10, function(x) {use.adjective(x, 1:10, 50, 0, function(x) {dnorm(x, 5, 1)}, function(x) {pnorm(x, 5, 1)})})[6], 3) == 1


# Task 2:
# Explore expected.success and use.adjective for various prior distribution functions.
# For this, assume that coverage.parameter $c$ is at 0 and lambda is at 50.

mem <- c()
scale.points = 65:135
task2iq.height <- data.frame(x=scale.points)
task2iq.height$y <- sapply(task2iq.height$x, function(x) {dnorm(x, mean=100, sd=10)})
task2iq.height$esiq <- sapply(scale.points, function(x){expected.success(x, scale.points, function(x) {dnorm(x, 100, 10)}, function(x) {pnorm(x, 100, 10)})})
task2iq.height$pt <- sapply(task2iq.height$x, function(x) {probability.threshold(x, scale.points, 50, 0, densityf=function(x) {dnorm(x, 100, 10)}, cumulativef=function(x) {pnorm(x, 100, 10)} )})
task2iq.height$ua <- sapply(task2iq.height$x, function(x) {use.adjective(x, scale.points, 50, 0, densityf=function(x) {dnorm(x, 100, 10)}, cumulativef=function(x) {pnorm(x, 100, 10)} )})

# plot 1
gt2iq <- ggplot(task2iq.height, aes(x=x, y=pt)) 
gt2iq <- gt2iq + geom_area(aes(y=pt),fill="steelblue", alpha=.4) 
gt2iq <- gt2iq + xlab("IQ") + ylab("P") + ggtitle("Threshold probability") + theme_gray(20) 
gt2iq

# plot 2
ggplot(task2iq.height, aes(x, ua)) + geom_line() + xlab("IQ") + ylab("P") + ggtitle("Use adjective") + theme_gray(20)

iqt <- subset(task2iq.height, esiq == max(task2iq.height$esiq))
iqt$x
ptmaxiq <- max(task2iq.height$pt)
uamaxlopeiq <- max(diff(task2iq.height$ua))
uamaxlopeindexiq <- which(diff(task2iq.height$ua) == max(diff(task2iq.height$ua)))
uamaxiq <- task2iq.height[uamaxlopeindexiq,]$ua

subset(task2iq.height, pt == ptmaxiq)$x
subset(task2iq.height, ua == uamaxiq)$x



mem <- c()
scale.points = 1:10
task2wt.height <- data.frame(x=scale.points)
task2wt.height$y <- sapply(task2wt.height$x, function(x) {dnorm(x, shape=4, scale=1, log = FALSE)})
task2wt.height$eswt <- sapply(scale.points, function(x){expected.success(x, scale.points, function(x) {dnorm(x, 4, 2)}, function(x) {pnorm(x, 4, 2)})})
task2wt.height$pt <- sapply(task2wt.height$x, function(x) {probability.threshold(x, scale.points, 50, 0, densityf=function(x) {dnorm(x, 4, 2)}, cumulativef=function(x) {pnorm(x, 4, 2)})})
task2wt.height$ua <- sapply(task2wt.height$x, function(x) {use.adjective(x, scale.points, 50, 0, densityf=function(x) {dnorm(x, 4, 2)}, cumulativef=function(x) {pnorm(x, 4, 2)})})

# plot 1
gt2wt <- ggplot(task2wt.height, aes(x=x, y=pt)) 
gt2wt <- gt2wt + geom_area(aes(y=pt),fill="steelblue", alpha=.4) 
gt2wt <- gt2wt + xlab("Waiting time (min)") + ylab("P") + ggtitle("Threshold probability") + theme_gray(20) 
gt2wt

# plot 2
ggplot(task2wt.height, aes(x, ua)) + geom_line() + xlab("Waiting time (min)") + ylab("P") + ggtitle("Use adjective") + theme_gray(20)

wtt <- subset(task2wt.height, eswt == max(task2wt.height$eswt))
wtt$x
ptmaxwt <- max(task2wt.height$pt)
uamaxlopewt <- max(diff(task2wt.height$ua))
uamaxlopeindexwt <- which(diff(task2wt.height$ua) == max(diff(task2wt.height$ua)))
uamaxwt <- task2wt.height[uamaxlopeindexwt,]$ua

subset(task2wt.height, pt == ptmaxwt)$x
subset(task2wt.height, ua == uamaxwt)$x

data.adjective <- read.csv(file="adjective-data.csv", header=TRUE)

gaussian.dist <-   c(1,2,3,4,5,6,5,4,3,2,1,0,0,0)
left.skew.dist <-  c(2,5,6,6,5,4,3,2,1,1,1,0,0,0)
moved.dist <-      c(0,0,0,1,2,3,4,5,6,5,4,3,2,1)
right.skew.dist <- c(1,1,1,2,3,4,5,6,6,5,2,0,0,0)

sapply(1:14, function(x) {round(length(rgamma(360, shape=1, scale=100)[which(round(rgamma(360, shape=4, scale=1.5)) == x)])/10)})


data.gaus <- data.adjective[data.adjective$Distribution=="gaussian",]
data.left <- data.adjective[data.adjective$Distribution=="left",]
data.moved <- data.adjective[data.adjective$Distribution=="moved",]

library(ggplot2)
library(gridExtra)
p.g <- ggplot(data.gaus,aes(x=Stimulus,y=100*percentage,colour=Adjective))+geom_line()+ ylab("P") +ggtitle("gaussian")
p.l <- ggplot(data.left,aes(x=Stimulus,y=100*percentage,colour=Adjective))+geom_line()+ggtitle("left skewed")
p.m <- ggplot(data.moved,aes(x=Stimulus,y=100*percentage,colour=Adjective))+geom_line()+ggtitle("moved")

grid.arrange(p.g,p.l,p.m,ncol=2)

# Task 3:
# check cor between predicted and observed data
cor(..., ..., method="pearson")

#install.packages("BayesianTools")
library(BayesianTools)

prior <- createUniformPrior(lower=c(0,0.1), upper=c(0.1,1), best=NULL)

data.gaus.big <- subset(data.gaus, Adjective == "big")

likelihood <- function(param1) {

    collect <- 0
    
    for (i in 1:14) {
        collect  <- collect + dnorm(data.gaus.big$percentage[i], mean=param1[1]+param1[2], sd=0.1, log=TRUE)

    }

    return(collect)
} 

bayesianSetup <- createBayesianSetup(likelihood = likelihood, prior = prior)

iter = 10000
settings = list(iterations = iter, message = FALSE)
out <- runMCMC(bayesianSetup = bayesianSetup, settings = settings)

summary(out)

# Task 4

prior <- createUniformPrior(lower=c(-1,1), upper=c(1,50), best=NULL)

likelihood <- function(param1) {

    collect <- 0
    
    for (i in 1:14) {
        collect  <- collect + dnorm(data.gaus.big$percentage[i], mean=..., sd=0.1, log=TRUE)

    }

    return(collect)
} 

#bayesianSetup <- createBayesianSetup(likelihood = likelihood, prior = prior)

#iter = 10000

#settings = list(iterations = iter, message = FALSE)

#out <- runMCMC(bayesianSetup = bayesianSetup, settings = settings)

# Task 5
