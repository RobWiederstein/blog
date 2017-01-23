require("XLConnect")
filename <- "./data_raw/staddcoest_2015_fyasrh.xls"
wb <- loadWorkbook(filename = filename, create = TRUE)
df1 <- readWorksheet(wb, sheet = "Adair", region = "I3:N5")

counties <- c("Adair, Allen, Anderson, Ballard, Barren, Bath, Bell, Boone, Bourbon, Boyd, Boyle, 
Bracken, Breathitt, Breckinridge, Bullitt, Butler, Caldwell, Calloway, Campbell, Carlisle, Carroll, 
Carter, Casey, Christian, Clark, Clay, Clinton, Crittenden, Cumberland, Daviess, Edmonson, Elliott, 
Estill, Fayette, Fleming, Floyd, Franklin, Fulton, Gallatin, Garrard, Grant, Graves, Grayson, 
Green, Greenup, Hancock, Hardin, Harlan, Harrison, Hart, Henderson, Henry, Hickman, Hopkins, 
Jackson, Jefferson, Jessamine, Johnson, Kenton, Knott, Knox, Larue, Laurel, Lawrence, Lee, Leslie, 
Letcher, Lewis, Lincoln, Livingston, Logan, Lyon, McCracken, McCreary, McLean, Madison, Magoffin, 
Marion, Marshall, Martin, Mason, Meade, Menifee, Mercer, Metcalfe, Monroe, Montgomery, Morgan, 
Muhlenberg, Nelson, Nicholas, Ohio, Oldham, Owen, Owsley, Pendleton, Perry, Pike, Powell, Pulaski, 
Robertson, Rockcastle, Rowan, Russell, Scott, Shelby, Simpson, Spencer, Taylor, Todd, Trigg, 
Trimble, Union, Warren, Washington, Wayne, Webster, Whitley, Wolfe, Woodford")

counties <- as.vector(str_split(counties, pattern = ", ", simplify = T))
counties <- gsub("\n", "", counties)
#read in data
df <- NULL
for (i in 1:length(counties)){
        a <- readWorksheet(wb, sheet = counties[i], region = "I3:N5")
        df <- rbind(df, a)
        
}
#lose blank row
df <- df[-which(is.na(df$Total)  == T), ]
#add county names
df <- cbind(counties, df)
#clean variable names
names(df) <- gsub("\\.", "", names(df))
names(df)[1] <- "County"
names(df) <- tolower(names(df))
#new variable--"pct_non_white"
df$pct_non_white <- round(((df$total - df$white) / df$total) * 100, 4)
#write it out
write.csv(df, file = "race.csv", row.names = F)


