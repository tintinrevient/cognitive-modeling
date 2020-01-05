library(tidyverse)

myvars <- c('mpg', 'hp', 'wt')
summary(mtcars[myvars])

pretty(c(-3, 3), 10)
scale(c(1,2,3,4,5), center=TRUE, scale = FALSE)
scale(c(1,2,3,4,5), center=TRUE, scale = TRUE)

x <- pretty(c(-3, 3), 10)
y <- dnorm(x)
plot(x, y, type='l')

set.seed(1234)
# runif(5)
rnorm(5)

library(MASS)
options(digits = 3)
set.seed(1234)
mean <- c(1, 2, 3)
sigma <- matrix(c(1, 1, 1, 1, 1, 1, 1, 1, 1), nrow = 3, ncol = 3)
mydata <- mvrnorm(500, mu = mean, Sigma = sigma)
mydata <- as.data.frame(mydata)
names(mydata) <- c('y', 'x1', 'x2')
dim(mydata)
head(mydata, n = 10)

grep('A', c('bb', 'A', 'AA', 'c'), fixed = TRUE)
strsplit("abcd", "", fixed = TRUE)

mydata <- matrix(rnorm(30), nrow = 6)
head(mydata, n = 10)
apply(mydata, 1, mean)
apply(mydata, 2, mean)
apply(mydata, 2, mean, trim = 0.2)

feelings <- c("sad", "afraid")
for(i in feelings) {
  print(
    switch (i,
                sad = "cheer up",
                afraid = "there is nothing to fear"
    )
  )
}

# install.packages("Hmisc")
# install.packages("pastecs")
# install.packages("psych")
# install.packages("doBy")
# install.packages("vcd")

library(Hmisc)
describe(mtcars[myvars])

library(pastecs)
stat.desc(mtcars[myvars], norm = TRUE)

library(psych)
describe(mtcars[myvars])

library(vcd)
head(Arthritis)
mytable <- with(Arthritis, table(Improved))
mytable
prop.table(mytable)

mytable <- with(Arthritis, table(Treatment, Improved))
mytable
chisq.test(mytable)
fisher.test(mytable)
assocstats(mytable)

mytable <- xtabs(~ Treatment + Sex, data = Arthritis)
mytable
chisq.test(mytable)
fisher.test(mytable)

mytable <- xtabs(~ Treatment + Improved + Sex, data = Arthritis)
mytable
mantelhaen.test(mytable)

ftable(mytable)
margin.table(mytable, c(1, 2))
margin.table(mytable, c(1, 3))
ftable(prop.table(mytable, c(1, 2)))
ftable(addmargins(prop.table(mytable, c(1, 2)), 3))
ftable(addmargins(prop.table(mytable, c(1, 2)), 3)) * 100

prop.table(mytable, 1)
prop.table(mytable, 2)

margin.table(mytable, 1)
margin.table(mytable, 2)

addmargins(mytable)
addmargins(prop.table(mytable, 1), 2)

# install.packages("gmodels")
library(gmodels)
CrossTable(Arthritis$Treatment, Arthritis$Improved)

# install.packages("ggm")
library(ggm)

states <- state.x77[,1:6]
head(states, n = 10)
cov(states)
cor(states)
cor(states, method = "spearman")

x <- states[, c(1, 2, 3, 6)]
y <- states[, c(4, 5)]
cor(x, y)
cor.test(states[,3], states[,5])
corr.test(states, use = "complete")

library(ggm)
pcor(c(1, 5, 2, 3, 6), cov(states))

pcor.test()
r.test()

options(scipen = 999)
t.test(Prob ~ So, data = UScrime)

# SD decreases when the number of samples increases
# samples = 5, SD of deviation = 0.360 <=> samples = 50, SD of deviation =  0.356
tableAllSamples <- runAllSimpleStrategies(25, "07854325698")
# View(tableAllSamples)
data <- tableAllSamples %>% filter(keypresses == 11)
# stat.desc(data)
sapply(data[c(2, 3)], function(x)(c(mean = mean(x), sd = sd(x))))
# with(data, t.test(deviations, times, paired = TRUE))

# Correlation between strats and deviation
# samples = 5, cor = 0.21 <=> samples = 50, cor = 0.438
data <- tableAllSamples %>% filter(keypresses == 11) %>% group_by(steers, strats) %>% summarise(mean = mean(deviations))
time <- tableAllSamples %>% filter(keypresses == 11) %>% group_by(steers, strats) %>% summarise(mean = mean(times))
cor(data$strats, data$mean)
cor(time$strats, time$mean)
corr.test(data, use = "complete")
# samples = 10, p-value = 0.02 <=> samples = 50, p-value = 0.0001
kruskal.test(mean ~ strats, data = data)

with(UScrime, by(Prob, So, median))
wilcox.test(Prob ~ So, data = UScrime)

sapply(UScrime[c("U1", "U2")], median)
with(UScrime, wilcox.test(U1, U2, paired = TRUE))

# Cmd + Enter: run the current line
states <- data.frame(state.x77, state.region)
kruskal.test(Illiteracy ~ state.region, data = states)

friedman.test()






