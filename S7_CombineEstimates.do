//Combine population by who age groups
use "${data}/BD011_py_mx_age", clear 
keep year agegrp_who Deaths PersonYears mx_1000 lb_mx_1000 ub_mx_1000
gen sitename="BD011"
save "${data}/AllSites_person_years_mx_who_age", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_py_mx_age", clear
		keep year agegrp_who Deaths PersonYears mx_1000 lb_mx_1000 ub_mx_1000
		gen sitename="`site'"
		append using "${data}/AllSites_person_years_mx_who_age"
		save "${data}/AllSites_person_years_mx_who_age", replace
	}
merge m:1 sitename using "${data}/Sites"
drop _merge
bys sitename year: egen  PersonYearsTotal = total(PersonYears)
bys sitename year: egen  DeathsTotal = total(Deaths)
gen pop_prop = PersonYears/PersonYearsTotal *100
drop PersonYearsTotal DeathsTotal  
order sitename sitename_location year agegrp_who ///
	PersonYears pop_prop Deaths 
sort sitename year agegrp_who
//export to excel
keep if year <=2021 & !inlist(sitename, "ET042","ET043")
quietly export excel using "${output}/Results.xlsx", sheet("py_mx_by_age")sheetreplace firstrow(variables)

//graph 
graph hbar (mean) pop_prop if year == 2019, /// basic horizontal bar graph command (can make vertical by removing "h")
over(agegrp_who) /// the groups *within* each bar (values seen within bars)
over(sitename_location) /// the sitenames that appear on the axis, identifying each stacked bar
stack asyvars /// commands needed for stacking bars
percentage /// necessary for communicating percentages within each category of second over() variable
bar(1, fcolor(eltgreen) lcolor(black)) ///
bar(2, fcolor(edkblue) lcolor(black)) ///
bar(3, fcolor(gray) lcolor(black)) ///
bar(4, fcolor(green) lcolor(black)) ///
bar(5, fcolor(gold) lcolor(black)) ///
ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", glpattern(solid) glcolor(gs15)) /// add vertical solid light gray lines
blabel(bar, pos(center) format(%3.0f) size(small) color(white)) /// add percentages
legend(order(1 "0-4 years"  2 "5-14 years" 3 "15-49 years" 4 "50-64 years" 5 "65+ years")pos(6) row(1) title("Age Group", size(small) margin(vsmall) box fcolor(gs10) color(white) lcolor(gs10)) size(small)) ///
ytitle(Percent of person years) /// title y-axis
graphregion(margin(small)) /// make region between plot and outer edge of graph size small
xsize(7) ysize(4) // make graph 6.5 inches wide and 4.5 inches tall
graph save "${graphs}/pop_prop_who_2019.gph", replace
graph export "${graphs}/pop_prop_who_2019.pdf", replace
graph export "${graphs}/pop_prop_who_2019.tif", replace
graph export "${graphs}/pop_prop_who_2019.png", replace

//reshape to wide format 
reshape wide PersonYears pop_prop Deaths mx_1000 lb_mx_1000 ub_mx_1000, i(sitename sitename_location year) j(agegrp_who)
sort sitename year 
save "${data}/py_by_who_age_wide", replace
//export to excel
quietly export excel using "${output}/Results.xlsx", sheet("py_mx_by_age_wide")sheetreplace firstrow(variables)

