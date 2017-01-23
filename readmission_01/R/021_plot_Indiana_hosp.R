#read in
file <- "./data_tidy/2016_readmission_penalties_all_hosp_five_years.csv"
df <- read.csv(file = file, header = T, stringsAsFactors = F)

#Indiana Hospitals
df.in <-
        df %>%
        filter(State == "IN")

#St. Mary's & Deaconness
df.both <- 
        df.in %>%
        filter(City == "EVANSVILLE")

#Shorten name for legend
df.both$Hospital.Name[grep("DEACONESS", df.both$Hospital.Name)] <- "Deaconess"
df.both$Hospital.Name[grep("ST MARY", df.both$Hospital.Name)]  <- "St. Mary's"

#plot Indiana readmissions penalty
p <- ggplot(df.in, aes(year, y = value, group = year))
p <- p + geom_boxplot(colour = "gray41")
p
p <- p + geom_line(data = df.both, aes(year, value, group = Hospital.Name, colour = Hospital.Name))
p <- p + geom_point(data = df.both, aes(year, value, group = Hospital.Name, colour = Hospital.Name), size = 2)
p
#scales
p <- p + scale_y_continuous(name = "",
                            breaks = c(0:3),
                            labels = c(paste(0:3, "%", sep = "")))
p <- p + scale_x_continuous(name = "")
p
#title
p <- p + ggtitle("Indiana Medicare Readmission Penalties By Hospital \n 2013 - 2017")
p <- p + theme(plot.title=element_text(hjust=0.5))
p
#customize the color
p <- p + scale_color_brewer(palette = "Set1")
p
#save the file
file <- "./plots/IN_Medicare_Readmit_Penalty_by_Hosp_2013_2017.jpg"
ggsave(p, filename = file, height = 5, width = 8, unit = "in")
