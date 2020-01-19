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








