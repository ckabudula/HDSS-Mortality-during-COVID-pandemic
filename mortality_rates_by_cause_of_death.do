local site = "${site}"

/* calculate deaths, person years and mortality rates */
foreach x of numlist 1(1)12 70 {
use "${data}/${sitename}_RawCensoredEpisodes_with_cod", clear
drop age_death-Period //drop variables not needed

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				STSET WITH DEATH FROM SPECIFIC BROAD CAUSE GROUP AS THE FAILURE		 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
stset enddate, id(individualid) failure(cause_broad_ncd == `x') time0(startdate) origin(dob) scale(365.25)
count if _t0 >= _t
drop if _t0 >= _t

//split on year
stsplit year, after((mdy(01,01,$yearstart)))  every(1)
replace year = year + $yearstart
tab year

//create time periods
recode year (2016/2017=1) (2018/2019=2)  (2020/2021=3), gen(Period)

//br individualid dob startdate enddate _origin _t _t0 year Period

//create 5 year age groups
stsplit agegrp, at(0(5)100) trim
label define agrps 0 "0-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" ///
	30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 50 "50-54" 55 "55-59" 60 "60-64" ///
	65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" 85 "85-89" 90 "90-94" 95 "95-99" 100 "100+" 
label values agegrp agrps

//create standard WHO  age groups
recode agegrp (0/4=0) (5/14=5) (15/49=15) (50/64=50) ///
	(65/max=65), gen(agegrp_who)
	
//mortality by broad cause of death categories

drop if ! inlist(Period, 1,2,3)
strate agegrp_who Period, output("${data}/${sitename}_py_mx_by_cod`x'",replace) nolist

/* look at death rates */
use "${data}/${sitename}_py_mx_by_cod`x'", clear
format _Y %9.0g
gen cause_broad_ncd = `x'
sort agegrp_who Period 
* correct for DAYS time scale
replace _Y = _Y
replace _Rate = _Rate
replace _Lower = _Lower
replace _Upper = _Upper
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
save "${data}/${sitename}_py_mx_by_cod`x'", replace
}

//combine the data files
use "${data}/${sitename}_py_mx_by_cod1", clear
save  "${data}/${sitename}_py_mx_by_cod", replace
foreach x of numlist 2(1)12 70 {
	use "${data}/${sitename}_py_mx_by_cod`x'", clear
	append using  "${data}/${sitename}_py_mx_by_cod"
	save  "${data}/${sitename}_py_mx_by_cod", replace
}
cap label define cause_broad_ncd_lbl 1 "HIV/AIDS and TB" 2 "Other infectious diseases" ///
								3 "Neoplasms" 4 "Metabolic" ///
								5 "Cardiovascular" 6 "Respiratory" 7 "Abdominal" ///
								8 "Neurological" 9 "Maternal" 10 "Neonatal" 11 "Other NCD" ///
								12 "External causes" 70 "Indeterminate"
label values cause_broad_ncd cause_broad_ncd_lbl
save  "${data}/${sitename}_py_mx_by_cod", replace


*Graph the data
use "${data}/${sitename}_py_mx_by_cod", clear
keep Period agegrp_who mx_1000 cause_broad_ncd
rename mx_1000 csmr
reshape wide csmr, i(agegrp_who Period) j(cause_broad_ncd)
foreach var of varlist csmr* {
	replace `var'=0 if `var'==.
}
sort Period agegrp_who
bys Period: gen age_grp_no = _n 

//replace disease categories not in the CoD data with zeros

forvalues  i = 1/12 {
	cap confirm variable csmr`i'
	if _rc>0 {
		gen csmr`i' = 0
	}
}

cap label define period_lbl 1 "2016-2017" 2 "2018-2019"  3 "2020-2021"
label values Period period_lbl

cap label define age_lbl 0 "0-4 years" 5 "5-14 years" ///
		15 "15-49 years" 50 "50-64 years" 65 "65+ years"
label values agegrp_who age_lbl

gen base=0
gen l1=base+csmr1 //"HIV/AIDS and TB"
gen l2=l1+csmr2 //"Other infectious diseases"
gen l3=l2+csmr10 //"Neonatal"
gen l4=l3+csmr9 //"Maternal"
gen l5=l4+csmr3 //"Neoplasms"
gen l6=l5+csmr4 //"Metabolic"
gen l7=l6+csmr5 //"Cardiovascular"
gen l8=l7+csmr6 //"Respiratory"
gen l9=l8+csmr7 //"Abdominal"
gen l10=l9+csmr8 //"Neurological"
gen l11=l10+csmr11 //"Other NCD"
gen l12=l11+csmr12  // "External causes"
gen l13=l12+csmr70  // "Indeterminate"

