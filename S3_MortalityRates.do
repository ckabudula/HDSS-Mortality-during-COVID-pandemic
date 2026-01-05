local site = "${site}"
//local site = "${sitename}"
global yearstart = 2015

use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

//split on year
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year

br individualid dob startdate enddate _origin _t _t0 year

//create 5 year age groups
stsplit agegrp, at(0(5)100) trim
label define agrps 0 "0-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" ///
	30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 50 "50-54" 55 "55-59" 60 "60-64" ///
	65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" 85 "85-89" 90 "90-94" 95 "95-99" 100 "100+" 
label values agegrp agrps

//create standard WHO  age groups
recode agegrp (0/4=0) (5/14=5) (15/49=15) (50/64=50) ///
	(65/max=65), gen(agegrp_who)
	
strate year agegrp_who, output("${data}/${sitename}_py_mx_age",replace) nolist
use "${data}/${sitename}_py_mx_age", clear
format _Y %9.0g
rename _D Deaths
rename _Y PersonYears
rename _Rate Mx
rename _Lower Lower95Mx
rename _Upper Upper95Mx
egen TotD = sum(Deaths)
egen TotPY = sum(PersonYears) 
gen mx_1000 = (Deaths/PersonYears)*1000
gen lb_mx_1000 = Lower95Mx *1000 
gen ub_mx_1000 = Upper95Mx *1000 
gen centreid = "${sitename}"
save "${data}/${sitename}_py_mx_age",replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("py_mx_age")sheetreplace firstrow(variables)

