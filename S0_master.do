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

*
*
foreach site in BD011 BD013 BD014 BF021 ET041 ET042 ET043 GH011 IN021 KE021 ///
	KE081 MW011 MZ011 TZ021 UG011 ZA011 ZA021 ZA031 KE022 ZA081  { 
global sitename="`site'"

//global sitename="ZA011"

if "${sitename}" == "BD011" {
	global site = "Matlab (BD011)"
	}
else if "${sitename}" == "BD013" {
	global site = "Chakaria (BD013)"
	}
else if "${sitename}" == "BD014" {
	global site = "Dhaka (BD014)"
	}
else if "${sitename}" == "BF021" {
	global site = "Nanoro (BF021)"
	}
else if "${sitename}" == "ET041" {
	global site = "Kersa (ET041)"
	}
else if "${sitename}" == "ET042" {
	global site = "Kersa (ET042)"
	}
else if "${sitename}" == "ET043" {
	global site = "Kersa (ET043)"
	}
else if "${sitename}" == "GH011" {
	global site = "Navrongo (GH011)"
	}
else if "${sitename}" == "IN021" {
	global site = "Vadu (IN021)"
	}
else if "${sitename}" == "KE021" {
	global site = "Siaya-Karemo (KE021)"
	}
else if "${sitename}" == "KE081" {
	global site = "Kaloleni-Rabai (KE081)"
	}
else if "${sitename}" == "KE022" {
	global site = "Manyatta (KE022)"
	}
else if "${sitename}" == "MW011" {
	global site = "Karonga (MW011)"
	}
else if "${sitename}" == "MZ011" {
	global site = "Manhica (MZ011)"
	}
else if "${sitename}" == "TZ021" {
	global site = "Magu (TZ021)"
	}
else if "${sitename}" == "UG011" {
	global site = "Iganga (UG011)"
	}
else if "${sitename}" == "ZA011" {
	global site = "Agincourt (ZA011)"
	}
else if "${sitename}" == "ZA021" {
	global site = "Dimamo (ZA021)"
	}
else if "${sitename}" == "ZA031" {
	global site = "AHRI (ZA031)"
	}
else if "${sitename}" == "ZA081" {
	global site = "Soweto (ZA081)"
	}

*------------------------------------------------------------------------------------*		            	               

cd "${workingdir}"

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

label define sex_lbl 0 "both sexes" 1 "male" 2 "female", modify 
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

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				STSET WITH CALENDAR TIME AS THE TIMESCALE					 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
/*
-stset- the data in a different way, so that _t0 and _t are counting from a date in the calendar.
For that use -enter()- rather than -origin()-, because this counts all times from 0, which is 
10jan1960 is Stata's date format.
*/
use "${data}/${sitename}_RawCensoredEpisodes", clear
*stset enddate, id(individualid) fail(died) enter(startdate) exit(enddate) // this will drop subsequent records of the same Id. So not recommended. 
//stset enddate, id(individualid) fail(died) enter(startdate)  
stset enddate, id(individualid) fail(died) time0(startdate)  
count if _t0 >= _t
drop if _t0 >= _t
save "${data}/${sitename}_RawCensoredEpisodes_calendar_st_ready", replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				COMPUTE AND PLOT PERSON YEARS AND NUMBER OF DEATHS				**
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
do "${workingdir}/do/S1_PersonYearsAndDeaths".do

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				CREATE POPULATION PYRAMIDS									 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
do "${workingdir}/do/S2_create_pop_pyramids".do

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				MORTALITY RATES BY AGE, SEX, YEAR								 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
do "${workingdir}/do/S3_MortalityRates".do

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				LIFE EXPECTANCY ESTIMATES								 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//do "${workingdir}/do/S4_LE_Estimates".do
do "${workingdir}/do/S4_LE_EstimatesV2".do

do "${workingdir}/do/S5_Decompose_LE_Differences".do

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				LIFE EXPECTANCY DIFFERENCES DECOMPOSITION								 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
do "${workingdir}/do/S5_UnderFiveAndAdultMortalityRates".do

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
**				MORTALITY RATES BY MONTH								 **
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
do "${workingdir}/do/S6_MonthlyMortalityRates".do
}

do "${workingdir}/do/S7_CombineEstimates".do
do "${workingdir}/do/S8_PlotMortalityChages".do