twoway (rbar base l1  age_grp_no if Period==1, color(cranberry) barw(.5)) ///
	(rbar l1 l2 age_grp_no if Period==1, color(orange_red) barw(.5)) ///
	(rbar l2 l3 age_grp_no if Period==1, color(red) barw(.5)) ///
	(rbar l3 l4 age_grp_no if Period==1,color(eltgreen) barw(.5)) /// 
	(rbar l4 l5 age_grp_no if Period==1,color(edkblue) barw(.5)) ///
	(rbar l5 l6 age_grp_no if Period==1,color(dkgreen) barw(.5)) ///
	(rbar l6 l7 age_grp_no if Period==1,color(green) barw(.5)) ///
	(rbar l7 l8 age_grp_no if Period==1,color(cyan) barw(.5)) ///
	(rbar l8 l9 age_grp_no if Period==1,color(lime) barw(.5)) ///
	(rbar l9 l10 age_grp_no if Period==1,color(gold) barw(.5)) ///
	(rbar l10 l11 age_grp_no if Period==1,color(maroon) barw(.5)) ///
	(rbar l11 l12 age_grp_no if Period==1,color(pink) barw(.5)) ///
	(rbar l12 l13 age_grp_no if Period==1,color(gray) barw(.5)) ///
	,xlabel(1 "0-4" 2 "5-14" ///
		3 "15-49" 4 "50-64" 5 "65+", angle(0) nogrid) ///
	ylab(0(10)50, gmax angle(horizontal)) ///
	yscale(on) ///
	ytitle("Mortality rate per 1,000 person-years", size(small)) ///
	xtitle("Age group") ///
	legend(order(13 "Indeterminate" 12 "External causes"  11 "Other NCD" 10 "Neurological" /// 
				9 "Abdominal" 8 "Respiratory" 7 "Cardiovascular"   6 "Metabolic" 5 "Neoplasms" ///
				  4 "Maternal"  3 "Neonatal" 2 "Other infectious" 1 "HIV/AIDS and TB") ///
		region(lwidth(0) lcolor(white)) position(3) ///
		ring(1) size(vsmall) cols(1) colgap(1) symxsize(4)) ///
	title("`site', 2016-2017",  size(*1)) ///
	graphregion(color(white)) name(csmf_cause_broad_by_age_2016,replace) 
	graph save "${graphs}/${sitename}_csmr_cause_broad_by_age_2016.gph", replace
graph export "${graphs}/${sitename}_csmr_cause_broad_by_age_2016.tif", replace

twoway (rbar base l1  age_grp_no if Period==2, color(cranberry) barw(.5)) ///
	(rbar l1 l2 age_grp_no if Period==2, color(orange_red) barw(.5)) ///
	(rbar l2 l3 age_grp_no if Period==2, color(red) barw(.5)) ///
	(rbar l3 l4 age_grp_no if Period==2,color(eltgreen) barw(.5)) /// 
	(rbar l4 l5 age_grp_no if Period==2,color(edkblue) barw(.5)) ///
	(rbar l5 l6 age_grp_no if Period==2,color(dkgreen) barw(.5)) ///
	(rbar l6 l7 age_grp_no if Period==2,color(green) barw(.5)) ///
	(rbar l7 l8 age_grp_no if Period==2,color(cyan) barw(.5)) ///
	(rbar l8 l9 age_grp_no if Period==2,color(lime) barw(.5)) ///
	(rbar l9 l10 age_grp_no if Period==2,color(gold) barw(.5)) ///
	(rbar l10 l11 age_grp_no if Period==2,color(maroon) barw(.5)) ///
	(rbar l11 l12 age_grp_no if Period==2,color(pink) barw(.5)) ///
	(rbar l12 l13 age_grp_no if Period==2,color(gray) barw(.5)) ///
	,xlabel(1 "0-4" 2 "5-14" ///
		3 "15-49" 4 "50-64" 5 "65+", angle(0) nogrid) ///
	ylab(0(10)50, gmax angle(horizontal)) ///
	yscale(on) ///
	ytitle("Mortality rate per 1,000 person-years", size(small)) ///
	xtitle("Age group") ///
	legend(order(13 "Indeterminate" 12 "External causes"  11 "Other NCD" 10 "Neurological" /// 
				9 "Abdominal" 8 "Respiratory" 7 "Cardiovascular"   6 "Metabolic" 5 "Neoplasms" ///
				  4 "Maternal"  3 "Neonatal" 2 "Other infectious" 1 "HIV/AIDS and TB") ///
		region(lwidth(0) lcolor(white)) position(3) ///
		ring(1) size(vsmall) cols(1) colgap(1) symxsize(4)) ///
	title("`site', 2018-2019",  size(*1)) ///
	graphregion(color(white)) name(csmf_cause_broad_by_age_2018,replace) 
	graph save "${graphs}/${sitename}_csmr_cause_broad_by_age_2018.gph", replace
graph export "${graphs}/${sitename}_csmr_cause_broad_by_age_2018.tif", replace

