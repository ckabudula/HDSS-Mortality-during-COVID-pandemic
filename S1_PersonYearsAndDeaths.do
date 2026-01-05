local site = "${site}"
//local site = "${sitename}"
global yearstart = 2015

/* person years, number of deaths and overall mortality*/
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
strate year, output("${data}/${sitename}_py_mx",replace) nolist
use "${data}/${sitename}_py_mx", clear
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
save "${data}/${sitename}_py_mx",replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("py_mx")sheetreplace firstrow(variables)

//plot of person years
drop if year > $yearend
format PersonYears %9.0fc
sum PersonYears 
local max= r(max)
local min= r(min)
local step = `max'/10

twoway (bar PersonYears year, barw(.4) fcolor(dkgreen) lcolor(dkgreen) lwidth(vthin)) ///
	(scatter PersonYears year, msymbol(none) mlabel(PersonYears) mlabposition(12)) ///
	,xlabel($yearstart(1) $yearend, grid angle(0)) ///
	ylabel(0 (`step') `max',format(%9.0fc) grid angle(0)) ///
	ytitle("Person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("`site': Person years") ///
	graphregion(color(white)) name(${sitename}_PY,replace) 
	graph save "${graphs}/${sitename}_PY.gph", replace
	graph export "${graphs}/${sitename}_PY.pdf", replace
	graph export "${graphs}/${sitename}_PY.png", replace
	graph export "${graphs}/${sitename}_PY.tif", replace	

///graph of deaths
sum Deaths
local max= r(max)
local min= r(min)
local step = `max'/10

twoway (bar Deaths year, barw(.5) fcolor(red) lcolor(red) lwidth(vthin)) ///
	(scatter Deaths year, msymbol(none) mlabel(Deaths) mlabposition(12)) ///
	,xlabel($yearstart(1) $yearend, grid angle(0)) ///
	ylabel(0 (`step') `max',format(%9.0fc) grid angle(0)) ///
	ytitle("Number of deaths",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("`site': Number of deaths") ///
	graphregion(color(white)) name(${sitename}_Dx,replace) 
	graph save "${graphs}/${sitename}_Dx.gph", replace
	graph export "${graphs}/${sitename}_Dx.pdf", replace
	graph export "${graphs}/${sitename}_Dx.png", replace
	graph export "${graphs}/${sitename}_Dx.tif", replace	
	
//plot overall mortality
twoway (rspike ub_mx_1000 lb_mx_1000 year, lcolor(gs4)) ///
	(scatter mx_1000 year,mfcolor(gs4) mlcolor(gs4) lcolor(gs4) msize(*.8)) ///
	,xlabel($yearstart(1) $yearend, grid angle(0)) ///
	ylabel(0 (1) 14,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(off) ///
	title("Overall Mortality:`site'") ///
	graphregion(color(white)) name(${sitename},replace) 
	graph save "${graphs}/${sitename}_Mx.gph", replace
	graph export "${graphs}/${sitename}_Mx.pdf", replace
	graph export "${graphs}/${sitename}_Mx.png", replace
	graph export "${graphs}/${sitename}_Mx.tif", replace

/* person years, number of deaths and mortality rates by year and sex*/
use "${data}/${sitename}_RawCensoredEpisodes_st_ready", clear
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year
strate year sex, output("${data}/${sitename}_py_mx_sex",replace) nolist
use "${data}/${sitename}_py_mx_sex", clear
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
save "${data}/${sitename}_py_mx_sex",replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("py_mx_sex")sheetreplace firstrow(variables)

//plot of person years by year and sex
drop if year > $yearend

capture drop xaxis*             
gen xaxisw=year+0.25
format PersonYears %9.0fc
sum PersonYears 
local max= r(max)
local min= r(min)
local step = `max'/10

	twoway (bar PersonYears year if sex==2, barw(.245) fcolor(dkgreen) lcolor(dkgreen) lwidth(vthin)) ///
		(bar PersonYears xaxisw if sex==1, barw(.245) fcolor(blue) lcolor(blue) lwidth(vthin)) ///
		(scatter PersonYears year if sex==2, msymbol(none) mlabel(PersonYears) mlabposition(1) msize(*0.8)) ///
		(scatter PersonYears xaxis if sex==1, msymbol(none) mlabel(PersonYears) mlabposition(1) msize(*0.8)) ///
		,xlabel($yearstart(1) $yearend.5, grid angle(0)) ///
		ylabel(0 (`step') `max',format(%9.0fc) grid angle(0)) ///
		ytitle("Person years",height(3) ) ///
		xtitle("Year",height(3) ) ///
		legend(order(1 "Female" 2 "Male" 3 "" 4 "") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
		title("`site': Person years") ///
		graphregion(color(white)) name(${sitename}_PY,replace) 
		graph save "${graphs}/${sitename}_PY_sex.gph", replace
		graph export "${graphs}/${sitename}_PY_sex.pdf", replace
		graph export "${graphs}/${sitename}_PY_sex.png", replace
		graph export "${graphs}/${sitename}_PY_sex.tif", replace	


//plot of deaths by year and sex
sum Deaths 
local max= r(max)
local min= r(min)
local step = `max'/10

	twoway (bar Deaths year if sex==2, barw(.245) fcolor(red) lcolor(red) lwidth(vthin)) ///
		(bar Deaths xaxisw if sex==1, barw(.245) fcolor(purple) lcolor(purple) lwidth(vthin)) ///
		(scatter Deaths year if sex==2, msymbol(none) mlabel(Deaths) mlabposition(1) msize(*0.8)) ///
		(scatter Deaths xaxis if sex==1, msymbol(none) mlabel(Deaths) mlabposition(1) msize(*0.8)) ///
		,xlabel($yearstart(1) $yearend.5, grid angle(0)) ///
		ylabel(0 (`step') `max',format(%9.0fc) grid angle(0)) ///
		ytitle("Number of deaths",height(3)) ///
		xtitle("Year",height(3) ) ///
		legend(order(1 "Female" 2 "Male" 3 "" 4 "") ///
			region(lwidth(0) lcolor(white)) position(12) ///
			ring(1) size(small) cols(4)) ///	
		title("`site': Number of deaths") ///
		graphregion(color(white)) name(${sitename}_Dx_sex,replace) 
		graph save "${graphs}/${sitename}_Dx_sex.gph", replace
		graph export "${graphs}/${sitename}_Dx_sex.pdf", replace
		graph export "${graphs}/${sitename}_Dx_sex.png", replace
		graph export "${graphs}/${sitename}_Dx_sex.tif", replace	
		
//plot of mortality rates by year and sex

capture drop xaxis*             
gen xaxisw=year+0.085
twoway (rspike ub_mx_1000 lb_mx_1000 year if sex==1,lcolor(gs4)) ///
	(scatter mx_1000 year if sex==1,mfcolor(gs4) mlcolor(gs4)) ///
	(rspike ub_mx_1000 lb_mx_1000 xaxisw  if sex==2,lcolor(blue)) ///
	(scatter mx_1000 xaxisw  if sex==2,mfcolor(white) mlcolor(blue)) ///
	,xlabel($yearstart(1) $yearend, grid angle(0)) ///
	ylabel(0 (1) 14,grid angle(0)) ///
	ytitle("Mortality per 1000 person years",height(3) ) ///
	xtitle("Year",height(3) ) ///
	legend(order(2 "Male" 1 "95% CI:Male" 4 "Female" 3 "95% CI:Female") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	title("Overall Mortality: `site'") ///
	graphregion(color(white)) name(${sitename}_mx_sex_year,replace) 
	graph save "${graphs}/${sitename}_mx_sex_year.gph", replace
	graph export "${graphs}/${sitename}_mx_sex_year.pdf", replace
	graph export "${graphs}/${sitename}_mx_sex_year.png", replace
	graph export "${graphs}/${sitename}_mx_sex_year.tif", replace
