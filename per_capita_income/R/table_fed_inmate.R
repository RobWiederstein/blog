
feds <- read.csv("ky_fed_inmates.csv", header = T, sep = ",",
                 stringsAsFactors = F)
feds$Pct..Feds <- (as.numeric(gsub("%", "", feds$Pct..Feds)))/100
names(feds) <- c("Date", "County", "Reported_Pop.", "Under_Over", "Fed_Inmates",
                 "Pct_Feds")
feds <- feds[rev(order(feds$Pct_Feds)), ]
feds <- feds[, c(1, 2, 3, 5, 6)]
feds$Rank <- (1: nrow(feds))

#table
library(xtable)
feds.table <- xtable(feds)
print(feds.table, type = "html", include.rownames = F)
write.csv(feds, file = "./table_feds.csv", quote = F, row.names = F)


