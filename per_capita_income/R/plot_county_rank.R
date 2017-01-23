#prerequisites
library(plyr)
library(dplyr)

#load
file <- paste(getwd(), "objects/bea_pci.csv", sep = "/")    
df <- read.csv(file = file, header = T, sep = ",")
df$TimePeriod <- as.Date(strptime(df$TimePeriod, format = "%Y"), "%Y")

#manipulate
library(dplyr)
library(plyr)
ky <- subset(df, State == "KY")
rank <- ddply(ky, .(TimePeriod), transform, Rank = round(rank(-DataValue), 0))

#plot
library(ggplot2)
file = paste(getwd(), "plots/Plot_hend_income_rank.pdf", sep = "/")
pdf(file = file, width = 8, height = 5)
hend <- subset(rank, County == "Henderson")
p <- ggplot(hend, aes(TimePeriod, Rank))
p <- p + geom_line(colour = "#2a7ae2")
p <- p + coord_cartesian(ylim = c(-5, 125))
p <- p + scale_y_reverse(breaks = c(1, 30, 60, 90, 120))
p <- p + scale_colour_brewer(palette = "Set1")
p <- p + annotate("text", x = as.Date("2013", "%Y"), y = 37, label = "31st")
p <- p + xlab("Year")
p <- p + ggtitle("Henderson Ranking in Per Capita Income in Kentucky \n (1968 - 2013)")
p <- p + annotate("text", x = as.Date("1975", "%Y"), y = 2, label = "2nd")
p <- p + geom_hline(aes(yintercept = 60), linetype = "dashed")
p <- p + annotate("text", x = as.Date("1990", "%Y"), y = 62, label = "Median", size = 3)
p
dev.off()

