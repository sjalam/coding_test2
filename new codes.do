use "C:\Users\HP\Downloads\cps_00003.dta" 
keep if age > 16

gen unemp = (empstat == 20) | (empstat == 21) | (empstat == 22)
 keep if unemp == 1 & labforce == 2
 
egen WeightedLabforce = total(wtfinl*empstat), by(month)

egen Weighted_unemp = total(wtfinl*labforce), by(month)

gen unemp_rate = (Weighted_unemp/WeightedLabforce)*100
twoway line unemp_rate month,title("Monthly Weighted Unemployment Rate") xtitle("Month") ytitle("Weighted Unemployment Rate (%)") xlabel(1(1)12) legend(off)