//plot
keep if year ==2019 & !inlist(sitename, "ET042","ET043")
gsort -pop_prop65
gen n = _n
replace n = n *2
gen b0_lab = pop_prop0/2
gen b5 = pop_prop0 + pop_prop5
gen b5_lab = pop_prop0 + (pop_prop5/2)
gen b15 = b5+ pop_prop15 
gen b15_lab = b5+ (pop_prop15/2)
gen b50 = b15+ pop_prop50
gen b50_lab = b15+ (pop_prop50/2)
gen b65 = b50+ pop_prop65
gen b65_lab = b50+ (pop_prop65-0.1)
gen site_label = 0
twoway (bar b65 n, horizontal fcolor(eltgreen) lcolor(eltgreen) barw(1.5) lwidth(*.1)) ///
		(bar b50 n, horizontal fcolor(edkblue) lcolor(edkblue) barw(1.5)lwidth(*.1)) ///
		(bar b15 n, horizontal fcolor(green) lcolor(green) barw(1.5)lwidth(*.1)) ///
		(bar b5 n, horizontal fcolor(eltblue) lcolor(eltblue) barw(1.5)lwidth(*.1)) ///
		(bar pop_prop0 n, horizontal fcolor(gray) lcolor(gray) barw(1.5)lwidth(*.1)) ///
		(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
		(scatter n b0_lab, mlabel(pop_prop0) mlabposition(center) msymbol(i) mlabcolor(white) mlabformat(%3.1f) mlabsize(small)) ///
		(scatter n b5_lab, mlabel(pop_prop5) mlabposition(center) msymbol(i) mlabcolor(white) mlabformat(%3.1f) mlabsize(small)) ///
		(scatter n b15_lab, mlabel(pop_prop15) mlabposition(center) msymbol(i) mlabcolor(white) mlabformat(%3.1f) mlabsize(small)) ///
		(scatter n b50_lab, mlabel(pop_prop50) mlabposition(center) msymbol(i) mlabcolor(white) mlabformat(%3.1f) mlabsize(small)) ///
			(scatter n b65_lab, mlabel(pop_prop65) mlabposition(center) msymbol(i) mlabcolor(black) mlabformat(%2.1f) mlabsize(small)) ///
		,xtitle("Percent of person years", size(small)) ///
text(38 -10 "{bf:HDSS setting}", size(*.9) color(black) just(left)) ///
xscale(range(-25 100)) xlabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", glpattern(solid) glcolor(gs15)) ///
legend(order(1 "0-4 years"  2 "5-14 years" 3 "15-49 years" 4 "50-64 years" 5 "65+ years") pos(6) row(1)  lcolor(gs10) size(small)) ///
yscale(range(1 38)) yscale(off) ///
xsize(7) ysize(4) // make graph 6.5 inches wide and 4.5 inches tall
graph save "${graphs}/pop_prop_who_2019_v2.gph", replace
graph export "${graphs}/pop_prop_who_2019_v2.pdf", replace
graph export "${graphs}/pop_prop_who_2019_v2.tif", replace
graph export "${graphs}/pop_prop_who_2019_v2.png", replace

//reshape to long format 
use "${data}/py_by_who_age_wide", clear
reshape long PersonYears pop_prop Deaths mx_1000 lb_mx_1000 ub_mx_1000, i(sitename sitename_location year) j(agegrp_who)  
//mortality in the pooled dataset
drop if inlist(sitename, "ET042","ET043") | year >2021
collapse (sum) Deaths PersonYears, by(year)
gen mx = (Deaths/PersonYears)*1000
//export to excel
quietly export excel using "${output}/Results.xlsx", sheet("py_mx_all")sheetreplace firstrow(variables)

//Combine population by age groups
use "${data}/BD011_pop_by_gender_5yr_agegrp_all", clear
gen sitename="BD011"
gen total_pop = male_total + female_total
gen pop_prop = py_male_female/total_pop *100
save "${data}/AllSites_pop_by_gender_5yr_agegrp", replace
  
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_pop_by_gender_5yr_agegrp_all", clear
		gen sitename="`site'"
		gen total_pop = male_total + female_total
		gen pop_prop = py_male_female/total_pop *100
		append using "${data}/AllSites_pop_by_gender_5yr_agegrp"
		save "${data}/AllSites_pop_by_gender_5yr_agegrp", replace
	}

use  "${data}/AllSites_pop_by_gender_5yr_agegrp", clear
merge m:1 sitename using "${data}/Sites"
drop _merge
keep sitename sitename_location year agegrp male female py_male_female per_male per_female pop_prop
replace male = -male
order sitename sitename_location year agegrp
sort sitename year agegrp
//export to excel
quietly export excel using "${output}/Results.xlsx", sheet("pop_by_age_gender")sheetreplace firstrow(variables)

use  "${data}/AllSites_pop_by_gender_5yr_agegrp", clear
twoway (scatter pop_prop agegrp if sitename=="ZA031" & year == 2019 ///
			,mcolor(gs7) lcolor(gs7) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="ZA011" & year == 2019 ///
			,mcolor(blue) lcolor(blue) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="ZA021" & year == 2019 ///
			,mcolor(navy) lcolor(navy) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="MZ011" & year == 2019 ///
			,mcolor(green) lcolor(green) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="MW011" & year == 2019 ///
			,mcolor(red) lcolor(red) recast(connected) lpattern(solid)) ///
