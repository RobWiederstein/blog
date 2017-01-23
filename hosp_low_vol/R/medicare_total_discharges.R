#read in file
file <- list.files(path = "./data_raw", pattern = "csv", full.names = T)
df <- read.csv(file = file, header = T, stringsAsFactors = F)

#break out DRG code
df$DRG <- substr(df$DRG.Definition, 1, 3)

#remove commas from Total Discharge variable and convert to integer
df$Total.Discharges <- as.integer(gsub(",", "", df$Total.Discharges))

#remove $ and ,
df[, 10:12] <- apply(df[, 10:12], 2, function(x) as.numeric(gsub("\\$|,", "",  x)))

#


##### Plot Tri-State Hospitals for total discharges DRG 469 and 470 in 2014
library(dplyr)
library(magrittr)
df.a <-
        df %>%
        filter(grepl("469|470", DRG)) %>%
        filter(grepl("IN|KY", Provider.State)) %>%
        filter(Provider.City %in% c("EVANSVILLE", "OWENSBORO", "HENDERSON")) %>%
        group_by(Provider.Name) %>%
        summarise(Total.Discharges = sum(Total.Discharges)) %>%
        arrange(-Total.Discharges)
        
df.a$rank <- 4:1
df.a$Provider.Name <- rev(c("St. Mary's", "Deaconess", "Owensboro", "Methodist"))
df.a$Provider.State <- rev(c("KY", "KY", "IN", "IN"))

library(ggplot2)
library(RColorBrewer)
p <- ggplot(df.a, aes(rank, Total.Discharges, colour = Provider.State))
p <- p + geom_point(size = 2.5)
p <- p + scale_x_continuous(labels = df.a$Provider.Name, name = "")
p <- p + scale_y_continuous(name = "Discharges")
p <- p + geom_hline(yintercept = 50, linetype = 2)
p <- p + annotate("text", x = 1.25, y = 130, 
                  label = "Take the Volume Pledge \n Hip & Knee = 50", 
                  size = 3)
p <- p + scale_color_brewer(palette = "Set1")
p <- p + ggtitle("Medicare Joint Replacement Lower Extremity FY2014 \n (DRG 469 & 470)")
p <- p + theme(plot.title=element_text(hjust=0.5))
p <- p + coord_flip()
p

file <- "./plots/Total_Medicare_Discharges_DRG_470_FY2014.pdf"
ggsave(filename = file, width = 8, height = 5, unit = "in")

file <- "./plots/Total_Medicare_Discharges_DRG_470_FY2014.jpg"
ggsave(filename = file, width = 8, height = 4.2, unit = "in")


##### Plot IN and KY Hospitals for # of Discharges for DRG 470 in 2014
library(dplyr)
library(magrittr)
df.ky.in <-
        df %>%
        filter(grepl("470", DRG)) %>%
       filter(grepl("IN|KY", Provider.State))
df.tri <- 
        df.ky.in %>%
        filter(Provider.City %in% c("EVANSVILLE", "HENDERSON", "OWENSBORO"))
df.tri$Provider.Name <- c("Deaconess", "St. Mary's", "Owensboro", "Methodist")
        
p <- ggplot(df.ky.in, aes(Provider.State, Total.Discharges, group = Provider.State))
p <- p + geom_boxplot(colour = "gray")
p <- p + geom_point(aes(Provider.State), position = position_jitter(width = .15), alpha = .5, colour = "gray")
p <- p + geom_point(data = df.tri, aes(x = Provider.State, y = Total.Discharges, colour = Provider.State), size = 2)
p <- p + geom_text(data = df.tri, aes(x = Provider.State, y = Total.Discharges, 
                                      label = Provider.Name, colour = Provider.State), 
                   size = 3, hjust = 0, nudge_x = .05, fontface = "bold")
p <- p + scale_color_brewer(palette = "Set1")
p <- p + theme(legend.position = "none")
p <- p + ggtitle("Medicare Joint Replacement Lower Extremity FY2014 \n (DRG 470)")
p <- p + theme(plot.title=element_text(hjust=0.5))
p <- p + scale_y_continuous(name = "Discharges")
p <- p + scale_x_discrete(name = "")
p
file <- "./plots/Total_Medicare_Discharges_DRG_470_FY2014_all_hospitals.pdf"
ggsave(filename = file, width = 5, height = 5, unit = "in")

