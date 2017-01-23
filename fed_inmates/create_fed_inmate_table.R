#import
feds <- read.csv("table_feds.csv", as.is = T, stringsAsFactors = F)
#format
feds$Pct_Feds <- feds$Pct_Feds * 100
#html table
library(xtable)
feds.table <- xtable(feds)
print(feds.table, type = "html")