,xlabel(0 "0-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" ///
	30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 50 "50-54" 55 "55-59" 60 "60-64" ///
	65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" 85 "85-89" 90 "90-94" 95 "95-99" 100 "100+" , nogrid angle(45)) ///
yscale(range(0 18)) ylabel(0 (1) 18,nogrid angle(0)) ///
ytitle("Percentage of population",height(3) ) ///
xtitle("Age",height(3) ) ///
legend(cols(1) position(3) ///
		order(1 "AHRI, South Africa" 2 "Agincourt, South Africa" 3 "Dimamo, South Africa" 4 "Manhica, Mozambique" 5 "Karonga, Malawi") ///
		region(lwidth(0) lcolor(white)) ring(0) size(*1.2)) ///
title("Population distribution by age: Southern Africa") ///
graphregion(color(white)) name(SouthernAfrica_age_structure,replace) 
graph save "${graphs}/SouthernAfrica_age_structure.gph", replace
graph export "${graphs}/SouthernAfrica_age_structure.pdf", replace
graph export "${graphs}/SouthernAfrica_age_structure.png", replace
graph export "${graphs}/SouthernAfrica_age_structure.tif", replace

twoway (scatter pop_prop agegrp if sitename=="TZ021" & year == 2019 ///
			,mcolor(gs7) lcolor(gs7) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="KE021" & year == 2019 ///
			,mcolor(blue) lcolor(blue) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="KE022" & year == 2019 ///
			,mcolor(navy) lcolor(navy) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="UG011" & year == 2019 ///
			,mcolor(green) lcolor(green) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="ET041" & year == 2019 ///
			,mcolor(red) lcolor(red) recast(connected) lpattern(solid)) ///
,xlabel(0 "0-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" ///
	30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 50 "50-54" 55 "55-59" 60 "60-64" ///
	65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" 85 "85-89" 90 "90-94" 95 "95-99" 100 "100+" , nogrid angle(45)) ///
yscale(range(0 18)) ylabel(0 (1) 18,nogrid angle(0)) ///
ytitle("Percentage of population",height(3) ) ///
xtitle("Age",height(3) ) ///
legend(cols(1) position(3) ///
		order(1 "Magu, Tanzania" 2 "Siaya-Karemo, Kenya" 3 "Manyatta, Kenya" 4 "Iganga, Uganda" 5 "Kersa, Ethiopia") ///
		region(lwidth(0) lcolor(white)) ring(0) size(*1.2)) ///
title("Population distribution by age: East Africa") ///
graphregion(color(white)) name(SouthernAfrica_age_structure,replace) 
graph save "${graphs}/EastAfrica_age_structure.gph", replace
graph export "${graphs}/EastAfrica_age_structure.pdf", replace
graph export "${graphs}/EastAfrica_age_structure.png", replace
graph export "${graphs}/EastAfrica_age_structure.tif", replace

twoway (scatter pop_prop agegrp if sitename=="BF021" & year == 2019 ///
			,mcolor(gs7) lcolor(gs7) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="GH011" & year == 2019 ///
			,mcolor(blue) lcolor(blue) recast(connected) lpattern(solid)) ///
,xlabel(0 "0-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" ///
	30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 50 "50-54" 55 "55-59" 60 "60-64" ///
	65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" 85 "85-89" 90 "90-94" 95 "95-99" 100 "100+" , nogrid angle(45)) ///
yscale(range(0 18)) ylabel(0 (1) 18,nogrid angle(0)) ///
ytitle("Percentage of population",height(3) ) ///
xtitle("Age",height(3) ) ///
legend(cols(1) position(3) ///
		order(1 "Nanoro, Burkina Faso" 2 "Navrongo, Ghana" ) ///
		region(lwidth(0) lcolor(white)) ring(0) size(*1.2)) ///
title("Population distribution by age: West Africa") ///
graphregion(color(white)) name(SouthernAfrica_age_structure,replace) 
graph save "${graphs}/WestAfrica_age_structure.gph", replace
graph export "${graphs}/WestAfrica_age_structure.pdf", replace
graph export "${graphs}/WestAfrica_age_structure.png", replace
graph export "${graphs}/WestAfrica_age_structure.tif", replace

twoway (scatter pop_prop agegrp if sitename=="BD011" & year == 2019 ///
			,mcolor(gs7) lcolor(gs7) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="BD013" & year == 2019 ///
			,mcolor(blue) lcolor(blue) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="BD014" & year == 2019 ///
			,mcolor(navy) lcolor(navy) recast(connected) lpattern(solid)) ///
		(scatter pop_prop agegrp if sitename=="IN021" & year == 2019 ///
			,mcolor(green) lcolor(green) recast(connected) lpattern(solid)) ///
,xlabel(0 "0-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" ///
	30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" 50 "50-54" 55 "55-59" 60 "60-64" ///
	65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" 85 "85-89" 90 "90-94" 95 "95-99" 100 "100+" , nogrid angle(45)) ///
yscale(range(0 18)) ylabel(0 (1) 18,nogrid angle(0)) ///
ytitle("Percentage of population",height(3) ) ///
xtitle("Age",height(3) ) ///
legend(cols(1) position(3) ///
		order(1 "Matlab, Bangladesh" 2 "Chakaria, Bangladesh" 3 "Dhaka, Bangladesh" 4 "Vadu, India") ///
		region(lwidth(0) lcolor(white)) ring(0) size(*1.2)) ///
title("Population distribution by age: South Asia") ///
graphregion(color(white)) name(SouthernAfrica_age_structure,replace) 
graph save "${graphs}/SouthAsia_age_structure.gph", replace
graph export "${graphs}/SouthAsia_age_structure.pdf", replace
graph export "${graphs}/SouthAsia_age_structure.png", replace
graph export "${graphs}/SouthAsia_age_structure.tif", replace

graph combine "${graphs}/SouthernAfrica_age_structure.gph" ///
"${graphs}/EastAfrica_age_structure.gph" ///
"${graphs}/WestAfrica_age_structure.gph" ///
"${graphs}/SouthAsia_age_structure.gph", ///
r(2) ycommon xcommon iscale(*.65) imargin(.9 .9 .9 .9) scheme(s1color)
graph export "${graphs}/Age_structure.pdf", replace
graph export "${graphs}/Age_structure.pdf", replace
graph export "${graphs}/Age_structure.png", replace
graph export "${graphs}/Age_structure.tif", replace

	
//Combine age standardized mortality rates
use "${data}/BD011_agestan_mx", replace
gen sitename="BD011"
save "${data}/AllSites_agestan_mx", replace
  
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_agestan_mx", clear
		gen sitename="`site'"
		append using "${data}/AllSites_agestan_mx"
		label values sex sex_lbl
		drop if sitename== "ZA081" & year <2017
		drop if year >2021
		save "${data}/AllSites_agestan_mx", replace
	}

//reshape into wide format
use "${data}/AllSites_agestan_mx", clear
merge m:1 sitename using "${data}/Sites"
drop _merge
label define sex_lbl 0 "both sexes" 1 "male" 2 "female", modify 
label values sex sex_lbl
order sitename sitename_location year sex
sort sitename year sex
quietly export excel using "${output}/Results.xlsx", sheet("standardised_mortality")sheetreplace firstrow(variables)
	
reshape wide agestan_rate agestan_lb agestan_ub, i(sex sitename sitename_location) j(year)
//compute changes between 2019 and 2021; 2019 and 2020; 2020 and 2021
gen rate_diff_15_16 = agestan_rate2016 - agestan_rate2015
gen lb_diff_15_16 = agestan_lb2016 - agestan_rate2015
gen ub_diff_15_16 = agestan_ub2016 - agestan_rate2015

gen rate_diff_16_17 = agestan_rate2017 - agestan_rate2016
gen lb_diff_16_17 = agestan_lb2017 - agestan_rate2016
gen ub_diff_16_17 = agestan_ub2017 - agestan_rate2016

gen rate_diff_17_18 = agestan_rate2018 - agestan_rate2017
gen lb_diff_17_18 = agestan_lb2018 - agestan_rate2017
gen ub_diff_17_18 = agestan_ub2018 - agestan_rate2017

gen rate_diff_18_19 = agestan_rate2019 - agestan_rate2018
gen lb_diff_18_19 = agestan_lb2019 - agestan_rate2018
gen ub_diff_18_19 = agestan_ub2019 - agestan_rate2018

gen rate_diff_19_20 = agestan_rate2020 - agestan_rate2019
gen lb_diff_19_20 = agestan_lb2020 - agestan_rate2019
gen ub_diff_19_20 = agestan_ub2020 - agestan_rate2019

gen rate_diff_20_21 = agestan_rate2021 - agestan_rate2020
gen lb_diff_20_21 = agestan_lb2021 - agestan_rate2020
gen ub_diff_20_21 = agestan_ub2021 - agestan_rate2020

gen rate_diff_19_21 = agestan_rate2021 - agestan_rate2019
gen lb_diff_19_21 = agestan_lb2021 - agestan_rate2019
gen ub_diff_19_21 = agestan_ub2021 - agestan_rate2019

egen rate_diff_15_19 = rowmean(rate_diff_15_16 rate_diff_16_17 rate_diff_17_18 rate_diff_18_19)
egen lb_diff_15_19 = rowmean(lb_diff_15_16 lb_diff_16_17 lb_diff_17_18 lb_diff_18_19)
egen ub_diff_15_19 = rowmean(ub_diff_15_16 ub_diff_16_17 ub_diff_17_18 ub_diff_18_19)
save "${data}/AllSites_agestan_mx_wide", replace

//export to excel
keep sitename sitename_location sex rate_diff_19_20 lb_diff_19_20 ub_diff_19_20 rate_diff_20_21 lb_diff_20_21 ub_diff_20_21 rate_diff_19_21 lb_diff_19_21 ub_diff_19_21 rate_diff_15_19 lb_diff_15_19 ub_diff_15_19
keep if !inlist(sitename, "ET042","ET043")
sort sitename sitename_location sex 
quietly export excel using "${output}/Results.xlsx", sheet("mortality_rate_changes")sheetreplace firstrow(variables)


//Combine under five mortality rates
use  "${data}/BD011_under5_mx", clear
gen sitename="BD011"
save "${data}/AllSites_U5_mx", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_under5_mx", clear
		gen sitename="`site'"
		append using "${data}/AllSites_U5_mx"
		save "${data}/AllSites_U5_mx", replace
	}

use "${data}/AllSites_U5_mx", clear
keep year q0ub q0lb q0_000 sitename
replace q0ub = q0ub * 1000
replace q0lb = q0lb * 1000
rename q0lb mx_lb
rename q0ub mx_ub
rename q0_000 mx
merge m:1 sitename using "${data}/Sites"
drop _merge
order sitename sitename_location year 
sort sitename year 
quietly export excel using "${output}/Results.xlsx", sheet("under_five_mortality")sheetreplace firstrow(variables)

//reshape into wide format
reshape wide mx mx_lb mx_ub, i(sitename sitename_location) j(year)
//compute changes between 2019 and 2021; 2019 and 2020; 2020 and 2021
gen mx_diff_15_16 = mx2016 - mx2015
gen lb_diff_15_16 = mx_lb2016 - mx2015
gen ub_diff_15_16 = mx_ub2016 - mx2015

gen mx_diff_16_17 = mx2017 - mx2016
gen lb_diff_16_17 = mx_lb2017 - mx2016
gen ub_diff_16_17 = mx_ub2017 - mx2016

gen mx_diff_17_18 = mx2018 - mx2017
gen lb_diff_17_18 = mx_lb2018 - mx2017
gen ub_diff_17_18 = mx_ub2018 - mx2017

gen mx_diff_18_19 = mx2019 - mx2018
gen lb_diff_18_19 = mx_lb2019 - mx2018
gen ub_diff_18_19 = mx_ub2019 - mx2018

gen mx_diff_19_20 = mx2020 - mx2019
gen lb_diff_19_20 = mx_lb2020 - mx2019
gen ub_diff_19_20 = mx_ub2020 - mx2019

gen mx_diff_20_21 = mx2021 - mx2020
gen lb_diff_20_21 = mx_lb2021 - mx2020
gen ub_diff_20_21 = mx_ub2021 - mx2020

gen mx_diff_19_21 = mx2021 - mx2019
gen lb_diff_19_21 = mx_lb2021 - mx2019
gen ub_diff_19_21 = mx_ub2021 - mx2019

egen mx_diff_15_19 = rowmean(mx_diff_15_16 mx_diff_16_17 mx_diff_17_18 mx_diff_18_19)
egen lb_diff_15_19 = rowmean(lb_diff_15_16 lb_diff_16_17 lb_diff_17_18 lb_diff_18_19)
egen ub_diff_15_19 = rowmean(ub_diff_15_16 ub_diff_16_17 ub_diff_17_18 ub_diff_18_19)
save "${data}/AllSites_U5_mx_wide", replace
//export to excel
keep sitename sitename_location mx_diff_19_20 lb_diff_19_20 ub_diff_19_20 mx_diff_20_21 lb_diff_20_21 ub_diff_20_21 mx_diff_19_21 lb_diff_19_21 ub_diff_19_21 mx_diff_15_19 lb_diff_15_19 ub_diff_15_19
keep if !inlist(sitename, "ET042","ET043")
sort sitename sitename_location  
quietly export excel using "${output}/Results.xlsx", sheet("u5_mortality_rate_changes")sheetreplace firstrow(variables)


//Combine adult mortality rates
use  "${data}/BD011_adult_mx_sex", clear
gen sitename="BD011"
save "${data}/AllSites_adult_mx_sex", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_adult_mx_sex", clear
		gen sitename="`site'"
		append using "${data}/AllSites_adult_mx_sex"
		save "${data}/AllSites_adult_mx_sex", replace
	}

use "${data}/AllSites_adult_mx_sex", clear
keep year sex q15_000 q15ub_000 q15lb_000 sitename
rename q15lb_000 mx_lb
rename q15ub_000 mx_ub
rename q15_000 mx
merge m:1 sitename using "${data}/Sites"
drop _merge
label define sex_lbl 0 "both sexes" 1 "male" 2 "female", modify 
label values sex sex_lbl
order sitename sitename_location year sex
sort sitename year sex
quietly export excel using "${output}/Results.xlsx", sheet("adult_mortality")sheetreplace firstrow(variables)

//reshape into wide format
reshape wide mx mx_lb mx_ub, i(sex sitename sitename_location) j(year)
//compute changes between 2019 and 2021; 2019 and 2020; 2020 and 2021
gen mx_diff_15_16 = mx2016 - mx2015
gen lb_diff_15_16 = mx_lb2016 - mx2015
gen ub_diff_15_16 = mx_ub2016 - mx2015

gen mx_diff_16_17 = mx2017 - mx2016
gen lb_diff_16_17 = mx_lb2017 - mx2016
gen ub_diff_16_17 = mx_ub2017 - mx2016

gen mx_diff_17_18 = mx2018 - mx2017
gen lb_diff_17_18 = mx_lb2018 - mx2017
gen ub_diff_17_18 = mx_ub2018 - mx2017

gen mx_diff_18_19 = mx2019 - mx2018
gen lb_diff_18_19 = mx_lb2019 - mx2018
gen ub_diff_18_19 = mx_ub2019 - mx2018

gen mx_diff_19_20 = mx2020 - mx2019
gen lb_diff_19_20 = mx_lb2020 - mx2019
gen ub_diff_19_20 = mx_ub2020 - mx2019

gen mx_diff_20_21 = mx2021 - mx2020
gen lb_diff_20_21 = mx_lb2021 - mx2020
gen ub_diff_20_21 = mx_ub2021 - mx2020

gen mx_diff_19_21 = mx2021 - mx2019
gen lb_diff_19_21 = mx_lb2021 - mx2019
gen ub_diff_19_21 = mx_ub2021 - mx2019

egen mx_diff_15_19 = rowmean(mx_diff_15_16 mx_diff_16_17 mx_diff_17_18 mx_diff_18_19)
egen lb_diff_15_19 = rowmean(lb_diff_15_16 lb_diff_16_17 lb_diff_17_18 lb_diff_18_19)
egen ub_diff_15_19 = rowmean(ub_diff_15_16 ub_diff_16_17 ub_diff_17_18 ub_diff_18_19)
save "${data}/AllSites_adult_mx_sex_wide", replace
//export to excel
keep sitename sitename_location sex mx_diff_19_20 lb_diff_19_20 ub_diff_19_20 mx_diff_20_21 lb_diff_20_21 ub_diff_20_21 mx_diff_19_21 lb_diff_19_21 ub_diff_19_21 mx_diff_15_19 lb_diff_15_19 ub_diff_15_19
keep if !inlist(sitename, "ET042","ET043")
sort sitename sitename_location sex 
quietly export excel using "${output}/Results.xlsx", sheet("adult_mortality_rate_changes")sheetreplace firstrow(variables)

//Combine life tables
use  "${data}/BD011_LE_est", clear
gen sitename="BD011"
save "${data}/AllSites_LE_est", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_LE_est", clear
		gen sitename="`site'"
		append using "${data}/AllSites_LE_est"
		save "${data}/AllSites_LE_est", replace
	}

