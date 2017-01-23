#load libraries
library(dplyr)
library(magrittr)

#add coal production from http://energy.ky.gov/Programs/Pages/data.aspx
#"clpctp" is county coal production (Tons)
file <- "./data_raw/KY_County_Data.csv"
coal <- read.csv(file = file, header = T, stringsAsFactors = F)

#get counties from 1970 forward and arrange alphabetically
df.coal <- coal %>%
        select(county, year, clpctp) %>%
        filter(year %in% 1970:2015) %>%
        arrange(county)
#keep any county that produced coal from 1970 forward
df.coal.county <- df.coal %>%
        group_by(county) %>%
        summarize(tot = sum(clpctp, na.rm = T)) %>%
        arrange(-tot)

df.coal.county <- df.coal.county[c(1:10, 16), ]

#subset the df.coal to only counties that produced coal (49 counties total)
df.coal.producers <- df.coal %>%
        filter(county %in% df.coal.county$county)

#Plot 1
#Sys.setenv("plotly_username"="RobWiederst")
#Sys.setenv("plotly_api_key"="TteBNNic2hrhgFJZEp9j")
library(plotly)
y <- list(title = "tons")
p <- plot_ly(df.coal.producers, x = ~year, y = ~clpctp, color = ~county,
             type = "scatter", mode = "lines") %>%
        layout(title = "Ten Largest Coal Producers (and Henderson) in Kentucky by County",
               yaxis = y)
p
#plotly_POST(p, filename = "top_10_and_Henderson_ky_coal_prod")

#Plot 2
amt <- df.coal %>%
        group_by(year) %>%
        summarize(tot = sum(clpctp, na.rm = T)) %>%
        filter(year %in% 1970:2015)
amt$president <- "Obama"
amt$president[which(amt$year %in% 2001:2008)] <- "Bush II"
amt$president[which(amt$year %in% 1993:2000)] <- "Clinton"
amt$president[which(amt$year %in% 1989:1992)] <- "Bush I"
amt$president[which(amt$year %in% 1981:1988)] <- "Reagan"
amt$president[which(amt$year %in% 1977:1980)] <- "Carter"
amt$president[which(amt$year %in% 1974:1976)] <- "Ford"
amt$president[which(amt$year %in% 1970:1973)] <- "Nixon"


y <- list(title = "tons")
nixon_1 <- list(
        x = 1971,
        y = 70000000,
        xanchor = 'right',
        text = ~paste('Nixon'),
        showarrow = FALSE,
        font = list(color = "grey", size = 10),
        color = "gray",
        textangle = 90)
ford_1 <- list(
        x = 1975,
        y = 70000000,
        xanchor = 'right',
        text = ~paste('Ford'),
        showarrow = FALSE,
        font = list(color = "grey", size = 10),
        color = "gray",
        textangle = 90)
carter_1 <- list(
        x = 1978,
        y = 70000000,
        xanchor = 'right',
        text = ~paste('Carter'),
        showarrow = FALSE,
        font = list(color = "grey", size = 10),
        color = "gray",
        textangle = 90)
reagan_1 <- list(
        x = 1982,
        y = 70000000,
        xanchor = 'right',
        text = ~paste('Reagan'),
        showarrow = FALSE,
        font = list(color = "grey", size = 10),
        color = "gray",
        textangle = 90)
bushI_1 <- list(
        x = 1990,
        y = 70000000,
        xanchor = 'right',
        text = ~paste('Bush I'),
        showarrow = FALSE,
        font = list(color = "grey", size = 10),
        color = "gray",
        textangle = 90)
clinton_1 <- list(
        x = 1994,
        y = 70000000,
        xanchor = 'right',
        text = ~paste('Clinton'),
        showarrow = FALSE,
        font = list(color = "grey", size = 10),
        color = "gray",
        textangle = 90)
bushII_1 <- list(
        x = 2002,
        y = 70000000,
        xanchor = 'right',
        text = ~paste('Bush II'),
        showarrow = FALSE,
        font = list(color = "grey", size = 10),
        color = "gray",
        textangle = 90)
obama_1 <- list(
        x = 2010,
        y = 70000000,
        xanchor = 'right',
        text = ~paste('Obama'),
        showarrow = FALSE,
        font = list(color = "grey", size = 10),
        color = "gray",
        textangle = 90)



