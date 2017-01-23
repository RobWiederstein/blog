#read in Trump data frame
trump <- read.csv("./data_tidy/ky_trump_2016.csv", header = T, stringsAsFactors = F)
paul  <- read.csv("./data_tidy/ky_paul_2016.csv", header = T, stringsAsFactors = F)

#fit linear model to Trump
fit.lm.trump <- lm(tr_pct ~ per_capita_income + pop_dens + pct_bachelor_deg + 
                     coal_2015_pct_chg + pop_2015 + pct_reg_repubs +
                     pct_reg_males + pct_65_and_older + pct_non_white, data = trump)

summary(fit.lm.trump)

#fit linear model to Paul
fit.lm.paul <- lm(paul_pct ~ per_capita_income + pop_dens + pct_bachelor_deg + 
                           coal_2015_pct_chg + pop_2015 + pct_reg_repubs +
                           pct_reg_males + pct_65_and_older + pct_non_white, data = paul)

summary(fit.lm.paul)

#plot choropleth map for paul
#plot 1--choropleth map of Trump Counties
library(choroplethr)
library(choroplethrMaps)
library(choroplethrAdmin1)
paul.1 <- dplyr::select(paul, paul_pct, region)
names(paul.1)[1] <- "value"
pdf(file = "./plots/ky_paul_2016.pdf",
    width = 8, 
    height = 5,
    bg = "transparent"
)  
p1 <- county_choropleth(paul.1,
                        title      = "Pct. of Paul Voters 2016",
                        legend     = "Percent",
                        num_colors = 5,
                        state_zoom = c("kentucky")
)
p1
dev.off()

plot(trump$tr_pct, trump$fitted)
plot(paul$paul_pct, paul$fitted)
st.dev <- sd(paul$paul_pct)
mean_paul <- mean(paul$paul_pct)
plot(rnorm(120, sd = st.dev, mean = mean_paul), rnorm(120, sd = st.dev, mean = mean_paul))
plot(rnorm(120, sd = .25, mean = mean_paul), rnorm(120, sd = .25, mean = mean_paul))

library(ggplot2)
p <- ggplot(trump, aes(fitted, tr_pct))
p <- p + geom_point(colour = "blue3")
p <- p + scale_x_continuous(limits = c(35, 90))
p <- p + scale_y_continuous(limits = c(35, 90))
p <- p + xlab("fitted values") + ylab("trump pct.")
p <- p + ggtitle("Trump's Actual Values to Fitted Values")
p <- p + annotate("text", x = 80.1, y = 50.1, label = "adj. R sq. = .7885")
p <- p + annotate("text", x = 80.1, y = 48.1, label = "p-value = 2.2e-16")
p <- p + theme(plot.title = element_text(hjust = 0.5))
p

q <- ggplot(paul, aes(fitted, paul_pct))
q <- q + geom_point(colour = "blue3")
q <- q + scale_x_continuous(limits = c(35, 90))
q <- q + scale_y_continuous(limits = c(35, 90))
q <- q + xlab("fitted values") + ylab("paul pct.")
q <- q + ggtitle("Paul's Actual Values to Fitted Values")
q <- q + annotate("text", x = 80.1, y = 50.1, label = "adj. R sq. = .5501")
q <- q + annotate("text", x = 80.1, y = 48.1, label = "p-value = 2.2e-16")
q <- q + theme(plot.title = element_text(hjust = 0.5))
q
pdf("./plots/model_comparisons.pdf", width = 8, height = 5)
grid.arrange(q, p, ncol = 2)
dev.off()


df <- data.frame(cbind(paul$County, paul$paul_pct, trump$tr_pct), stringsAsFactors = F)
names(df)[1:3] <- c("County", "paul_pct", "tr_pct")
df[, 2:3] <- sapply(df[, 2:3], as.numeric)
df <- tidyr::gather(df, key = "variable", value = "value", -County)

pdf("./plots/trump_paul_win_comparisons.pdf", width = 5, height = 5)
r <- ggplot(df, aes(factor(variable, labels = c("Paul", "Trump")), value))
r <- r + geom_boxplot(color = "blue3")
r <- r + xlab("")
r <- r + ylab("pct. voters")
r <- r + ggtitle("Paul and Trump Victories Compared")
r <- r + theme(plot.title = element_text(hjust = 0.5))
r
dev.off()
