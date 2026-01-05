use "${data}/AllSites_agestan_mx", clear
br if inlist(year,2019,2020,2021) & inlist(sitename, "ZA011","ZA021", "ZA031", "MZ011", "MW011")

drop if year >2021
twoway (scatter agestan_rate year if sitename=="ZA031" & sex == 1 ///
			,mcolor(black) lcolor(black) recast(connected) lpattern(solid)) ///
		(scatter agestan_rate year if sitename=="ZA011" & sex == 1 ///
			,mcolor(blue) lcolor(blue) recast(connected) lpattern(solid)) ///
		(scatter agestan_rate year if sitename=="ZA021" & sex == 1 ///
			,mcolor(red) lcolor(red) recast(connected) lpattern(solid)) ///
		(scatter agestan_rate year if sitename=="MZ011" & sex == 1 ///
			,mcolor(green) lcolor(green) recast(connected) lpattern(solid)) ///
,xlabel(2015(1)2021 , nogrid angle(0)) ///
ylabel(0 (2) 18,nogrid angle(0)) ///
ytitle("Age-standardized Mortality per 1000 person years",height(3) ) ///
xtitle("Year",height(3) ) ///
legend(cols(2) position(12) ///
		order(1 "AHRI, South Africa" 2 "Agincourt, South Africa" 3 "Dimamo, South Africa" 4 "Manhica, Mozambique" ) ///
		region(lwidth(0) lcolor(white)) ring(1) size(*1)) ///
title("Males") ///
graphregion(color(white)) name(SouthernAfrica_agestan_mx_M,replace) 
graph save "${graphs}/SouthernAfrica_agestan_mx_M.gph", replace
graph export "${graphs}/SouthernAfrica_agestan_mx_M.pdf", replace
graph export "${graphs}/SouthernAfrica_agestan_mx_M.png", replace
graph export "${graphs}/SouthernAfrica_agestan_mx_M.tif", replace

twoway (scatter agestan_rate year if sitename=="ZA031" & sex == 2 ///
			,mcolor(black) lcolor(black) recast(connected) lpattern(solid)) ///
		(scatter agestan_rate year if sitename=="ZA011" & sex == 2 ///
			,mcolor(blue) lcolor(blue) recast(connected) lpattern(solid)) ///
		(scatter agestan_rate year if sitename=="ZA021" & sex == 2 ///
			,mcolor(red) lcolor(red) recast(connected) lpattern(solid)) ///
		(scatter agestan_rate year if sitename=="MZ011" & sex == 2 ///
			,mcolor(green) lcolor(green) recast(connected) lpattern(solid)) ///
,xlabel(2015(1)2021 , nogrid angle(0)) ///
ylabel(0 (2) 18,nogrid angle(0)) ///
ytitle("Age-standardized Mortality per 1000 person years",height(3) ) ///
xtitle("Year",height(3) ) ///
legend(cols(2) position(12) ///
		order(1 "AHRI, South Africa" 2 "Agincourt, South Africa" 3 "Dimamo, South Africa" 4 "Manhica, Mozambique" ) ///
		region(lwidth(0) lcolor(white)) ring(1) size(*1)) ///
title("Females") ///
graphregion(color(white)) name(SouthernAfrica_agestan_mx_F,replace) 
graph save "${graphs}/SouthernAfrica_agestan_mx_F.gph", replace
graph export "${graphs}/SouthernAfrica_agestan_mx_F.pdf", replace
graph export "${graphs}/SouthernAfrica_agestan_mx_F.png", replace
graph export "${graphs}/SouthernAfrica_agestan_mx_F.tif", replace


graph combine "${graphs}/ZA011_agestan_mx.gph" ///
"${graphs}/ZA021_agestan_mx.gph" ///
"${graphs}/ZA031_agestan_mx.gph" ///
"${graphs}/MZ011_agestan_mx.gph" ///
"${graphs}/MW011_agestan_mx.gph", ///
r(2) ycommon xcommon iscale(*.65) imargin(.5 .5 .5 .5) scheme(s1color)
graph export "${graphs}/SouthernAfrica_agestan_mx.pdf", replace
graph export "${graphs}/SouthernAfrica_agestan_mx.pdf", replace
graph export "${graphs}/SouthernAfrica_agestan_mx.png", replace
graph export "${graphs}/SouthernAfrica_agestan_mx.tif", replace


