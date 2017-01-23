setwd("~/Dropbox/R-Projects/ACT_Poverty")
source("mung_saipe.R")
source("mung_KDE.R")

load("mung_saipe")
load("mung_ACT")

names(act)[1] <- names(saipe)[3]
saipe$District_Name <- gsub("School District", "", saipe$District_Name)
library(gdata)
saipe$District_Name <- trim(saipe$District_Name)
setdiff(saipe$District_Name, act$District_Name)
all <- merge(act, saipe)
all <- all[, c(1, 2, 3, 10)]
all$COMPOSITE_MEAN_SCORE <- as.numeric(all$COMPOSITE_MEAN_SCORE)
y <- lm(all$COMPOSITE_MEAN_SCORE ~ all$pct)
summary(y)
plot(y)

library(ggplot2)
p <- ggplot(all, aes(COMPOSITE_MEAN_SCORE, pct))
p <- p + geom_point()
p <- p + stat_smooth()
p <- p + geom_point(x = 19.2, y = .04, colour = "red", label = "Henderson")
p

plot(density(y$residuals))
