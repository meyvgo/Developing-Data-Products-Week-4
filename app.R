## Include libraries
library(dplyr)

# Suppress summarise info
options(dplyr.summarise.inform = FALSE)

## Read the data from the two data files
## The data came from here: https://github.com/fivethirtyeight/data/find/master
b1<-read.csv("Data/births/US_births_1994-2003_CDC_NCHS.csv")
b2<-read.csv("Data/births/US_births_2000-2014_SSA.csv")

## Since the provided data comes in two sets, create a single data frame
## There is some overlap in the data; I used the SSA data for the overlap years
births<-b1
births<-births %>% filter(year<2000)
births<-bind_rows(births,b2)

## Figure the average births per day for the whole dataset
overall_daily_avg<-mean(births$births)

## Get the average birth per day for each month
## And the percent difference of that average from the overall daily average
avg_per_month<-births %>% 
        group_by(month) %>% 
        summarize(mean=mean(births)) %>%
        mutate(pct_dif=(mean-overall_daily_avg)/overall_daily_avg*100) 

## Add month_abbrev since we will want to use this in our monthly plot
avg_per_month$month_abbrev<-as.factor(month.abb)

## Setup dataset for daily plot
avg_per_day<-births %>%
        select(c("month","date_of_month","births")) %>%
        group_by(date_of_month, month) %>%
        mutate(mean=mean(births)) %>%
        mutate(pct_dif=(mean-avg_per_month$mean[month])/avg_per_month$mean[month]*100)

## Add month_abbrev since we will want to use this in our daily plot
avg_per_day$month_abbrev<-as.factor(month.abb[avg_per_day$month])