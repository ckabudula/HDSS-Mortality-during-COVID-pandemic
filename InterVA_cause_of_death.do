
local site = "${site}"
//load insilicova results
/*
insheet using "${data}/cause_of_death/${sitename}_Insilico_CauseOfDeath.csv", comma names clear
*/
//load InterVA results

insheet using "${data}/cause_of_death/${sitename}_InterVA_CauseOfDeath.csv", comma names clear
rename id individualid
keep individualid cause1 lik1

count
merge 1:m individualid using "${data}/${sitename}_RawCensoredEpisodes_st_ready"
tab cause1 if died == 0
replace cause1 = "" if died == 0
replace lik1 = . if died == 0
drop if _merge == 2
drop _merge
replace cause1 = trim(cause1)

gen SexCode = sex 
replace SexCode = 0 if SexCode == 2

capture label drop sex_code
label define sex_code 0 "Female" 1 "Male"
label values SexCode sex_code

//age at death
gen age = int((dod-dob)/365.25)
gen AgeGroup5 = int(age/5)*5 //lower limit of 5 year age groups
//set upper age bound at 80
replace AgeGroup5 = 80  if AgeGroup5 > 80

//create 10 year age groups
recode age (0/4=0) (5/14=5) (15/24=15) (25/34=25) ///
	(35/44=35) (45/54=45) (55/64=55) (65/74=65) ///
	(75/max=75), gen(AgeGroup10)

//create standard WHO  age groups
recode age (0/4=0) (5/14=5) (15/49=15) (50/64=50) ///
	(65/max=65), gen(AgeGroup_WHO)
//different age groupings
recode age (0/4=0) (5/14=5) (15/29=15) (30/49=30) (50/64=50) ///
	(65/max=65), gen(AgeGroup2)
	
//separate adult age group
recode age (0/4=0) (5/14=5) (15/59=15) ///
	(60/max=60), gen(AgeGroup_adult)
	
gen year = year(dod)
//create time periods
recode year (2016/2017=1) (2018/2019=2)  (2020/2021=3), gen(Period)

capture label drop lbl_period
label define lbl_period 1 "2016-2017" 2 "2018-2019" 3 "2020-2021"
label values Period lbl_period

gen cod = cause1

replace cod = "Reproductive neoplasms" if trim(cod)== "Reproductive neoplasms MF"
//replace cod = "Other and unspecified NCD" if cod=="er and unspecified NCD"
replace cod = "HIV/AIDS & TB" if substr(cod,1,9) == "Pulmonary"
replace cod = "HIV/AIDS & TB" if substr(cod,1,3) == "HIV"
save "${data}/${sitename}_CoD", replace


//Top 10 causes of death
use "${data}/${sitename}_CoD", clear
keep if died == 1
gen n = 1
collapse (sum)n, by(year cod)
gen SexCode = 2
bys year: egen total_deaths = sum(n)
drop if cod == ""
bys year(n): gen rank = _n
gsort year - rank
bys year: replace rank = _n
gen percent = n/total_deaths*100
format percent %5.0f 
gen n_perc = string(n) + "(" + string(percent,"%5.0fc") + "%)"
gen cause_lbl = cod + "(" + string(percent,"%5.0fc") + "%)"
keep if rank <=10  
rename n no_of_deaths
reshape wide cod cause_lbl total_deaths no_of_deaths percent n_perc, i(rank) j(year)
save "${data}/${sitename}_top_causes_of_death_by_year", replace

//repeat for males and females
use "${data}/${sitename}_CoD", clear
keep if died == 1
gen n = 1
collapse (sum)n, by(year cod SexCode)
bys SexCode year: egen total_deaths = sum(n)
drop if cod == ""
bys SexCode year(n): gen rank = _n
gsort SexCode year - rank
bys SexCode year: replace rank = _n
gen percent = n/total_deaths*100
format percent %5.0f 
gen n_perc = string(n) + "(" + string(percent,"%5.0fc") + "%)"
gen cause_lbl = cod + "(" + string(percent,"%5.0fc") + "%)"
keep if rank <=10  
rename n no_of_deaths
reshape wide cod cause_lbl total_deaths no_of_deaths percent n_perc, i(SexCode rank) j(year)
append using "${data}/${sitename}_top_causes_of_death_by_year"
label define sex_code 0 "Female" 1 "Male" 2 "Both sexes", modify
//drop *1992 *2020
gsort -SexCode rank
save "${data}/${sitename}_top_causes_of_death_by_year", replace

*top causes by period
use "${data}/${sitename}_CoD", clear
keep if died == 1
gen n = 1
drop if !inlist(Period, 1,2,3)
collapse (sum)n, by(Period cod)
bys Period: egen total_deaths = sum(n)
gen SexCode = 2
drop if cod == ""
sort Period n
bys Period: gen rank = _n
gsort Period - rank
bys Period: replace rank = _n
gen percent = n/total_deaths*100
format percent %5.0f 
gen n_perc = string(n) + "(" + string(percent,"%5.0fc") + "%)"
gen cause_lbl = cod + "(" + string(percent,"%5.0fc") + "%)"
keep if rank <=10
rename n no_of_deaths
reshape wide cod cause_lbl total_deaths no_of_deaths percent n_perc, i(rank) j(Period)
save "${data}/${sitename}_top_causes_of_death_by_period", replace

