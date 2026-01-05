local site = "${site}"

///top cause all
use "${data}/${sitename}_top_causes_of_death_by_period", clear

keep if SexCode == 2
gsort SexCode -rank
bys SexCode: gen rank_reverse = _n
cap n drop label_pos*
foreach num of numlist 1(1)3 {
cap gen label_pos`num' = percent`num'+0.1
cap replace label_pos`num' = 15 if cod`num'== "HIV/TB" & `num' > 1 & `num' < 6
}

if "${sitename}" != "BD014" {
sum total_deaths1 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent1 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos1 if SexCode == 2 , ///
		mlabel(cause_lbl1) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 45)) ///
	 xlabel(0 (5) 45, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("All ages: `site', 2016-2017",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2016,replace) 
graph save "${graphs}/${sitename}_top10_causes_2016.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2016.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2016.png", replace
graph export "${graphs}/${sitename}_top10_causes_2016.tif", replace

sum total_deaths2 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent2 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos2 if SexCode == 2 , ///
		mlabel(cause_lbl2) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 45)) ///
	 xlabel(0 (5) 45, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("All ages: `site', 2018-2019",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2018,replace) 
graph save "${graphs}/${sitename}_top10_causes_2018.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2018.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2018.png", replace
graph export "${graphs}/${sitename}_top10_causes_2018.tif", replace
}

