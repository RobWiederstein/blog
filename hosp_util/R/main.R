#######################################
##  Kentucky Hospital Utilization
##  Rob Wiederstein
##  March 24, 2016
#######################################

source("./R/create_table_data.R")

source("./R/create_summary_data.R")

source("./R/functions.R")

#plot total number of licensed beds in Kentucky
plot_ky_tot_licensed_beds()

#plot total number of beds in operation in Kentucky
plot_ky_beds_in_operation()

#plot total number of hospital admissions in Kentucky
plot_ky_hosp_admissions()

#plot total number of inpatient days in Kentucky
#Why are data for 2003 missing??????
plot_ky_hosp_inpatient_days()

#plot total number of hospital discharges in Kentucky
plot_ky_hosp_discharges()

#plot total number of discharge days in Kentucky
plot_ky_hosp_discharge_days()
 
#plot the median of hospitals average daily census
#in Kentucky
plot_ky_hosp_avg_daily_census()

#plot the median of hospitals average length of stay
#in Kentucky
plot_ky_hosp_avg_length_of_stay()

#plot the median of hospitals occupancy percentage in
#Kentucky
plot_ky_hosp_occupancy_pct()

#plot Methodist Hospital Henderson total licensed beds
plot_methodist_tot_licensed_beds()

#plot Methodist Hospital Henderson beds in operation
plot_methodist_beds_in_operation()

#plot Methodist Hospital Henderson admissions
plot_methodist_admissions()

#plot Methodist Hospital Henderson inpatient days
plot_methodist_inpatient_days()

#plot Methodist Hospital Henderson discharges
plot_methodist_discharges()

#plot Methodist Hospital Henderson discharge days
plot_methodist_discharge_days()

#plot Methodist Hospital Henderson average daily census
plot_methodist_avg_daily_census()

#plot Methodist Hospital Henderson average length of stay
plot_methodist_avg_length_of_stay()

#plot Methodist Hospital Henderson occupancy percentage
plot_methodist_occupancy_pct()




