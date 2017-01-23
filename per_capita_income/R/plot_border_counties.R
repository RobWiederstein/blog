require(ggplot2)
#load
file <- paste(getwd(), "objects/bea_pci.csv", sep = "/")    
df <- read.csv(file = file, header = T, sep = ",")
df$TimePeriod <- as.Date(strptime(df$TimePeriod, format = "%Y"), "%Y")

#plot
#Pick County by Fips code
Daviess <- 21059
Henderson <- 21101
McLean <- 21149
Union <- 21225
Vanderburgh <- 18163
Warrick <- 18173
Webster <- 21233
border_counties <- c(Daviess, Henderson, McLean, Union, Vanderburgh, 
                     Warrick, Webster)

pdf(file = "./plots/Plot_border_counties.pdf", width = 8, height = 5)
p <- ggplot(subset(df, GeoFips %in% border_counties), aes(TimePeriod, DataValue, colour = County))
p <- p + geom_line()
p <- p + scale_colour_brewer(palette = "Set1")
p <- p + xlab("Year") + ylab("Dollars") + ggtitle("Per Capita Income by County
                                                  (Bordering Counties)")
p
dev.off()

#table
library(xtable)
bc <- subset(df, GeoFips %in% border_counties & TimePeriod == 2013,
             select = c("TimePeriod", "County", "Code", "DataValue"))
#bc$TimePeriod <- substr(bc$TimePeriod, start = 0, stop = 4)
bc$Pct <- (round((bc$DataValue - 34958) / 34958, 3)) * 100
names(bc)[which(names(bc) == "TimePeriod")] <- "Year"
bc <- bc[rev(order(bc$Pct)), ]
bc.table <- xtable(bc)
print(bc.table, type = "html", include.rownames = F)

write.csv(bc, file = "./tables/Table_border_counties.csv", quote = F, row.names = F)


