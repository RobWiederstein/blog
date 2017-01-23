#load
file <- paste(getwd(), "objects/bea_pci.csv", sep = "/")    
df <- read.csv(file = file, header = T, sep = ",")
df$TimePeriod <- as.Date(strptime(df$TimePeriod, format = "%Y"), "%Y")

#plot
library(ggplot2)
file = paste(getwd(), "plots/Plot_county_income_dist.pdf", sep = "/")
pdf(file = file, width = 16, height = 10)
library(ggplot2)
library(RColorBrewer)
dates <- as.Date(paste(seq(1970, 2010, by = 5), "01-01", sep = "-"), "%Y")
df.dates <- df[df$TimePeriod %in% dates, ]
    p <- ggplot(df.dates, aes(DataValue, fill = as.factor(substr(TimePeriod, start = 0, stop = 4))))
    p <- p + geom_density()
    p <- p + facet_grid(. ~ State)
    p <- p + guides(fill = guide_legend(title = "Year"))
    p <- p + xlab("Dollars")
    p <- p + ggtitle("Per Capita Income Distribution at the County Level \n (1970 - 2010)")
    p <- p + scale_fill_brewer(palette = "Blues")
    p
dev.off()
