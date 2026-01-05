local site = "${site}"
//local site = "${sitename}"
global yearstart = 2015

use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

//split on year
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year

br individualid dob startdate enddate _origin _t _t0 year

//drop cases with entry time _t0 >= survival time _t
count if _t0 >= _t
drop if _t0 >= _t

//u5 mortality rate male and female combined
sts list, at(0(5)10) by(year) saving("${data}/${sitename}_under5_surv_year", replace)
use "${data}/${sitename}_under5_surv_year",clear
keep if year >=2015 & year < 2022
rename time agegrp
keep if agegrp==5
gen q0 = 1-survivor 
gen q0ub =  1-lb
gen q0lb = 1-ub
gen q0_000 = q0*1000
save "${data}/${sitename}_under5_mx",replace
twoway (scatter q0_000 year, recast(connected)  msize(*0.7))  ///
	,xlabel(2015 (1) 2021, grid angle(0)) ///
	ylabel(0 (4) 80,grid angle(0)) ///
	ytitle("Under five mortality rate (per 1 000)",height(3) ) ///
	xtitle("Year",height(3) ) ///
	title("Under five mortality: `site'") ///
	graphregion(color(white)) name(${sitename}_U5ByYear,replace)
	graph save "${graphs}/${sitename}_U5ByYear.gph", replace
	graph export "${graphs}/${sitename}_U5ByYear.pdf", replace
	graph export "${graphs}/${sitename}_U5ByYear.png", replace
	graph export "${graphs}/${sitename}_U5ByYear.tif", replace
	

//adult mortality rate both sexes
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year

br individualid dob startdate enddate _origin _t _t0 year

//drop cases with entry time _t0 >= survival time _t
count if _t0 >= _t
drop if _t0 >= _t
drop if _t0<15	| _t>=70  					//restrict age range
sts list, at(15(5)65) by(year) saving("${data}/${sitename}_adult_surv_by_age", replace)

use "${data}/${sitename}_adult_surv_by_age",clear
keep if year >=2015 & year < 2022
rename time agegrp
keep if agegrp==60
gen q15 = 1-survivor 
gen q15ub =  1-lb
gen q15lb = 1-ub

foreach var of varlist q15* {
gen `var'_000 = `var'*1000
}

gen sex=0
save "${data}/${sitename}_adult_mx_sex",replace
	
twoway (scatter q15_000 year if  year <= 2021, recast(connected) mfcolor(pink) mlcolor(pink) lcolor(pink) msize(*.8)) ///
	,xlabel(2015 (1) 2021, angle(90) grid) ///
	ylabel(0 (100) 800,grid angle(0)) ///
	ytitle("Adult mortality (per 1 000)",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("Adult mortality: `site'") ///
	graphregion(color(white)) name(${sitename}_AdultMort_All,replace) 
	graph save "${graphs}/${sitename}_AdultMortAllPer1000.gph", replace
	graph export "${graphs}/${sitename}_AdultMortAllPer1000.pdf", replace
	graph export "${graphs}/${sitename}_AdultMortAllPer1000.png", replace
	graph export "${graphs}/${sitename}_AdultMortAllPer1000.tif", replace
	
//adult mortality rate by sex
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year

br individualid dob startdate enddate _origin _t _t0 year

//drop cases with entry time _t0 >= survival time _t
count if _t0 >= _t
drop if _t0 >= _t
drop if _t0<15	| _t>=70  					//restrict age range
sts list, at(15(5)65) by(year sex) saving("${data}/${sitename}_adult_surv_by_age_sex", replace)

use "${data}/${sitename}_adult_surv_by_age_sex",clear
keep if year >=2015 & year < 2022
rename time agegrp
keep if agegrp==60
gen q15 = 1-survivor 
gen q15ub =  1-lb
gen q15lb = 1-ub

foreach var of varlist q15* {
gen `var'_000 = `var'*1000
}

append using "${data}/${sitename}_adult_mx_sex"
save "${data}/${sitename}_adult_mx_sex",replace
capture drop xax             
gen xax=year+0.00
	
twoway (scatter q15_000 xax if sex==2 & year <= 2021, recast(connected) mfcolor(pink) mlcolor(pink) lcolor(pink) msize(*.8)) ///
	(scatter q15_000 year if sex==1 & year <= 2021, recast(connected) mfcolor(white) mcolor(blue) lcolor(blue)  msize(*.8)) ///
	,xlabel(2015 (1) 2021, angle(90) grid) ///
	ylabel(0 (100) 800,grid angle(0)) ///
	ytitle("Adult mortality (per 1 000)",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(order(1 "Female"  2 "Male") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	title("Adult mortality: `site'") ///
	graphregion(color(white)) name(${sitename}_AdultMort_Male_Female,replace) 
	graph save "${graphs}/${sitename}_AdultMortPer1000.gph", replace
	graph export "${graphs}/${sitename}_AdultMortPer1000.pdf", replace
	graph export "${graphs}/${sitename}_AdultMortPer1000.png", replace
	graph export "${graphs}/${sitename}_AdultMortPer1000.tif", replace

