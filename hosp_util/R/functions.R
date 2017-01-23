get_data <- function(){
        file <- "./data_tidy/kyhut1all.csv"
        read.csv(file = file, 
                 header = T,
                 as.is = T)
}

get_table <- function(health_metric){
        file <- "./tables/kyhut1_summary.csv"
        h <- read.csv(file = file,
                       header = T,
                        as.is = T)
        h[h$variable == health_metric, ]
}

###################Kentucky############

plot_ky_tot_licensed_beds <- function(){
        a <- get_table("tot_licensed_beds")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = sum))
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Tot. Licensed Beds"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("beds")
        p
        ggsave("./charts/Ky_Hosp_Tot_Licensed_Beds.pdf",
               width = 8, height = 5, units = c("in"))
}

plot_ky_beds_in_operation <- function(){
        a <- get_table("beds_in_operation")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = sum))
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Beds in Operation"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("beds")
        p
        ggsave("./charts/Ky_Hosp_Beds_in_Operation.pdf",
               width = 8, height = 5, units = c("in"))
}

plot_ky_hosp_admissions <- function(){
        a <- get_table("admissions")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = sum))
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Admissions"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("admissions")
        p
        ggsave("./charts/Ky_Hosp_Admissions.pdf",
               width = 8, height = 5, units = c("in"))
}

plot_ky_hosp_inpatient_days <- function(){
        a <- get_table("inpatient_days")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = sum))
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Inpatient Days"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("days")
        p
        ggsave("./charts/Ky_Hosp_Inpatient_Days.pdf",
               width = 8, height = 5, units = c("in"))
}
        
plot_ky_hosp_discharges <- function(){
        a <- get_table("discharges")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = sum))
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Discharges"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("discharges")
        p
        ggsave("./charts/Ky_Hosp_Discharges.pdf",
               width = 8, height = 5, units = c("in")
               )
}

plot_ky_hosp_discharge_days <- function(){
        a <- get_table("discharge_days")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = sum))
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Discharge Days"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("days")
        p
        ggsave("./charts/Ky_Hosp_Discharge_Days.pdf",
               width = 8, height = 5, units = c("in")
        )
}

plot_ky_hosp_avg_daily_census <- function(){
        a <- get_table("avg_daily_census")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = median))
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Avg. Daily Census"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("patients")
        p
        ggsave("./charts/Ky_Hosp_Avg_Daily_Census.pdf",
               width = 8, height = 5, units = c("in")
        )
}

plot_ky_hosp_avg_length_of_stay <- function(){
        a <- get_table("avg_length_of_stay")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = median)) #median
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Avg. Length of Stay"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("days")
        p
        ggsave("./charts/Ky_Hosp_Avg_Length_of_Stay.pdf",
               width = 8, height = 5, units = c("in")
        )
}

plot_ky_hosp_occupancy_pct <- function(){
        a <- get_table("occupancy_pct")
        library(ggplot2)
        library(scales)
        p <- ggplot(a, aes(x = year, y = median)) #median
        p <- p + geom_line()
        p <- p + ggtitle(paste("Kentucky Hospitals Occupancy Percent"))
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("pct")
        p
        ggsave("./charts/Ky_Hosp_Occupancy_Pct.pdf",
               width = 8, height = 5, units = c("in")
        )
}

###################Methodist###########

plot_methodist_tot_licensed_beds <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                               a$variable == "tot_licensed_beds",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("beds")
        p <- p + ggtitle("Methodist Hospital Tot. Licensed Beds")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p
        ggsave("./charts/Methodist_Tot_Licensed_Beds.pdf", width = 8, height = 5,
               units = c("in"))
}

plot_methodist_beds_in_operation <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                               a$variable == "beds_in_operation",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("beds")
        p <- p + ggtitle("Methodist Hospital Beds in Operation")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p
        ggsave("./charts/Methodist_Beds_in_Operation.pdf", width = 8, height = 5,
               units = c("in"))
}

plot_methodist_admissions <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                               a$variable == "admissions",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("admissions")
        p <- p + ggtitle("Methodist Hospital Admissions")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p
        ggsave("./charts/Methodist_Admissions.pdf", width = 8, height = 5,
               units = c("in"))
}

plot_methodist_inpatient_days <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                               a$variable == "inpatient_days",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("days")
        p <- p + ggtitle("Methodist Hospital Inpatient Days")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("days")
        p
        ggsave("./charts/Methodist_Inpatient_Days.pdf", width = 8, height = 5,
               units = c("in"))
}

plot_methodist_discharges <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                               a$variable == "discharges",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("discharges")
        p <- p + ggtitle("Methodist Hospital Discharges")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("discharges")
        p
        ggsave("./charts/Methodist_Discharges.pdf", width = 8, height = 5,
               units = c("in"))
}

plot_methodist_discharge_days <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                               a$variable == "discharge_days",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("days")
        p <- p + ggtitle("Methodist Hospital Discharge Days")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p <- p + ylab("days")
        p
        ggsave("./charts/Methodist_Discharge_Days.pdf", width = 8, height = 5,
               units = c("in"))
}

plot_methodist_avg_daily_census <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                        a$variable == "avg_daily_census",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("patients")
        p <- p + ggtitle("Methodist Hospital \n Average Daily Census")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p
        ggsave("./charts/Methodist_Avg_Daily_Census.pdf", width = 8, height = 5,
               units = c("in"))
}

plot_methodist_avg_length_of_stay <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                               a$variable == "avg_length_of_stay",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("days")
        p <- p + ggtitle("Methodist Hospital \n Avg. Length of Stay")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p
        ggsave("./charts/Methodist_Avg_Length_of_Stay.pdf", width = 8, height = 5,
               units = c("in"))
}

plot_methodist_occupancy_pct <- function(){
        a <- get_data()
        library(ggplot2)
        library(scales)
        methodist <- a[a$hospital == "methodist hospital" &
                               a$variable == "occupancy_pct",
                       ]
        p <- ggplot(methodist, aes(x = year, y = value))
        p <- p + geom_line()
        p <- p + ylab("percent")
        p <- p + ggtitle("Methodist Hospital \n Occupancy Percent")
        p <- p + scale_x_continuous(breaks = c(2000, 2005, 2010, 2015),
                                    minor_breaks = 2000:2015,
                                    limits = c(2000, 2015)
        )
        p
        ggsave("./charts/Methodist_Occupancy_Percent.pdf", width = 8, height = 5,
               units = c("in"))
}