use "C:\Users\HP\Downloads\cps_00003.dta" 
// Loding file
log using "C:\Users\HP\Downloads\Log file2.smcl"
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
// Keeping people unemplyed code == 1 and labforce == 2 by knowing 
// them from tab command
keep if unemp == 1 & labforce == 2
// generating new variables as aggregated value of unemployed 
// and labour force
egen WeightedUnemployed = total(wtfinl*unemp), by(month)
egen TotalWeightedLaborForce = total(wtfinl*age) if labforce == 2, by(month)
// new column of unemployment rate 
gen weighted_unemp_rate = (WeightedUnemployed / TotalWeightedLaborForce) * 100
// graph...
twoway line weighted_unemp_rate month, title("Monthly Weighted Unemployment Rate") xtitle("Month") ytitle("Weighted Unemployment Rate (%)") xlabel(1(1)12) legend(off)
log close
