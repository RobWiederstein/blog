#Making Sense of Trump's Election Results in Kentucky
#The War on Coal and Its Impact on the 2016 Presidential Race in Kentucky
#The Kentucky Trump-nami of 2016

The above three posts were composed using the same project folder. Many data sources were used.  The analysis can be recreated by running the scripts in the "R" subdirectory of `trump_ky`.  The different articles were wonky enough without digressing into the model fitting aspects of it.  While the different models were alluded to, they were not discussed except to mention that the lasso model was a better fit.

A total of nine [models](https://github.com/RobWiederstein/blog/blob/master/trump_ky/plots/model_results.pdf) were attempted with lasso and linear models being ranked first and second in root mean squared error ("rmse") and adjusted r-squared.  Here, the plots involving model fit and variable importance are included for greater understanding of the data and the apparent contradiction between the [lasso](https://github.com/RobWiederstein/blog/blob/master/trump_ky/plots/var_imp_lasso.pdf) and [linear model](https://github.com/RobWiederstein/blog/blob/master/trump_ky/plots/var_imp_lm.pdf) on variable importance.
