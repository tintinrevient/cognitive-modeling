library(ggplot2)
library(gridExtra)

# Task 1
literal.listener <- function(x, threshold, densityf, cumulativef) {
  
  ifelse(
    x>=threshold,
    densityf(x)/(1-cumulativef(threshold)),
    0
  )
  
}

expected.success <- function(threshold, scale.points, densityf, cumulativef) {
  
  ifelse(threshold>min(scale.points), sum(sapply(scale.points[scale.points<threshold], function(x) {densityf(x) * densityf(x)})), 0) + 
    sum(sapply(scale.points[scale.points>=threshold], function(x) {densityf(x) * literal.listener(x, threshold, densityf, cumulativef)}))
  
}

utility <- function(threshold, scale.points, coverage.parameter, densityf, cumulativef) {
  
  expected.success(threshold, scale.points, densityf, cumulativef) + 
    coverage.parameter * sum(sapply(scale.points[scale.points>=threshold], function(x) {densityf(x)}))

}

probability.threshold <- function(threshold, scale.points, lambda, coverage.parameter, densityf, cumulativef, denominator) {
  
  if(is.null(denominator))
    denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, coverage.parameter, densityf, cumulativef))}))
  
  exp(lambda * utility(threshold, scale.points, coverage.parameter, densityf, cumulativef)) / denominator
  
}

use.adjective <- function(degree, scale.points, lambda, coverage.parameter, densityf, cumulativef, denominator) {
  
  if(is.null(denominator))
    denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, coverage.parameter, densityf, cumulativef))}))
  
  sum(sapply(scale.points[scale.points<=degree], function(x) {probability.threshold(x, scale.points, lambda, coverage.parameter, densityf, cumulativef, denominator)}))
  
}

# plot 1: probability of threshold
# we will work with points 1 to 250 (cm)
scale.points <- c(1:250) 
lambda <- 50
c <- 0

densityf <- function(x) {dnorm(x, 180, 10)}
cumulativef <- function(x) {pnorm(x, 180, 10)}

# we create a dataframe for plotting
example.height <- data.frame(x=scale.points) 

denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

example.height$pt <- sapply(example.height$x, 
                           function(x) {probability.threshold(x, scale.points, lambda, c, densityf, cumulativef, denominator)}) 

g1 <- ggplot(example.height, aes(x=x, y=pt)) 
g1 <- g1 + geom_area(fill="steelblue", alpha=.4) + xlab("height (cm)") + ylab("probability") + ggtitle("Probability of threshold for height")
g1

# plot 2: probability of using adjective
example.height$pua <- sapply(example.height$x,
                             function(x) {use.adjective(x, scale.points, lambda, c, densityf, cumulativef, denominator)})

g2 <- ggplot(example.height, aes(x=x, y=pua)) + xlab("height (cm)") + ylab("probability") + ggtitle("Probability of using adjective tall")
g2 <- g2 + geom_line() 
g2

grid.arrange(g1, g2, ncol=2)

