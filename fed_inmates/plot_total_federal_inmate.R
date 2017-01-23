url <- "http://www.bop.gov/about/statistics/raw_stats/BOP_pastPopulationTotals.csv"
download.file(url = url, destfile = "bop_tot_inmates.csv")
feds <- read.csv("bop_tot_inmates.csv", stringsAsFactors = F)
feds$Total.Population <- gsub(",", "", feds$Total.Population)
feds$Total.Population <- as.integer(feds$Total.Population)


#plot
library(ggplot2)
library(scales)
file = paste(getwd(), "Plot_total_federal_inmate.pdf", sep = "/")
pdf(file = file, width = 8, height = 5)
p <- ggplot(feds, aes(FY, Total.Population))
p <- p + geom_line(colour = "#2a7ae2")
p <- p + xlab("Year") + ylab("Inmates")
p <- p + ggtitle("Total Federal Inmate Population \n (1980 - 2014)")
p <- p + ylim(0, 230000)
p <- p + geom_hline(aes(yintercept = max(feds$Total.Population)))
p <- p + annotate("text", x = 2013, y = max(feds$Total.Population) + 5000,
                       label = comma(max(feds$Total.Population)), size = 3)
p
dev.off()