use  "${data}/BD011_LE_est15", clear
gen sitename="BD011"
save "${data}/AllSites_LE_est15", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_LE_est15", clear
		gen sitename="`site'"
		append using "${data}/AllSites_LE_est15"
		save "${data}/AllSites_LE_est15", replace
	}

use  "${data}/BD011_LE_est50", clear
gen sitename="BD011"
save "${data}/AllSites_LE_est50", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_LE_est50", clear
		gen sitename="`site'"
		append using "${data}/AllSites_LE_est50"
		save "${data}/AllSites_LE_est50", replace
	}

use  "${data}/BD011_LE_est60", clear
gen sitename="BD011"
save "${data}/AllSites_LE_est60", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_LE_est60", clear
		gen sitename="`site'"
		append using "${data}/AllSites_LE_est60"
		save "${data}/AllSites_LE_est60", replace
	}

//reshape into wide format
use "${data}/AllSites_LE_est", clear
keep sex year e elb eub sitename
reshape wide e elb eub, i(sitename sex) j(year)
//compute changes between 2019 and 2021; 2019 and 2020; 2020 and 2021
gen e_diff_15_16 = e2016 - e2015
gen lb_diff_15_16 = elb2016 - e2015
gen ub_diff_15_16 = eub2016 - e2015

gen e_diff_16_17 = e2017 - e2016
gen lb_diff_16_17 = elb2017 - e2016
gen ub_diff_16_17 = eub2017 - e2016