*top causes by HIV period, males and females
use "${data}/${sitename}_CoD", clear
keep if died == 1
gen n = 1
drop if !inlist(Period, 1,2,3)
collapse (sum)n, by(Period cod SexCode)
bys SexCode Period: egen total_deaths = sum(n)
drop if cod == ""
sort SexCode Period n
bys SexCode Period: gen rank = _n
gsort SexCode Period - rank
bys SexCode Period: replace rank = _n
gen percent = n/total_deaths*100
format percent %5.0f 
gen n_perc = string(n) + "(" + string(percent,"%5.0fc") + "%)"
gen cause_lbl = cod + " (" + string(percent,"%5.0fc") + "%)"
keep if rank <=10
rename n no_of_deaths
reshape wide cod cause_lbl total_deaths no_of_deaths percent n_perc, i(SexCode rank) j(Period)
append using  "${data}/${sitename}_top_causes_of_death_by_period"
label define sex_code 0 "Female" 1 "Male" 2 "Both sexes", modify
//drop *1992 *2019 *2020
gsort -SexCode rank
save "${data}/${sitename}_top_causes_of_death_by_period", replace

*top causes by period and who age groups
use "${data}/${sitename}_CoD", clear
keep if died == 1
drop if !inlist(Period, 1,2,3)
gen n = 1
collapse (sum)n, by(Period AgeGroup_WHO cod)
bys Period AgeGroup_WHO: egen total_deaths = sum(n)
gen SexCode = 2
drop if cod == ""
sort AgeGroup_WHO Period n
bys AgeGroup_WHO Period: gen rank = _n
gsort AgeGroup_WHO Period - rank
bys AgeGroup_WHO Period: replace rank = _n
gen percent = n/total_deaths*100
format percent %5.0f 
gen n_perc = string(n) + "(" + string(percent,"%5.0fc") + "%)"
gen cause_lbl = cod + "(" + string(percent,"%5.0fc") + "%)"
keep if rank <=10
rename n no_of_deaths
reshape wide cod cause_lbl total_deaths no_of_deaths percent n_perc, i(AgeGroup_WHO rank) j(Period)
save "${data}/${sitename}_top_causes_of_death_by_period_who_age", replace

*top causes by period and who age groups, males and females
use "${data}/${sitename}_CoD", clear
keep if died == 1
drop if !inlist(Period, 1,2,3)
gen n = 1
collapse (sum)n, by(Period AgeGroup_WHO SexCode cod)
bys Period SexCode AgeGroup_WHO: egen total_deaths = sum(n)
drop if cod == ""
sort AgeGroup_WHO Period SexCode n
bys AgeGroup_WHO Period SexCode: gen rank = _n
gsort AgeGroup_WHO Period SexCode - rank
bys AgeGroup_WHO Period SexCode: replace rank = _n
gen percent = n/total_deaths*100
format percent %5.0f 
gen n_perc = string(n) + "(" + string(percent,"%5.0fc") + "%)"
gen cause_lbl = cod + "(" + string(percent,"%5.0fc") + "%)"
keep if rank <=10
rename n no_of_deaths
reshape wide cod cause_lbl total_deaths no_of_deaths percent n_perc, i(AgeGroup_WHO SexCode rank) j(Period)
append using "${data}/${sitename}_top_causes_of_death_by_period_who_age"
save "${data}/${sitename}_top_causes_of_death_by_period_who_age", replace

*top causes by period and age groups for children and adolescents
use "${data}/${sitename}_CoD", clear
keep if died == 1
drop if !inlist(Period, 1,2,3)
//drop if AgeGroup5 > 15
gen n = 1
collapse (sum)n, by(Period AgeGroup5 cod)
bys Period AgeGroup5: egen total_deaths = sum(n)
gen SexCode = 2
drop if cod == ""
sort AgeGroup5 Period n
bys AgeGroup5 Period: gen rank = _n
gsort AgeGroup5 Period - rank
bys AgeGroup5 Period: replace rank = _n
gen percent = n/total_deaths*100
format percent %5.0f 
gen n_perc = string(n) + "(" + string(percent,"%5.0fc") + "%)"
gen cause_lbl = cod + "(" + string(percent,"%5.0fc") + "%)"
keep if rank <=10
rename n no_of_deaths
reshape wide cod cause_lbl total_deaths no_of_deaths percent n_perc, i(AgeGroup5 rank) j(Period)
save "${data}/${sitename}_top_causes_of_death_by_period_age_5yrs", replace

*top causes by period and age groups , males and females
use "${data}/${sitename}_CoD", clear
keep if died == 1
drop if !inlist(Period, 1,2,3)
//drop if AgeGroup5 > 15
gen n = 1
collapse (sum)n, by(Period AgeGroup5 SexCode cod)
bys Period AgeGroup5 SexCode: egen total_deaths = sum(n)
drop if cod == ""
sort AgeGroup5 Period SexCode n
bys AgeGroup5 Period SexCode: gen rank = _n
gsort AgeGroup5 Period SexCode - rank
bys AgeGroup5 Period SexCode: replace rank = _n
gen percent = n/total_deaths*100
format percent %5.0f 
gen n_perc = string(n) + "(" + string(percent,"%5.0fc") + "%)"
gen cause_lbl = cod + "(" + string(percent,"%5.0fc") + "%)"
keep if rank <=10
rename n no_of_deaths
reshape wide cod cause_lbl total_deaths no_of_deaths percent n_perc, i(AgeGroup5 SexCode rank) j(Period)
append using "${data}/${sitename}_top_causes_of_death_by_period_age_5yrs"
save "${data}/${sitename}_top_causes_of_death_by_period_age_5yrs", replace








