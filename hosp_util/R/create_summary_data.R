file <- "./data_tidy/kyhut1all.csv"
a <- read.csv(file = file, 
         header = T,
         as.is = T)
library(plyr)
library(dplyr)
a.1 <- a %>%
        group_by(year, variable) %>%
        summarize(obs = length(value),
                  min = min(value),
                  qu.1st = quantile(value, probs = .25, na.rm = T),
                  median = median(value),
                  mean = mean(value),
                  qu.3rd = quantile(value, probs = .75, na.rm = T),
                  max = max(value),
                  sum = sum(value),
                  sd = sd(value, na.rm = T),
                  nas = sum(is.na(value))
        ) %>%
        arrange(variable, year)
write.csv(a.1, file = "./tables/kyhut1_summary.csv",
          row.names = F)
rm(list = ls())