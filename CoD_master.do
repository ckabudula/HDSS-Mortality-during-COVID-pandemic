***************************************************************************************
*-------------------------------------------------------------------------------------*
********  				 MORTALITY ANALYSIS                          ********
*-------------------------------------------------------------------------------------*
***************************************************************************************

/*

DESCRIPTION
This do-file runs other do files for excess mortality analysis
*/

clear all
set mem 1000m
set more off,permanently

*------DEFINE GLOBAL MACROS---------------------------------------------------------------*	

*location of do-files and working directory for this analysis
*global workingdir = "~/OneDrive - University of Witwatersrand/DataDistribution/HDSSExcessMortality/Analysis_Workshop"

global workingdir = "~/GoogleDrive/FromOneDrive/Analytics/HDSSExcessMortality/Analysis_Workshop" 
*location of dataset
global data ="${workingdir}/data/AnalysisReady"
*location of output folder
global output = "${workingdir}/output"
*location of graphs
global graphs = "${workingdir}/graphs"

global yearstart = 2015
global yearend = 2021

cd "${workingdir}"

foreach site in BD011 BD013 BD014 BF021 ET041 GH011 KE021 KE022 ///
	MW011 MZ011 ZA011 ZA021 ZA031 { 
global sitename="`site'"

//global sitename="ZA011"
//global sitename="MW011"

if "${sitename}" == "BD011" {
	global site = "Matlab (Bangladesh)"
	}
else if "${sitename}" == "BD013" {
	global site = "Chakaria (Bangladesh)"
	}
else if "${sitename}" == "BD014" {
	global site = "Dhaka (Bangladesh)"
	}
else if "${sitename}" == "BF021" {
	global site = "Nanoro (Burkina Faso)"
	}
else if "${sitename}" == "ET041" {
	global site = "Kersa (Ethiopia)"
	}
else if "${sitename}" == "ET042" {
	global site = "Kersa (Ethiopia)"
	}
else if "${sitename}" == "ET043" {
	global site = "Kersa (Ethiopia)"
	}
else if "${sitename}" == "GH011" {
	global site = "Navrongo (Ghana)"
	}
else if "${sitename}" == "IN021" {
	global site = "Vadu (India)"
	}
else if "${sitename}" == "KE021" {
	global site = "Siaya-Karemo (Kenya)"
	}
else if "${sitename}" == "KE081" {
	global site = "Kaloleni-Rabai (Kenya)"
	}
else if "${sitename}" == "KE022" {
	global site = "Manyatta (Kenya)"
	}
else if "${sitename}" == "MW011" {
	global site = "Karonga (Malawi)"
	}
else if "${sitename}" == "MZ011" {
	global site = "Manhica (Mozambique)"
	}
else if "${sitename}" == "TZ021" {
	global site = "Magu (Tanzania)"
	}
else if "${sitename}" == "UG011" {
	global site = "Iganga (Uganda)"
	}
else if "${sitename}" == "ZA011" {
	global site = "Agincourt (South Africa)"
	}
else if "${sitename}" == "ZA021" {
	global site = "Dimamo (South Africa)"
	}
else if "${sitename}" == "ZA031" {
	global site = "AHRI (South Africa)"
	}
else if "${sitename}" == "ZA081" {
	global site = "Soweto (South Africa)"
	}

*------------------------------------------------------------------------------------*		            	               
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				READ RAW DATA							 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
import delimited "${data}/${sitename}_RawCensoredEpisodes.csv", varnames(1) encoding(ISO-8859-1)clear
foreach var of varlist dob  startdate  enddate {
	gen `var'2 = date(`var', "YMD")
	format `var'2 %td
	drop `var'
	rename `var'2 `var'
}
gen dod = enddate if endevent == "DTH"
gen died = endevent == "DTH"

label define sex_lbl 1 "male" 2 "female" 
label values sex sex_lbl

* CHECK AND DROP EPISODES WITH UNKNOWN SEX
tab sex
count if ! inlist(sex,1,2)
drop if ! inlist(sex,1,2)

* DROP EPISODES WITH NEGATIVE DURATION
count if startdate>enddate
drop if startdate>enddate


***IDENTIFY INDIVIDUALS WITH EXIT AND ENTRY ON THE SAME DAY 
capture drop same_exit_entry
bys individualid: gen same_exit_entry=1 if enddate[_n-1]==startdate
* Add 1 day to the date of entry of the next event
replace startdate=startdate + 1 if same_exit_entry==1 
drop same_exit_entry

* CHECK NUMBER OF EPISODES WITH ZERO DURATION
count if startdate==enddate

* GIVE 1/5 OF A DAY TO INDIVIDUALS WITH STARTDATE = ENDDATE 
* SO THAT THEY ARE INCLUDED IN THE SURVIVAL TIME CALCULATIONS
replace enddate = enddate+0.2 if startdate == enddate
save "${data}/${sitename}_RawCensoredEpisodes", replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				STSET WITH DEATH AS THE FAILURE						 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
use "${data}/${sitename}_RawCensoredEpisodes", clear
stset enddate, id(individualid) failure(died) time0(startdate) origin(dob) scale(365.25)
count if _t0 >= _t
drop if _t0 >= _t
save "${data}/${sitename}_RawCensoredEpisodes_st_ready", replace

//do "${workingdir}/do/CausesOfDeath/cause_of_death".do *this is for InSilicoVA
do "${workingdir}/do/CausesOfDeath/InterVA_cause_of_death".do
do "${workingdir}/do/CausesOfDeath/top_cause_of_death_plots".do
}

do "${workingdir}/do/CausesOfDeath/RawCensoredEpisodes_with_cod".do


