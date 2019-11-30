# install.packages("tidyverse")
library(tidyverse)

# View(mpg)

ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, color = class))
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, size = class))
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, color = cty))
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy), stroke = 3)
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap( ~ class, nrow = 2)
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = cyl))
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(cyl ~ .)
ggplot(data = mpg) +  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cty)
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), show.legend = FALSE)
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, color = drv)) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth() + geom_point()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  stat_smooth() + geom_point()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth() + geom_point(mapping = aes(color = class))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE) + geom_point(mapping = aes(color = class))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() + geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(position = "jitter")
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() + coord_flip()

# install.packages("maps")
library(maps)
nz <- map_data("nz")
ggplot(data = nz, mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "black", fill= "white")
ggplot(data = nz, mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "black", fill= "white") +
  coord_quickmap()

# install.packages("mapproj")
library(mapproj)
ggplot(data = nz, mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "black", fill= "white") +
  coord_map()

bar <- ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = FALSE, width = 1) +
  theme(aspect.ratio = 1) + 
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "identity") +
  coord_polar()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() +
  geom_abline() + 
  coord_fixed()

# View(diamonds)
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, color = cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(alpha = 1/5, position = "identity")
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(fill = NA, position = "identity")
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "identity")
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill")
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")

ggplot(data = diamonds) + stat_count(mapping = aes(x= cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = price), stat = "identity")
ggplot(data = diamonds) + geom_col(mapping = aes(x = cut, y = price))

demo <- tribble(
  ~a, ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40
)
ggplot(data = demo) + geom_bar(mapping = aes(x = a, y = b), stat = "identity")

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop.., fill = cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..count.., fill = ..count..))

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop..))

ggplot(data = diamonds) + stat_summary(mapping = aes(x = cut, y = depth), 
                                       fun.ymin = min,
                                       fun.ymax = max,
                                       fun.y = median)
ggplot(data = diamonds) + geom_point(mapping = aes(x= cut, y = depth))
ggplot(data = diamonds) + geom_freqpoly(mapping = aes(x = depth))
ggplot(data = diamonds) + geom_histogram(mapping = aes(x = depth))

# shortcut
# alt + "-": <- 
# cmd + shift + "c": comment

sin(pi/2)
y <- seq(2, 18)
y
(y <- seq(2, 18))