# verification
probability.threshold(183, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(184, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(185, scale.points, lambda, c, densityf, cumulativef, denominator)


# Task 2
# IQ
# wrong one without range [50, 150]
test <- rnorm(101, 100, 15)
mean(test)
sd(test)

count <- 0
for(i in 1:101) {
  if(test[i] >= 70 && test[i] <= 130) {
    count <- count + 1
  }
}
count/100

# right one with range [50, 150]
mean <- 100
sd <- 15

x <- c(50:150)
y <- sapply(x, function(x) {dnorm(x, mean, sd)})
df <- data.frame(x, y)
ggplot(df, aes(x = x, y = y)) + geom_line()

p <- pnorm(x, mean, sd)
p[81] # 95% + 5%/2 = 97.5%, the cumulative probability that x < 130
x[81] # check if x's upper bound = 130

scale.points <- c(50:150) 
lambda <- 50
c <- 0

densityf <- function(x) {dnorm(x, mean, sd)}
cumulativef <- function(x) {pnorm(x, mean, sd)}

example.iq <- data.frame(x=scale.points) 

denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

example.iq$pt <- sapply(example.iq$x, 
                            function(x) {probability.threshold(x, scale.points, lambda, c, densityf, cumulativef, denominator)}) 

g1 <- ggplot(example.iq, aes(x=x, y=pt)) 
g1 <- g1 + geom_area(fill="steelblue", alpha=.4) + xlab("IQ") + ylab("probability") + ggtitle("Probability of threshold for IQ")
g1

example.iq$pua <- sapply(example.iq$x,
                             function(x) {use.adjective(x, scale.points, lambda, c, densityf, cumulativef, denominator)})


g2 <- ggplot(example.iq, aes(x=x, y=pua)) + xlab("IQ") + ylab("probability") + ggtitle("Probability of using adjective smart")
g2 <- g2 + geom_line() 
g2

grid.arrange(g1, g2, ncol=2)

# verification

probability.threshold(105, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(106, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(107, scale.points, lambda, c, densityf, cumulativef, denominator)

use.adjective(106, scale.points, lambda, c, densityf, cumulativef, denominator)


# Waiting time
# test if shape = 2, scale = 1, mean = 2, var = 2
test <- rgamma(31, shape = 2, scale = 1)
mean(test) 
var(test)

x <- c(0:30)
y <- sapply(x, function(x) {dgamma(x, shape = 2, scale = 1)})
df <- data.frame(x, y)
ggplot(df, aes(x = x, y = y)) + geom_line()

scale.points <- c(0:30) 
lambda <- 50
c <- 0

densityf <- function(x) {dgamma(x, shape = 2, scale = 1)}
cumulativef <- function(x) {pgamma(x, shape = 2, scale = 1)}

example.wt <- data.frame(x=scale.points) 

denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

example.wt$pt <- sapply(example.wt$x, 
                        function(x) {probability.threshold(x, scale.points, lambda, c, densityf, cumulativef, denominator)}) 

g1 <- ggplot(example.wt, aes(x=x, y=pt)) 
g1 <- g1 + geom_area(fill="steelblue", alpha=.4) + xlab("Wating time (minutes)") + ylab("probability") + ggtitle("Probability of threshold for waiting time")
g1

example.wt$pua <- sapply(example.wt$x,
                         function(x) {use.adjective(x, scale.points, lambda, c, densityf, cumulativef, denominator)})


g2 <- ggplot(example.wt, aes(x=x, y=pua)) + xlab("Waiting time (minutes)") + ylab("probability") + ggtitle("Probability of using adjective late")
g2 <- g2 + geom_line() 
g2

grid.arrange(g1, g2, ncol=2)

# verification
probability.threshold(1, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(2, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(3, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(4, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(5, scale.points, lambda, c, densityf, cumulativef, denominator)
probability.threshold(6, scale.points, lambda, c, densityf, cumulativef, denominator)

use.adjective(2, scale.points, lambda, c, densityf, cumulativef, denominator)
use.adjective(7, scale.points, lambda, c, densityf, cumulativef, denominator)
use.adjective(10, scale.points, lambda, c, densityf, cumulativef, denominator)
use.adjective(15, scale.points, lambda, c, densityf, cumulativef, denominator)
use.adjective(20, scale.points, lambda, c, densityf, cumulativef, denominator)
use.adjective(30, scale.points, lambda, c, densityf, cumulativef, denominator)


# Task 3
data.adjective <- read.csv(file="adjective-data.csv", header=TRUE)

gaussian.dist <- c(1,2,3,4,5,6,5,4,3,2,1,0,0,0)
left.skew.dist <- c(2,5,6,6,5,4,3,2,1,1,1,0,0,0)
moved.dist <- c(0,0,0,1,2,3,4,5,6,5,4,3,2,1)
right.skew.dist <- c(1,1,1,2,3,4,5,6,6,5,2,0,0,0)

df <- as.data.frame(gaussian.dist)
ggplot(df, aes(x=df$gaussian.dist)) + geom_bar()

data.gaus <- data.adjective[data.adjective$Distribution=="gaussian",]
data.left <- data.adjective[data.adjective$Distribution=="left",]
data.moved <- data.adjective[data.adjective$Distribution=="moved",]

p.g <- ggplot(data.gaus,aes(x=Stimulus,y=100*percentage,colour=Adjective))+geom_line()+ ylab("Percentage") +ggtitle("gaussian")
p.l <- ggplot(data.left,aes(x=Stimulus,y=100*percentage,colour=Adjective))+geom_line()+ ylab("Percentage")+ggtitle("left skewed")
p.m <- ggplot(data.moved,aes(x=Stimulus,y=100*percentage,colour=Adjective))+geom_line()+ ylab("Percentage")+ggtitle("moved")

# "big" correlation

# user data
data.gaus.big <- subset(data.gaus, Adjective == "big")
data.left.big <- subset(data.left, Adjective == "big")
data.moved.big <- subset(data.moved, Adjective == "big")

# model gaussian
scale.points <- c(1:14)
lambda <- 40
c <- 0 # c = 0.1, -0.1, 0
densityf <- function(x) {dnorm(x, 6, 2)}
cumulativef <- function(x) {pnorm(x, 6, 2)}
denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

Stimulus <- c()
percentage <- c()
for(i in 1:14) {
  Stimulus <- c(Stimulus, i)
  x <- use.adjective(i, scale.points, lambda, c, densityf, cumulativef, denominator)
  percentage <- c(percentage, x)
}
model.gaus.big <- data.frame(Stimulus, percentage)

cor.test(data.gaus.big$percentage, model.gaus.big$percentage)

# model left skewed
scale.points <- c(1:14)
lambda <- 40
c <- -0.1 # c = 0.1, -0.1, 0
densityf <- function(x) {dgamma(x, shape = 4, scale = 1.5)}
cumulativef <- function(x) {pgamma(x, shape = 4, scale = 1.5)}
denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

Stimulus <- c()
percentage <- c()
for(i in 1:14) {
  Stimulus <- c(Stimulus, i)
  x <- use.adjective(i, scale.points, lambda, c, densityf, cumulativef, denominator)
  percentage <- c(percentage, x)
}
model.left.big <- data.frame(Stimulus, percentage)

cor.test(data.left.big$percentage, model.left.big$percentage)

# model moved
scale.points <- c(1:14)
lambda <- 40
c <- -0.1 # c = 0.1, -0.1, 0
densityf <- function(x) {dnorm(x, 9, 2)}
cumulativef <- function(x) {pnorm(x, 9, 2)}
denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

Stimulus <- c()
percentage <- c()
for(i in 1:14) {
  Stimulus <- c(Stimulus, i)
  x <- use.adjective(i, scale.points, lambda, c, densityf, cumulativef, denominator)
  percentage <- c(percentage, x)
}
model.moved.big <- data.frame(Stimulus, percentage)

cor.test(data.moved.big$percentage, model.moved.big$percentage)

# model left skewed: gamma -> normal
scale.points <- c(1:14)
lambda <- 40
c <- -0.1 # c = 0.1, -0.1, 0
densityf <- function(x) {dnorm(x, 9, 2)}
cumulativef <- function(x) {pnorm(x, 9, 2)}
denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

Stimulus <- c()
percentage <- c()
for(i in 1:14) {
  Stimulus <- c(Stimulus, i)
  x <- use.adjective(i, scale.points, lambda, c, densityf, cumulativef, denominator)
  percentage <- c(percentage, x)
}
model.left.big <- data.frame(Stimulus, percentage)

cor.test(data.left.big$percentage, model.left.big$percentage)

# model moved: normal -> gamma
scale.points <- c(1:14)
lambda <- 40
c <- -0.1 # c = 0.1, -0.1, 0
densityf <- function(x) {dgamma(x, shape = 4, scale = 1.5)}
cumulativef <- function(x) {pgamma(x, shape = 4, scale = 1.5)}
denominator <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

Stimulus <- c()
percentage <- c()
for(i in 1:14) {
  Stimulus <- c(Stimulus, i)
  x <- use.adjective(i, scale.points, lambda, c, densityf, cumulativef, denominator)
  percentage <- c(percentage, x)
}
model.moved.big <- data.frame(Stimulus, percentage)

cor.test(data.moved.big$percentage, model.moved.big$percentage)

# Task 4
# install.packages('BayesianTools')

# Example
library(BayesianTools)

# P(A): probability of param1, param1 = p1 + p2
prior <- createUniformPrior(lower = c(0, 0.1), upper = c(0.1, 1), best = NULL)

data.gaus.big <- subset(data.gaus, Adjective == "big")

# P(B|A): 
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

# data.gaus.big
prior <- createUniformPrior(lower = c(-1, 1), upper = c(1, 50), best = NULL)

data.gaus.big <- subset(data.gaus, Adjective == "big")

scale.points <- c(1:14)
lambda <- 40
c <- -1
densityf <- function(x) {dnorm(x, 6, 2)}
cumulativef <- function(x) {pnorm(x, 6, 2)}
denominator <- sum(sapply(c(1:14), function(x) {exp(lambda * utility(x, scale.points, c, densityf, cumulativef))}))

# P(B|A): 
likelihood <- function(param1) {
  
  collect <- 0
  
  for (i in 1:14) {
    collect  <- collect + dnorm(data.gaus.big$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], densityf, cumulativef, denominator), sd=0.1, log=TRUE)
    
  }
  
  return(collect)
} 

bayesianSetup <- createBayesianSetup(likelihood = likelihood, prior = prior)

iter = 10000
settings = list(iterations = iter, message = FALSE)
out <- runMCMC(bayesianSetup = bayesianSetup, settings = settings)

summary(out)

# Task 5

prior <- createUniformPrior(lower = c(-1, 1), upper = c(1, 50), best = NULL)

data.gaus.big <- subset(data.gaus, Adjective == "big")
data.left.big <- subset(data.left, Adjective == "big")
data.moved.big <- subset(data.moved, Adjective == "big")

data.gaus.pointy <- subset(data.gaus, Adjective == "pointy")
data.left.pointy <- subset(data.left, Adjective == "pointy")
data.moved.pointy <- subset(data.moved, Adjective == "pointy")

data.gaus.tall <- subset(data.gaus, Adjective == "tall")
data.left.tall <- subset(data.left, Adjective == "tall")
data.moved.tall <- subset(data.moved, Adjective == "tall")

scale.points <- c(1:14)
lambda <- 40
c <- -1

denominator.gaus <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, function(x) {dnorm(x, 6, 2)}, function(x) {pnorm(x, 6, 2)}))}))
denominator.left <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, function(x) {dgamma(x, shape = 4, scale = 1.5)}, function(x) {pgamma(x, shape = 4, scale = 1.5)}))}))
denominator.moved <- sum(sapply(scale.points, function(x) {exp(lambda * utility(x, scale.points, c, function(x) {dnorm(x, 9, 2)}, function(x) {pnorm(x, 9, 2)}))}))


