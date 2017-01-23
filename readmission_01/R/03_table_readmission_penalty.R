##### read in
file <- "./data_tidy/2016_readmission_penalties_all_hosp_five_years.csv"
df <- read.csv(file = file, header = T, stringsAsFactors = F)

##### table all observations
df.all <- 
        df %>%
        group_by(year) %>%
        summarise(number = length(value),
                  min = min(value),
                  q1 = quantile(value, .25),
                  median = median(value),
                  mean = mean(value),
                  q3 = quantile(value, .75),
                  max = max(value))
file <- "./tables/Readmission_Penalties_All_Hosp_2013_2017.csv"
write.csv(df.all, file = file, row.names = F)

##### plot all hospitals
p1 <- ggplot(df, aes(value))
p1 <- p1 + facet_grid(. ~ year)
p1 <- p1 + geom_histogram(bins = 15)
p1 <- p1 + ylab("all hospitals")
p1
file <- "./plots/Readmission_penalties_All_Hosp_2013_2017.pdf"
ggsave(p1, filename = file, height = 5, width = 8, unit = "in")

##### table all kentucky hospitals
 df.ky <-       
         df %>%
                filter(State == "KY") %>%
                group_by(year) %>%
                summarise(number = length(value),
                          min = min(value),
                          q1 = quantile(value, .25),
                          median = median(value),
                          mean = mean(value),
                          q3 = quantile(value, .75),
                          max = max(value))
file <- "./tables/Readmission_Penalties_KY_hosp_2013_2017.csv"
write.csv(df.ky, file = file, row.names = F)

##### plot kentucky hospitals
  df.ky.1 <-
         df %>%
         filter(State == "KY")

p2 <- ggplot(df.ky.1, aes(value))
p2 <- p2 + facet_grid(. ~ year)
p2 <- p2 + geom_histogram(bins = 15)
p2 <- p2 + ylab("ky hospitals")
p2
file <- "./plots/Readmission_penalties_KY_Hosp_2013_2017.pdf"
ggsave(p2, filename = file, height = 5, width = 8, unit = "in")

##### table indiana hospitals
df.in <-         
        df %>%
        filter(State == "IN") %>%
        group_by(year) %>%
        summarise(number = length(value),
                  min = min(value),
                  q1 = quantile(value, .25),
                  median = median(value),
                  mean = mean(value),
                  q3 = quantile(value, .75),
                  max = max(value))
file <- "./tables/Readmission_Penalties_IN_Hosp_2013_2017.csv"
write.csv(df.in, file = file, row.names = F)

#####plot indiana hospitals
df.in.1 <- 
        df %>%
        filter(State == "IN")
p3 <- ggplot(df.in.1, aes(value))
p3 <- p3 + facet_grid(. ~ year)
p3 <- p3 + geom_histogram(bins = 15)
p3 <- p3 + ylab("in hospitals")
p3
file <- "./plots/Readmission_penalties_IN_Hosp_2013_2017.pdf"
ggsave(p3, filename = file, height = 5, width = 8, unit = "in")

#Combine plots
file <- "./plots/All_KY_IN_Hosp_Readmission_Penalty.pdf"
pdf(file = file, height = 5, width = 8)
library(ggplot2)
library(grid)
library(gridExtra)
p4 <- grid.arrange(p1, p2, p3, ncol = 1, top = "Readmission Penalties by Year -- All, KY, IN")
p4
dev.off()

#clean
rm(list = ls())



        