local site = "${site}"
********************************************************************************
*DESCRIPTIVE INFORMATION ON THE NUMBER OF DEATHS WITH VA 
********************************************************************************
use "${data}/${sitename}_RawCensoredEpisodes_with_cod", clear

*LOOK AT VA COVERAGE OF DEATHS 
tab va_done
foreach myvar in age_death_grp_who SexCode {
tab va_done `myvar' if died == 1, col
}

tab cause_broad_ncd if va_done == 1 

tab cause_broad_ncd sex if va_done == 1
tab cause_broad_ncd if va_done == 1 & sex ==1
tab cause_broad_ncd if va_done == 1 & sex ==0

*CREATE A TABLE WITH THE RESULTS YOU HAVE JUST LOOKED AT
global myvarlist sex 

tempname out_file

file open `out_file' using "${output}/${sitename}_num_deaths_by_age.txt",write replace
*pass file handle to this sub do file
global out_file="`out_file'"

file write ${out_file} "Number of deaths with a VA by participant characteristics" _n

*write column headings
file write ${out_file} _tab "All participants" _tab "0-4" _tab "5-14" _tab "15-49" _tab "50-64"  _tab "65+" _n


levels age_death_grp_who,local(alist)

*OVERALL  
file write ${out_file} "Overall"
count if va_done==1 & died==1
local tot = r(N) 
file write ${out_file} _tab ("`tot'") 

foreach a in `alist' {
count if va_done==1 & age_death_grp_who==`a' & died==1 
local tot = r(N) 
file write ${out_file} _tab ("`tot'")
}
file write ${out_file} _n _n

*TOTALS FOR OTHER VARIABLES 

