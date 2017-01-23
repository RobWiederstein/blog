#load
file <- paste(getwd(), "./objects/bea_pci.csv", sep = "/")    
df <- read.csv(file = file, header = T, sep = ",")
df$TimePeriod <- as.Date(strptime(df$TimePeriod, format = "%Y"), "%Y")

#plot
#Pick County by Fips code
Daviess <- 21059
Hancock <- 21091
Henderson <- 21101
McLean <- 21149
Ohio <- 21183
Union <- 21225
Webster <- 21233
GRADD_counties <- c(Daviess, Hancock, Henderson, McLean, Ohio, Union, 
                    Webster)

pdf(file = "./plots/Plot_GRADD_counties.pdf", width = 8, height = 5)
p <- ggplot(subset(df, GeoFips %in% GRADD_counties), aes(TimePeriod, DataValue, colour = County))
p <- p + geom_line()
p <- p + scale_colour_brewer(palette = "Set1")
p <- p + xlab("Year") + ylab("Dollars") + ggtitle("Per Capita Income by County in GRADD")
p
dev.off()

#table
library(xtable)
grd <- subset(df, GeoFips %in% GRADD_counties & TimePeriod == "2013-05-26", select = c("TimePeriod", "County", "Code", "DataValue"))
grd$TimePeriod <- substr(grd$TimePeriod, start = 0, stop = 4)
grd$Pct <- (round((grd$DataValue - 34958) / 34958, 3)) * 100
names(grd)[which(names(grd) == "TimePeriod")] <- "Year"
grd <- grd[rev(order(grd$Pct)), ]
grd.table <- xtable(grd)
print(grd.table, type = "html", include.rownames = F)
write.csv(grd, file = "Table_grd_counties.csv", quote = F, row.names = F)
