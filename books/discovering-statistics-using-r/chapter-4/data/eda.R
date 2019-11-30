library(tidyverse)
library(nycflights13)

ggplot(diamonds) + geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
count(diamonds, cut_width(carat, 0.5))

smaller <- diamonds %>% filter(carat < 3)
ggplot(data = smaller, mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.1)
ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)

ggplot(data = diamonds, mapping = aes(x = y)) + 
  geom_histogram(binwidth = 0.5)
ggplot(data = diamonds, mapping = aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  arrange(y)
unusual

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

flights %>% 
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100, 
         sched_min = sched_dep_time %% 100, 
         sched_dep_time = sched_hour + sched_min / 60) %>% 
  ggplot(mapping = aes(x = sched_dep_time)) + 
  geom_freqpoly(mapping = aes(color = cancelled), binwidth = 1/4)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_point()
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), 
                             y = hwy))
ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), 
                             y = hwy)) + 
  coord_flip()

# install.packages("lvplot")
library(lvplot)
ggplot(data = diamonds) + 
  geom_lv(mapping = aes(x = cut, y = price)) 

ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = price), binwidth = 500) +
  facet_wrap(~ cut)

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
count(diamonds, color, cut)

diamonds %>% count(color, cut) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price))
ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1/100)

# install.packages("hexbin")
library(hexbin)

smaller <- diamonds %>% filter(carat < 3)
ggplot(data = smaller) + 
  geom_jitter(mapping = aes(x = carat, y = price))
ggplot(data = smaller) + 
  geom_bin2d(mapping = aes(x = carat, y = price))
ggplot(data = smaller) + 
  geom_hex(mapping = aes(x = carat, y = price))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), varwidth = TRUE)
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)
diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))
ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))
ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))





