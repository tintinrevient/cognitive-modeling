data(Affairs, package = "AER")

summary(Affairs)
table(Affairs$affairs)

Affairs$ynaffair[Affairs$affairs > 0] <- 1
Affairs$ynaffair[Affairs$affairs == 0] <- 0
Affairs$ynaffair <- factor(Affairs$ynaffair, levels = c(0, 1), labels = c("No", "Yes"))
table(Affairs$ynaffair)

fit.full <- glm(formula = ynaffair ~ gender + age + yearsmarried + children + religiousness + education + occupation + rating,
           family = binomial(), 
           data = Affairs)
summary(fit.full)

fit.reduced <- glm(formula = ynaffair ~ age + yearsmarried + religiousness + rating,
                family = binomial(), 
                data = Affairs)
summary(fit.reduced)

# regression diagnostics
plot(predict(fit.reduced, type = "response"),
     residuals(fit.reduced, type = "deviance"))

plot(rstudent(fit.reduced))
abline(h = c(-2, 2), col = "red", lty = 2)

plot(hatvalues(fit.reduced))
p <- length(coef(fit.reduced))
n <- length(fitted(fit.reduced))
abline(h = c(2,3)*p/n, col = "red", lty = 2)

plot(cooks.distance(fit.reduced))
p <- length(coef(fit.reduced))
n <- length(fitted(fit.reduced))
cutoff <- 4 / (n - p - 1)
abline(h = cutoff, lty = 2, col = "red")

anova(fit.reduced, fit.full, test = "Chisq")

coef(fit.reduced)
exp(coef(fit.reduced))

testdata <- data.frame(rating = c(1, 2, 3, 4, 5),
                       age = mean(Affairs$age),
                       yearsmarried = mean(Affairs$yearsmarried),
                       religiousness = mean(Affairs$religiousness))

testdata$prob <- predict(fit.reduced, newdata = testdata, type = "response")
testdata

testdata <- data.frame(rating = mean(Affairs$rating),
                       age = seq(17, 57, 10),
                       yearsmarried = mean(Affairs$yearsmarried),
                       religiousness = mean(Affairs$religiousness))
testdata$prob <- predict(fit.reduced, newdata = testdata, type = "response")
testdata

overdispersion <- deviance(fit.reduced) / df.residual(fit.reduced)
overdispersion

fit <- glm(formula = ynaffair ~ age + yearsmarried + religiousness + rating,
                   family = binomial(), 
                   data = Affairs)

fit.od <- glm(formula = ynaffair ~ age + yearsmarried + religiousness + rating,
              family = quasibinomial(), 
              data = Affairs)

pchisq(summary(fit.od)$dispersion * fit$df.residual, fit$df.residual, lower = F)

library(robust)
data(breslow.dat, package = "robust")
names(breslow.dat)
summary(breslow.dat[c(6, 7, 8, 10)])

opar <- par(no.readonly = TRUE)
par(mfrow = c(1, 2))
attach(breslow.dat)
hist(sumY, breaks = 20, xlab = "Seizure Count", main = "Distribution of Seizures")

boxplot(sumY ~ Trt, xlab = "Treatment", main = "Group Comparisons")
par(opar)

fit <- glm(sumY ~ Base + Age + Trt, data = breslow.dat, family = poisson())
summary(fit)
coef(fit)
exp(coef(fit))

deviance(fit) / df.residual(fit)

library(qcc)
qcc.overdispersion.test(breslow.dat$sumY, type = "poisson")

fit.od <- glm(sumY ~ Base + Age + Trt, data = breslow.dat, family = quasipoisson())
summary(fit.od)

fit <- glm(sumY ~ Base + Age + Trt, data = breslow.dat, 
           offset = log(time),
           family = poisson())





