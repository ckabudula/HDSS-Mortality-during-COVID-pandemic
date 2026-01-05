local site = "${site}"
//local site = "${sitename}"
global yearstart = 2015

global agecutofftop = 90			//upper age limit, can be set to a very high value (e.g.100)

global LEcompstart = 2019				//starting period for overall LE comparison (period of lowest observed LE)
global LEcompend = 2021				//end period for overall LE comparison (last period with data)


use "${data}/${sitename}_LE_est_wide", clear

// decompose life expectancy difference by age using formulas from 
// Arriaga EE. Measuring and explaining the change in life expectancies. 
// Demography 1984;21:83-96.

*Direct effect : l${LEcompstart} * (L${LEcompend}/l${LEcompend}-L${LEcompstart}/l${LEcompstart})
*Indirect effect and interaction term:  T${LEcompend}[_n+1]*(l${LEcompstart}/l${LEcompend} - l${LEcompstart}[_n+1]/l${LEcompend}[_n+1])
gen delta = l${LEcompstart} * (L${LEcompend}/l${LEcompend}-L${LEcompstart}/l${LEcompstart})+T${LEcompend}[_n+1]*(l${LEcompstart}/l${LEcompend} - l${LEcompstart}[_n+1]/l${LEcompend}[_n+1]) 
bysort sex : replace delta = l${LEcompstart}*(T${LEcompend}/l${LEcompend}-T${LEcompstart}/l${LEcompstart}) if agegrp==${agecutofftop}-5

* Code below is only to reassure that the deltas sum to the total life expectancy gap; is of no further relevance & could be left out if so desired 
egen sumdelt =total(delta) if sex==0 			// caculate the sum of the deltas
egen sumdeltaf =total(delta) if sex==2 	
replace sumdelt = sumdeltaf if sex==2 			
egen sumdeltam =total(delta) if sex==1 
replace sumdelt = sumdeltam if sex==1 
gen  legapinfem= e${LEcompend}-e${LEcompstart} if sex==2 & agegrp==0	//caculate the overall LE gap for the reference period
gen  legapinmal= e${LEcompend}-e${LEcompstart} if sex==1 & agegrp==0
di "Comparison of LE gain and the sum of the deltas (should be the same)"
list legapinfem sumdeltaf if  sex==2 & agegrp==0   
list legapinmal sumdeltam if  sex==1 & agegrp==0

assert round(legapinfem,0.05)==round(sumdeltaf,0.05) if sex==2 & agegrp==0  //program will be interrupted if the estimates differ
assert round(legapinmal,0.05)==round(sumdeltam,0.05) if sex==1 & agegrp==0  

save "${data}/${sitename}_LE_Decomposition_2019_2021",replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("LE_Decomposition2019_2021")sheetreplace firstrow(variables)

keep agegrp sex delta sumdelt
gen period = "2019 to 2021"
gen centreid = "${sitename}"
save "${data}/${sitename}_LE_Gaps",replace

*creating the graph
gen agegrp2=agegrp-0.6
gen agegrp3=agegrp+0.6

twoway (bar  delta agegrp2 if sex==1 & agegrp<=${agecutofftop}-5) ///
	   (bar  delta agegrp3 if sex==2 & agegrp<=${agecutofftop}-5) ///
	   ,ylabel(-1(0.2)1, format(%5.1f) angle(0) labsize(small)) ///
	   ytitle("Contribution, years",height(2) size(small))  ///
	   xtitle("Age group",height(3) size(small)) ///
	   xlabel(0 "<1" 1 "1-4" 5 "5-9" 10 "10-14" 15 "15-19" 20 "20-24" 25 "25-29" 30 "30-34" 35 "35-39" 40 "40-44" 45 "45-49" ///
	   50 "50-54" 55 "55-59" 60 "60-64" 65 "65-69" 70 "70-74" 75 "75-79" 80 "80-84" ///
	   85 "85-89", labsize(small) alternate labgap(*6)) ///
	   legend(order(1 "Male" 2 "Female") ///
		region(lwidth(0) lcolor(white)) position(12) ///
		ring(1) size(small) cols(4)) ///
	   title("Age contribution to LE changes") ///
	   subtitle("`site': ${LEcompstart} to ${LEcompend}") ///
	graphregion(color(white)) name(${sitename}_LE_Decomposition,replace) 
	graph save "${graphs}/${sitename}_LE_Decomposition.gph", replace
	graph export "${graphs}/${sitename}_LE_Decomposition.pdf", replace
	graph export "${graphs}/${sitename}_LE_Decomposition.png", replace
	graph export "${graphs}/${sitename}_LE_Decomposition.tif", replace

	
*===================================================	
//REPEAT FOR 2019 to 2020
*====================================================

global agecutofftop = 90			//upper age limit, can be set to a very high value (e.g.100)

