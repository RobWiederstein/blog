setwd("~/Dropbox/R-projects/hend_co_teacher_wages/")
require(gdata)
#gleaner--Henderson County Schools Total Salaries
date <- paste(2004:2015, "01", "01", sep = "-")
index <- c(seq(from = 100, to = 135.5, by = 3.55),(3.55 + 135.5))
hcstot <- as.data.frame(cbind(date,index), stringsAsFactors = F)
hcstot$index <- as.numeric(hcstot$index)
hcstot$date <- strptime(hcstot$date, "%Y-%m-%d")
hcstot$var <- "hcstot"

##Gleaner --Henderson County Schools Average Salaries (hcsas)
#In 2004, 1,034 personnel with an annual payroll of $29,464,839. Avg Salary = 28495.98
#In 2014, 1,188 personnel with an annual payroll of $39,929,850. Avg Salary =  33610.98
date <- paste(2004:2015, "01", "01", sep = "-")
avg.salary.2004 <- 28495.98
avg.salary.2010 <- 33610.98
time.period <- length(2004:2010)
annual.pct.inc <- (((avg.salary.2010 - avg.salary.2004) / avg.salary.2004) / time.period) * 100
index <- seq(from = 100, by = annual.pct.inc, length.out = length(2004:2015))
hcsas <- as.data.frame(cbind(date,index), stringsAsFactors = F)
hcsas$index <- as.numeric(hcsas$index)
hcsas$date <- strptime(hcsas$date, "%Y-%m-%d")
hcsas$var <- "hcsas"

#Employment Cost Index: Wages & Salaries: Private Industry Workers, Index: December 2005=100, Quarterly, Seasonally Adjusted
file <- paste(getwd(), "fredgraph-5.xls", sep = "/")
eciwag <- read.xls(xls = file, as.is = T)
eciwag <- eciwag[9: nrow(eciwag), ]
names(eciwag) <- c("date", "index")
eciwag$date <- strptime(eciwag$date, "%Y-%m-%d")
eciwag$index <- as.numeric(eciwag$index)
eciwag <- eciwag[format.Date(eciwag$date, "%m") == "01", ]
years <- as.character(2004: 2015)
eciwag <- eciwag[format.Date(eciwag$date, "%Y") %in% years, ]

#compute new index
eciwag$index_rev <- c(100, rep(NA, 11))
diff <- eciwag$index[2:nrow(eciwag)] - eciwag$index[1]
base <- 100
eciwag$index_rev[2: nrow(eciwag)] <- round((diff/base * 100) + 100, 1)
eciwag$var <- "eciwag"
eciwag <- eciwag[, c(1, 3, 4)]
names(eciwag)[2] <- "index"


#Total compensation for State and local government workers in Education services, 
#Index: December 2005=100, Quarterly, Not Seasonally Adjusted
file <- paste(getwd(), "fredgraph-4.xls", sep = "/")
tcslge <- read.xls(xls = file, as.is = T)
tcslge <- tcslge[9: nrow(tcslge), ]
names(tcslge) <- c("date", "index")
tcslge$date <- strptime(tcslge$date, "%Y-%m-%d")
tcslge$index <- as.numeric(tcslge$index)
tcslge <- tcslge[format.Date(tcslge$date, "%m") == "01", ]
years <- as.character(2004: 2015)
tcslge <- tcslge[format.Date(tcslge$date, "%Y") %in% years, ]


#compute new index
tcslge$index_rev <- c(100, rep(NA, 11))
diff <- tcslge$index[2:nrow(tcslge)] - tcslge$index[1]
base <- 100
tcslge$index_rev[2: nrow(tcslge)] <- round((diff/base * 100) + 100, 1)
tcslge$var <- "tcslge"
tcslge <- tcslge[, c(1, 3, 4)]
names(tcslge)[2] <- "index"

##Wages and salaries for All Civilian workers in Elementary and secondary schools, 
#Index: December 2005=100, Quarterly, Not Seasonally Adjusted
file <- paste(getwd(), "fredgraph-3.xls", sep = "/")
wscess <- read.xls(xls = file, as.is = T)
wscess <- wscess[9: nrow(wscess), ]
names(wscess) <- c("date", "index")
wscess$date <- strptime(wscess$date, "%Y-%m-%d")
wscess$index <- as.numeric(wscess$index)
wscess <- wscess[format.Date(wscess$date, "%m") == "01", ]
years <- as.character(2004: 2015)
wscess <- wscess[format.Date(wscess$date, "%Y") %in% years, ]


#compute new index
wscess$index_rev <- c(100, rep(NA, 11))
diff <- wscess$index[2:nrow(wscess)] - wscess$index[1]
base <- 100
wscess$index_rev[2: nrow(wscess)] <- round((diff/base * 100) + 100, 1)
wscess$var <- "wscess"
wscess <- wscess[, c(1, 3, 4)]
names(wscess)[2] <- "index"

##Consumer Price Index:Total All Items for the U.S.
#Seasonally adjusted base year 2010 == 100
file <- paste(getwd(), "fredgraph-2.xls", sep = "/")
cpiall <- read.xls(xls = file, as.is = T)
cpiall <- cpiall[9: nrow(cpiall), ]
names(cpiall) <- c("date", "index")
cpiall$date <- strptime(cpiall$date, "%Y-%m-%d")
cpiall$index <- as.numeric(cpiall$index)
cpiall <- cpiall[format.Date(cpiall$date, "%m") == "01", ]
years <- as.character(2004: 2015)
cpiall <- cpiall[format.Date(cpiall$date, "%Y") %in% years, ]


#compute new index
cpiall$index_rev <- c(100, rep(NA, 11))
diff <- cpiall$index[2:nrow(cpiall)] - cpiall$index[1]
base <- cpiall$index[1] #changed base from 100
cpiall$index_rev[2: nrow(cpiall)] <- round((diff/base * 100) + 100, 1)
cpiall$var <- "cpiall"
cpiall <- cpiall[, c(1, 3, 4)]
names(cpiall)[2] <- "index"

all <- rbind(cpiall, eciwag, hcsas, hcstot, wscess, tcslge, deparse.level = 1)


##new try
require(ggplot2)
p <- ggplot(all, aes(date, index, colour = var))
p <- p + geom_line()
p <- p + ggtitle("Educational Wage Growth \n 2004-2015")
p <- p + ylab("Index 2004 = 100")
p <- p + scale_colour_discrete(name = "Benchmark")
p <- p + annotate("text", x = strptime(2010, "%Y"), y = 132, 
                  label = "Hend. Co. Tot. Annual Payroll",
                  size = 3)
p

#ggsave
ggsave(filename = "benchmarks.pdf", width = 16, height = 10, units = "cm")