gen e_diff_17_18 = e2018 - e2017
gen lb_diff_17_18 = elb2018 - e2017
gen ub_diff_17_18 = eub2018 - e2017

gen e_diff_18_19 = e2019 - e2018
gen lb_diff_18_19 = elb2019 - e2018
gen ub_diff_18_19 = eub2019 - e2018

gen e_diff_19_20 = e2020 - e2019
gen lb_diff_19_20 = elb2020 - e2019
gen ub_diff_19_20 = eub2020 - e2019

gen e_diff_20_21 = e2021 - e2020
gen lb_diff_20_21 = elb2021 - e2020
gen ub_diff_20_21 = eub2021 - e2020

gen e_diff_19_21 = e2021 - e2019
gen lb_diff_19_21 = elb2021 - e2019
gen ub_diff_19_21 = eub2021 - e2019

egen e_diff_15_19 = rowmean(e_diff_15_16 e_diff_16_17 e_diff_17_18 e_diff_18_19)
egen lb_diff_15_19 = rowmean(lb_diff_15_16 lb_diff_16_17 lb_diff_17_18 lb_diff_18_19)
egen ub_diff_15_19 = rowmean(ub_diff_15_16 ub_diff_16_17 ub_diff_17_18 ub_diff_18_19)

merge m:1 sitename using "${data}/Sites"
save "${data}/AllSites_LE_est_wide", replace

