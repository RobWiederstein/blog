#libraries
library(reshape2)
library(ggplot2)

#load
url <- "http://kaiserhealthnews.files.wordpress.com/2014/10/readmissions-year-3.csv"
destfile <- paste(getwd(), "readmissions.csv", sep = "/")
#download.file(url = url, destfile = destfile)
r <- read.csv("readmissions.csv", header = T, sep = ",", skip = 5)

#rename variables
names(r)[1]  <- "id"
names(r)[2]  <- "name"
names(r)[3]  <- "address"
names(r)[4]  <- "city"
names(r)[5]  <- "state"
names(r)[6]  <- "zip"
names(r)[7]  <- "county"
names(r)[8]  <- "2013"
names(r)[9]  <- "2014"
names(r)[10] <- "2015"

#clean
r[, 8]  <- gsub("%", "", r[, 8])
r[, 9]  <- gsub("%", "", r[, 9])
r[, 10] <- gsub("%", "", r[, 10])
r[, c(8:10)] <- apply(r[, c(8:10)], 2, as.numeric)
r <- r[, -11]

#check data
summary(r)

#wide to long
 r <- melt (r, id = c("id", "name", "address", "city", "state", "zip", "county"))
names(r)[8] <- "year"
names(r)[grep("value", names(r))] <- "penalty"

#rm NA
r <- r[which(complete.cases(r)== T), ]

#methodist
r[r$zip == "42420", ]
ky <- r[r$state == "KY" & r$year == 2015, ]
ky <- ky[rev(order(ky$penalty, ky$name)), ]

#plot
p <- ggplot(r[r$year == 2015, ])
p <- p + geom_histogram(aes(penalty))
p <- p + annotate("point", x = 2.25, y = 40, colour = "#3333FF", size = 3 )
p <- p + xlab("percent")
p <- p + ylim(0, 1250)
p <- p + ggtitle("2015 Readmission Penalty
                  (3379-Hospitals)")
p <- p + annotate("text", x = 2.25, y = 100, label = "Methodist", colour = "#3333FF", size = 3)
p <- p + annotate("point", x = 1.15, y = 100, colour = "#3333FF", size = 3)
p <- p + annotate("text", x = 1.14, y = 160, label = "St. Mary's", colour = "#3333FF", size = 3)
p <- p + annotate("point", x = .35, y = 250, colour = "#3333FF", size = 3)
p <- p + annotate("text", x = .55, y = 330, label = "Deaconess", size = 3, colour = "#3333FF")
p <- p + annotate("point", x = .05, y = 1170, colour = "#3333FF", size = 3)
p <- p + annotate("text", x = .05, y = 1225, label = "O'boro", colour = "#3333FF", size = 3)
p

file <- paste(getwd(), "readmission.png", sep = "/")
file

ggsave(filename = file,
       path = NULL, scale = 1,
       width = 6,
       height = 4,
       units = c("in"),
       dpi = 300,
       limitsize = TRUE
)

png(filename = file,
    width = 800,
    height = 600,
    units = "px",
    res = 300,
    )
plot(p)
dev.off()
