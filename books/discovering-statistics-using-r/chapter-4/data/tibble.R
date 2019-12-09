library(tidyverse)

frame <- tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
)

tframe <- tribble(
  ~x, ~y, ~z,
  "a", 2, 3.5,
  "b", 1, 8.4
)

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1: 1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>% print(n = 10, width = Inf)

# package help: package?tibble

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

df$x
df[["x"]]
df[[1]]
df %>% .$x
df %>% .[["x"]]

enframe(1:3)
enframe(c(a = 2, b = 4))
deframe(enframe(1:3))
