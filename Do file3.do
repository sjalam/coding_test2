// Loding file
use "C:\Users\HP\Downloads\cps_00003.dta" 
// Deleting Children below 16 years old
keep if age > 16
// To get get to know more about employment status
// and labour force
tab empstat
tab labforce
tabulate empstat labforce
// Generating new colunm of unemployed people with code of
// employment status of 20, 21, and 22
gen unemp = (empstat == 20) | (empstat == 21) | (empstat == 22)
// generating new variables as aggregated value of unemployed 
// and labour force
egen WeightedUnemployed = total(wtfinl*unemp) if unemp == 1, by(month)
egen TotalWeightedLaborForce = total(wtfinl*age) if labforce == 2, by(month)
// new column of unemployment rate 
gen weighted_unemp_rate = (WeightedUnemployed / TotalWeightedLaborForce) * 100
// graph...
twoway line weighted_unemp_rate month, title("Monthly Weighted Unemployment Rate") xtitle("Month") ytitle("Weighted Unemployment Rate (%)") xlabel(1(1)12) legend(off)
