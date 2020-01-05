# data(litter, package = "multcomp")

library(multcomp)

attach(litter)
table(dose)

aggregate(weight, by = list(dose), FUN = mean)
fit <- aov(weight ~ gesttime + dose)
summary(fit)

library(effects)
effect("dose", fit)

library(multcomp)
constrast = rbind("no drug vs. drug" = c(3, -1, -1, -1))
summary(glht(fit, linfct = mcp(dose = constrast)))

library(multcomp)
fit2 <- aov(weight ~ gesttime * dose, data = litter)
summary(fit2)

library(HH)
ancova(weight ~ gesttime + dose, data = litter)
ancova(weight ~ gesttime * dose, data = litter)
