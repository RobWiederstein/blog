#load
file <- paste(getwd(), "objects/bea_pci.csv", sep = "/")    
df <- read.csv(file = file, header = T, sep = ",")
df$TimePeriod <- as.Date(strptime(df$TimePeriod, format = "%Y"), "%Y")

#plot
#Pick County by Fips code
Gibson <- 18051
Henderson <- 21101
Posey <- 18129
Vanderburgh <- 18163
Warrick <- 18173
Webster <- 21233
msa_counties <- c(Gibson, Henderson, Posey, Vanderburgh, Warrick, Webster)

file = paste(getwd(), "plots/Plot_msa_counties.pdf", sep = "/")
pdf(file = file, width = 16, height = 10)
library(ggplot2)
p <- ggplot(subset(df, GeoFips %in% msa_counties), aes(TimePeriod, DataValue, colour = County))
p <- p + geom_line()
p <- p + scale_colour_brewer(palette = "Set1")
p <- p + xlab("Year") + ylab("Dollars")
p <- p + ggtitle("Per Capita Income by County \n in Metropolitan Statistical Area")
p
dev.off()

#table
library(xtable)
msa <- subset(df, GeoFips %in% msa_counties & TimePeriod == "2013-05-26", select = c("TimePeriod", "County", "Code", "DataValue"))
msa$TimePeriod <- substr(msa$TimePeriod, start = 0, stop = 4)
msa$Pct <- (round((msa$DataValue - 34958) / 34958, 3)) * 100
names(msa)[which(names(msa) == "TimePeriod")] <- "Year"
msa <- msa[rev(order(msa$Pct)), ]
msa.table <- xtable(msa)
print(msa.table, type = "html", include.rownames = F)
file <- paste(getwd(), "tables/Table_msa_counties.csv", sep = "/")
write.csv(msa, file = file, quote = F, row.names = F)

rm(list = ls())
