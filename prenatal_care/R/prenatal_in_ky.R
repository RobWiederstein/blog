#####################################
# Rob Wiederstein
# IN-KY Prenatal Healthcare
# May 30, 2015
# www.robwiederstein.org
 ####################################

#prerequisites
library(ggplot2)
library(RColorBrewer)

#load
path <- (getwd())
dir <- "data"
file01 <- "Births to mothers receiving early and regular prenatal care.csv"
k <- read.table(file = paste(path, dir, file01, sep = "/"), sep = ",", header = T, stringsAsFactors = F)

#clean KY
k <- subset(k, Location != "Kentucky")
k$TimeFrame <- as.Date(as.character(k$TimeFrame), "%Y")
Kentucky <- subset(k, DataFormat == "Percent")
Henderson <- subset(k, DataFormat == "Percent" & Location == "Henderson")
Daviess <- subset(k, DataFormat == "Percent" & Location == "Daviess")

#plot
pdf(file = "./plots/Plot_hend_mothers_early_reg_prenatal.pdf", width = 8, height = 5)
p <- ggplot(Kentucky, aes(TimeFrame, Data, group = Location))
p <- p + geom_line(col = "gray60")
p <- p + geom_line(data = Henderson, color = "red", size = 1)
p <- p + ggtitle("Henderson Mothers Receiving Early & Regular Prenatal Care \n (2004 - 2009)")
p <- p + ylim(.20, .90)
p
dev.off()

#plot
pdf(file = "./plots/Box_plot_ky_mothers_early_reg_prenatal.pdf", width = 8, height = 5)
p <- ggplot(Kentucky, aes(TimeFrame, Data, group = TimeFrame))
p <- p + geom_boxplot()
p <- p + geom_line(data = Henderson, aes(TimeFrame, Data, group = Location), colour = "red",
                   size = 1)
p <- p + ggtitle("Henderson Mothers Receiving Early & Regular Prenatal Care \n (2004 - 2009)")
p
dev.off()

#load IN
path <- (getwd())
dir <- "data"
file01 <- "Mothers who received first trimester prenatal care (2003 Revised Birth Certificate).csv"
i <- read.table(file = paste(path, dir, file01, sep = "/"), sep = ",", header = T, stringsAsFactors = F)

#clean
i <- subset(i, Location != "Indiana")
i$TimeFrame <- as.Date(as.character(i$TimeFrame), "%Y")
Indiana <- i
Vanderburgh <- subset(Indiana, Location == "Vanderburgh")

#plot
p <- ggplot(Indiana, aes(TimeFrame, Data, group = TimeFrame))
p <- p + geom_boxplot()
p

#plot
pdf(file = "./plots/Plot_Vanderburgh_Mothers_Prenatal_Care.pdf", width = 8, height = 5)
p <- ggplot(Indiana, aes(TimeFrame, Data, group = Location))
p <- p + geom_line(col = "gray60")
p <- p + geom_line(data = Vanderburgh, color = "red", size = 1)
p <- p + ylim(.20, .90)
p <- p + ggtitle("Vanderburgh Mothers Receiving First Trimester Prenatal Care \n (2007 - 2013)")
p
dev.off()

#side by side
pdf(file = "./plots/Plot_hend_vand.pdf", width = 12, height = 7.5)
require(gridExtra)
p1 <- ggplot(Kentucky, aes(TimeFrame, Data, group = Location))
p1 <- p1 + geom_line(col = "gray60")
p1 <- p1 + geom_line(data = Henderson, color = "red", size = 1)
p1 <- p1 + ggtitle("Kentucky Early & Regular Prenatal Care \n (2004 - 2009)")
p1 <- p1 + xlab("") + ylab("Pct.")
p1 <- p1 + annotate("text", x = as.Date(as.character(2008), "%Y"), y = .45, label = "Henderson", col = "red")
p1 <- p1 + ylim(.20, .90)
p2 <- ggplot(Indiana, aes(TimeFrame, Data, group = Location))
p2 <- p2 + geom_line(col = "gray60")
p2 <- p2 + geom_line(data = Vanderburgh, color = "red", size = 1)
p2 <- p2 + annotate("text", x = as.Date(as.character(2011), "%Y"), y = .7, label = "Vanderburgh", col = "red")
p2 <- p2 + ylim(.20, .90)
p2 <- p2 + ggtitle("Indiana First Trimester Prenatal Care \n (2007 - 2013)")
p2 <- p2 + xlab("") + ylab("Pct.")
p3 <- grid.arrange(p1, p2, ncol=2)
p3
dev.off()
file.copy(from = "./Plot_hend_vand.pdf", to = "~/Dropbox/blog/img/prenatal_health/Plot_hend_vand.pdf",
          overwrite = T)