use  "${data}/BD011_LE_est_by_age", clear
gen sitename="BD011"
save "${data}/AllSites_LE_est_by_age", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_LE_est_by_age", clear
		gen sitename="`site'"
		append using "${data}/AllSites_LE_est_by_age"
		save "${data}/AllSites_LE_est_by_age", replace
	}

//reshape into wide format
use "${data}/AllSites_LE_est_by_age", clear
merge m:1 sitename using "${data}/Sites"
drop _merge centreid
label define sex_lbl 0 "both sexes" 1 "male" 2 "female", modify 
label values sex sex_lbl
keep sex year e elb eub lower_age sitename sitename_location
order sitename sitename_location year lower_age sex 
sort sitename year lower_age sex
quietly export excel using "${output}/Results.xlsx", sheet("life_expectancies")sheetreplace firstrow(variables)

reshape wide e elb eub, i(sitename sitename_location sex lower_age) j(year)
//compute changes between 2019 and 2021; 2019 and 2020; 2020 and 2021
gen e_diff_15_16 = e2016 - e2015
gen lb_diff_15_16 = elb2016 - e2015
gen ub_diff_15_16 = eub2016 - e2015

gen e_diff_16_17 = e2017 - e2016
gen lb_diff_16_17 = elb2017 - e2016
gen ub_diff_16_17 = eub2017 - e2016