**variables to look at 
 foreach myvar of varlist $myvarlist {

**write variable name in first column
	local myvarlab: variable label `myvar' 
	file write ${out_file}  ("`myvarlab'")  _n
	
**local macros of level of variables
levels `myvar',local(vlist)

**write status in left col under study name
	foreach x in `vlist' {
		local xname: label (`myvar') `x' 
		file write ${out_file} ("`xname'") 

count if va_done==1 & died==1 & `myvar'==`x'
local tot = r(N) 
count if va_done==1 & died==1 
local denom = r(N)
local res: disp %4.1f (`tot'/`denom'*100)
file write ${out_file} _tab ("`tot' (`res')")

foreach a in `alist' {
count if va_done==1 & age_death_grp_who==`a' & died==1 & `myvar'==`x'
local tot = r(N) 
count if va_done==1 & age_death_grp_who==`a' & died==1  
local denom = r(N)
local res: disp %4.1f (`tot'/`denom'*100)
file write ${out_file} _tab ("`tot' (`res')")
} /*close age loop*/
file write ${out_file} _n

} /*end of within variable loop*/

file write ${out_file} _n

} /*end of variable loop*/

noi di as txt `"(output written to {browse "${output}/${sitename}_num_deaths_by_age.txt"})"'


*VA COVERAGE
tempname out_file

global myvarlist age_death_grp_who SexCode 
file open `out_file' using "${output}/${sitename}_va_coverage.txt",write replace
*pass file handle to this sub do file
global out_file="`out_file'"

file write ${out_file} "Coverage of verbal autopsy" _n

*write column headings
file write ${out_file} _tab "Number of deaths in HDSS" 
file write ${out_file} _tab "Number of deaths with a verbal autopsy" 

file write ${out_file} _n

*OVERALL 
file write ${out_file} "Overall" 
	
count if died==1 
local tot = r(N) 
count if va_done==1 & died==1 
local num = r(N) 
local res: disp %4.1f (`num'/`tot'*100)
file write ${out_file} _tab ("`tot'") _tab ("`num' (`res')") 

file write ${out_file} _n

*TOTALS FOR OTHER VARIABLES 

**variables to look at 
 foreach myvar of varlist $myvarlist {

	**write variable name in first column
	local myvarlab: variable label `myvar' 
	file write ${out_file}  ("`myvarlab'")  _n
	
	**local macros of level of variables
	levels `myvar',local(vlist)

	**write status in left col under study name
	foreach x in `vlist' {
	
		local xname: label (`myvar') `x' 
		file write ${out_file} ("`xname'") 
		
		count if died==1 & `myvar'==`x'
		local tot = r(N) 
		count if va_done==1 & died==1 & `myvar'==`x'
		local num = r(N) 
		local res: disp %4.1f (`num'/`tot'*100)
		file write ${out_file} _tab ("`tot'") _tab ("`num' (`res')")

		file write ${out_file} _n

	} /*end of within variable loop*/
	
file write ${out_file} _n

} /*end of variable loop*/

noi di as txt `"(output written to {browse "${output}/${sitename}_va_coverage.txt"})"'


use "${data}/${sitename}_RawCensoredEpisodes_with_cod", clear
collapse (sum) lik1 if died == 1 & va_done ==1 & causen!=0, by(causen SexCode age_death_grp_who Period)
rename lik1 lik
save "${data}/${sitename}_lik1_age_sex", replace

use "${data}/${sitename}_RawCensoredEpisodes_with_cod", clear
collapse (sum) lik2 if died == 1 & va_done & causen2>0 & causen!=0, by(causen2 SexCode age_death_grp_who Period)
rename causen2 causen
rename lik2 lik
drop if causen == .
save "${data}/${sitename}_lik2_age_sex", replace

use "${data}/${sitename}_RawCensoredEpisodes_with_cod", clear
collapse (sum) lik3 if died == 1 & va_done & causen3>0 & causen!=0, by(causen3 SexCode age_death_grp_who Period)
rename causen3 causen
rename lik3 lik
drop if causen == .
save "${data}/${sitename}_lik3_age_sex", replace

use "${data}/${sitename}_RawCensoredEpisodes_with_cod", clear
collapse (sum) resid_lik if died == 1 & va_done & causen!=0, by(SexCode age_death_grp_who Period)
gen causen=70
rename resid_lik lik
save "${data}/${sitename}_lik4_age_sex", replace

use "${data}/${sitename}_lik1_age_sex", replace
append using "${data}/${sitename}_lik2_age_sex"
append using "${data}/${sitename}_lik3_age_sex"
append using "${data}/${sitename}_lik4_age_sex"
egen lik_tot = total(lik)

collapse (sum) lik, by(causen SexCode age_death_grp_who Period)
replace lik=lik
gen cause_broad = causen
recode cause_broad 1/2=3 3=1 4/8=3 9=2 10/13=3 14/19=4 20/22=5 23/26=6 27/28=7 29/31=8 /// 
					32=9 61=12 33/41 = 10 42/49=11 50/60=13

cap label define cause_broad_lbl 1 "HIV/AIDS" ///
							 2 "TB"  ///
							 3 "Other infectious diseases" ///
							 4 "Neoplasms" 5 "Metabolic" ///
							 6 "Cardiovascular" 7 "Respiratory" 8 "Abdominal" ///
							 9 "Neurological" 10 "Maternal" 11 "Neonatal" 12 "Other NCD" ///
							13 "External causes" 70 "Indeterminate"
label values cause_broad cause_broad_lbl

gen cause_broad2 = causen
recode cause_broad2 1/2=2 3=1 4/8=2 9=1 10/13=2 14/19=3 20/22=4 23/26=5 27/28=6 29/31=7 /// 
					32=8 61=11 33/41 = 9 42/49=10 50/60=12
cap label define cause_broad2_lbl 1 "HIV/AIDS and TB" 2 "Other infectious diseases" ///
								3 "Neoplasms" 4 "Metabolic" ///
								5 "Cardiovascular" 6 "Respiratory" 7 "Abdominal" ///
								8 "Neurological" 9 "Maternal" 10 "Neonatal" 11 "Other NCD" ///
								12 "External causes" 70 "Indeterminate"
label values cause_broad2 cause_broad2_lbl

*GENERATE A BROAD CAUSE CATEGORY WITH NCDS BROKEN INTO SLIGTHLY DIFFERENT GROUPS
gen cause_broad_ncd = causen
recode cause_broad_ncd 1/2=2 3=1 4/8=2 9=1 10/13=2 14/19=3 20/21=11 22=4 23/24=5 25=11 26=5 27/28=6 29/31=7 /// 
					32=8 61=11 33/41=9 42/49=10 50/60=12
cap label define cause_broad_ncd_lbl 1 "HIV/AIDS and TB" 2 "Other infectious diseases" ///
								3 "Neoplasms" 4 "Metabolic" ///
								5 "Cardiovascular" 6 "Respiratory" 7 "Abdominal" ///
								8 "Neurological" 9 "Maternal" 10 "Neonatal" 11 "Other NCD" ///
								12 "External causes" 70 "Indeterminate"
label values cause_broad_ncd cause_broad_ncd_lbl

*GENERATE A BROAD CAUSE CATEGORY WITH CARDIOMETABOLIC DISEASE GROUP
gen cause_broad_cmd = causen
recode cause_broad_cmd 1/2=2 3=1 4/8=2 9=1 10/13=2 14/19=3 20/21=10 22=4 23/24=4 25=10 26=4 27/28=5 29/31=6 /// 
					32=7 61=10 33/41=8 42/49=9 50/60=11
cap label define cause_broad_cmd_lbl 1 "HIV/AIDS and TB" 2 "Other infectious diseases" ///
								3 "Neoplasms" 4 "Cardiometabolic" ///
								5 "Respiratory" 6 "Abdominal" ///
								7 "Neurological" 8 "Maternal" 9 "Neonatal" 10 "Other NCD" ///
								11 "External causes" 70 "Indeterminate"
label values cause_broad_cmd cause_broad_cmd_lbl

*GENERATE A BROAD CAUSE CATEGORY WITH CARDIOMETABOLIC DISEASE GROUP
gen cause_broad_cmd_ncd = causen
recode cause_broad_cmd_ncd 1/2=2 3=1 4/8=2 9=1 10/13=2 14/19=6 20/21=6 22=5 23/24=5 25=6 26=5 27/28=6 29/31=6 /// 
					32=6 61=6 33/41=3 42/49=4 50/60=7
cap label define cause_broad_cmd_ncd_lbl 1 "HIV/AIDS and TB" 2 "Other infectious diseases" ///
								 3 "Maternal" 4 "Neonatal" 5 "Cardiometabolic" 6 "Other NCD" ///
								 7 "External causes" 70 "Indeterminate"
label values cause_broad_cmd_ncd cause_broad_cmd_ncd_lbl
save "${data}/${sitename}_likout_age_sex", replace


********************************************************************************
*PROPORTION OF DEATHS
*OVERALL AND BY AGE AND SEX 
********************************************************************************

*CSMF 
use "${data}/${sitename}_likout_age_sex", clear
drop if causen==70
*Calculate number of individuals 
egen likround=total(lik)
*Calculate the CSMF by dividing likelihood of death by total 
gen csmfr=100*lik/likround
*Sum the CSMF from each individual within each age group to give the overall
*population CSMF 
collapse (sum) csmfr, by(cause_broad_cmd_ncd Period)
sort cause_broad
save "${output}/${sitename}_csmf_cause_broad", replace

*CSMF STRATIFIED BY BROAD AGE GROUPS
use "${data}/${sitename}_likout_age_sex", clear
drop if causen==70
*Calculate number of individuals in each group (age group) 
egen likround=total(lik), by(age_death_grp_who Period)
*Calculate the CSMF by dividing likelihood of death by total in each group
*i.e. if an individual aged 40-49 has a likelihood of 0.93 (93%) for TB, 
*and there are 308 individuals in the group then they represent 0.30 of a
*the total CSMF for the group
gen csmfr=100*lik/likround
*Sum the CSMF from each individual within each age group to give the overall
*population CSMF 
collapse (sum) csmfr, by(cause_broad_ncd age_death_grp_who Period)
sort age_death_grp_who Period cause_broad_ncd
tab cause_broad_ncd age_death_grp_who 
save "${output}/${sitename}_csmf_cause_broad_by_age", replace

*Graph the data
/*
use "${output}/${sitename}_csmf_cause_broad_by_age", clear
#delimit ;
graph bar (mean) csmfr if inlist(Period,1,2,3), 
over(cause_broad_ncd) by(Period) asyvars stack 
over(age_death_grp_who)
nofill
xsize(10) ysize(5)
ytitle("Percentage of deaths")  
ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", gmax angle(horizontal))
bar(1, fcolor(cranberry) lcolor(black))
bar(2, fcolor(orange_red) lcolor(black))  
bar(3, fcolor(orange_red*0.7) lcolor(black)) 
bar(4, fcolor(eltgreen) lcolor(black))
bar(5, fcolor(edkblue) lcolor(black))
bar(6, fcolor(gray) lcolor(black))  
bar(7, fcolor(green) lcolor(black)) 
bar(8, fcolor(cyan) lcolor(black)) 
bar(9, fcolor(lime) lcolor(black)) 
bar(10, fcolor(gold) lcolor(black)) 
bar(11, fcolor(maroon) lcolor(black)) 
bar(12, fcolor(pink) lcolor(black)) 
legend(order(12 11 10 9 8 7 6 5 4 3 2 1) keygap(1) cols(1) symxsize(4) symysize(4) size(small) position(6) region(lcolor(none) margin(zero)))
  graphregion(fcolor(white) ifcolor(white))  
  ; 
#delimit cr
graph export "${graphs}/${sitename}_csmf_cause_broad_by_age.tif",replace
*/


*Graph the data
use "${output}/${sitename}_csmf_cause_broad_by_age", clear
drop if ! inlist(Period,1,2,3)
reshape wide csmfr, i(age_death_grp_who Period) j(cause_broad_ncd)
foreach var of varlist csmfr* {
	replace `var'=0 if `var'==.
}
sort Period age_death_grp_who
bys Period: gen age_grp_no = _n 

//replace disease categories not in the CoD data with zeros

forvalues  i = 1/12 {
	cap confirm variable csmfr`i'
	if _rc>0 {
		gen csmfr`i' = 0
	}
}

gen base=0
gen l1=base+csmfr1 //"HIV/AIDS and TB"
gen l2=l1+csmfr2 //"Other infectious diseases"
gen l3=l2+csmfr10 //"Neonatal"
gen l4=l3+csmfr9 //"Maternal"
gen l5=l4+csmfr3 //"Neoplasms"
gen l6=l5+csmfr4 //"Metabolic"
gen l7=l6+csmfr5 //"Cardiovascular"
gen l8=l7+csmfr6 //"Respiratory"
gen l9=l8+csmfr7 //"Abdominal"
gen l10=l9+csmfr8 //"Neurological"
gen l11=l10+csmfr11 //"Other NCD"
gen l12=l11+csmfr12  // "External causes"

twoway (rbar base l1  age_grp_no if Period==1, color(cranberry) barw(.5)) ///
	(rbar l1 l2 age_grp_no if Period==1, color(orange_red) barw(.5)) ///
	(rbar l2 l3 age_grp_no if Period==1, color(orange_red*0.6) barw(.5)) ///
	(rbar l3 l4 age_grp_no if Period==1,color(eltgreen) barw(.5)) /// 
	(rbar l4 l5 age_grp_no if Period==1,color(edkblue) barw(.5)) ///
	(rbar l5 l6 age_grp_no if Period==1,color(gray) barw(.5)) ///
	(rbar l6 l7 age_grp_no if Period==1,color(green) barw(.5)) ///
	(rbar l7 l8 age_grp_no if Period==1,color(cyan) barw(.5)) ///
	(rbar l8 l9 age_grp_no if Period==1,color(lime) barw(.5)) ///
	(rbar l9 l10 age_grp_no if Period==1,color(gold) barw(.5)) ///
	(rbar l10 l11 age_grp_no if Period==1,color(maroon) barw(.5)) ///
	(rbar l11 l12 age_grp_no if Period==1,color(pink) barw(.5)) ///
	,xlabel(1 "0-4" 2 "5-14" ///
		3 "15-49" 4 "50-64" 5 "65+", angle(0) nogrid) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", gmax angle(horizontal)) ///
	yscale(on) ///
	ytitle("Percentage of deaths", size(small)) ///
	xtitle("Age group") ///
	legend(order(12 "External causes"  11 "Other NCD" 10 "Neurological" 9 "Abdominal" ///
				8 "Respiratory" 7 "Cardiovascular"   6 "Metabolic" 5 "Neoplasms"  ///
				  4 "Maternal"  3 "Neonatal" 2 "Other infectious" 1 "HIV/AIDS and TB") ///
		region(lwidth(0) lcolor(white)) position(3) ///
		ring(1) size(vsmall) cols(1) colgap(1) symxsize(4)) ///
	title("`site', 2016-2017",  size(*1)) ///
	graphregion(color(white)) name(csmf_cause_broad_by_age_2016,replace) 
	graph save "${graphs}/${sitename}_csmf_cause_broad_by_age_2016.gph", replace
graph export "${graphs}/${sitename}_csmf_cause_broad_by_age_2016.tif", replace

twoway (rbar base l1  age_grp_no if Period==2, color(cranberry) barw(.5)) ///
	(rbar l1 l2 age_grp_no if Period==2, color(orange_red) barw(.5)) ///
	(rbar l2 l3 age_grp_no if Period==2, color(orange_red*0.6) barw(.5)) ///
	(rbar l3 l4 age_grp_no if Period==2,color(eltgreen) barw(.5)) /// 
	(rbar l4 l5 age_grp_no if Period==2,color(edkblue) barw(.5)) ///
	(rbar l5 l6 age_grp_no if Period==2,color(gray) barw(.5)) ///
	(rbar l6 l7 age_grp_no if Period==2,color(green) barw(.5)) ///
	(rbar l7 l8 age_grp_no if Period==2,color(cyan) barw(.5)) ///
	(rbar l8 l9 age_grp_no if Period==2,color(lime) barw(.5)) ///
	(rbar l9 l10 age_grp_no if Period==2,color(gold) barw(.5)) ///
	(rbar l10 l11 age_grp_no if Period==2,color(maroon) barw(.5)) ///
	(rbar l11 l12 age_grp_no if Period==2,color(pink) barw(.5)) ///
	,xlabel(1 "0-4" 2 "5-14" ///
		3 "15-49" 4 "50-64" 5 "65+", angle(0) nogrid) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", gmax angle(horizontal)) ///
	yscale(on) ///
	ytitle("Percentage of deaths", size(small)) ///
	xtitle("Age group") ///
	legend(order(12 "External causes"  11 "Other NCD" 10 "Neurological" 9 "Abdominal" ///
				8 "Respiratory" 7 "Cardiovascular"   6 "Metabolic" 5 "Neoplasms"  ///
				  4 "Maternal"  3 "Neonatal" 2 "Other infectious" 1 "HIV/AIDS and TB") ///
		region(lwidth(0) lcolor(white)) position(3) ///
		ring(1) size(vsmall) cols(1) colgap(1) symxsize(4)) ///
	title("`site', 2018-2019",  size(*1)) ///
	graphregion(color(white)) name(csmf_cause_broad_by_age_2018,replace) 
	graph save "${graphs}/${sitename}_csmf_cause_broad_by_age_2018.gph", replace
graph export "${graphs}/${sitename}_csmf_cause_broad_by_age_2018.tif", replace

twoway (rbar base l1  age_grp_no if Period==3, color(cranberry) barw(.5)) ///
	(rbar l1 l2 age_grp_no if Period==3, color(orange_red) barw(.5)) ///
	(rbar l2 l3 age_grp_no if Period==3, color(orange_red*0.6) barw(.5)) ///
	(rbar l3 l4 age_grp_no if Period==3,color(eltgreen) barw(.5)) /// 
	(rbar l4 l5 age_grp_no if Period==3,color(edkblue) barw(.5)) ///
	(rbar l5 l6 age_grp_no if Period==3,color(gray) barw(.5)) ///
	(rbar l6 l7 age_grp_no if Period==3,color(green) barw(.5)) ///
	(rbar l7 l8 age_grp_no if Period==3,color(cyan) barw(.5)) ///
	(rbar l8 l9 age_grp_no if Period==3,color(lime) barw(.5)) ///
	(rbar l9 l10 age_grp_no if Period==3,color(gold) barw(.5)) ///
	(rbar l10 l11 age_grp_no if Period==3,color(maroon) barw(.5)) ///
	(rbar l11 l12 age_grp_no if Period==3,color(pink) barw(.5)) ///
	,xlabel(1 "0-4" 2 "5-14" ///
		3 "15-49" 4 "50-64" 5 "65+", angle(0) nogrid) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", gmax angle(horizontal)) ///
	yscale(on) ///
	ytitle("Percentage of deaths", size(small)) ///
	xtitle("Age group") ///
	legend(order(12 "External causes"  11 "Other NCD" 10 "Neurological" 9 "Abdominal" ///
				8 "Respiratory" 7 "Cardiovascular"   6 "Metabolic" 5 "Neoplasms"  ///
				  4 "Maternal"  3 "Neonatal" 2 "Other infectious" 1 "HIV/AIDS and TB") ///
		region(lwidth(0) lcolor(white)) position(3) ///
		ring(1) size(vsmall) cols(1) colgap(1) symxsize(4)) ///
	title("`site', 2020-2021",  size(*1)) ///
	graphregion(color(white)) name(csmf_cause_broad_by_age_2020,replace) 
	graph save "${graphs}/${sitename}_csmf_cause_broad_by_age_2020.gph", replace
graph export "${graphs}/${sitename}_csmf_cause_broad_by_age_2020.tif", replace


//combine graphs
graph combine "${graphs}/${sitename}_csmf_cause_broad_by_age_2016.gph" ///
"${graphs}/${sitename}_csmf_cause_broad_by_age_2018.gph" ///
"${graphs}/${sitename}_csmf_cause_broad_by_age_2020.gph", ///
r(3) iscale(*.7) imargin(0 0 0 0) scheme(s1color) ycommon xcommon ysize(14) xsize(10)
graph export "${graphs}/${sitename}_csmf_cause_broad_by_age.pdf", replace
graph export "${graphs}/${sitename}_csmf_cause_broad_by_age.pdf", replace
graph export "${graphs}/${sitename}_csmf_cause_broad_by_age.png", replace
graph export "${graphs}/${sitename}_csmf_cause_broad_by_age.tif", replace
