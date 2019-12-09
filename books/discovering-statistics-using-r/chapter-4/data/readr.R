library(tidyverse)

frame <- read_csv("keyPressDataWithLaneDeviation.csv")

inlineFrame <- read_csv("a, b, c
                        1, 2, 3
                        2, 4, 6
                        3, 6, 9", skip = 1)

inlineFrame <- read_csv("#comment goes here
a, b, c
                        1, 2, 3
                        2, 4, 6
                        3, 6, 9", comment = "#")
View(inlineFrame)

parse_integer(c("1", "231", ".", "456"), na = ".")
parse_double("1,23", locale = locale(decimal_mark = ","))
parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")
parse_number("123.456.789", locale = locale(grouping_mark = "."))
charToRaw("Hadley")
guess_encoding(charToRaw("Hadley"))
guess_parser("2010-10-01")
str(parse_guess("2010-10-10"))

# library(feather)
# write_feather(challenge, "challenge.feather") 
# read_feather("challenge.feather")
# 
# write_rds(challenge, "challenge.rds") 
# read_rds("challenge.rds")

