CO2$conc <- factor(CO2$conc)
w1b1 <- subset(CO2, Treatment == "chilled")

fit <- aov(uptake ~ conc * Type + Error(Plant/(conc)), w1b1)
summary(fit)

par(las = 2)
par(mar = c(10, 4, 4, 2))
with(w1b1, interaction.plot(conc, Type, uptake, 
                            type = "b",
                            col = c("red", "blue"),
                            pch = c(16, 18),
                            main = "Interaction Plot for Plant Type and Concentration"))

boxplot(uptake ~ Type*conc, data = w1b1, col = c("gold", "green"),
        main = "Chilled Quebec and Mississippi Plants",
        ylab = "Carbon dioxide uptake rate (umol/m^2 sec)")
