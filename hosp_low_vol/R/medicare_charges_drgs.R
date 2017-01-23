#libraries
library(magrittr)
library(dplyr)
library(ggplot2)

#read in file
file <- list.files(path = "./data_raw", pattern = "csv", full.names = T)
df <- read.csv(file = file, header = T, stringsAsFactors = F)

#break out DRG code
df$DRG <- substr(df$DRG.Definition, 1, 3)

#remove commas from Total Discharge variable and convert to integer
df$Total.Discharges <- as.integer(gsub(",", "", df$Total.Discharges))

my_drgs <- c("871")
df.1 <-
        df %>%
        filter(Provider.State == "KY") %>%
        filter(Provider.City %in% c("OWENSBORO", "HENDERSON"))

p <- ggplot(df.1, aes(Average.Covered.Charges, 
                      Average.Total.Payments, 
                      group = Provider.Name,
                      colour = Provider.Name))
p <- p + geom_point()
p <- p + ggtitle("DRG FY2014")
#p <- p + guides(colour = FALSE)
p
df.2 <- df %>%
        filter(Provider.State == "IN") %>%
        filter(Provider.City == "EVANSVILLE")

p <- ggplot(df.2, aes(Average.Covered.Charges, 
                      Average.Total.Payments, 
                      group = Provider.Name,
                      colour = Provider.Name))
p <- p + geom_point()
p <- p + ggtitle("DRG FY2014")
#p <- p + guides(colour = FALSE)
p

df.3 <-
        df %>%
        filter(Provider.State %in% c("IN", "KY")) %>%
        filter(Provider.City %in% c("EVANSVILLE", "HENDERSON", "OWENSBORO"))

p <- ggplot(df.3, aes(Average.Covered.Charges, 
                      Average.Total.Payments, 
                      group = Provider.Name,
                      colour = Provider.Name))
p <- p + geom_point()
p <- p + ggtitle("DRGs FY2014")
p <- p + ylim(0, 60000) + xlim(0, 165000)
p <- p + theme(plot.title=element_text(hjust=0.5))

#p <- p + guides(colour = FALSE)
p
file <- "./plots/DRGs_FY2014.pdf"
ggsave(filename = file, width = 8, height = 5, unit = "in")

df.4 <- df %>%
        filter(Provider.State %in% c("IN", "KY")) %>%
        filter(Provider.City %in% c("EVANSVILLE", "HENDERSON", "OWENSBORO")) %>%
        filter(DRG %in% c("469", "470"))

p <- ggplot(df.4, aes(Average.Covered.Charges, 
                      Average.Total.Payments, 
                      group = Provider.Name,
                      colour = Provider.Name))
p <- p + geom_point()
p <- p + ggtitle("DRGs FY2014")
p <- p + ylim(0, 60000) + xlim(0, 165000)
p <- p + theme(plot.title=element_text(hjust=0.5))

#p <- p + guides(colour = FALSE)
p
df.5 <- 
        df %>%
        filter(Provider.Zip.Code == "42420") %>%
        arrange(-Average.Total.Payments)
df.5$DRG <- as.integer(df.5$DRG)
df.5$rank <- nrow(df.5):1

p <- ggplot(df.5, aes(rank, Average.Total.Payments))
p <- p + geom_point()
p <- p + geom_text(data = df.5, aes(rank, Average.Total.Payments, 
                                    label = DRG, 
                                    angle = 90, 
                                    hjust = -1),
                                    size = 2.5)
p <- p + scale_x_continuous(breaks = 1:36,
                            labels = df.5$rank)
p <- p + scale_y_continuous(limits = c(0, 17500))
p <- p + ggtitle("Methodist Hospital's Avg. Total Medicare Payment by DRG \n 2014")
p <- p + theme(plot.title=element_text(hjust=0.5))
p
file <- "./plots/Methodist_Avg_Tot_Medicare_Pmt_by_DRG.pdf"
ggsave(filename = file, width = 8, height = 5, unit = "in")