twoway (rbar base l1  age_grp_no if Period==3, color(cranberry) barw(.5)) ///
	(rbar l1 l2 age_grp_no if Period==3, color(orange_red) barw(.5)) ///
	(rbar l2 l3 age_grp_no if Period==3, color(red) barw(.5)) ///
	(rbar l3 l4 age_grp_no if Period==3,color(eltgreen) barw(.5)) /// 
	(rbar l4 l5 age_grp_no if Period==3,color(edkblue) barw(.5)) ///
	(rbar l5 l6 age_grp_no if Period==3,color(dkgreen) barw(.5)) ///
	(rbar l6 l7 age_grp_no if Period==3,color(green) barw(.5)) ///
	(rbar l7 l8 age_grp_no if Period==3,color(cyan) barw(.5)) ///
	(rbar l8 l9 age_grp_no if Period==3,color(lime) barw(.5)) ///
	(rbar l9 l10 age_grp_no if Period==3,color(gold) barw(.5)) ///
	(rbar l10 l11 age_grp_no if Period==3,color(maroon) barw(.5)) ///
	(rbar l11 l12 age_grp_no if Period==3,color(pink) barw(.5)) ///
	(rbar l12 l13 age_grp_no if Period==3,color(gray) barw(.5)) ///
	,xlabel(1 "0-4" 2 "5-14" ///
		3 "15-49" 4 "50-64" 5 "65+", angle(0) nogrid) ///
	ylab(0(10)50, gmax angle(horizontal)) ///
	yscale(on) ///
	ytitle("Mortality rate per 1,000 person-years", size(small)) ///
	xtitle("Age group") ///
	legend(order(13 "Indeterminate" 12 "External causes"  11 "Other NCD" 10 "Neurological" /// 
				9 "Abdominal" 8 "Respiratory" 7 "Cardiovascular"   6 "Metabolic" 5 "Neoplasms" ///
				  4 "Maternal"  3 "Neonatal" 2 "Other infectious" 1 "HIV/AIDS and TB") ///
		region(lwidth(0) lcolor(white)) position(3) ///
		ring(1) size(vsmall) cols(1) colgap(1) symxsize(4)) ///
	title("`site', 2020-2021",  size(*1)) ///
	graphregion(color(white)) name(csmf_cause_broad_by_age_2020,replace) 
	graph save "${graphs}/${sitename}_csmr_cause_broad_by_age_2020.gph", replace
graph export "${graphs}/${sitename}_csmr_cause_broad_by_age_2020.tif", replace


//combine graphs
graph combine "${graphs}/${sitename}_csmr_cause_broad_by_age_2016.gph" ///
"${graphs}/${sitename}_csmr_cause_broad_by_age_2018.gph" ///
"${graphs}/${sitename}_csmr_cause_broad_by_age_2020.gph", ///
r(3) iscale(*.7) imargin(0 0 0 0) scheme(s1color) ycommon xcommon ysize(14) xsize(10)
graph export "${graphs}/${sitename}_csmr_cause_broad_by_age.pdf", replace
graph export "${graphs}/${sitename}_csmr_cause_broad_by_age.pdf", replace
graph export "${graphs}/${sitename}_csmr_cause_broad_by_age.png", replace
graph export "${graphs}/${sitename}_csmr_cause_broad_by_age.tif", replace

twoway (rbar base l1  Period, by(agegrp_who, yrescale note("") title("`site'",  size(*1))) color(cranberry) barw(.5)) ///
	 (rbar l1 l2 Period, color(orange_red) barw(.5)) ///
	(rbar l2 l3 Period, color(red) barw(.5)) ///
	(rbar l3 l4 Period,color(eltgreen) barw(.5)) /// 
	(rbar l4 l5 Period,color(edkblue) barw(.5)) ///
	(rbar l5 l6 Period,color(dkgreen) barw(.5)) ///
	(rbar l6 l7 Period,color(green) barw(.5)) ///
	(rbar l7 l8 Period,color(cyan) barw(.5)) ///
	(rbar l8 l9 Period,color(lime) barw(.5)) ///
	(rbar l9 l10 Period,color(gold) barw(.5)) ///
	(rbar l10 l11 Period,color(maroon) barw(.5)) ///
	(rbar l11 l12 Period,color(pink) barw(.5)) ///
	(rbar l12 l13 Period,color(gray) barw(.5)) ///
	,xlabel(1 "2016-2017" 2 "2018-2019" 3 "2020-2021", angle(45) nogrid) ///
	ytitle("Mortality rate per 1,000 person-years", size(small)) ///
	xtitle("Time period") ///
	legend(order(13 "Indeterminate" 12 "External causes"  11 "Other NCD" 10 "Neurological" /// 
				9 "Abdominal" 8 "Respiratory" 7 "Cardiovascular"   6 "Metabolic" 5 "Neoplasms" ///
				  4 "Maternal"  3 "Neonatal" 2 "Other infectious" 1 "HIV/AIDS and TB") ///
		region(lwidth(0) lcolor(white)) position(3) ///
		ring(1) size(vsmall) cols(1) colgap(1) symxsize(4)) ///
	graphregion(color(white)) name(csmf_cause_broad_by_period,replace) 
	graph save "${graphs}/${sitename}_csmr_cause_broad_by_period.gph", replace
graph export "${graphs}/${sitename}_csmr_cause_broad_by_period.tif", replace

