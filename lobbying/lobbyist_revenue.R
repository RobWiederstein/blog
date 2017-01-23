#################################################
##  Rob Wiederstein
##  Kentucky Lobbyist Revenue
##  November 1, 2016
#################################################

#load
url <-"http://klec.ky.gov/Reports/Reports/LAComp.txt"
destfile <- "./data_raw/LAComp.txt"
if(!file.exists(destfile)){
        download.file(url = url,destfile = destfile, method = "curl")
}
l <- read.csv(file = destfile, skip = 2, header = T, sep = ";")

#clean
rows.heading <- grep("Legislative", l$Legislative.Agent)
l <- l[-rows.heading, ]
l$Compensation <- gsub(",", "", l$Compensation)
l$Compensation <- gsub("\\$", "", l$Compensation)
l$Compensation <- as.numeric(as.character(l$Compensation))

#manipulate
library(dplyr)
library(magrittr)
df.Lobbyist <-
        l %>%
        group_by(Legislative.Agent) %>%
        summarise(sum = sum(Compensation)) %>%
        arrange(-sum) %>%
        slice(1:20)

#add rank column
df.Lobbyist$rank <- 20:1

#plot
library(ggplot2)
library(scales)
p <- ggplot(df.Lobbyist, aes(sum, rank))
p <- p + geom_point(colour = "blue")
p <- p + scale_y_continuous(labels = rev(df.Lobbyist$Legislative.Agent), 
                            breaks = 1:20,
                            minor_breaks = NULL
)
p <- p + ylab("")
p <- p + scale_x_continuous(labels = comma)
p <- p + xlab("")
p <- p + ggtitle("Top 20 Lobbyists by Total Revenue \n 2016")
p
filename01 <- "Top_20_Lobbyists_Tot_Revenue.jpg"
ggsave(filename = filename01, height = 5, width = 8, units = "in")

##double check Babbage
df.Babbage <-
        l %>%
        filter(Legislative.Agent == "Babbage Robert A") %>%
        group_by(Report.Period) %>%
        summarise(sum = sum(Compensation))