global LEcompstart = 2019				//starting period for overall LE comparison (period of lowest observed LE)
global LEcompend = 2020				//end period for overall LE comparison (last period with data)


use "${data}/${sitename}_LE_est_wide", clear
gen delta = l${LEcompstart} * (L${LEcompend}/l${LEcompend}-L${LEcompstart}/l${LEcompstart})+T${LEcompend}[_n+1]*(l${LEcompstart}/l${LEcompend} - l${LEcompstart}[_n+1]/l${LEcompend}[_n+1]) 
bysort sex : replace delta = l${LEcompstart}*(T${LEcompend}/l${LEcompend}-T${LEcompstart}/l${LEcompstart}) if agegrp==${agecutofftop}-5

* Code below is only to reassure that the deltas sum to the total life expectancy gap; is of no further relevance & could be left out if so desired 
egen sumdelt =total(delta) if sex==0 			// caculate the sum of the deltas
egen sumdeltaf =total(delta) if sex==2 	
replace sumdelt = sumdeltaf if sex==2 			
egen sumdeltam =total(delta) if sex==1 
replace sumdelt = sumdeltam if sex==1 
gen  legapinfem= e${LEcompend}-e${LEcompstart} if sex==2 & agegrp==0	//caculate the overall LE gap for the reference period
gen  legapinmal= e${LEcompend}-e${LEcompstart} if sex==1 & agegrp==0
di "Comparison of LE gain and the sum of the deltas (should be the same)"
list legapinfem sumdeltaf if  sex==2 & agegrp==0   
list legapinmal sumdeltam if  sex==1 & agegrp==0

assert round(legapinfem,0.05)==round(sumdeltaf,0.05) if sex==2 & agegrp==0  //program will be interrupted if the estimates differ
assert round(legapinmal,0.05)==round(sumdeltam,0.05) if sex==1 & agegrp==0  

save "${data}/${sitename}_LE_Decomposition_2019_2020",replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("LE_Decomposition2019_2020")sheetreplace firstrow(variables)

keep agegrp sex delta sumdelt
gen period = "2019 to 2020"
gen centreid = "${sitename}"
append using "${data}/${sitename}_LE_Gaps"
save "${data}/${sitename}_LE_Gaps",replace

*===================================================	
//REPEAT FOR 2020 to 2021
*====================================================

global agecutofftop = 90			//upper age limit, can be set to a very high value (e.g.100)

global LEcompstart = 2020				//starting period for overall LE comparison (period of lowest observed LE)
global LEcompend = 2021				//end period for overall LE comparison (last period with data)


use "${data}/${sitename}_LE_est_wide", clear
gen delta = l${LEcompstart} * (L${LEcompend}/l${LEcompend}-L${LEcompstart}/l${LEcompstart})+T${LEcompend}[_n+1]*(l${LEcompstart}/l${LEcompend} - l${LEcompstart}[_n+1]/l${LEcompend}[_n+1]) 
bysort sex : replace delta = l${LEcompstart}*(T${LEcompend}/l${LEcompend}-T${LEcompstart}/l${LEcompstart}) if agegrp==${agecutofftop}-5

* Code below is only to reassure that the deltas sum to the total life expectancy gap; is of no further relevance & could be left out if so desired 
egen sumdelt =total(delta) if sex==0 			// caculate the sum of the deltas
egen sumdeltaf =total(delta) if sex==2 	
replace sumdelt = sumdeltaf if sex==2 			
egen sumdeltam =total(delta) if sex==1 
replace sumdelt = sumdeltam if sex==1 
gen  legapinfem= e${LEcompend}-e${LEcompstart} if sex==2 & agegrp==0	//caculate the overall LE gap for the reference period
gen  legapinmal= e${LEcompend}-e${LEcompstart} if sex==1 & agegrp==0
di "Comparison of LE gain and the sum of the deltas (should be the same)"
list legapinfem sumdeltaf if  sex==2 & agegrp==0   
list legapinmal sumdeltam if  sex==1 & agegrp==0

assert round(legapinfem,0.05)==round(sumdeltaf,0.05) if sex==2 & agegrp==0  //program will be interrupted if the estimates differ
assert round(legapinmal,0.05)==round(sumdeltam,0.05) if sex==1 & agegrp==0  

save "${data}/${sitename}_LE_Decomposition_2020_2021",replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("LE_Decomposition2020_2021")sheetreplace firstrow(variables)

keep agegrp sex delta sumdelt
gen period = "2020 to 2021"
gen centreid = "${sitename}"
append using "${data}/${sitename}_LE_Gaps"
save "${data}/${sitename}_LE_Gaps",replace
//export to excel
quietly export excel using "${output}/${sitename}.xlsx", sheet("LE_Gaps")sheetreplace firstrow(variables)