sum total_deaths3 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent3 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos3 if SexCode == 2 , ///
		mlabel(cause_lbl3) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 45)) ///
	 xlabel(0 (5) 45, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("All ages: `site', 2020-2021",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2020,replace) 
graph save "${graphs}/${sitename}_top10_causes_2020.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2020.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2020.png", replace
graph export "${graphs}/${sitename}_top10_causes_2020.tif", replace


///top causes for under 5 fives
use "${data}/${sitename}_top_causes_of_death_by_period_age_5yrs", clear
keep if SexCode == 2
keep if AgeGroup5 == 0
gsort SexCode -rank
bys SexCode: gen rank_reverse = _n
cap n drop label_pos*
foreach num of numlist 1(1)3 {
cap gen label_pos`num' = percent`num'+0.1
cap replace label_pos`num' = 15 if cod`num'== "HIV/TB" & `num' > 1 & `num' < 6
}

if "${sitename}" != "BD014" {
sum total_deaths1 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent1 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos1 if SexCode == 2 , ///
		mlabel(cause_lbl1) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("0-4 years: `site', 2016-2017",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2016_u5,replace) 
graph save "${graphs}/${sitename}_top10_causes_2016_u5.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2016_u5.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2016_u5.png", replace
graph export "${graphs}/${sitename}_top10_causes_2016_u5.tif", replace

sum total_deaths2 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent2 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos2 if SexCode == 2 , ///
		mlabel(cause_lbl2) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("0-4 years: `site', 2018-2019",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2018_u5,replace) 
graph save "${graphs}/${sitename}_top10_causes_2018_u5.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2018_u5.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2018_u5.png", replace
graph export "${graphs}/${sitename}_top10_causes_2018_u5.tif", replace
}
sum total_deaths3 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent3 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos3 if SexCode == 2 , ///
		mlabel(cause_lbl3) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("0-4 years: `site', 2020-2021",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2020_u5,replace) 
graph save "${graphs}/${sitename}_top10_causes_2020_u5.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2020_u5.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2020_u5.png", replace
graph export "${graphs}/${sitename}_top10_causes_2020_u5.tif", replace

///top causes for 5-14 ages
use "${data}/${sitename}_top_causes_of_death_by_period_who_age", clear
keep if SexCode == 2
keep if AgeGroup_WHO == 5
gsort SexCode -rank
bys SexCode: gen rank_reverse = _n
cap n drop label_pos*
foreach num of numlist 1(1)3 {
cap gen label_pos`num' = percent`num'+0.1
cap replace label_pos`num' = 15 if cod`num'== "HIV/TB" & `num' > 1 & `num' < 6
}

if "${sitename}" != "BD014" {
sum total_deaths1 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent1 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos1 if SexCode == 2 , ///
		mlabel(cause_lbl1) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("5-14 years: `site', 2016-2017",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2016_5to14,replace) 
graph save "${graphs}/${sitename}_top10_causes_2016_5to14.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2016_5to14.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2016_5to14.png", replace
graph export "${graphs}/${sitename}_top10_causes_2016_5to14.tif", replace

sum total_deaths2 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent2 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos2 if SexCode == 2 , ///
		mlabel(cause_lbl2) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("5-14 years: `site', 2018-2019",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2018_5to14,replace) 
graph save "${graphs}/${sitename}_top10_causes_2018_5to14.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2018_5to14.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2018_5to14.png", replace
graph export "${graphs}/${sitename}_top10_causes_2018_5to14.tif", replace
}

sum total_deaths3 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent3 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos3 if SexCode == 2 , ///
		mlabel(cause_lbl3) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("5-14 years: `site', 2020-2021",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2020_5to14,replace) 
graph save "${graphs}/${sitename}_top10_causes_2020_5to14.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2020_5to14.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2020_5to14.png", replace
graph export "${graphs}/${sitename}_top10_causes_2020_5to14.tif", replace

///top causes for 15-49 ages
use "${data}/${sitename}_top_causes_of_death_by_period_who_age", clear
keep if SexCode == 2
keep if AgeGroup_WHO == 15
gsort SexCode -rank
bys SexCode: gen rank_reverse = _n
cap n drop label_pos*
foreach num of numlist 1(1)3 {
cap gen label_pos`num' = percent`num'+0.1
cap replace label_pos`num' = 15 if cod`num'== "HIV/TB" & `num' > 1 & `num' < 6
}

if "${sitename}" != "BD014" {
sum total_deaths1 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent1 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos1 if SexCode == 2 , ///
		mlabel(cause_lbl1) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("15-49 years: `site', 2016-2017",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2016_15to49,replace) 
graph save "${graphs}/${sitename}_top10_causes_2016_15to49.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2016_15to49.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2016_15to49.png", replace
graph export "${graphs}/${sitename}_top10_causes_2016_15to49.tif", replace

sum total_deaths2 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent2 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos2 if SexCode == 2 , ///
		mlabel(cause_lbl2) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("15-49 years: `site', 2018-2019",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2018_15to49,replace) 
graph save "${graphs}/${sitename}_top10_causes_2018_15to49.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2018_15to49.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2018_15to49.png", replace
graph export "${graphs}/${sitename}_top10_causes_2018_15to49.tif", replace
}

sum total_deaths3 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent3 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos3 if SexCode == 2 , ///
		mlabel(cause_lbl3) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("15-49 years: `site', 2020-2021",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2020_15to49,replace) 
graph save "${graphs}/${sitename}_top10_causes_2020_15to49.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2020_15to49.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2020_15to49.png", replace
graph export "${graphs}/${sitename}_top10_causes_2020_15to49.tif", replace

///top causes for 50-64 ages
use "${data}/${sitename}_top_causes_of_death_by_period_who_age", clear
keep if SexCode == 2
keep if AgeGroup_WHO == 50
gsort SexCode -rank
bys SexCode: gen rank_reverse = _n
cap n drop label_pos*
foreach num of numlist 1(1)3 {
cap gen label_pos`num' = percent`num'+0.1
cap replace label_pos`num' = 15 if cod`num'== "HIV/TB" & `num' > 1 & `num' < 6
}

if "${sitename}" != "BD014" {
sum total_deaths1 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent1 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos1 if SexCode == 2 , ///
		mlabel(cause_lbl1) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("50-64 years: `site', 2016-2017",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2016_50to64,replace) 
graph save "${graphs}/${sitename}_top10_causes_2016_50to64.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2016_50to64.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2016_50to64.png", replace
graph export "${graphs}/${sitename}_top10_causes_2016_50to64.tif", replace

sum total_deaths2 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent2 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos2 if SexCode == 2 , ///
		mlabel(cause_lbl2) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("50-64 years: `site', 2018-2019",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2018_50to64,replace) 
graph save "${graphs}/${sitename}_top10_causes_2018_50to64.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2018_50to64.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2018_50to64.png", replace
graph export "${graphs}/${sitename}_top10_causes_2018_50to64.tif", replace
}

sum total_deaths3 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent3 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos3 if SexCode == 2 , ///
		mlabel(cause_lbl3) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("50-64 years: `site', 2020-2021",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2020_50to64,replace) 
graph save "${graphs}/${sitename}_top10_causes_2020_50to64.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2020_50to64.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2020_50to64.png", replace
graph export "${graphs}/${sitename}_top10_causes_2020_50to64.tif", replace

///top causes for 65+ year
use "${data}/${sitename}_top_causes_of_death_by_period_who_age", clear
keep if SexCode == 2
keep if AgeGroup_WHO == 65
gsort SexCode -rank
bys SexCode: gen rank_reverse = _n
cap n drop label_pos*
foreach num of numlist 1(1)3 {
cap gen label_pos`num' = percent`num'+0.1
cap replace label_pos`num' = 15 if cod`num'== "HIV/TB" & `num' > 1 & `num' < 6
}

if "${sitename}" != "BD014" {
sum total_deaths1 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent1 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos1 if SexCode == 2 , ///
		mlabel(cause_lbl1) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("65+ years: `site', 2016-2017",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2016_65plus,replace) 
graph save "${graphs}/${sitename}_top10_causes_2016_65plus.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2016_65plus.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2016_65plus.png", replace
graph export "${graphs}/${sitename}_top10_causes_2016_65plus.tif", replace

sum total_deaths2 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent2 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos2 if SexCode == 2 , ///
		mlabel(cause_lbl2) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("65+ years: `site', 2018-2019",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2018_65plus,replace) 
graph save "${graphs}/${sitename}_top10_causes_2018_65plus.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2018_65plus.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2018_65plus.png", replace
graph export "${graphs}/${sitename}_top10_causes_2018_65plus.tif", replace
}

sum total_deaths3 if SexCode == 2
local total_deaths =r(mean) 
twoway (bar percent3 rank_reverse if SexCode == 2, ///
			horizontal barw(.8) fcolor(gs6) lcolor(gs6) lwidth(vthin)) ///
		(scatter rank_reverse label_pos3 if SexCode == 2 , ///
		mlabel(cause_lbl3) msymbol(i) mlabcolor(gs0) mlabsize(*1.5)) ///
	 ,yscale(range(1 10)) yscale(off) yscale(alt) ylabel(none) ///
	 xscale(range(1 100)) ///
	 xlabel(0 (10) 100, angle(0) labsize(*1.2) grid) ///
	 xtitle("Percentage of deaths", size(*1) just(right)) ///
	 title("65+ years: `site', 2020-2021",  size(*1)) ///
	legend(off) ///
	graphregion(color(white)) ///
graphregion(color(white)) name(${sitename}_top10_causes_2020_65plus,replace) 
graph save "${graphs}/${sitename}_top10_causes_2020_65plus.gph", replace
graph export "${graphs}/${sitename}_top10_causes_2020_65plus.pdf", replace
graph export "${graphs}/${sitename}_top10_causes_2020_65plus.png", replace
graph export "${graphs}/${sitename}_top10_causes_2020_65plus.tif", replace