//GRAPHS
use "${data}/AllSites_agestan_mx_wide", clear
keep if sex == 0
sort rate_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = -3
graph twoway  (scatter n rate_diff_19_20 if rate_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n rate_diff_19_20 if rate_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 > 0 , horizontal color(red)) ///
(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-7 6)) xlabel(-3(1)6, labsize(vsmall) grid) ///
xtitle(" ", size(small)) ///
yscale(range(-1 -30)) yscale(off) ylabel(none) ///
legend(off) ///
text(0.3 -4.5 "{bf:Site}", size(small) color(black) just(left)) ///
text(0 0 "{bf:Change between 2019 and 2020}", size(small) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(agestan_mx_diff_19_20,replace) 
graph save "${graphs}/agestan_mx_diff_19_20.gph", replace
graph export "${graphs}/agestan_mx_diff_19_20.pdf", replace
graph export "${graphs}/agestan_mx_diff_19_20.png", replace
graph export "${graphs}/agestan_mx_diff_19_20.tif", replace

use "${data}/AllSites_agestan_mx_wide", clear
keep if sex == 0
sort rate_diff_19_21
gen n = -_n
replace n = n *1.5
graph twoway  (scatter n rate_diff_19_20 if rate_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n rate_diff_19_20 if rate_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 > 0 , horizontal color(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-3 6)) xlabel(-3(1)6, labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) ///
yscale(range(-1 -30)) yscale(off) ylabel(none) ///
legend(off) ///
text(0 0 "{bf:Change between 2019 and 2020}", size(small) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(agestan_mx_diff_19_20V2,replace) 
graph save "${graphs}/agestan_mx_diff_19_20V2.gph", replace

use "${data}/AllSites_agestan_mx_wide", clear
keep if sex == 0
sort rate_diff_19_21
gen n = -_n
replace n = n *1.5
graph twoway  (scatter n rate_diff_20_21 if rate_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n rate_diff_20_21 if rate_diff_20_21 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_20_21 ub_diff_20_21 n if rate_diff_20_21 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_20_21 ub_diff_20_21 n if rate_diff_20_21 > 0 , horizontal color(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-3 6)) xlabel(-3(1)6, labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) ///
yscale(range(-1 -30)) yscale(off) ylabel(none) ///
legend(off) ///
text(0 0 "{bf:Change between 2020 and 2021}", size(small) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(agestan_mx_diff_20_21,replace) 
graph save "${graphs}/agestan_mx_diff_20_21.gph", replace


use "${data}/AllSites_agestan_mx_wide", clear
keep if sex == 0
sort rate_diff_19_21
gen n = -_n
replace n = n *1.5
gen pos_19_21 = 1
gen pos_19_20 = 2
gen pos_20_21 = 3
gen pos_15_19 = 4
gen diff_19_20_label = string(rate_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(rate_diff_19_20,"%6.1fc") if rate_diff_19_20 > 0
gen diff_20_21_label = string(rate_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(rate_diff_20_21,"%6.1fc") if rate_diff_20_21 > 0
gen diff_19_21_label = string(rate_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(rate_diff_19_21,"%6.1fc") if rate_diff_19_21 > 0
gen diff_15_19_label = string(rate_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(rate_diff_15_19,"%6.1fc") if rate_diff_15_19 > 0

graph twoway  (scatter n pos_19_21 if rate_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_21 if rate_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if rate_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if rate_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if rate_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if rate_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if rate_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if rate_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
,xscale(range(0.9 4.5)) xlabel(0.9 " ",tl(1) labsize(vsmall) nogrid) ///
xtitle(" ", size(small)) ///
yscale(range(-1 -30)) yscale(off) ylabel(none) ///
legend(off) ///
text(0 0.9 "{&Delta} {bf:2019-2021}", size(small) color(black) orientation(horizontal)) ///
text(0 1.9 "{&Delta} {bf:2019-2020}", size(small) color(black) orientation(horizontal)) ///
text(0 2.9 "{&Delta} {bf:2020-2021}", size(small) color(black) orientation(horizontal)) ///
text(0 4.2 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(small) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(agestan_mx_diff_text,replace) 
graph save "${graphs}/agestan_mx_diff_text.gph", replace

use "${data}/AllSites_agestan_mx_wide", clear
keep if sex == 0
sort rate_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = 0
graph twoway (scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
,xscale(range(-0.01 0.0)) xlabel(0 " ", labsize(vsmall) grid) ///
xtitle(" ", size(small)) ///
yscale(range(-1 -30)) yscale(off) ylabel(none) ///
legend(off) ///
text(0 -0.0015 "{bf:HDSS setting}", size(small) color(black) ) ///
graphregion(color(white)) name(agestan_mx_diff_sites,replace) 
graph save "${graphs}/agestan_mx_diff_sites.gph", replace

graph combine "${graphs}/agestan_mx_diff_sites.gph" ///
"${graphs}/agestan_mx_diff_19_20V2.gph" ///
"${graphs}/agestan_mx_diff_20_21.gph" ///
"${graphs}/agestan_mx_diff_text.gph", ///
 r(1) iscale(*0.7) 
graph export "${graphs}/agestan_mx_changes.pdf", replace

use "${data}/AllSites_agestan_mx_wide", clear
keep if sex == 0 & !inlist(sitename, "ET042","ET043")
sort rate_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = -3

gen xrate_diff_20_21 = rate_diff_20_21 + 11
gen xlb_diff_20_21 = lb_diff_20_21 + 11
gen xub_diff_20_21 = ub_diff_20_21 + 11

gen pos_19_21 = 20
gen pos_19_20 = 23
gen pos_20_21 = 26.5
gen pos_15_19 = 30.5
gen diff_19_20_label = string(rate_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(rate_diff_19_20,"%6.1fc") if rate_diff_19_20 > 0
gen diff_20_21_label = string(rate_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(rate_diff_20_21,"%6.1fc") if rate_diff_20_21 > 0
gen diff_19_21_label = string(rate_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(rate_diff_19_21,"%6.1fc") if rate_diff_19_21 > 0
gen diff_15_19_label = string(rate_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(rate_diff_15_19,"%6.1fc") if rate_diff_15_19 > 0


graph twoway  (scatter n rate_diff_19_20 if rate_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n rate_diff_19_20 if rate_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 > 0 , horizontal color(red)) ///
(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xrate_diff_20_21 if rate_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n xrate_diff_20_21 if rate_diff_20_21 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if rate_diff_20_21 <= 0 , horizontal color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if rate_diff_20_21 > 0 , horizontal color(red)) ///
(scatter n pos_19_21 if rate_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_21 if rate_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if rate_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if rate_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if rate_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if rate_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if rate_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if rate_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(11, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-11 31)) xlabel(-3(1)6 8 "-3" 9 "-2" 10 "-1" 11 "0" 12 "1" 13 "2" 14 "3" 15 "4" 16 "5" 17 "6", labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -5 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 0 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 11.3 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 18.5 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 22.0 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 25.5 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 30 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(agestan_mx_changes_all,replace) 
graph save "${graphs}/agestan_mx_changes_all.gph", replace
graph export "${graphs}/agestan_mx_changes_all.pdf", replace
graph export "${graphs}/agestan_mx_changes_all.tif", replace
graph export "${graphs}/agestan_mx_changes_all.png", replace


//REPEAT FOR MALES
use "${data}/AllSites_agestan_mx_wide", clear
keep if sex == 1 & !inlist(sitename, "ET042","ET043")
sort rate_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = -3

gen xrate_diff_20_21 = rate_diff_20_21 + 11
gen xlb_diff_20_21 = lb_diff_20_21 + 11
gen xub_diff_20_21 = ub_diff_20_21 + 11

gen pos_19_21 = 20
gen pos_19_20 = 23
gen pos_20_21 = 26.5
gen pos_15_19 = 30.5
gen diff_19_20_label = string(rate_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(rate_diff_19_20,"%6.1fc") if rate_diff_19_20 > 0
gen diff_20_21_label = string(rate_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(rate_diff_20_21,"%6.1fc") if rate_diff_20_21 > 0
gen diff_19_21_label = string(rate_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(rate_diff_19_21,"%6.1fc") if rate_diff_19_21 > 0
gen diff_15_19_label = string(rate_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(rate_diff_15_19,"%6.1fc") if rate_diff_15_19 > 0


graph twoway  (scatter n rate_diff_19_20 if rate_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n rate_diff_19_20 if rate_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 > 0 , horizontal color(red)) ///
(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xrate_diff_20_21 if rate_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n xrate_diff_20_21 if rate_diff_20_21 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if rate_diff_20_21 <= 0 , horizontal color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if rate_diff_20_21 > 0 , horizontal color(red)) ///
(scatter n pos_19_21 if rate_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_21 if rate_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if rate_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if rate_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if rate_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if rate_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if rate_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if rate_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(11, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-11 31)) xlabel(-3(1)6 8 "-3" 9 "-2" 10 "-1" 11 "0" 12 "1" 13 "2" 14 "3" 15 "4" 16 "5" 17 "6", labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -5.5 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 0 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 11.3 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 18.5 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 22.0 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 25.5 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 30 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(agestan_mx_changes_male,replace) 
graph save "${graphs}/agestan_mx_changes_male.gph", replace
graph export "${graphs}/agestan_mx_changes_male.pdf", replace
graph export "${graphs}/agestan_mx_changes_male.tif", replace
graph export "${graphs}/agestan_mx_changes_male.png", replace

//REPEAT FOR FEMALES
use "${data}/AllSites_agestan_mx_wide", clear
keep if sex == 2 & !inlist(sitename, "ET042","ET043")
sort rate_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = -5.5

gen xrate_diff_20_21 = rate_diff_20_21 + 11
gen xlb_diff_20_21 = lb_diff_20_21 + 11
gen xub_diff_20_21 = ub_diff_20_21 + 11

gen pos_19_21 = 20
gen pos_19_20 = 23
gen pos_20_21 = 26.5
gen pos_15_19 = 30.5
gen diff_19_20_label = string(rate_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(rate_diff_19_20,"%6.1fc") if rate_diff_19_20 > 0
gen diff_20_21_label = string(rate_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(rate_diff_20_21,"%6.1fc") if rate_diff_20_21 > 0
gen diff_19_21_label = string(rate_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(rate_diff_19_21,"%6.1fc") if rate_diff_19_21 > 0
gen diff_15_19_label = string(rate_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(rate_diff_15_19,"%6.1fc") if rate_diff_15_19 > 0


graph twoway  (scatter n rate_diff_19_20 if rate_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n rate_diff_19_20 if rate_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if rate_diff_19_20 > 0 , horizontal color(red)) ///
(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xrate_diff_20_21 if rate_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n xrate_diff_20_21 if rate_diff_20_21 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if rate_diff_20_21 <= 0 , horizontal color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if rate_diff_20_21 > 0 , horizontal color(red)) ///
(scatter n pos_19_21 if rate_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_21 if rate_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if rate_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if rate_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if rate_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if rate_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if rate_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if rate_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(11, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-14 31)) xlabel(-5(1)6 8 "-3" 9 "-2" 10 "-1" 11 "0" 12 "1" 13 "2" 14 "3" 15 "4" 16 "5" 17 "6", labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -8 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 0 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 11.3 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 18.5 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 22.0 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 25.5 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 30 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(agestan_mx_diff_20_21,replace) 
graph save "${graphs}/agestan_mx_changes_female.gph", replace
graph export "${graphs}/agestan_mx_changes_female.pdf", replace
graph export "${graphs}/agestan_mx_changes_female.tif", replace
graph export "${graphs}/agestan_mx_changes_female.png", replace

//UNDER 5 MORTALITY
use "${data}/AllSites_U5_mx_wide", clear
keep if !inlist(sitename, "ET042","ET043")
sort mx_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = -30

gen xmx_diff_20_21 = mx_diff_20_21 + 110
gen xlb_diff_20_21 = lb_diff_20_21 + 110
gen xub_diff_20_21 = ub_diff_20_21 + 110

gen pos_19_21 = 200
gen pos_19_20 = 230
gen pos_20_21 = 265
gen pos_15_19 = 305
gen diff_19_20_label = string(mx_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(mx_diff_19_20,"%6.1fc") if mx_diff_19_20 > 0
gen diff_20_21_label = string(mx_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(mx_diff_20_21,"%6.1fc") if mx_diff_20_21 > 0
gen diff_19_21_label = string(mx_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(mx_diff_19_21,"%6.1fc") if mx_diff_19_21 > 0
gen diff_15_19_label = string(mx_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(mx_diff_15_19,"%6.1fc") if mx_diff_15_19 > 0


graph twoway  (scatter n mx_diff_19_20 if mx_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n mx_diff_19_20 if mx_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if mx_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if mx_diff_19_20 > 0 , horizontal color(red)) ///
(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xmx_diff_20_21 if mx_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n xmx_diff_20_21 if mx_diff_20_21 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if mx_diff_20_21 <= 0 , horizontal color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if mx_diff_20_21 > 0 , horizontal color(red)) ///
(scatter n pos_19_21 if mx_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_21 if mx_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if mx_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if mx_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if mx_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if mx_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if mx_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if mx_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(110, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-110 310)) xlabel(-30(10)60 80 "-30" 90 "-20" 100 "-10" 110 "0" 120 "10" 130 "20" 140 "30" 150 "40" 160 "50" 170 "60", labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -48 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 3 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 113 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 185 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 220 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 255 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 300 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(U5_mx_changes,replace) 
graph save "${graphs}/U5_mx_changes.gph", replace
graph export "${graphs}/U5_mx_changes.pdf", replace
graph export "${graphs}/U5_mx_changes.tif", replace
graph export "${graphs}/U5_mx_changes.png", replace


//ADULT MORTALITY
use "${data}/AllSites_adult_mx_sex_wide", clear
keep if sex==0 & !inlist(sitename, "ET042","ET043")
sort mx_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = -100

gen xmx_diff_20_21 = mx_diff_20_21 + 260
gen xlb_diff_20_21 = lb_diff_20_21 + 260
gen xub_diff_20_21 = ub_diff_20_21 + 260

gen pos_19_21 = 450
gen pos_19_20 = 520
gen pos_20_21 = 600
gen pos_15_19 = 680
gen diff_19_20_label = string(mx_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(mx_diff_19_20,"%6.1fc") if mx_diff_19_20 > 0
gen diff_20_21_label = string(mx_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(mx_diff_20_21,"%6.1fc") if mx_diff_20_21 > 0
gen diff_19_21_label = string(mx_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(mx_diff_19_21,"%6.1fc") if mx_diff_19_21 > 0
gen diff_15_19_label = string(mx_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(mx_diff_15_19,"%6.1fc") if mx_diff_15_19 > 0


graph twoway  (scatter n mx_diff_19_20 if mx_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n mx_diff_19_20 if mx_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if mx_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if mx_diff_19_20 > 0 , horizontal color(red)) ///
(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xmx_diff_20_21 if mx_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n xmx_diff_20_21 if mx_diff_20_21 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if mx_diff_20_21 <= 0 , horizontal color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if mx_diff_20_21 > 0 , horizontal color(red)) ///
(scatter n pos_19_21 if mx_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_21 if mx_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if mx_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if mx_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if mx_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if mx_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if mx_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if mx_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(260, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-260 660)) xlabel(-80(40)120 180 "-80" 220 "-40"  260 "0" 300 "40" 340 "80" 380 "120" , labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -150 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 3 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 265 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 410 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 485 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 560 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 655 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(adult_mx_changes_all,replace) 
graph save "${graphs}/adult_mx_changes_all.gph", replace
graph export "${graphs}/adult_mx_changes_all.pdf", replace
graph export "${graphs}/adult_mx_changes_all.tif", replace
graph export "${graphs}/adult_mx_changes_png.pdf", replace

//ADULT MORTALITY MALE
use "${data}/AllSites_adult_mx_sex_wide", clear
keep if sex==1 & !inlist(sitename, "ET042","ET043")
sort mx_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = -115

gen xmx_diff_20_21 = mx_diff_20_21 + 340
gen xlb_diff_20_21 = lb_diff_20_21 + 340
gen xub_diff_20_21 = ub_diff_20_21 + 340

gen pos_19_21 = 580
gen pos_19_20 = 680
gen pos_20_21 = 770
gen pos_15_19 = 870
gen diff_19_20_label = string(mx_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(mx_diff_19_20,"%6.1fc") if mx_diff_19_20 > 0
gen diff_20_21_label = string(mx_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(mx_diff_20_21,"%6.1fc") if mx_diff_20_21 > 0
gen diff_19_21_label = string(mx_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(mx_diff_19_21,"%6.1fc") if mx_diff_19_21 > 0
gen diff_15_19_label = string(mx_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(mx_diff_15_19,"%6.1fc") if mx_diff_15_19 > 0


graph twoway  (scatter n mx_diff_19_20 if mx_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n mx_diff_19_20 if mx_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if mx_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if mx_diff_19_20 > 0 , horizontal color(red)) ///
(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xmx_diff_20_21 if mx_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n xmx_diff_20_21 if mx_diff_20_21 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if mx_diff_20_21 <= 0 , horizontal color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if mx_diff_20_21 > 0 , horizontal color(red)) ///
(scatter n pos_19_21 if mx_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_21 if mx_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if mx_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if mx_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if mx_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if mx_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if mx_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if mx_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(340, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-320 880)) xlabel(-120(40)160  220 "-120"  260 "-80" 300 "-40" 340 "0" 380 "40" 420 "80" 460 "120" 500 "160", labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -170 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 3 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 345 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 530 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 630 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 730 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 850 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(adult_mx_changes_all,replace) 
graph save "${graphs}/adult_mx_changes_male.gph", replace
graph export "${graphs}/adult_mx_changes_male.pdf", replace
graph export "${graphs}/adult_mx_changes_male.tif", replace
graph export "${graphs}/adult_mx_changes_male.png", replace

//ADULT MORTALITY FEMALE
use "${data}/AllSites_adult_mx_sex_wide", clear
keep if sex==2 & !inlist(sitename, "ET042","ET043")
sort mx_diff_19_21
gen n = -_n
replace n = n *1.5
gen site_label = -115

gen xmx_diff_20_21 = mx_diff_20_21 + 340
gen xlb_diff_20_21 = lb_diff_20_21 + 340
gen xub_diff_20_21 = ub_diff_20_21 + 340

gen pos_19_21 = 580
gen pos_19_20 = 680
gen pos_20_21 = 770
gen pos_15_19 = 870
gen diff_19_20_label = string(mx_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(mx_diff_19_20,"%6.1fc") if mx_diff_19_20 > 0
gen diff_20_21_label = string(mx_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(mx_diff_20_21,"%6.1fc") if mx_diff_20_21 > 0
gen diff_19_21_label = string(mx_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(mx_diff_19_21,"%6.1fc") if mx_diff_19_21 > 0
gen diff_15_19_label = string(mx_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(mx_diff_15_19,"%6.1fc") if mx_diff_15_19 > 0


graph twoway  (scatter n mx_diff_19_20 if mx_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n mx_diff_19_20 if mx_diff_19_20 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if mx_diff_19_20 <= 0 , horizontal color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if mx_diff_19_20 > 0 , horizontal color(red)) ///
(scatter n site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xmx_diff_20_21 if mx_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(blue)) ///
(scatter n xmx_diff_20_21 if mx_diff_20_21 > 0, msymbol(dot) msize(0.5) color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if mx_diff_20_21 <= 0 , horizontal color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if mx_diff_20_21 > 0 , horizontal color(red)) ///
(scatter n pos_19_21 if mx_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_21 if mx_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if mx_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if mx_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if mx_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if mx_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if mx_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if mx_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(340, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-320 880)) xlabel(-120(40)160  220 "-120"  260 "-80" 300 "-40" 340 "0" 380 "40" 420 "80" 460 "120" 500 "160", labsize(vsmall) grid) ///
xtitle("Deaths per 1000 person years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -170 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 3 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 345 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 530 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 630 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 730 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 850 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(adult_mx_changes_all,replace) 
graph save "${graphs}/adult_mx_changes_female.gph", replace
graph export "${graphs}/Uadult_mx_changes_female.pdf", replace
graph export "${graphs}/Uadult_mx_changes_female.tif", replace
graph export "${graphs}/Uadult_mx_changes_female.png", replace

//LIFE EXPECTANCY ALL
use "${data}/AllSites_LE_est_by_age_wide", clear
keep if lower_age==0 & sex == 0 & !inlist(sitename, "ET042","ET043")
sort e_diff_19_21
gen n = -_n
replace n = n *1.5
gen sitlabel = -9

gen xe_diff_20_21 = e_diff_20_21 + 20
gen xlb_diff_20_21 = lb_diff_20_21 + 20
gen xub_diff_20_21 = ub_diff_20_21 + 20

gen pos_19_21 = 29
gen pos_19_20 = 35
gen pos_20_21 = 40
gen pos_15_19 = 45
gen diff_19_20_label = string(e_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(e_diff_19_20,"%6.1fc") if e_diff_19_20 > 0
gen diff_20_21_label = string(e_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(e_diff_20_21,"%6.1fc") if e_diff_20_21 > 0
gen diff_19_21_label = string(e_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(e_diff_19_21,"%6.1fc") if e_diff_19_21 > 0
gen diff_15_19_label = string(e_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(e_diff_15_19,"%6.1fc") if e_diff_15_19 > 0


graph twoway  (scatter n e_diff_19_20 if e_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(red)) ///
(scatter n e_diff_19_20 if e_diff_19_20 > 0, msymbol(dot) msize(0.5) color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if e_diff_19_20 <= 0 , horizontal color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if e_diff_19_20 > 0 , horizontal color(blue)) ///
(scatter n sitlabel, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xe_diff_20_21 if e_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(red)) ///
(scatter n xe_diff_20_21 if e_diff_20_21 > 0, msymbol(dot) msize(0.5) color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if e_diff_20_21 <= 0 , horizontal color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if e_diff_20_21 > 0 , horizontal color(blue)) ///
(scatter n pos_19_21 if e_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_21 if e_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if e_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if e_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if e_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if e_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if e_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if e_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(20, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-20.5 47)) xlabel(-9(1)9 11 "-9" 12 "-8" 13 "-7" 14 "-6" 15 "-5" 16 "-4" 17 "-3" 18 "-2" 19 "-1" 20 "0" 21 "1" 22 "2" 23 "3" 24 "4" 25 "5", labsize(vsmall) grid) ///
xtitle("Years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -13 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 0 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 20.3 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 27.5 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 33 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 38.5 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 45 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(le_diff_20_21,replace) 
graph save "${graphs}/le_changes_all.gph", replace
graph export "${graphs}/le_changes_all.pdf", replace
graph export "${graphs}/le_changes_all.tif", replace
graph export "${graphs}/le_changes_all.png", replace

//LIFE EXPECTANCY MALE
use "${data}/AllSites_LE_est_by_age_wide", clear
keep if lower_age==0 & sex == 1 & !inlist(sitename, "ET042","ET043")
sort e_diff_19_21
gen n = -_n
replace n = n *1.5
gen sitlabel = -9

gen xe_diff_20_21 = e_diff_20_21 + 20
gen xlb_diff_20_21 = lb_diff_20_21 + 20
gen xub_diff_20_21 = ub_diff_20_21 + 20

gen pos_19_21 = 29
gen pos_19_20 = 35
gen pos_20_21 = 40
gen pos_15_19 = 45
gen diff_19_20_label = string(e_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(e_diff_19_20,"%6.1fc") if e_diff_19_20 > 0
gen diff_20_21_label = string(e_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(e_diff_20_21,"%6.1fc") if e_diff_20_21 > 0
gen diff_19_21_label = string(e_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(e_diff_19_21,"%6.1fc") if e_diff_19_21 > 0
gen diff_15_19_label = string(e_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(e_diff_15_19,"%6.1fc") if e_diff_15_19 > 0


graph twoway  (scatter n e_diff_19_20 if e_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(red)) ///
(scatter n e_diff_19_20 if e_diff_19_20 > 0, msymbol(dot) msize(0.5) color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if e_diff_19_20 <= 0 , horizontal color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if e_diff_19_20 > 0 , horizontal color(blue)) ///
(scatter n sitlabel, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xe_diff_20_21 if e_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(red)) ///
(scatter n xe_diff_20_21 if e_diff_20_21 > 0, msymbol(dot) msize(0.5) color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if e_diff_20_21 <= 0 , horizontal color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if e_diff_20_21 > 0 , horizontal color(blue)) ///
(scatter n pos_19_21 if e_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_21 if e_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if e_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if e_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if e_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if e_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if e_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if e_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(20, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-20.5 47)) xlabel(-9(1)9 11 "-9" 12 "-8" 13 "-7" 14 "-6" 15 "-5" 16 "-4" 17 "-3" 18 "-2" 19 "-1" 20 "0" 21 "1" 22 "2" 23 "3" 24 "4" 25 "5", labsize(vsmall) grid) ///
xtitle("Years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -10.5 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 0 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 20.3 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 27.5 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 33 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 38.5 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 45 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(le_diff_20_21_male,replace) 
graph save "${graphs}/le_changes_male.gph", replace
graph export "${graphs}/le_changes_male.pdf", replace
graph export "${graphs}/le_changes_male.tif", replace
graph export "${graphs}/le_changes_male.png", replace

//LIFE EXPECTANCY FEMALE
//use "${data}/AllSites_LE_est_wide", clear
use "${data}/AllSites_LE_est_by_age_wide", clear
keep if lower_age==0 & sex == 2 & !inlist(sitename, "ET042","ET043")
sort e_diff_19_21
gen n = -_n
replace n = n *1.5
gen sitlabel = -7.5

gen xe_diff_20_21 = e_diff_20_21 + 28
gen xlb_diff_20_21 = lb_diff_20_21 + 28
gen xub_diff_20_21 = ub_diff_20_21 + 28

gen pos_19_21 = 38
gen pos_19_20 = 43.5
gen pos_20_21 = 49.5
gen pos_15_19 = 55.5
gen diff_19_20_label = string(e_diff_19_20,"%6.1fc") 
replace diff_19_20_label = "+" +string(e_diff_19_20,"%6.1fc") if e_diff_19_20 > 0
gen diff_20_21_label = string(e_diff_20_21,"%6.1fc") 
replace diff_20_21_label = "+" +string(e_diff_20_21,"%6.1fc") if e_diff_20_21 > 0
gen diff_19_21_label = string(e_diff_19_21,"%6.1fc") 
replace diff_19_21_label = "+" +string(e_diff_19_21,"%6.1fc") if e_diff_19_21 > 0
gen diff_15_19_label = string(e_diff_15_19,"%6.1fc") 
replace diff_15_19_label = "+" +string(e_diff_15_19,"%6.1fc") if e_diff_15_19 > 0


graph twoway  (scatter n e_diff_19_20 if e_diff_19_20 <= 0, msymbol(dot) msize(0.5) color(red)) ///
(scatter n e_diff_19_20 if e_diff_19_20 > 0, msymbol(dot) msize(0.5) color(blue)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if e_diff_19_20 <= 0 , horizontal color(red)) ///
(rspike lb_diff_19_20 ub_diff_19_20 n if e_diff_19_20 > 0 , horizontal color(blue)) ///
(scatter n sitlabel, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
(scatter n xe_diff_20_21 if e_diff_20_21 <= 0, msymbol(dot) msize(0.5) color(red)) ///
(scatter n xe_diff_20_21 if e_diff_20_21 > 0, msymbol(dot) msize(0.5) color(blue)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if e_diff_20_21 <= 0 , horizontal color(red)) ///
(rspike xlb_diff_20_21 xub_diff_20_21 n if e_diff_20_21 > 0 , horizontal color(blue)) ///
(scatter n pos_19_21 if e_diff_19_21 <=0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_21 if e_diff_19_21 > 0, mlabel(diff_19_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_19_20 if e_diff_19_20 <=0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_19_20 if e_diff_19_20 > 0, mlabel(diff_19_20_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_20_21 if e_diff_20_21 <=0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_20_21 if e_diff_20_21 > 0, mlabel(diff_20_21_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
(scatter n pos_15_19 if e_diff_15_19 <=0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(red)) ///
(scatter n pos_15_19 if e_diff_15_19 > 0, mlabel(diff_15_19_label) mlabposition(9) msymbol(i) mlabcolor(blue)) ///
,xline(0, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xline(28, lwidth(thin) lcolor(gs9) lpattern(solid)) ///
xscale(range(-20.5 57.5)) xlabel(-8(2)16 20 "-8" 22 "-6" 24 "-4" 26 "-2" 28 "0" 30 "2" 32 "4" 34 "6", labsize(vsmall) grid) ///
xtitle("Years", size(small)) xsize(8) ///
yscale(range(-1 -27)) yscale(off) ylabel(-1"" -2.5"" -4"" -5.5"" -7"" -8.5"" -10"" -11.5"" -13"" -14.5"" -16"" -17.5"" -19"" -20.5"" -22"" -23.5"" -25"" -26.5"", grid) ///
legend(off) ///
text(0 -10.5 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0 0 "{bf:Change: 2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 28.3 "{bf:Change: 2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 36 "{&Delta} {bf:2019-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 42 "{&Delta} {bf:2019-2020}", size(*.6) color(black) orientation(horizontal)) ///
text(0 48 "{&Delta} {bf:2020-2021}", size(*.6) color(black) orientation(horizontal)) ///
text(0 55.5 "{bf:AVG:} {&Delta} {bf:2015-2019}", size(*.6) color(black) orientation(horizontal)) ///
graphregion(color(white)) name(le_diff_20_21_female,replace) 
graph save "${graphs}/le_changes_female.gph", replace
graph export "${graphs}/le_changes_female.pdf", replace
graph export "${graphs}/le_changes_female.tif", replace
graph export "${graphs}/le_changes_female.png", replace

//Plot contributions to life expectancy gaps among under five
use "${data}/AllSites_LE_Gaps_Selected_Ages_wide", clear
keep if agegrp2== 0 & sex == 0 & !inlist(sitename, "ET042","ET043")
sort delta1 
gen n = -_n
replace n = n *2
gen n2 = n + 0.4
gen n3 = n + 0.8
gen site_label = -2.
twoway (bar delta1 n, horizontal fcolor(emidblue) lcolor(emidblue) barw(.4) lwidth(*.1)) ///
		(bar delta2 n2, horizontal fcolor(dkorange) lcolor(dkorange) barw(.4)lwidth(*.1)) ///
		(bar delta3 n3, horizontal fcolor(maroon) lcolor(maroon) barw(.4)lwidth(*.1)) ///
		(scatter n2 site_label, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
		,xtitle("Years", size(small)) ///
text(0.4 -2.3 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
xscale(range(-3.0 2)) xlabel(-2(0.5)2) ///
yscale(range(-1 -35)) yscale(off) ylabel(-0.5"" -2.5"" -4.5"" -6.5"" -8.5"" -10.5"" -12.5"" -14.5"" -16.5"" -18.5"" -20.5"" -22.5"" -24.5"" -26.5"" -28.5"" -30.5"" -32.5"" -34.5"", grid) ///
legend(order(1 "2019-2021" 2 "2019-2020" 3 "2020-2021" ) ///
		region(lwidth(0) lcolor(white)) position(6) ///
		ring(1) size(small) cols(3)) ///
		graphregion(color(white)) name(LE_Gap_Under5,replace)
		gr_edit .legend.plotregion1.key[1].ysz.editstyle 1
		gr_edit .legend.plotregion1.key[2].ysz.editstyle 1
		gr_edit .legend.plotregion1.key[3].ysz.editstyle 1
graph save "${graphs}/LE_Gap_Under5.gph", replace
graph export "${graphs}/LE_Gap_Under5.pdf", replace
graph export "${graphs}/LE_Gap_Under5.tif", replace
graph export "${graphs}/LE_Gap_Under5.png", replace

//Plot contributions to life expectancy gaps among 15-49 year olds
use "${data}/AllSites_LE_Gaps_Selected_Ages_wide", clear
keep if agegrp2== 15 & sex == 0 & !inlist(sitename, "ET042","ET043")
sort delta1 
gen n = -_n
replace n = n *2
gen n2 = n + 0.4
gen n3 = n + 0.8
keep sitename n n2 n3 
gen site_label = -3
merge 1:m sitename using "${data}/AllSites_LE_Gaps_Selected_Ages_wide"
keep if _merge == 3
drop _merge 

gen s1 = 0
gen s2 = 8
gen s3 = 16
gen fdelta1 = delta1 + 8
gen fdelta2 = delta2 + 8
gen fdelta3 = delta3 + 8

gen xdelta1 = delta1 + 16
gen xdelta2 = delta2 + 16
gen xdelta3 = delta3 + 16

twoway 	(rbar delta1 s1 n if agegrp2 == 15 & sex == 2, horizontal fcolor(emidblue) lcolor(blue) barw(.4) lwidth(*.1)) ///
		(rbar delta2 s1 n2 if agegrp2 == 15 & sex == 2, horizontal fcolor(dkorange) lcolor(red) barw(.4)lwidth(*.1)) ///
		(rbar delta3 s1 n3 if agegrp2 == 15 & sex == 2, horizontal fcolor(maroon) lcolor(maroon) barw(.4)lwidth(*.1)) ///
		(rbar fdelta1 s2 n if agegrp2 == 15 & sex == 2, horizontal fcolor(emidblue) lcolor(blue) barw(.4) lwidth(*.1)) ///
		(rbar fdelta2 s2 n2 if agegrp2 == 15 & sex == 2, horizontal fcolor(dkorange) lcolor(red) barw(.4)lwidth(*.1)) ///
		(rbar fdelta3 s2 n3 if agegrp2 == 15 & sex == 2, horizontal fcolor(maroon) lcolor(maroon) barw(.4)lwidth(*.1)) ///
		(rbar xdelta1 s3 n if agegrp2 == 15 & sex == 2, horizontal fcolor(emidblue) lcolor(blue) barw(.4) lwidth(*.1)) ///
		(rbar xdelta2 s3 n2 if agegrp2 == 15 & sex == 2, horizontal fcolor(dkorange) lcolor(red) barw(.4)lwidth(*.1)) ///
		(rbar xdelta3 s3 n3 if agegrp2 == 15 & sex == 2, horizontal fcolor(maroon) lcolor(maroon) barw(.4)lwidth(*.1)) ///
		(scatter n2 site_label if  agegrp2 == 15 & sex == 1, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
		,xtitle("Years", size(small)) ///
text(0.4 -5 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0.4 0 "{bf:Male}", size(*.6) color(black)) ///
text(0.4 8 "{bf:Female}", size(*.6) color(black)) ///
text(0.4 16 "{bf:Both sexes}", size(*.6) color(black)) ///
xscale(range(-9 19)) xlabel(-3(1)3 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 13 "-3" 14 "-2" 15 "-1" 16 "0" 17 "1" 18 "2" 19 "3") ///
yscale(range(-1 -35)) yscale(off) ylabel(-0.5"" -2.5"" -4.5"" -6.5"" -8.5"" -10.5"" -12.5"" -14.5"" -16.5"" -18.5"" -20.5"" -22.5"" -24.5"" -26.5"" -28.5"" -30.5"" -32.5"" -34.5"", grid) ///
legend(order(1 "2019-2021" 2 "2019-2020" 3 "2020-2021" ) ///
		region(lwidth(0) lcolor(white)) position(6) ///
		ring(1) size(small) cols(3)) ///
		graphregion(color(white)) name(LE_Gap_15to49,replace)
		gr_edit .legend.plotregion1.key[1].ysz.editstyle 1
		gr_edit .legend.plotregion1.key[2].ysz.editstyle 1
		gr_edit .legend.plotregion1.key[3].ysz.editstyle 1
graph save "${graphs}/LE_Gap_15to49.gph", replace
graph export "${graphs}/LE_Gap_15to49.pdf", replace
graph export "${graphs}/LE_Gap_15to49.tif", replace
graph export "${graphs}/LE_Gap_15to49.png", replace

//Plot contributions to life expectancy gaps among 65 year olds
use "${data}/AllSites_LE_Gaps_Selected_Ages_wide", clear
keep if agegrp2== 15 & sex == 0 & !inlist(sitename, "ET042","ET043")
sort delta1 
gen n = -_n
replace n = n *2
gen n2 = n + 0.4
gen n3 = n + 0.8
keep sitename n n2 n3 
gen site_label = -4
merge 1:m sitename using "${data}/AllSites_LE_Gaps_Selected_Ages_wide"
keep if _merge == 3
drop _merge 

gen s1 = 0
gen s2 = 10
gen s3 = 20
gen fdelta1 = delta1 + 10
gen fdelta2 = delta2 + 10
gen fdelta3 = delta3 + 10

gen xdelta1 = delta1 + 20
gen xdelta2 = delta2 + 20
gen xdelta3 = delta3 + 20

twoway 	(rbar delta1 s1 n if agegrp2 == 65 & sex == 2, horizontal fcolor(emidblue) lcolor(blue) barw(.4) lwidth(*.1)) ///
		(rbar delta2 s1 n2 if agegrp2 == 65 & sex == 2, horizontal fcolor(dkorange) lcolor(red) barw(.4)lwidth(*.1)) ///
		(rbar delta3 s1 n3 if agegrp2 == 65 & sex == 2, horizontal fcolor(maroon) lcolor(maroon) barw(.4)lwidth(*.1)) ///
		(rbar fdelta1 s2 n if agegrp2 == 65 & sex == 2, horizontal fcolor(emidblue) lcolor(blue) barw(.4) lwidth(*.1)) ///
		(rbar fdelta2 s2 n2 if agegrp2 == 65 & sex == 2, horizontal fcolor(dkorange) lcolor(red) barw(.4)lwidth(*.1)) ///
		(rbar fdelta3 s2 n3 if agegrp2 == 65 & sex == 2, horizontal fcolor(maroon) lcolor(maroon) barw(.4)lwidth(*.1)) ///
		(rbar xdelta1 s3 n if agegrp2 == 65 & sex == 2, horizontal fcolor(emidblue) lcolor(blue) barw(.4) lwidth(*.1)) ///
		(rbar xdelta2 s3 n2 if agegrp2 == 65 & sex == 2, horizontal fcolor(dkorange) lcolor(red) barw(.4)lwidth(*.1)) ///
		(rbar xdelta3 s3 n3 if agegrp2 == 65 & sex == 2, horizontal fcolor(maroon) lcolor(maroon) barw(.4)lwidth(*.1)) ///
		(scatter n2 site_label if  agegrp2 == 65 & sex == 1, mlabel(sitename_location) mlabposition(9) msymbol(i) mlabcolor(gs0)) ///
		,xtitle("Years", size(small)) ///
text(0.4 -6 "{bf:HDSS setting}", size(*.6) color(black) just(left)) ///
text(0.4 0 "{bf:Male}", size(*.6) color(black)) ///
text(0.4 10 "{bf:Female}", size(*.6) color(black)) ///
text(0.4 20 "{bf:Both sexes}", size(*.6) color(black)) ///
xscale(range(-11 19)) xlabel(-4(1)4 6 "-4" 7 "-3" 8 "-2" 9 "-1" 10 "0" 11 "1" 12 "2" 13 "3" 14 "4" 16 "-4" 17 "-3" 18 "-2" 19 "-1" 20 "0" 21 "1" 22 "2" 23 "3" 24 "4") ///
yscale(range(-1 -35)) yscale(off) ylabel(-0.5"" -2.5"" -4.5"" -6.5"" -8.5"" -10.5"" -12.5"" -14.5"" -16.5"" -18.5"" -20.5"" -22.5"" -24.5"" -26.5"" -28.5"" -30.5"" -32.5"" -34.5"", grid) ///
legend(order(1 "2019-2021" 2 "2019-2020" 3 "2020-2021" ) ///
		region(lwidth(0) lcolor(white)) position(6) ///
		ring(1) size(small) cols(3)) ///
		graphregion(color(white)) name(LE_Gap_65,replace)
		gr_edit .legend.plotregion1.key[1].ysz.editstyle 1
		gr_edit .legend.plotregion1.key[2].ysz.editstyle 1
		gr_edit .legend.plotregion1.key[3].ysz.editstyle 1
graph save "${graphs}/LE_Gap_65.gph", replace
graph export "${graphs}/LE_Gap_65.pdf", replace
graph export "${graphs}/LE_Gap_65.tif", replace
graph export "${graphs}/LE_Gap_65.png", replace


use "${data}/AllSites_LE_est", clear
rename lower_age age
keep year sex age e elb eub sitename
keep if age == 0
drop if year >2021
twoway (scatter e year if sitename=="ZA031" & sex == 1 ///
			,mcolor(black) lcolor(black) recast(connected) lpattern(solid)) ///
		(scatter e year if sitename=="ZA011" & sex == 1 ///
			,mcolor(blue) lcolor(blue) recast(connected) lpattern(solid)) ///
		(scatter e year if sitename=="ZA021" & sex == 1 ///
			,mcolor(red) lcolor(red) recast(connected) lpattern(solid)) ///
		(scatter e year if sitename=="MZ011" & sex == 1 ///
			,mcolor(green) lcolor(green) recast(connected) lpattern(solid)) ///
,xlabel(2015(1)2021 , nogrid angle(0)) ///
ylabel(40 (5) 75,format(%9.0fc) labsize(*1.2) grid angle(0)) ///
ytitle("Life expectancy at birth",height(3) ) ///
xtitle("Year",height(3) ) ///
legend(cols(2) position(12) ///
		order(1 "AHRI, South Africa" 2 "Agincourt, South Africa" 3 "Dimamo, South Africa" 4 "Manhica, Mozambique" ) ///
		region(lwidth(0) lcolor(white)) ring(1) size(*1)) ///
title("Males") ///
graphregion(color(white)) name(SouthernAfrica_LE_M,replace) 
graph save "${graphs}/SouthernAfrica_LE_M.gph", replace
graph export "${graphs}/SouthernAfrica_LE_M.pdf", replace
graph export "${graphs}/SouthernAfrica_LE_M.png", replace
graph export "${graphs}/SouthernAfrica_LE_M.tif", replace


twoway (scatter e year if sitename=="ZA031" & sex == 2 ///
			,mcolor(black) lcolor(black) recast(connected) lpattern(solid)) ///
		(scatter e year if sitename=="ZA011" & sex == 2 ///
			,mcolor(blue) lcolor(blue) recast(connected) lpattern(solid)) ///
		(scatter e year if sitename=="ZA021" & sex == 2 ///
			,mcolor(red) lcolor(red) recast(connected) lpattern(solid)) ///
		(scatter e year if sitename=="MZ011" & sex == 2 ///
			,mcolor(green) lcolor(green) recast(connected) lpattern(solid)) ///
,xlabel(2015(1)2021 , nogrid angle(0)) ///
ylabel(40 (5) 75,format(%9.0fc) labsize(*1.2) grid angle(0)) ///
ytitle("Life expectancy at birth",height(3) ) ///
xtitle("Year",height(3) ) ///
legend(cols(2) position(12) ///
		order(1 "AHRI, South Africa" 2 "Agincourt, South Africa" 3 "Dimamo, South Africa" 4 "Manhica, Mozambique" ) ///
		region(lwidth(0) lcolor(white)) ring(1) size(*1)) ///
title("Females") ///
graphregion(color(white)) name(SouthernAfrica_LE_M,replace) 
graph save "${graphs}/SouthernAfrica_LE_F.gph", replace
graph export "${graphs}/SouthernAfrica_LE_F.pdf", replace
graph export "${graphs}/SouthernAfrica_LE_F.png", replace
graph export "${graphs}/SouthernAfrica_LE_F.tif", replace