use "${data}/${sitename}_py_mx_age", clear 
drop if year > $yearend
twoway (scatter mx_1000 year if agegrp==0,mfcolor(gs7) mlcolor(gs7)) ///
	(scatter mx_1000 year if agegrp==5,mfcolor(blue) mlcolor(blue)) ///
	(scatter mx_1000 year if agegrp==15,mfcolor(green) mlcolor(green)) ///
	(scatter mx_1000 year if agegrp==50,mfcolor(red) mlcolor(red)) ///
	(scatter mx_1000 year if agegrp==65,mfcolor(navy) mlcolor(navy)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (10) 60,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(cols(6) position(12) ///
			order(1 "0-4 years" 2 "5-14 years" 3 "15-49" 4 "50-64 years" 5 "65+ years") ///
			region(lwidth(0) lcolor(white)) ring(1) size(small)) ///
	title("Overall Mortality: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_agegrp_year,replace) 
	graph save "${graphs}/${sitename}_mx_agegrp_year.gph", replace
	graph export "${graphs}/${sitename}_mx_agegrp_year.pdf", replace
	graph export "${graphs}/${sitename}_mx_agegrp_year.png", replace
	graph export "${graphs}/${sitename}_mx_agegrp_year.tif", replace
	

twoway (rspike ub_mx_1000 lb_mx_1000 year if agegrp==0, lcolor(gs4)) ///
	(scatter mx_1000 year if agegrp==0,mfcolor(gs4) mlcolor(gs4)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (1) 10,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("Mortality for 0-4 year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_0to4_year,replace) 
	graph save "${graphs}/${sitename}_mx_0to4_year.gph", replace
	graph export "${graphs}/${sitename}_mx_0to4_year.pdf", replace
	graph export "${graphs}/${sitename}_mx_0to4_year.png", replace
	graph export "${graphs}/${sitename}_mx_0to4_year.tif", replace
	
twoway (rspike ub_mx_1000 lb_mx_1000 year if agegrp==5, lcolor(gs4)) ///
	(scatter mx_1000 year if agegrp==5,mfcolor(gs4) mlcolor(gs4)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (1) 3,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("Mortality for 5-14 year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_5to14_year,replace) 
	graph save "${graphs}/${sitename}_mx_5to14_year.gph", replace
	graph export "${graphs}/${sitename}_mx_5to14_year.pdf", replace
	graph export "${graphs}/${sitename}_mx_5to14_year.png", replace
	graph export "${graphs}/${sitename}_mx_5to14_year.tif", replace	
	
twoway (rspike ub_mx_1000 lb_mx_1000 year if agegrp==15, lcolor(gs4)) ///
	(scatter mx_1000 year if agegrp==15,mfcolor(gs4) mlcolor(gs4)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (1) 10,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("Mortality for 15-49 year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_15to49_year,replace) 
	graph save "${graphs}/${sitename}_mx_15to49_year.gph", replace
	graph export "${graphs}/${sitename}_mx_15to49_year.pdf", replace
	graph export "${graphs}/${sitename}_mx_15to49_year.png", replace
	graph export "${graphs}/${sitename}_mx_15to49_year.tif", replace	

twoway (rspike ub_mx_1000 lb_mx_1000 year if agegrp==50, lcolor(gs4)) ///
	(scatter mx_1000 year if agegrp==50,mfcolor(gs4) mlcolor(gs4)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (2) 24,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("Mortality for 50-64 year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_50to64_year,replace) 
	graph save "${graphs}/${sitename}_mx_50to64_year.gph", replace
	graph export "${graphs}/${sitename}_mx_50to64_year.pdf", replace
	graph export "${graphs}/${sitename}_mx_50to64_year.png", replace
	graph export "${graphs}/${sitename}_mx_50to64_year.tif", replace

twoway (rspike ub_mx_1000 lb_mx_1000 year if agegrp==65, lcolor(gs4)) ///
	(scatter mx_1000 year if agegrp==65,mfcolor(gs4) mlcolor(gs4)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (5) 85,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("Mortality for 65+ year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_65_year,replace) 
	graph save "${graphs}/${sitename}_mx_65_year.gph", replace
	graph export "${graphs}/${sitename}_mx_65_year.pdf", replace
	graph export "${graphs}/${sitename}_mx_65_year.png", replace
	graph export "${graphs}/${sitename}_mx_65_year.tif", replace

//mortality rates by year, age and sex
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

//create 5 year age groups
stsplit agegrp, at(0(5)100)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year

label define agrps 0 "0-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" ///
	30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 50 "50-54" 55 "55-59" 60 "60-64" ///
	65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" 85 "85-89" 90 "90-94" 95 "95-99" 100 "100+" 
label values agegrp agrps

//create standard WHO  age groups
recode agegrp (0/4=0) (5/14=5) (15/49=15) (50/64=50) ///
	(65/max=65), gen(agegrp_who)
	
strate year sex agegrp_who, output("${data}/${sitename}_py_mx_sex_age",replace) nolist
use "${data}/${sitename}_py_mx_sex_age", clear
format _Y %9.0g
rename _D Deaths
rename _Y PersonYears
rename _Rate Mx
rename _Lower Lower95Mx
rename _Upper Upper95Mx
egen TotD = sum(Deaths)
egen TotPY = sum(PersonYears) 
gen mx_1000 = (Deaths/PersonYears)*1000
gen lb_mx_1000 = Lower95Mx *1000 
gen ub_mx_1000 = Upper95Mx *1000 
gen centreid = "${sitename}"
save "${data}/${sitename}_py_mx_sex_age",replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("py_mx_sex_age")sheetreplace firstrow(variables)

//plot mortality rates by year, age and sex
drop if year > $yearend
capture drop xaxis*             
gen xaxisw=year+0.085

twoway (rspike ub_mx_1000 lb_mx_1000 year if sex==1 & agegrp==0,lcolor(gs4)) ///
	(scatter mx_1000 year if sex==1 & agegrp==0,mfcolor(gs4) mlcolor(gs4)) ///
	(rspike ub_mx_1000 lb_mx_1000 xaxisw  if sex==2 & agegrp==0,lcolor(blue)) ///
	(scatter mx_1000 xaxisw  if sex==2 & agegrp==0,mfcolor(white) mlcolor(blue)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (1) 10,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(order(2 "Male" 1 "95% CI:Male" 4 "Female" 3 "95% CI:Female") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	title("Mortality for 0-4 year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_0to4_year2,replace) 
	graph save "${graphs}/${sitename}_mx_0to4_year2.gph", replace
	graph export "${graphs}/${sitename}_mx_0to4_year2.pdf", replace
	graph export "${graphs}/${sitename}_mx_0to4_year2.png", replace
	graph export "${graphs}/${sitename}_mx_0to4_year2.tif", replace

twoway (rspike ub_mx_1000 lb_mx_1000 year if sex==1 & agegrp==5,lcolor(gs4)) ///
	(scatter mx_1000 year if sex==1 & agegrp==5,mfcolor(gs4) mlcolor(gs4)) ///
	(rspike ub_mx_1000 lb_mx_1000 xaxisw  if sex==2 & agegrp==5,lcolor(blue)) ///
	(scatter mx_1000 xaxisw  if sex==2 & agegrp==5,mfcolor(white) mlcolor(blue)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (1) 5,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(order(2 "Male" 1 "95% CI:Male" 4 "Female" 3 "95% CI:Female") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	title("Mortality for 5-14 year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_5to14_year2,replace) 
	graph save "${graphs}/${sitename}_mx_5to14_year2.gph", replace
	graph export "${graphs}/${sitename}_mx_5to14_year2.pdf", replace
	graph export "${graphs}/${sitename}_mx_5to14_year2.png", replace
	graph export "${graphs}/${sitename}_mx_5to14_year2.tif", replace	
	

twoway (rspike ub_mx_1000 lb_mx_1000 year if sex==1 & agegrp==15,lcolor(gs4)) ///
	(scatter mx_1000 year if sex==1 & agegrp==15,mfcolor(gs4) mlcolor(gs4)) ///
	(rspike ub_mx_1000 lb_mx_1000 xaxisw  if sex==2 & agegrp==15,lcolor(blue)) ///
	(scatter mx_1000 xaxisw  if sex==2 & agegrp==15,mfcolor(white) mlcolor(blue)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (1) 10,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(order(2 "Male" 1 "95% CI:Male" 4 "Female" 3 "95% CI:Female") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	title("Mortality for 15-49 year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_15to49_year2,replace) 
	graph save "${graphs}/${sitename}_mx_15to49_year2.gph", replace
	graph export "${graphs}/${sitename}_mx_15to49_year2.pdf", replace
	graph export "${graphs}/${sitename}_mx_15to49_year2.png", replace
	graph export "${graphs}/${sitename}_mx_15to49_year2.tif", replace	

twoway (rspike ub_mx_1000 lb_mx_1000 year if sex==1 & agegrp==50,lcolor(gs4)) ///
	(scatter mx_1000 year if sex==1 & agegrp==50,mfcolor(gs4) mlcolor(gs4)) ///
	(rspike ub_mx_1000 lb_mx_1000 xaxisw  if sex==2 & agegrp==50,lcolor(blue)) ///
	(scatter mx_1000 xaxisw  if sex==2 & agegrp==50,mfcolor(white) mlcolor(blue)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (5) 35,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(order(2 "Male" 1 "95% CI:Male" 4 "Female" 3 "95% CI:Female") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	title("Mortality for 50-64 year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_50to64_year2,replace) 
	graph save "${graphs}/${sitename}_mx_50to64_year2.gph", replace
	graph export "${graphs}/${sitename}_mx_50to64_year2.pdf", replace
	graph export "${graphs}/${sitename}_mx_50to64_year2.png", replace
	graph export "${graphs}/${sitename}_mx_50to64_year2.tif", replace

twoway (rspike ub_mx_1000 lb_mx_1000 year if sex==1 & agegrp==65,lcolor(gs4)) ///
	(scatter mx_1000 year if sex==1 & agegrp==65,mfcolor(gs4) mlcolor(gs4)) ///
	(rspike ub_mx_1000 lb_mx_1000 xaxisw  if sex==2 & agegrp==65,lcolor(blue)) ///
	(scatter mx_1000 xaxisw  if sex==2 & agegrp==65,mfcolor(white) mlcolor(blue)) ///
	,xlabel($yearstart (1) $yearend, grid angle(0)) ///
	ylabel(0 (10) 100,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(order(2 "Male" 1 "95% CI:Male" 4 "Female" 3 "95% CI:Female") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	title("Mortality for 65+ year olds: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_65_year2,replace) 
	graph save "${graphs}/${sitename}_mx_65_year2.gph", replace
	graph export "${graphs}/${sitename}_mx_65_year2.pdf", replace
	graph export "${graphs}/${sitename}_mx_65_year2.png", replace
	graph export "${graphs}/${sitename}_mx_65_year2.tif", replace

//combine graphs
graph combine "${graphs}/${sitename}_mx_0to4_year.gph" ///
"${graphs}/${sitename}_mx_5to14_year.gph" ///
"${graphs}/${sitename}_mx_15to49_year.gph" ///
"${graphs}/${sitename}_mx_50to64_year.gph" ///
"${graphs}/${sitename}_mx_65_year.gph", ///
r(2) iscale(*.8) imargin(0 0 0 0) scheme(s1color)
graph export "${graphs}/${sitename}_mx_age_year2.pdf", replace
graph export "${graphs}/${sitename}_mx_age_year2.pdf", replace
graph export "${graphs}/${sitename}_mx_age_year2.png", replace
graph export "${graphs}/${sitename}_mx_age_year2.tif", replace

graph combine "${graphs}/${sitename}_mx_0to4_year2.gph" ///
"${graphs}/${sitename}_mx_15to49_year2.gph" ///
"${graphs}/${sitename}_mx_50to64_year2.gph" ///
"${graphs}/${sitename}_mx_65_year2.gph", ///
r(2) iscale(*.8) imargin(0 0 0 0) scheme(s1color)
graph export "${graphs}/${sitename}_mx_age_sex_year.pdf", replace
graph export "${graphs}/${sitename}_mx_age_sex_year.pdf", replace
graph export "${graphs}/${sitename}_mx_age_sex_year.png", replace
graph export "${graphs}/${sitename}_mx_age_sex_year.tif", replace



*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				COMPUTE AGE STANDARDIZED MORTALITY RATES							**
** USE DIRECT STANDARDIZATION USING WHO STANDARD POPULATION 
** (https://www.researchgate.net/publication/284696312_Age_Standardization_of_Rates_A_New_WHO_Standard)
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear

//create 5 year age groups to age 85+
stsplit agegrp, at(0(5)85)
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year

label define agrps 0 "0-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" ///
	30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 50 "50-54" 55 "55-59" 60 "60-64" ///
	65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" 85 "85+" 
label values agegrp agrps

*run the strate commands to get the output for doing age standardisation
strate year agegrp, output("${data}/${sitename}_py_mx_age_all", replace)

strate year agegrp if sex==1, output("${data}/${sitename}_py_mx_age_male", replace)
strate year agegrp if sex==2, output("${data}/${sitename}_py_mx_age_female", replace)

//Direct standardization - manual approach
use "${data}/${sitename}_py_mx_age_male", clear
merge m:1 agegrp using "${data}/who_standard_population"
generate crude_death=_D/_Y
generate product = crude_death*pop_proportion/100
bys year: egen adj_rate = sum(product)
drop _merge
list

*run the age-standardisation on the strate outputs generated above with dstdize
foreach X in all male female {
	use "${data}/${sitename}_py_mx_age_`X'", clear
	gen pop_proportion=round(_Y, 1)
	replace pop_proportion=_D if _D>pop_proportion
	gen site = "${sitename}"
	dstdize _D pop_proportion agegrp, by(year) using("${data}/who_standard_population") print 
	//return list
	matrix results=(r(adj)',r(lb_adj)',r(ub_adj)')
	rename year year_old
	gen year=""
	local r=1
	forvalues l=1/`r(k)' {
		di `r(c`l')'
		replace year =`r(c`l')' in `r'
		local r=`r'+1
		}
	destring year, replace force
	la val year year
	svmat results
	rename (results1 results2 results3) (agestan_rate agestan_lb agestan_ub)
	replace agestan_rate=agestan_rate*1000
	replace agestan_lb=agestan_lb*1000
	replace agestan_ub=agestan_ub*1000
	keep year agestan_rate agestan_lb agestan_ub
	keep if year ~=.
	save "${data}/${sitename}_agestan_mx_`X'", replace
	//export to excel
	quietly export excel using "${output}/${sitename}.xlsx", sheet("agestan_mx_`X'")sheetreplace firstrow(variables)
	}
	
use "${data}/${sitename}_agestan_mx_male", clear	
gen sex=1
save "${data}/${sitename}_agestan_mx", replace
use "${data}/${sitename}_agestan_mx_female", clear	
gen sex=2
append using "${data}/${sitename}_agestan_mx"
save "${data}/${sitename}_agestan_mx", replace
use "${data}/${sitename}_agestan_mx_all", clear	
gen sex=0
append using "${data}/${sitename}_agestan_mx"
save "${data}/${sitename}_agestan_mx", replace

//plot age standardized mortality rates by yearand sex
drop if year > $yearend
capture drop xaxis*             
gen xaxisw=year+0.085

twoway (rspike agestan_ub agestan_lb year if sex==1 ,lcolor(green)) ///
	(scatter agestan_rate year if sex==1,mfcolor(white) mlcolor(green)) ///
	(rspike agestan_ub agestan_lb xaxisw  if sex==2,lcolor(blue)) ///
	(scatter agestan_rate xaxisw  if sex==2,mfcolor(white) mlcolor(blue)) ///
	(rspike agestan_ub agestan_lb xaxisw  if sex==0,lcolor(gs4)) ///
	(scatter agestan_rate xaxisw  if sex==0,mfcolor(gs4) mlcolor(gs4)) ///
	,xlabel($yearstart (1) $yearend, nogrid angle(0)) ///
	ylabel(0 (1) 15,nogrid angle(0)) ///
	ytitle("Age-standardized Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(order(2 "Male" 1 "95% CI:Male" 4 "Female" 3 "95% CI:Female" 6 "Both" 5 "95% CI:Both") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	title("Age-standardized Mortality: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_0to4_year2,replace) 
	graph save "${graphs}/${sitename}_agestan_mx.gph", replace
	graph export "${graphs}/${sitename}_agestan_mx.pdf", replace
	graph export "${graphs}/${sitename}_agestan_mx.png", replace
	graph export "${graphs}/${sitename}_agestan_mx.tif", replace
