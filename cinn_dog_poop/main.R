#setwd
setwd("~/Dropbox/R-Projects/cinn_dog_poop-R")

#downloaded from https://data.cincinnati-oh.gov/
#Thriving-Healthy-Neighborhoods/Cincinnati-311-Non-Emergency-Service-Requests/4cjh-bm8b
#xlsx "DOG_WSTE"
file <- dir(pattern = "Cin")
library("xlsx")
dog <- read.xlsx(file = file, sheetIndex = 1)
require(ggmap)
main <- paste("Canine Fecal Dispersion in Greater Cincinnati \n", 2015, sep = " ")
#stamen
pdf(file = "dog_poop.pdf", width = 8, height = 5)
qmplot(x = LONGITUDE, 
       y = LATITUDE, 
       data = dog,     
       colour = I("blue"), 
       size = I(2), 
       darken = .3,
       source = "stamen", 
       )
dev.off()
