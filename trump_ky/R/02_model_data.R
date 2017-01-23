df <- read.csv("./data_tidy/ky_trump_2016.csv", header = T, stringsAsFactors = F)

library(magrittr)
library(dplyr)
df <- df %>%
        select(tr_pct, per_capita_income, pop_dens, pop_2015, pct_bachelor_deg,
                 pct_reg_repubs, pct_reg_males, pct_65_and_older, 
               coal_2015_pct_chg, pct_non_white)


#get variable importance chart for most accurate model
# prepare training scheme
library(caret)
control <- trainControl(method="repeatedcv", number=10, repeats=3)

# CART
set.seed(7)
form <- as.formula(tr_pct ~ .)
fit.cart <- train(form = form, data = df, method="rpart", trControl=control)
# SVM
set.seed(7)
fit.svm <- train(form = form, data = df, method="svmRadial", trControl=control)
# kNN
set.seed(7)
fit.knn <- train(form = form, data = df, method="knn", trControl=control)
# Random Forest
set.seed(7)
fit.rf <- train(form = form, data = df, method="rf", trControl=control)
#gbm
set.seed(7)
fit.gbm <- train(form = form, data = df, method = "gbm", trControl = control)
#xgboost
set.seed(7)
fit.xgb <- train(form = form, data = df, method = "xgbLinear", trControl = control)
#lasso
set.seed(7)
fit.lasso <- train(form = form, data = df, method = "lasso", trControl = control)
#boruta
set.seed(7)
fit.boruta <- train(form = form, data = df, method = "Boruta", trControl = control)
#linear regression
set.seed(7)
fit.lm <- train(form = form, data = df, method = "lm", trControl = control)
# collect resamples
results <- resamples(list(CART=fit.cart, SVM=fit.svm, KNN=fit.knn, RF=fit.rf,
                          GBM = fit.gbm, XGB = fit.xgb, LAS = fit.lasso,
                          BOR = fit.boruta, LM = fit.lm)
)
a <- summary(results)

#save rmse results from modeling in table
rmse <- data.frame(a$statistics$RMSE, stringsAsFactors = F)
rmse$Models <- row.names(rmse)
rmse <- rmse[, c(8, 1:7)]
rmse <- dplyr::arrange(rmse, Mean)
write.csv(rmse, file = "./tables/model_rmse.csv", row.names = F)

#save rsquared results in table
rsquared <- data.frame(a$statistics$Rsquared, stringsAsFactors = F)
rsquared$Models <- row.names(rsquared)
rsquared <- rsquared[, c(8, 1:7)]
rsquared <- dplyr::arrange(rsquared, -Mean)
write.csv(rsquared, file ="./tables/model_rsquared.csv", row.names = F)


#plot rmse and rsquared results
p <- dotplot(results, main = "Model Outcomes in Presidential Race 2016")
pdf(file = "./plots/model_results.pdf",
    width = 8, 
    height = 5,
    bg = "transparent"
)  
p
dev.off()

#plot variable importance linear model
p01 <- plot(varImp(fit.lm, scale = F), main = "Variable Importance -- Linear Model")
pdf(file = "./plots/var_imp_lm.pdf",
    width = 8, 
    height = 5,
    bg = "transparent"
)  
p01
dev.off()

#plot variable importance lasso model
p02 <- plot(varImp(fit.lasso, scale = F), main = "Variable Importance -- Lasso Model")
p02
pdf(file = "./plots/var_imp_lasso.pdf",
    width = 8, 
    height = 5,
    bg = "transparent"
)  
p02
dev.off()








