library(ggplot2)
library(Amelia)
library(scales)
library(RColorBrewer)
library(dplyr)
library(tidyr)

#read file in
file <- "./data_tidy/2016_readmission_penalties_all_hosp_five_years.csv"
df <- read.csv(file = file, header = T, stringsAsFactors = F)

#dataframe of Kentucky Hospitals
df.ky <-
        df %>%
        filter(State == "KY")
#dataframe of Methodist Hospital
df.meth <- df.ky %>% filter(Hospital.Name == "METHODIST HOSPITAL")
#dataframe of Owensboro Health Regional Hospital
df.obor <- df.ky %>% filter(Hospital.Name == "OWENSBORO HEALTH REGIONAL HOSPITAL")
#dataframe with both Hospitals
df.both <- rbind(df.meth, df.obor)
#shorten names
df.both$Hospital.Name[grep("METHODIST", df.both$Hospital.Name)] <- "Methodist"
df.both$Hospital.Name[grep("OWENSBORO", df.both$Hospital.Name)] <- "Owenboro"

####Plot
p <- ggplot(df.ky, aes(year, value, group = year))
p <- p + geom_boxplot(colour = "gray41")
p
# #plot Methodist line with points
# p <- p + geom_line(data = df.meth, aes(year, value, group = Hospital.Name), colour = "blue3", size = 1)
# p <- p + geom_point(data = df.meth, aes(year, value), colour = "blue3", size = 2)
# #plot Owenboro line with points
# p <- p + geom_line(data = df.obor, aes(year, value, group = Hospital.Name), colour = "red", size = 1)
# p <- p + geom_point(data = df.obor, aes(year, value), colour = "red", size = 2)
# #
p <- p + geom_line(data = df.both, aes(year, value, group = Hospital.Name, colour = Hospital.Name))
p
p <- p + geom_point(data = df.both, aes(year, value, group = Hospital.Name, colour = Hospital.Name), size = 2)
p
#scales
p <- p + scale_y_continuous(name = "",
                            breaks = c(0:3),
                            labels = c(paste(0:3, "%", sep = "")))
p <- p + scale_x_continuous(name = "")
p
#annotations
#p <- p + annotate("text", x = 2013, y = 1.2, label = "Methodist", colour = "blue3", size = 2.5)
#title
p <- p + ggtitle("Kentucky Medicare Readmission Penalties By Hospital \n 2013 - 2017")
p <- p + theme(plot.title=element_text(hjust=0.5))
p
#customize the color
p <- p + scale_color_brewer(palette = "Set1")
p
#save plot
filename <- "./plots/Ky_Medicare_Readmit_Penalty_by_Hosp_2013_2017.jpg"
ggsave(filename = filename, width = 8, height = 5, unit = "in")

#save facebook plot
filename <- "./plots/Ky_Medicare_Readmit_Penalty_by_Hosp_2013_2017_fb.jpg"
ggsave(filename = filename, width = 6, height = 3.15, unit = "in")
rm(list = ls())





