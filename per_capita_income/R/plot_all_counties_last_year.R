#prerequisites
library(plyr)
library(dplyr)

#load
file <- paste(getwd(), "objects/bea_pci.csv", sep = "/")    
df <- read.csv(file = file, header = T, sep = ",")
#df$TimePeriod <- as.Date(strptime(df$TimePeriod, format = "%Y"), "%Y")
df.ky <- subset(df, TimePeriod == max(df$TimePeriod) &
                State == "KY")
#plot
library(ggplot2)
library(scales)
file <- paste(getwd(), "plots/Plot_ky_counties_pci.pdf", sep = "/")
pdf(file = file, width = 10, height = 16)
p <- ggplot(df.ky, aes(reorder(County, DataValue), DataValue))
p <- p + geom_point()
p <- p + geom_point(stat = "identity", colour = "#2a7ae2", size = 2)
p <- p + geom_hline(yintercept = median(df.ky$DataValue))
#p <- p + geom_hline(yintercept = mean(df.ky$DataValue), colour = "red")
p <- p + coord_flip()
p <- p + xlab("")
p <- p + ylab("")
p <- p + scale_y_continuous(name="Dollars", labels = comma)
p <- p + ggtitle("Kentucky Counties Ordered by Per Capita Income 2013")
p
dev.off()
#