gen e_diff_17_18 = e2018 - e2017
gen lb_diff_17_18 = elb2018 - e2017
gen ub_diff_17_18 = eub2018 - e2017

gen e_diff_18_19 = e2019 - e2018
gen lb_diff_18_19 = elb2019 - e2018
gen ub_diff_18_19 = eub2019 - e2018

gen e_diff_19_20 = e2020 - e2019
gen lb_diff_19_20 = elb2020 - e2019
gen ub_diff_19_20 = eub2020 - e2019

gen e_diff_20_21 = e2021 - e2020
gen lb_diff_20_21 = elb2021 - e2020
gen ub_diff_20_21 = eub2021 - e2020

gen e_diff_19_21 = e2021 - e2019
gen lb_diff_19_21 = elb2021 - e2019
gen ub_diff_19_21 = eub2021 - e2019

egen e_diff_15_19 = rowmean(e_diff_15_16 e_diff_16_17 e_diff_17_18 e_diff_18_19)
egen lb_diff_15_19 = rowmean(lb_diff_15_16 lb_diff_16_17 lb_diff_17_18 lb_diff_18_19)
egen ub_diff_15_19 = rowmean(ub_diff_15_16 ub_diff_16_17 ub_diff_17_18 ub_diff_18_19)
save "${data}/AllSites_LE_est_by_age_wide", replace

