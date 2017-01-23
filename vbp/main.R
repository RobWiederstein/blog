source("functions.R")
vpg <- import_vpg()
cert <- import_cert_num()
tps <- import_hosp_vbp_tps()


tps <- tps[, c(1:6, 16)]
tristate <- c("180038", "180056", "150100", "150149", "150082")
tri <- tps[tps$Provider.Number %in% tristate, ]

library(ggplot2)
p <- ggplot(tps, aes(Total.Performance.Score))
p <- p + geom_histogram()
p
