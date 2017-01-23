#plot map with choropleth package
library(choroplethr)
library(choroplethrMaps)
library(choroplethrAdmin1)

#load pci data
file <- paste(getwd(), "objects/bea_pci.csv", sep = "/")    
df <- read.csv(file = file, header = T, sep = ",", as.is = T)
#df$TimePeriod <- as.Date(strptime(df$TimePeriod, format = "%Y"), "%Y")
#construct pct column
pci.year.last   <- subset(df, TimePeriod == max(df$TimePeriod))
pci.year.2000  <- subset(df, TimePeriod == 2000)
pct.change <- round(((pci.year.last$DataValue - pci.year.2000$DataValue)/ 
                         pci.year.2000$DataValue) * 100, 3)
df_pct_change <- pci.year.last[, 2:5]
df_pct_change <- cbind(df_pct_change, pct.change)
names(df_pct_change)[1] <- "region"
names(df_pct_change)[5] <- "value"

#plot
pdf(file = "./plots/Tristate_Per_Capita_Income_Growth.pdf",
    width = 8, 
    height = 5,
    bg = "transparent"
)  
p1 <- county_choropleth(df_pct_change,
                  title      = "Per Capita Income Growth \n 2000-2013",
                  legend     = "Pct. Change",
                  num_colors = 7,
                  state_zoom = c("indiana", "kentucky", "illinois")
                  )
p1
dev.off()

