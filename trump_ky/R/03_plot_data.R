df <- read.csv("./data_tidy/ky_trump_2016.csv", header = T, stringsAsFactors = F)

#fit.lm
fit.lm <- lm(tr_pct ~ per_capita_income + pop_dens + pct_bachelor_deg + 
                     coal_2015_pct_chg + pop_2015 + pct_reg_repubs +
                     pct_reg_males + pct_65_and_older + pct_non_white, data = df)

summary(fit.lm)



#plot 1--choropleth map of Trump Counties
library(choroplethr)
library(choroplethrMaps)
library(choroplethrAdmin1)
df.1 <- dplyr::select(df, tr_pct, region)
names(df.1)[1] <- "value"
pdf(file = "./plots/ky_trump_2016.pdf",
    width = 8, 
    height = 5,
    bg = "transparent"
)  
p1 <- county_choropleth(df.1,
                        title      = "Pct. of Trump Voters 2016",
                        legend     = "Percent",
                        num_colors = 5,
                        state_zoom = c("kentucky")
)
p1
dev.off()

rm(p1, df.1)


#plot 2
library(plotly)
y <- list(title = "pct")
x <- list(title = "dollars")
p <- plot_ly(df, x = ~per_capita_income, y = ~tr_pct, type = "scatter",
             #color = ~senate_dist,
             colors = "Set2",
             mode = "markers",
             marker = list(size = ~pct_bachelor_deg),
             hoverinfo = "text",
             text = ~paste("County: ", County,
                           "<br>Trump_Pct: ", tr_pct,
                           '<br>PCI: ', per_capita_income,
                           "<br>Bch: ", pct_bachelor_deg,
                           "</br>Pop: ", pop_2015)
             
             
) %>%
        layout(title = "Trump Voters to Per Capita Income by County",
               yaxis = y,
               xaxis = x)

p
#plotly_POST(p, filename = "annual_ky_coal_prod_1970_2015")

#random--no association
set.seed(7)
x <- rnorm(120, mean = mean(df$fitted), sd = sd(df$fitted)) #fitted
y <- rnorm(120, mean = mean(df$tr_pct), sd = sd(df$tr_pct))#actual
p <- plot_ly(x = ~x, y = ~y, type = "scatter", mode = "markers") %>%
        layout(title = "Random Noise")
p
rm(x, y)


#plot 3 fitted to actual
y <- list(title = "actual")
x <- list(title = "fitted")
adjusted_r <- list(
        text = "Adjusted R-squared : 0.7885",
          x = 75,
          y = 50,
          showarrow = FALSE

)
p_value <- list (
        text = "p-value : 2.2e-16",
        x = 75, 
        y = 48,
        showarrow = FALSE

)
perfect <- list(
        x = 40:100,
        y = 40:100,
        
)
p <- plot_ly(df, x = ~fitted, y = ~tr_pct, type = "scatter",
             mode = "markers",
             hoverinfo = "text",
             text = ~paste("County: ", County,
                           "<br>Trump_Pct: ", tr_pct,
                           '<br>Model: ', fitted)
)%>%
        layout(title = "Actual vs. Fitted Values") %>%
        layout(xaxis = x, yaxis = y) %>%
        layout(annotations = p_value) %>%
        layout(annotations = adjusted_r)

p

#plotly_POST(p, filename = "./election_2016/actual_v_fitted_values")

#plot 4 order residuals based on  error
df.1 <- df[order(df$resids), ]
x <- list(title = "Number of Counties")
y <- list(title = "pct error")
p <- plot_ly(df.1, x = 1:120, y = ~resids, type = "scatter",
             mode = "markers",
             hoverinfo = "text",
             text = ~paste("County: ", County,
                           "<br>Trump_Pct: ", tr_pct,
                           '<br>Model: ', round(fitted, 4),
                           "<br>Error: ", round(resids,4),
                           "<br>Tot_votes: ", tot_votes)
)%>%
        layout(title = "Kentucky Counties Ordered by Model Error") %>%
        layout(xaxis = x, yaxis = y)
p

#plotly_POST(p, filename = "./election_2016/kentucky_counties_ordered_by_model_error")

#plot 5--add line two deviations from mean of 0
library(plotly)
y <- list(title = "pct error")
x <- list(title = "votes")
sd_minus_2 <- list(
        x = 300000,
        y = -(2 * sd(df$resids) - .5),
        text = "Std. dev. = 2",
        font = list(color = "grey", size = 10),
        color = "gray",
        showarrow = FALSE
)
sd_plus_2 <- list(
        x = 300000,
        y = (2 * sd(df$resids) - .5),
        text = "Std. dev = 2",
        font = list(color = "grey", size = 10),
        color = "gray",
        showarrow = FALSE
)
p <- plot_ly(df, x = ~tot_votes, y = ~resids, type = "scatter",
             mode = "markers",
             hoverinfo = "text",
             text = ~paste("County: ", County,
                           "<br>Trump_Pct: ", tr_pct,
                           '<br>Model: ', round(fitted, 4),
                           "<br>Error: ", round(resids,4),
                           "<br>Tot_Votes: ", tot_votes),
             showlegend = FALSE)%>%
        add_trace(y = (2*sd(df$resids)), 
                  mode = "lines", 
                  line = list(color ="gray", 
                              width = 1)) %>%
        add_trace(y = -(2*sd(df$resids)), 
                  mode = "lines", 
                  line = list(color = "gray",
                              width = 1)) %>%
        layout(title = "Model Error by Percent and Total Votes Cast",
               yaxis = y,
               xaxis = x) %>%
        layout(annotations = sd_minus_2) %>%
        layout(annotations = sd_plus_2)
p
#plotly_POST(p, filename = "./election_2016/model_error_by_votes_cast")

#plot--choropleth map of model error
library(ggplot2)
library(choroplethr)
library(choroplethrMaps)
library(choroplethrAdmin1)
outliers <- c("Martin", "Harlan", "Carlisle", "Hancock", "Marion",
             "Franklin", "Rowan", "Graves")
library(magrittr)
library(dplyr)
library(xtable)
a <- df %>%
        filter(df$County %in% outliers) %>%
        select(County, resids) %>%
        arrange(-resids)
print(xtable(a), type = "html")
write.csv(a, file = "./tables/model_error_by_county.csv",
          row.names = F)

df$resids_1 <- df$resids
df$resids_1[-which(df$County %in% outliers)] <- 0
df$resids_1[which(df$resids_1 < 0)] <- -1
df$resids_1[which(df$resids_1 > 0)] <- 1

df.1 <- dplyr::select(df, resids_1, region)
names(df.1)[1] <- "value"

pdf(file = "./plots/model_error_2016.pdf",
    width = 8, 
    height = 5,
    bg = "transparent"
)  
p1 <- county_choropleth(df.1,
                        title      = "Extreme Model Error 2016 Presidential Race",
                        legend     = "Percent",
                        num_colors = 1,
                        state_zoom = c("kentucky")
                        #legend = "Pct"
)
p1
dev.off()

rm(list = ls())