#plot map with choropleth package
library(choroplethr)
library(choroplethrMaps)
library(choroplethrAdmin1)

#load pci data
file <- paste(getwd(), "objects/bea_pci.csv", sep = "/")    
df <- read.csv(file = file, header = T, sep = ",", as.is = T)
df_latest_yr   <- subset(df, TimePeriod == max(df$TimePeriod))
names(df_latest_yr)[grep("GeoFips", names(df_latest_yr))] <- "region"
names(df_latest_yr)[grep("DataValue", names(df_latest_yr))] <- "value"

#plot
pdf(file = "./plots/Tristate_Per_Capita_Income_2013.pdf",
    width = 8, 
    height = 5,
    bg = "transparent"
)    
p <- county_choropleth(df_latest_yr,
                        title      = "2013 Tristate Per Capita Income",
                        legend     = "Per Capita Income",
                        num_colors = 7,
                        state_zoom = c("kentucky", "indiana", "illinois")
                       )
p
dev.off()
