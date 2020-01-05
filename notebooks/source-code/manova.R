library(MASS)
attach(UScereal)

shelf <- factor(shelf)
y <- cbind(calories, fat, sugars)

aggregate(y, by = list(shelf), FUN = mean)
cov(y)

fit <- manova(y ~ shelf)
summary(fit)
summary.aov(fit)

# the normality of the dependent variables
center <- colMeans(y)
n <- nrow(y)
p <- ncol(y)
cov <- cov(y)
d <- mahalanobis(y, center, cov)
coord <- qqplot(qchisq(ppoints(n), df = p), d, 
                main = "Q-Q Plot Assessing Multivariate Normality",
                ylab = "Mahalanobis D2")
abline(a = 0, b = 1)
identify(coord$x, coord$y, labels = row.names(UScereal))

# outlier
library(mvoutlier)
outliers <- aq.plot(y)

# non-parametric manova test
library(rrcov)
Wilks.test(y, shelf, method = "mcd")

# aov
library(multcomp)
levels(cholesterol$trt)
fit.aov <- aov(response ~ trt, data = cholesterol)
summary(fit.aov)

# lm
fit.lm <- lm(response ~ trt, data = cholesterol)
summary(fit.lm)