p <- plot_ly(amt, x = ~year, y = ~tot, type = "scatter", mode = "lines",
             hoverinfo = "text",
             text = ~paste("Total Coal: ", tot)) %>%
        add_trace(x = c(2009), line = list(color = "gray")) %>%
        add_trace(x = c(2001), line = list(color = "gray")) %>%
        add_trace(x = c(1993), line = list(color = "gray")) %>%
        add_trace(x = c(1989), line = list(color = "gray")) %>% 
        add_trace(x = c(1981), line = list(color = "gray")) %>%
        add_trace(x = c(1977), line = list(color = "gray")) %>%
        add_trace(x = c(1974), line = list(color = "gray")) %>%
        add_trace(x = c(1970), line = list(color = "gray")) %>%
        layout(title = "Annual Kentucky Coal Production in Tons",
               yaxis = y,
               showlegend = FALSE) %>%
        layout(annotations = obama_1) %>%
        layout(annotations = nixon_1) %>%
        layout(annotations = ford_1)  %>%
        layout(annotations = carter_1)%>%
        layout(annotations = reagan_1)%>%
        layout(annotations = bushI_1) %>%
        layout(annotations = clinton_1)%>%
        layout(annotations = bushII_1)
p

#plotly_POST(p, filename = "annual_ky_coal_prod_1970_2015")

#boxplot Trump percent to Coal Producers vs. Non-Coal Producers
df.coal.county <- df.coal %>%
        group_by(county) %>%
        filter(year == 2015) %>%
        filter(clpctp > 0) %>%
        arrange(-clpctp)
coal.prod.2015 <- df.coal.county$county

all.counties <- unique(df.coal$county)
no.coal.prod.2015 <- setdiff(all.counties, coal.prod.2015)

#load secretary of state general election results Nov 2016
file <- "./data_raw/2016_11_08_ky_general.csv"
v <- read.csv(file = file, header = T, stringsAsFactors = F)
v$total <- rowSums(v[, 2:7])
v$tr_pct <- round((v$Trump.Pence / v$total) * 100, 4)

df.coal.trump <- v %>%
        select(County, tr_pct)

df.coal.prod.2015 <- df.coal %>%
        filter(year == 2015)
df.coal.prod.2015$clpctp[which(is.na(df.coal.prod.2015$clpctp) == T)] <- 0
names(df.coal.prod.2015)[1] <- "County"
df.coal.trump <- merge(df.coal.trump, df.coal.prod.2015)
df.coal.trump$coal <- 0
df.coal.trump$coal[which(df.coal.trump$clpctp > 0)] <- 1
df.coal.trump$coal <- factor(df.coal.trump$coal, labels = c("coal", "no coal"))

#do box plot comparing trumps performance between counties with coal and counties
#without coal
df.coal.trump$coal <- factor(df.coal.trump$coal, labels = c("No Coal", "Coal"))
Sys.setenv("plotly_username"="RobWiederst")
Sys.setenv("plotly_api_key"="TIhAUdyUc11ZCcfLbxZx")
y <- list(title = "pct")
p <- plot_ly(df.coal.trump, y = ~tr_pct, color = ~coal, type = "box",
             boxpoints = "all", jitter = 0.4, colors = "Dark2",
             pointpos = -1.8
             )%>%
        layout(title = "Percent Voters for Trump in Coal Country",
               yaxis = y)
p

#plotly_POST(p, filename = "trump_coal_boxplot")

#do two-tailed t-test.  Assumption in two-tailed t-test is that the variances
#between the two groups is constant.
with(df.coal.trump, var.test(tr_pct[coal == "Coal"], tr_pct[coal == "Coal"]))
#p-value == 1.  This is greater than .05 and means that we can assume the 
#two variances are homogeneous.
with(df.coal.trump, t.test(tr_pct[coal == "Coal"], tr_pct[coal == "No Coal"]))
#reject the null hypothesis because the p-value <.05 and the difference
#in the means is statisically different.


#choropleth plot of Kentucky coal producing counties
library(choroplethr)
library(choroplethrMaps)
library(choroplethrAdmin1)
data("county.map") #choropleth pkg
x <- county.map %>%
        dplyr::filter(STATE == 21) %>%
        select(NAME, region) %>%
        distinct(NAME, region) %>%
        arrange(NAME)
df <- data.frame(cbind(x$region, df.coal.prod.2015$clpctp))
names(df)[1:2] <- c("region", "value")

        
pdf(file = "./plots/ky_coal_counties_2015.pdf",
            width = 8, 
            height = 5,
            bg = "transparent"
        )  
p1 <- county_choropleth(df,
                        title      = "Kentucky's Coal Producing Counties 2015",
                        legend     = "Tons",
                        num_colors = 1,
                        state_zoom = c("kentucky")
)
p1
dev.off()
rm(list = ls())

