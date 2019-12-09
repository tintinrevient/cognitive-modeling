library(tidyverse)
library(modelr)
options(na.action = na.warn)

x <- range(c(4, 6, 9), na.rm=TRUE)
print(x)
print(x[1])
print(x[2])

ggplot(sim1, aes(x, y)) +
  geom_point()

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a1, slope=a2),
              data = models, alpha = 1/4) +
  geom_point()