# P(B|A): 
likelihood <- function(param1) {
  
  collect <- 0
  
  for (i in 1:14) {
    collect  <- collect + 
      dnorm(data.gaus.big$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dnorm(x, 6, 2)}, function(x) {pnorm(x, 6, 2)}, denominator.gaus), sd=0.1, log=TRUE) +
      dnorm(data.gaus.pointy$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dnorm(x, 6, 2)}, function(x) {pnorm(x, 6, 2)}, denominator.gaus), sd=0.1, log=TRUE) +
      dnorm(data.gaus.tall$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dnorm(x, 6, 2)}, function(x) {pnorm(x, 6, 2)}, denominator.gaus), sd=0.1, log=TRUE) +
      dnorm(data.left.big$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dgamma(x, shape = 4, scale = 1.5)}, function(x) {pgamma(x, shape = 4, scale = 1.5)}, denominator.left), sd=0.1, log=TRUE) +
      dnorm(data.left.pointy$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dgamma(x, shape = 4, scale = 1.5)}, function(x) {pgamma(x, shape = 4, scale = 1.5)}, denominator.left), sd=0.1, log=TRUE) +
      dnorm(data.left.tall$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dgamma(x, shape = 4, scale = 1.5)}, function(x) {pgamma(x, shape = 4, scale = 1.5)}, denominator.left), sd=0.1, log=TRUE) +
      dnorm(data.moved.big$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dnorm(x, 9, 2)}, function(x) {pnorm(x, 9, 2)}, denominator.moved), sd=0.1, log=TRUE) +
      dnorm(data.moved.pointy$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dnorm(x, 9, 2)}, function(x) {pnorm(x, 9, 2)}, denominator.moved), sd=0.1, log=TRUE) +
      dnorm(data.moved.tall$percentage[i], mean=use.adjective(i, scale.points, param1[2], param1[1], function(x) {dnorm(x, 9, 2)}, function(x) {pnorm(x, 9, 2)}, denominator.moved), sd=0.1, log=TRUE)
  }
  
  return(collect)
} 

bayesianSetup <- createBayesianSetup(likelihood = likelihood, prior = prior)

iter = 10000
settings = list(iterations = iter, message = FALSE)
out <- runMCMC(bayesianSetup = bayesianSetup, settings = settings)

summary(out)



