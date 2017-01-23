#################################################
##  Rob Wiederstein
##  Kentucky Lobbyist Employer Expenses
##  November 1, 2016
#################################################

#import data
a <- readLines(con = "http://klec.ky.gov/Reports/Reports/EmpExpNOB.txt")
a1 <- strsplit(a, split = ";")
b <- do.call(rbind.data.frame, a1)

#name variables
names(b) <- c("Industry", "Employer", "Date", "Emp_AE", "Emp_RME",
              "Emp_Exp", "LA_Comp", "Total")

#drop total
b <- dplyr::select(b, -Total)

#convert factors to numeric
b$LA_Comp <- gsub(",", "", b$LA_Comp)
b$LA_Comp <- as.numeric(as.character(b$LA_Comp))

#Emp_Exp
b$Emp_Exp <- gsub(",", "", b$Emp_Exp)
b$Emp_Exp <- as.numeric(as.character(b$Emp_Exp))

#Emp_RME
b$Emp_RME <- gsub(",", "", b$Emp_RME)
b$Emp_RME <- as.numeric(as.character(b$Emp_Exp))

#Emp_AE
b$Emp_AE <- gsub(",", "", b$Emp_RME)
b$Emp_AE <- as.numeric(as.character(b$Emp_AE))

#put in data table
library(dplyr)
library(magrittr)
library(ggplot2)
library(scales)

b <- dplyr::tbl_df(b)
b$Industry <- as.character(b$Industry)
df.Industry <-
        b %>%
        group_by(Industry) %>%
        summarise(sum = sum(Emp_AE, Emp_RME, Emp_Exp, LA_Comp)) %>%
        arrange(-sum) %>%
        slice(1:20)
df.Industry$rank <- 20:1
df.Industry[19, 1] <- "Horse Racing"
df.Industry[6, 1] <- "Pharmaceutical Issues"
#plot
p <- ggplot(df.Industry, aes(sum, rank))
p <- p + geom_point(colour = "blue")
p <- p + scale_y_continuous(labels = rev(df.Industry$Industry), 
                            breaks = 1:20,
                            minor_breaks = NULL
                            )
p <- p + ylab("")
p <- p + scale_x_continuous(labels = comma)
p <- p + xlab("")
p <- p + ggtitle("Top 20 Industries by Lobbying Expenses \n 2016")
p
filename01 <- "Top_20_Indus_Lobbying_Expenses.jpg"
ggsave(filename = filename01, height = 5, width = 8, units = "in")


df.Employer <-
        b %>%
        group_by(Employer) %>%
        summarize(sum = sum(Emp_AE, Emp_RME, Emp_Exp, LA_Comp)) %>%
        arrange(-sum) %>%
        slice(1:20)
df.Employer$rank <- 20:1

#plot
p <- ggplot(df.Employer, aes(sum, rank))
p <- p + geom_point(colour = "blue")
p <- p + scale_y_continuous(labels = rev(df.Employer$Employer), 
                            breaks = 1:20,
                            minor_breaks = NULL
)
p <- p + ylab("")
p <- p + scale_x_continuous(labels = comma)
p <- p + xlab("")
p <- p + ggtitle("Top 20 Employers by Lobbying Expenses \n 2016")
p
filename02 <-"Top_20_Empl_Lobbying_Expenses.jpg"
ggsave(filename = filename02, height = 5, width = 8, units = "in")

#healthcare
df.Healthcare <-
        b %>%
        filter(Industry == "Health Care") %>%
        group_by(Employer) %>%
        summarise(sum = sum(Emp_AE, Emp_RME, Emp_Exp, LA_Comp)) %>%
        arrange(-sum) %>%
        slice(1:20)
df.Healthcare$rank <- 20:1

#plot
p <- ggplot(df.Healthcare, aes(sum, rank))
p <- p + geom_point(colour = "blue")
p <- p + scale_y_continuous(labels = rev(df.Healthcare$Employer), 
                            breaks = 1:20,
                            minor_breaks = NULL
)
p <- p + ylab("")
p <- p + scale_x_continuous(labels = comma)
p <- p + xlab("")
p <- p + ggtitle("Top 20 Healthcare Employers by Lobbying Expenses \n 2016")
p
filename03 <-"Top_20_Healthcare_Empl_Lobbying_Expenses.jpg"
ggsave(filename = filename03, height = 5, width = 8, units = "in")

#Non-profit
df.Non_Profit <-
        b %>%
        filter(Industry == "Non Profit") %>%
        group_by(Employer) %>%
        summarise(sum = sum(Emp_AE, Emp_RME, Emp_Exp, LA_Comp)) %>%
        arrange(-sum) %>%
        slice(1:20)
df.Non_Profit$rank <- 20:1

#plot non profits
p <- ggplot(df.Non_Profit, aes(sum, rank))
p <- p + geom_point(colour = "blue")
p <- p + scale_y_continuous(labels = rev(df.Non_Profit$Employer), 
                            breaks = 1:20,
                            minor_breaks = NULL
)
p <- p + ylab("")
p <- p + scale_x_continuous(labels = comma)
p <- p + xlab("")
p <- p + ggtitle("Top 20 Non Profit Employers by Lobbying Expenses \n 2016")
p
filename04 <-"Top_20_Non_Profit_Empl_Lobbying_Expenses.jpg"
ggsave(filename = filename04, height = 5, width = 8, units = "in")

