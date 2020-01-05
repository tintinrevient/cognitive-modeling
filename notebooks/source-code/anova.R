library(multcomp)

attach(cholesterol)
table(trt)

aggregate(response, by = list(trt), FUN = mean)
aggregate(response, by = list(trt), FUN = sd)
fit <- aov(response ~ trt)
summary(fit)

library(gplots)
plotmeans(response ~ trt, xlab = "Treatment", ylab = "Response", main = "Mean Plot\nwith 95% CI")
detach(cholesterol)

# pairwise comparison
TukeyHSD(fit)

par(mar = c(5, 4, 6, 2))
tuk <- glht(fit, linfct = mcp(trt = "Tukey"))
plot(cld(tuk, level = 0.05), col = "lightgrey")

# the normality assumption has been met
library(car)
qqPlot(lm(response ~ trt, data = cholesterol), 
       simulate = TRUE, 
       main = "Q - Q Plot", 
       labels = FALSE)

# the equality of variance = homogeneity
bartlett.test(response ~ trt, data = cholesterol)

# outlier test
outlierTest(fit)

# two-way anova
attach(ToothGrowth)
table(supp, dose)

aggregate(len, by = list(supp, dose), FUN = mean)
aggregate(len, by = list(supp, dose), FUN = sd)

dose <- factor(dose)
fit <- (len ~ supp * dose)
summary(fit)

# display the interaction in a two-way ANOVA
interaction.plot(dose, supp, len, 
                 type = "b", 
                 col = c("red", "blue"), 
                 pch = c(16, 18), 
                 main = "Interaction between Dose and Supplement Type")

# interaction with the mean, error bar and sample size
library(gplots)
plotmeans(len ~ interaction(supp, dose, sep = " "),
          connect = list(c(1, 3, 5), c(2, 4, 6)), 
          col = c("red", "darkgreen"),
          main = "Interaction Plot with 95% CIs",
          xlab = "Treatment and Dose Combination")

# interaction
library(HH)
interaction2wt(len ~ supp * dose)

detach(ToothGrowth)
