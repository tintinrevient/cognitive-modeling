# cmd + enter: run the code line by line

# install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

# View(flights)

filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)
(jan1 <- filter(flights, month == 1, day == 1))

# sqrt(2) ^ 2 == 2
# near(sqrt(2) ^ 2, 2)

filter(flights, month == 11 | month == 12)
filter(flights, month %in% c(11, 12))
filter(flights, arr_delay <= 120, dep_delay <= 120)
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, dest == "IAH" | dest == "HOU")
filter(flights, month %in% c(7, 8, 9))
filter(flights, between(month, 7, 9))
filter(flights, is.na(dep_time))

# x <- NA
# is.na(x)

df <- tibble(x = c(1, 5, 2, NA, 3))
filter(df, x > 1 | is.na(x))
filter(df, x > 1)
arrange(df, x)
arrange(df, desc(x))
arrange(flights, desc(arr_delay))
arrange(flights, min_rank(dep_delay))

select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))
select(flights, starts_with("dep"))
select(flights, ends_with("delay"))
rename(flights, depart_time = dep_time)
select(flights, time_hour, air_time, everything())
select(flights, time_hour, time_hour)

var <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(var))
select(flights, contains("TIME"))

flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)
transmute(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)

flights_sml %>% 
  group_by(year, month, day) %>% 
  filter(rank(desc(arr_delay)) < 10)

flights_dep <- select(flights, year:day, dep_time, sched_dep_time)
mutate(flights_dep, 
       dep_min = dep_time %/% 100 * 60 + dep_time %% 100, 
       sched_dep_min = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100)

x <- 1:10
lag(x)
lead(x)
cumsum(x)
cumprod(x)
cummin(x)
cummax(x)
cummean(x)

5 %% 2
5 %/% 2

y <- c(1,2,2,NA,3,4)
y
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)
ntile(x = row_number(y), 2)

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest, count = n(), 
                   dist = mean(distance, na.rm = TRUE), 
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dest != "HNL")
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(mapping = aes(size = count), alpha = 1/3) + 
  geom_smooth(se = FALSE)

# shortcut for pipe %>%: cmd + shift + "m" 
# shortcut for sending the chosen code snippet to the console: cmd + shift + "p"
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(count = n(), 
            dist = mean(distance, na.rm = TRUE), 
            delay = mean(arr_delay, na.rm = TRUE)) %>% 
  filter(count > 20, dest != "HNL")
ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
  geom_point(mapping = aes(size = count), alpha = 1/3) + 
  geom_smooth(se = FALSE)

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay))
delays
ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay), n = n())
ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay), n = n())
delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(avg_delay1 = mean(arr_delay),
            avg_delay2 = mean(arr_delay[arr_delay > 0]))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(first = min(dep_time),
            quarter1 = quantile(dep_time, 0.25),
            median = median(dep_time),
            quarter3 = quantile(dep_time, 0.75),
            last = max(dep_time))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(first_step = first(dep_time),
            last_step = last(dep_time))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% count(dest)

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% count(tailnum, wt = distance)
not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(n = sum(distance))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))
# mean becomes proportion
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_perc = mean(arr_delay > 60))

daily <- flights %>% group_by(year, month, day)
(per_day <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year <- summarise(per_month, flights = sum(flights)))

daily %>% 
  ungroup() %>% 
  summarise(flights = n())

popular_flights <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_flights



