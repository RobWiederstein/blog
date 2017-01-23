library("xlsx")
library("ggplot2")
j <- read.xlsx("./data_raw/DeputyJudgesKY.xlsx", sheetIndex = 1, 
               colClasses = "character", stringsAsFactors = F)
h <- c("Henderson", 65000, 44000, NA)
j <- as.data.frame(rbind(j, h), stringsAsFactors = F)
j[, 2] <- as.integer(j[, 2])
j[, 3] <- as.integer(j[, 3])
library(Hmisc)
j$pop_quartile <- as.ordered(cut2(j$Est.2014.Pop, g = 4))
levels(j$pop_quartile) <- c("Q1", "Q2", "Q3", "Q4")

#linear model
salary.1 <- lm(Salary ~ 1 + Est.2014.Pop, data = j)

#plot
file = paste(getwd(), "/plots/plot_1_deputy_judge_exec_salary.pdf", sep = "/")
pdf(file = file, width = 5, height = 5)
p <- ggplot(j, aes(reorder(County, Salary), Salary), group = pop_quartile)
p <- p + geom_point(stat = "identity", col= "red", size = 2)
#p <- p + geom_point(aes(hend$County, hend$Salary), col = "red", size = 2)
p <- p + coord_flip()
#p <- p + facet_grid(pop_quartile ~ .)
p <- p + xlab("")
p
dev.off()

#plot
file = paste(getwd(), "/plots/plot_2_deputy_judge_exec_salary.pdf", sep = "/")
pdf(file = file, width = 8, height = 5)
p <- ggplot(j, aes(Est.2014.Pop, Salary))
p <- p + geom_point()
p <- p + stat_smooth(method = "lm")
p <- p + annotate("point", x = 44000, y = 65000, col = "blue")
p <- p + ggtitle("Deputy Judge Executive Compensation and County Population")
p <- p + xlab("Population")
p
dev.off()
