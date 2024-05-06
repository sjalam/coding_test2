library(dplyr)
library(haven)
library(Hmisc)
library(ggplot2)

data= read_dta('cps_00003.dta')
str(data$age)
colnames(data)
unique(data$empstat) #20, 21, 22 means unemployed
unique(data$qage)

#Removing people below 16
data_above16= subset(data, age>16)


#Checking unemployment tag
unique(data_above16$empstat) #20,21,22,


#cross tabs
cross= table(data_above16$empstat, data_above16$labforce)
print(cross)
unique(data_above16$empstat)
table(data_above16$labforce)


#we will consider people with unemp status 20,21,22 as unemployed
#Cteating unemp column
data_above16 <- data_above16 %>%
  mutate(unemp = ifelse(empstat %in% c('20','21','22'), 1, 0))


#Now we will filter the data for unemployed people in the labour force
unemployed=  data_above16 %>% filter(unemp==1, labforce==2)


# Group the filtered data by month and calculate the weighted sum of unemployed people
result <- unemployed %>% group_by(month) %>% summarise(WeightedUnemployed= sum(wtfinl))
result

result_1= unemployed %>% group_by(month) %>% summarise(WeightedUnemployed= n())

# Calculate the weighted sum of people in the labor force
total_labor_force <- data_above16 %>% filter(labforce==2) %>% 
                     group_by(month) %>% summarise(TotalWeightedLaborForce = sum(wtfinl))

# Merge the two data frames to get the weighted unemployment rate
final <- merge(result, total_labor_force, by = 'month')

#Calculating unemployment rate
final$weighted_unemp_rate= (final$WeightedUnemployed/final$TotalWeightedLaborForce)*100

#Ploting unemp rate
  plot(final$month, final$weighted_unemp_rate, type = "b",col="blue",
       xlab = "Month", ylab = "Weighted Unemployment Rate (%)", 
       main = "Monthly Weighted Unemployment Rate")  