//export to excel
keep sitename sitename_location sex lower_age e_diff_19_20 lb_diff_19_20 ub_diff_19_20 e_diff_20_21 lb_diff_20_21 ub_diff_20_21 e_diff_19_21 lb_diff_19_21 ub_diff_19_21 e_diff_15_19 lb_diff_15_19 ub_diff_15_19
keep if !inlist(sitename, "ET042","ET043")
sort sitename sitename_location sex 
quietly export excel using "${output}/Results.xlsx", sheet("life_expectancy_changes")sheetreplace firstrow(variables)

use  "${data}/BD011_LT", clear
gen sitename="BD011"
save "${data}/AllSites_LT", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_LT", clear
		gen sitename="`site'"
		append using "${data}/AllSites_LT"
		save "${data}/AllSites_LT", replace
	}

//Combine estimates of life expectancy gaps
use  "${data}/BD011_LE_Gaps", clear
gen sitename="BD011"
save "${data}/AllSites_LE_Gaps", replace
foreach site in BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 KE022 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 ZA081 { 
		global sitename="`site'"
		use "${data}/${sitename}_LE_Gaps", clear
		gen sitename="`site'"
		append using "${data}/AllSites_LE_Gaps"
		save "${data}/AllSites_LE_Gaps", replace
	}

use "${data}/AllSites_LE_Gaps", clear
merge m:1 sitename using "${data}/Sites"
drop _merge centreid sumdelt
order sitename sitename_location period sex agegrp
sort sitename sitename_location period sex agegrp
label define sex_lbl 0 "both sexes" 1 "male" 2 "female", modify 
label values sex sex_lbl
quietly export excel using "${output}/Results.xlsx", sheet("LE_Gaps")sheetreplace firstrow(variables)

gen agegrp2 = .
replace agegrp2 = 0 if inlist(agegrp, 0,1) 
replace agegrp2 = 15 if agegrp >=15 & agegrp <50 
replace agegrp2 = 65 if agegrp >=65 
drop if agegrp2 == .
collapse (sum) delta, by(sitename sitename_location sex period agegrp2)
save "${data}/AllSites_LE_Gaps_Selected_Ages", replace

//reshape into wide format
use "${data}/AllSites_LE_Gaps_Selected_Ages", clear
*encode period, generate(period_code)
gen period_code = .
replace period_code = 1 if period == "2019 to 2021"
replace period_code = 2 if period == "2019 to 2020"
replace period_code = 3 if period == "2020 to 2021"

drop period
reshape wide delta, i(sitename sitename_location sex agegrp2) j(period_code)
save "${data}/AllSites_LE_Gaps_Selected_Ages_wide", replace

