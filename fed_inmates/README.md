<h2>Which Kentucky Counties Are Most Vulnerable To Federal Corrections Reform?</h2>

There are two objects inserted into the page:  (1) a table of Kentucky counties housing federal inmates and (2) a chart of total federal inmates.

Beginning with the table, the data were taken from the daily inmate counts from the Kentucky Department of Corrections.  More current numbers are available [here](http://corrections.ky.gov/about/Pages/ResearchandStatistics.aspx).  Because the original document was in a pdf format, the data were input by hand into an Excel spreadsheet and saved as a csv file.  The R script converts it into an html table that was cut and pasted into a markdown document.

With regard to the chart showing the first decline in federal inmates since 1980, the data were downloaded using an Rscript from the Bureau of Prisons [webpage](https://www.bop.gov/about/statistics/).  A script relying on the "ggplot2" package generated the chart and saved it as a pdf.
