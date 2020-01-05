options(scipen = 999)

fit <- lm(weight ~ height, data = women)
summary(fit)
fitted(fit)
residuals(fit)
plot(women$height, women$weight, xlab = "Height (in inches)", ylab = "Weight (in pounds)")
abline(fit)

par(mfrow = c(2, 2))
plot(fit)

fit2 <- lm(weight ~ height + I(height^2), data = women)
summary(fit2)
plot(women$height, women$weight, xlab = "Height (in inches)", ylab = "Weight (in pounds)")
lines(women$height, fitted(fit2))

par(mfrow = c(2, 2))
plot(fit2)

library(car)
states <- as.data.frame(state.x77[, c("Murder", "Population", "Illiteracy", "Income", "Frost")])
cor(states)
scatterplotMatrix(states, spread = FALSE, smoother.args = list(ltyp = 2), main = "Scatter Plot Matrix")
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data = states)
summary(fit)
confint(fit)

par(mfrow = c(2, 2))
plot(fit)

# various tests

# normal
qqPlot(fit, labels = row.names(states), id.method = "identify", simulate = TRUE, main = "Q-Q Plot") 
# independence
durbinWatsonTest(fit)
# linear
crPlots(fit)
# constant variance
ncvTest(fit)
spreadLevelPlot(fit)

# summary of all above
library(gvlma)
gvmodel <- gvlma(fit)
summary(gvmodel)

# multicollinearity
vif(fit)
sqrt(vif(fit)) > 2 # problem of multicollinearity

# outlier
outlierTest(fit)

# high-leverage observations - hat values
p <- length(coefficients(fit))
n <- length(fitted(fit))
plot(hatvalues(fit), main = "Index Plot of Hat Values")
abline(h = c(2,3)*p/n, col = "red", lty = 2)
identify(1:n, hatvalues(fit), names(hatvalues(fit))) #interactive mode

# influential observations - cook's distance
cutoff <- 4 / (nrow(states) - length(fit$coefficients) - 1)
plot (fit, which = 4, cook.levels = cutoff)
abline(h = cutoff, lty = 2, col = "red")

# influential observations - added-variable plot
avPlots(fit, ask =  FALSE, id.method = "identify")

# outlier + leverage + influential in one plot
influencePlot(fit, main = "Influence Plot")

states["Nevada",]
fitted(fit)["Nevada"]
residuals(fit)["Nevada"]
rstudent(fit)["Nevada"]

library(effects)
fit <- lm(mpg ~ hp + wt + hp:wt, data = mtcars)
summary(fit)
plot(effect("hp:wt", fit, , list(wt=c(2.2, 3.2, 4.2))), multiline = TRUE)

# normality - transform response variable
summary(powerTransform(states$Murder))

# linearity - transform predictor variables
boxTidwell(Murder~Illiteracy+Population, data = states)

# comparing models
fit1 <- lm(Murder~Population+Illiteracy+Income+Frost, data = states)
fit2 <- lm(Murder~Population+Illiteracy, data = states)
anova(fit2, fit1)

# Akaike Information Criterion
AIC(fit1, fit2)

library(MASS)
stepAIC(fit, direction = "backward")

# All subset regression
library(leaps)
leaps <- regsubsets(Murder~Population+Illiteracy+Income+Frost, data = states, nbest = 4)
plot(leaps, scale = "adjr2")

car::subsets(leaps, statistic = "cp", main = "Cp Plot for All Subsets Regression")
abline(1, 1, lty = 2, col = "red")

# cross validation
library(bootstrap)
theta.fit <- function(x, y){lsfit(x, y)}
theta.predict <- function(fit, x){cbind(1, x)%*%fit$coef}
x <- fit$model


# relative importance - standardized regression coefficients
zstates <- as.data.frame(scale(states))
zfit <- lm(Murder~Population+Illiteracy+Income+Frost, data = zstates)
coef(zfit)



