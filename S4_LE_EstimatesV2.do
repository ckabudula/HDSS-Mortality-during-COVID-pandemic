local site = "${site}"
//local site = "${sitename}"
global yearstart = 2015

//load STSET data
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
if "${sitename}" == "KE022" {
	global yearstart = 2017
	}
else if "${sitename}" == "ET043" {
	global yearstart = 2018
	}
else if "${sitename}" == "ZA081" {
	global yearstart = 2018
	}
	
//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
drop if agegrp >= 100 //deleting records pertaining to the old (age misreporting ?)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t

//compute LE for males and females combined and period and store along with CI's in new dataset 
tempname stciout
postfile `stciout' sex year N e se elb eub using "${data}/${sitename}_LE_est_all", replace 
local i = 0
forvalues j=$yearstart(1)$yearend {			//j=year 
			stci if year==`j',  rmean     // mean survival time restricted to the longest follow-up time
			local e=r(rmean)
			local se=r(se)
			local eub=r(ub)
			local elb=r(lb)
			local N=r(N_sub)
			post `stciout' (`i') (`j') (`N') (`e') (`se') (`elb') (`eub')
}
postclose `stciout'

//compute adult LE by sex and period and store along with CI's in new dataset 
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
if "${sitename}" == "KE022" {
	global yearstart = 2017
	}
else if "${sitename}" == "ET043" {
	global yearstart = 2018
	}
else if "${sitename}" == "ZA081" {
	global yearstart = 2017
	}
	
//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
drop if agegrp >= 100 //deleting records pertaining to the old (age misreporting ?)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t

tempname stciout
postfile `stciout'  sex year N e se elb eub using "${data}/${sitename}_LE_est", replace 
forvalues i=1(1)2 {						//i=male
	forvalues j=$yearstart(1)$yearend {			//j=year 
			stci if sex==`i' & year==`j',  rmean     // mean survival time restricted to the longest follow-up time
			local e=r(rmean)
			local se=r(se)
			local eub=r(ub)
			local elb=r(lb)
			local N=r(N_sub)
			post `stciout' (`i') (`j') (`N') (`e') (`se') (`elb') (`eub')
	}
}
postclose `stciout'

use "${data}/${sitename}_LE_est",clear
append using "${data}/${sitename}_LE_est_all"
lab var N "Number of subjects"
lab var e "Years lived"
lab var se "Standard error for e"
lab var elb "Years lived, lower bound"
lab var eub "Years lived, uppper bound"
gen lower_age = 0
sort sex year
list, clean noobs
save "${data}/${sitename}_LE_est", replace
outsheet using "${data}/${sitename}_LE_est.csv", comma replace

//LIFE EXPECTANCY AT AGE 15
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
global yearstart = 2015
if "${sitename}" == "KE022" {
	global yearstart = 2017
	}
else if "${sitename}" == "ET043" {
	global yearstart = 2018
	}
else if "${sitename}" == "ZA081" {
	global yearstart = 2018
	}
	
//split by age and calender year
stsplit agegrp, at(15(5)100)
drop if agegrp <15 | agegrp >= 100 //deleting records pertaining to children  & the old (age misreporting ?)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t

//compute LE at age 15 for males and females combined and period and store along with CI's in new dataset 
tempname stciout
postfile `stciout' sex year N e se elb eub using "${data}/${sitename}_LE_est_all_15", replace 
local i = 0
forvalues j=$yearstart(1)$yearend {			//j=year 
			stci if year==`j',  rmean     // mean survival time restricted to the longest follow-up time
			local e=r(rmean)
			local se=r(se)
			local eub=r(ub)
			local elb=r(lb)
			local N=r(N_sub)
			post `stciout' (`i') (`j') (`N') (`e') (`se') (`elb') (`eub')
}
postclose `stciout'

//compute LE at age 15 by sex and period and store along with CI's in new dataset 
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
if "${sitename}" == "KE022" {
	global yearstart = 2017
	}
else if "${sitename}" == "ET043" {
	global yearstart = 2018
	}
else if "${sitename}" == "ZA081" {
	global yearstart = 2017
	}

//split by age and calender year
stsplit agegrp, at(15(5)100)
drop if agegrp <15 | agegrp >= 100 //deleting records pertaining to children  & the old (age misreporting ?)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t

tempname stciout
postfile `stciout'  sex year N e se elb eub using "${data}/${sitename}_LE_est_15", replace 
forvalues i=1(1)2 {						//i=male
	forvalues j=$yearstart(1)$yearend {			//j=year 
			stci if sex==`i' & year==`j',  rmean     // mean survival time restricted to the longest follow-up time
			local e=r(rmean)
			local se=r(se)
			local eub=r(ub)
			local elb=r(lb)
			local N=r(N_sub)
			post `stciout' (`i') (`j') (`N') (`e') (`se') (`elb') (`eub')
	}
}
postclose `stciout'

use "${data}/${sitename}_LE_est_15",clear
append using "${data}/${sitename}_LE_est_all_15"
lab var N "Number of subjects"
lab var e "Years lived"
lab var se "Standard error for e"
lab var elb "Years lived, lower bound"
lab var eub "Years lived, uppper bound"
gen lower_age = 15
sort sex year
list, clean noobs
save "${data}/${sitename}_LE_est_15", replace
outsheet using "${data}/${sitename}_LE_est_15.csv", comma replace

//LIFE EXPECTANCY AT AGE 50
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

if "${sitename}" == "KE022" {
	global yearstart = 2017
	}
else if "${sitename}" == "ET043" {
	global yearstart = 2018
	}
else if "${sitename}" == "ZA081" {
	global yearstart = 2018
	}
	
//split by age and calender year
stsplit agegrp, at(50(5)100)
drop if agegrp <50 | agegrp >= 100 //deleting records pertaining to children  & the old (age misreporting ?)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t

//compute LE at age 50 for males and females combined and period and store along with CI's in new dataset 
tempname stciout
postfile `stciout' sex year N e se elb eub using "${data}/${sitename}_LE_est_all_50", replace 
local i = 0
forvalues j=$yearstart(1)$yearend {			//j=year 
			stci if year==`j',  rmean     // mean survival time restricted to the longest follow-up time
			local e=r(rmean)
			local se=r(se)
			local eub=r(ub)
			local elb=r(lb)
			local N=r(N_sub)
			post `stciout' (`i') (`j') (`N') (`e') (`se') (`elb') (`eub')
}
postclose `stciout'

//compute LE at age 50 by sex and period and store along with CI's in new dataset 
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

if "${sitename}" == "KE022" {
	global yearstart = 2017
	}
else if "${sitename}" == "ET043" {
	global yearstart = 2018
	}
else if "${sitename}" == "ZA081" {
	global yearstart = 2017
	}

//split by age and calender year
stsplit agegrp, at(50(5)100)
drop if agegrp <50 | agegrp >= 100 //deleting records pertaining to children  & the old (age misreporting ?)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t

tempname stciout
postfile `stciout'  sex year N e se elb eub using "${data}/${sitename}_LE_est_50", replace 
forvalues i=1(1)2 {						//i=male
	forvalues j=$yearstart(1)$yearend {			//j=year 
			stci if sex==`i' & year==`j',  rmean     // mean survival time restricted to the longest follow-up time
			local e=r(rmean)
			local se=r(se)
			local eub=r(ub)
			local elb=r(lb)
			local N=r(N_sub)
			post `stciout' (`i') (`j') (`N') (`e') (`se') (`elb') (`eub')
	}
}
postclose `stciout'

use "${data}/${sitename}_LE_est_50",clear
append using "${data}/${sitename}_LE_est_all_50"
lab var N "Number of subjects"
lab var e "Years lived"
lab var se "Standard error for e"
lab var elb "Years lived, lower bound"
lab var eub "Years lived, uppper bound"
gen lower_age = 50
sort sex year
list, clean noobs
save "${data}/${sitename}_LE_est_50", replace
outsheet using "${data}/${sitename}_LE_est_50.csv", comma replace

//LIFE EXPECTANCY AT AGE 60
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

if "${sitename}" == "KE022" {
	global yearstart = 2017
	}
else if "${sitename}" == "ET043" {
	global yearstart = 2018
	}
else if "${sitename}" == "ZA081" {
	global yearstart = 2018
	}
	
//split by age and calender year
stsplit agegrp, at(60(5)100)
drop if agegrp <60 | agegrp >= 100 //deleting records pertaining to children  & the old (age misreporting ?)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t

//compute LE at age 60 for males and females combined and period and store along with CI's in new dataset 
tempname stciout
postfile `stciout' sex year N e se elb eub using "${data}/${sitename}_LE_est_all_60", replace 
local i = 0
forvalues j=$yearstart(1)$yearend {			//j=year 
			stci if year==`j',  rmean     // mean survival time restricted to the longest follow-up time
			local e=r(rmean)
			local se=r(se)
			local eub=r(ub)
			local elb=r(lb)
			local N=r(N_sub)
			post `stciout' (`i') (`j') (`N') (`e') (`se') (`elb') (`eub')
}
postclose `stciout'

//compute LE at age 60 by sex and period and store along with CI's in new dataset 
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

if "${sitename}" == "KE022" {
	global yearstart = 2017
	}
else if "${sitename}" == "ET043" {
	global yearstart = 2018
	}
else if "${sitename}" == "ZA081" {
	global yearstart = 2017
	}

//split by age and calender year
stsplit agegrp, at(60(5)100)
drop if agegrp <50 | agegrp >= 100 //deleting records pertaining to children  & the old (age misreporting ?)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t

tempname stciout
postfile `stciout'  sex year N e se elb eub using "${data}/${sitename}_LE_est_60", replace 
forvalues i=1(1)2 {						//i=male
	forvalues j=$yearstart(1)$yearend {			//j=year 
			stci if sex==`i' & year==`j',  rmean     // mean survival time restricted to the longest follow-up time
			local e=r(rmean)
			local se=r(se)
			local eub=r(ub)
			local elb=r(lb)
			local N=r(N_sub)
			post `stciout' (`i') (`j') (`N') (`e') (`se') (`elb') (`eub')
	}
}
postclose `stciout'

use "${data}/${sitename}_LE_est_60",clear
append using "${data}/${sitename}_LE_est_all_60"
lab var N "Number of subjects"
lab var e "Years lived"
lab var se "Standard error for e"
lab var elb "Years lived, lower bound"
lab var eub "Years lived, uppper bound"
gen lower_age = 60
sort sex year
list, clean noobs
save "${data}/${sitename}_LE_est_60", replace
outsheet using "${data}/${sitename}_LE_est_60.csv", comma replace

//COMBINE INTO ONE FILE
use "${data}/${sitename}_LE_est"
append using "${data}/${sitename}_LE_est_15"
append using "${data}/${sitename}_LE_est_50"
append using "${data}/${sitename}_LE_est_60"
gen centreid = "${sitename}"
save "${data}/${sitename}_LE_est_by_age", replace
outsheet using "${data}/${sitename}_LE_est_by_age.csv", comma replace

//another approach
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
drop if agegrp >=100
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t
* survivor functions by sex and year
sts list, at(0 1 5 (5)90) by(sex year) saving("${data}/${sitename}_surv", replace) 

//redo for both males and females combined
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
drop if agegrp >=100
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t
* survivor functions by year
sts list, at(0 1 5 (5)100) by(year) saving("${data}/${sitename}_surv_all", replace) 

use "${data}/${sitename}_surv_all",clear
gen sex = 0
append using "${data}/${sitename}_surv"
save "${data}/${sitename}_surv", replace

use "${data}/${sitename}_surv", clear
rename time agegrp
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("SurvivorFunctions")sheetreplace firstrow(variables)
drop begin fail std_err lb ub

* Standard life table terminology is used:
* l=proportion surviving to age x, L= person-years in age interval, T= person years above exact age x
rename surv l
sort sex year agegrp
by sex year: gen L=(5*l[_n+1]) + (2.55 * (l-l[_n+1])) if _n <_N	//PY (L) in the age-interval 
by sex year: egen T=total(L) // T, T0=total PY lived between ages 0 and upper bound
by sex year: replace T=T[_n-1]-L[_n-1] if _n>=2 //PY above exact age x 
by sex year: replace T= . if _n ==_N //don't need this for upper age interval 
gen e=T/l 

list sex year age l L T e

save "${data}/${sitename}_LE_est2", replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("LifeExpectanciesV2")sheetreplace firstrow(variables)

use "${data}/${sitename}_LE_est2", clear
reshape wide l L T e, i(sex agegrp) j(year)
save "${data}/${sitename}_LE_est_wide", replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("LifeExpectanciesWide")sheetreplace firstrow(variables)


//Life expectancy at age 15
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
drop if agegrp >=100
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t
* survivor functions by sex and year
sts list, at(15(5)95) by(sex year) saving("${data}/${sitename}_surv15", replace) 

//redo for both males and females combined
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t
* survivor functions by year
sts list, at(15(5)95) by(year) saving("${data}/${sitename}_surv15_all", replace) 

use "${data}/${sitename}_surv15_all",clear
gen sex = 0
append using "${data}/${sitename}_surv15"
save "${data}/${sitename}_surv15", replace

use "${data}/${sitename}_surv15", replace
rename time agegrp
drop begin fail std_err lb ub

* Standard life table terminology is used:
* l=proportion surviving to age x, L= person-years in age interval, T= person years above exact age x
rename surv l
sort sex year agegrp
by sex year: gen L=(5*l[_n+1]) + (2.55 * (l-l[_n+1])) if _n <_N	//PY (L) in the age-interval 
by sex year: egen T=total(L) // T, T0=total PY lived between ages 0 and upper bound
by sex year: replace T=T[_n-1]-L[_n-1] if _n>=2 //PY above exact age x 
by sex year: replace T= . if _n ==_N //don't need this for upper age interval 
gen e=T/l 

list sex year age l L T e

save "${data}/${sitename}_LE_est15_V2", replace

use "${data}/${sitename}_LE_est15_V2", clear
reshape wide l L T e, i(sex agegrp) j(year)
save "${data}/${sitename}_LE_est_wide15", replace

list sex e* if agegrp==15



//Life expectancy at age 50
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t
* survivor functions by sex and year
sts list, at(50(5)95) by(sex year) saving("${data}/${sitename}_surv50", replace) 

//redo for both males and females combined
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t
* survivor functions by year
sts list, at(50(5)95) by(year) saving("${data}/${sitename}_surv50_all", replace) 

use "${data}/${sitename}_surv50_all",clear
gen sex = 0
append using "${data}/${sitename}_surv50"
save "${data}/${sitename}_surv50", replace

use "${data}/${sitename}_surv50", replace
rename time agegrp
drop begin fail std_err lb ub

* Standard life table terminology is used:
* l=proportion surviving to age x, L= person-years in age interval, T= person years above exact age x
rename surv l
sort sex year agegrp
by sex year: gen L=(5*l[_n+1]) + (2.55 * (l-l[_n+1])) if _n <_N	//PY (L) in the age-interval 
by sex year: egen T=total(L) // T, T0=total PY lived between ages 0 and upper bound
by sex year: replace T=T[_n-1]-L[_n-1] if _n>=2 //PY above exact age x 
by sex year: replace T= . if _n ==_N //don't need this for upper age interval 
gen e=T/l 

list sex year age l L T e

save "${data}/${sitename}_LE_est50_V2", replace

use "${data}/${sitename}_LE_est50_V2", clear
reshape wide l L T e, i(sex agegrp) j(year)
save "${data}/${sitename}_LE_est_wide50", replace

list sex e* if agegrp==50


//Life expectancy at age 60
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t
* survivor functions by sex and year
sts list, at(60(5)95) by(sex year) saving("${data}/${sitename}_surv60", replace) 

//redo for both males and females combined
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
//split by age and calender year
stsplit agegrp, at(0 1 5 (5)100)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
tab agegrp

count if _t0 >= _t
drop if _t0 >= _t
* survivor functions by year
sts list, at(60(5)95) by(year) saving("${data}/${sitename}_surv60_all", replace) 

use "${data}/${sitename}_surv60_all",clear
gen sex = 0
append using "${data}/${sitename}_surv60"
save "${data}/${sitename}_surv60", replace

use "${data}/${sitename}_surv60", replace
rename time agegrp
drop begin fail std_err lb ub

* Standard life table terminology is used:
* l=proportion surviving to age x, L= person-years in age interval, T= person years above exact age x
rename surv l
sort sex year agegrp
by sex year: gen L=(5*l[_n+1]) + (2.55 * (l-l[_n+1])) if _n <_N	//PY (L) in the age-interval 
by sex year: egen T=total(L) // T, T0=total PY lived between ages 0 and upper bound
by sex year: replace T=T[_n-1]-L[_n-1] if _n>=2 //PY above exact age x 
by sex year: replace T= . if _n ==_N //don't need this for upper age interval 
gen e=T/l 

list sex year age l L T e

save "${data}/${sitename}_LE_est60_V2", replace

use "${data}/${sitename}_LE_est60_V2", clear
reshape wide l L T e, i(sex agegrp) j(year)
save "${data}/${sitename}_LE_est_wide60", replace

list sex e* if agegrp==60


