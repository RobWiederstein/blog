# Kentucky Hospital Utilization

## Data Source
This data analysis uses Kentucky's annual hospitalization reports from 1999 to 2014.  The reports are available from the Kentucky Cabinet for Health and Family Services [Data Resource Gallery](http://chfs.ky.gov/ohp/dhppd/dataresgal.htm).  The latest release was from July, 2015.  Table 1 was scraped from the pdfs with software called [Tabula](http://tabula.technology). Unfortunately, the data from 1999 could not be imported.

## Challenges
Observations are by hospital.  The data are messy with 116 hospitals reporting utilization data in 2000, but only 83 reporting in 2015.  Table one includes both psychiatric and acute care hospitals.  Very few hospitals have consistently reported the data using the same name throughout the time period examined, Methodist Hospital in Henderson, Kentucky, being one exception.  For example, the University of Kentucky Hospital reported its data under the "University of Ky Hospital" and the "University of Kentucky Hospital." A total of 198 names have been used to report the utilization data.  The names discrepancy may be due to mergers, name changes, or clerical error.  Regardless of the reason, the data is difficult to use at the hospital level due to inconsistent reporting.

## Analysis

The analysis compares trends over time between all Kentucky hospitals and Methodist Hospital in Henderson. Methodist Hospital of Union County was not included.  The variables for comparison are (1) total licensed beds, (2) beds in operation, (3) admissions, (4) inpatient days, (5) discharges, (6) discharge days, (7) average daily census, (8) average length of stay, and (9) occupancy percentage.

Using admissions as an example, total Kentucky admissions in 2000 were 568,266 and in 2014 were 538,010.  Admissions declined by approximately 5% over the time period examined.  When looking at Methodist's admissions in Henderson, they were 7,532 in 2000 and 4,343 in 2014, a reduction of 42%.  All variables indicate that Methodist Hospital's utilization declined significantly over the last 14 years.

One aside is that both Kentucky and Methodist's utilization numbers show a demonstrable decline between 2013 and 2014.  This reduction in hospital utilization could be attributed to Kentucky's adoption of risk-based managed care beginning in 2011.

## Contact

Specific questions regarding the utilization reports can be directed to Beth Morris at 502.564.9592 ext. 3156 or email at BethA.Morris@ky.gov.  Problems regarding the analysis can be opened as an [issue](https://github.com/RobWiederstein/ky_hospital_utilization/issues) on github or suggestions for improvement can be sent to me via rob@robwiederstein.org.
