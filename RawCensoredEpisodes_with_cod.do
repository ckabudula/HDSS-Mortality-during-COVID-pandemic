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

cd "${workingdir}"

global yearstart = 2015
global yearend = 2021

//BD014 only has period 3
//GH011  ids do not match
//GH011 --csmfr4 not found
//KE022 --csmfr6 not found
foreach site in BD011 BD013 BD014 BF021 ET041 GH011 KE021 KE022 ///
	MW011 MZ011 ZA011 ZA021 ZA031 { 
global sitename="`site'"

//global sitename="ZA011"
//global sitename="GH011"

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
	

//load insilicova results
/*
insheet using "${data}/cause_of_death/${sitename}_Insilico_CauseOfDeath.csv", comma names clear
*/
//load InterVA results

di "==========${sitename}========"
insheet using "${data}/cause_of_death/${sitename}_InterVA_CauseOfDeath.csv", comma names clear
rename id individualid

count
merge 1:m individualid using "${data}/${sitename}_RawCensoredEpisodes"
tab cause1 if died == 0
replace cause1 = "" if died == 0
replace lik1 = . if died == 0
gen va_done = _merge == 3 & died == 1
drop if _merge == 1
drop _merge
replace cause1 = trim(cause1)

* calculate residual indeterminate fractions
destring lik1, replace
destring lik2, replace
destring lik3, replace
replace lik1=0 if lik1==.
replace lik2=0 if lik2==.
replace lik3=0 if lik3==.
gen resid_lik=1-lik1-lik2-lik3 if died == 1


*generate numeric cause variables
replace cause1=trim(cause1)
replace cause2=trim(cause2)
replace cause3=trim(cause3)
gen causen=.
replace causen=1 if cause1=="Sepsis (non-obstetric)"
replace causen=2 if cause1=="Acute resp infect incl pneumonia"
replace causen=3 if cause1=="HIV/AIDS related death"
replace causen=4 if cause1=="Diarrhoeal diseases"
replace causen=5 if cause1=="Malaria"
replace causen=6 if cause1=="Measles"
replace causen=7 if cause1=="Meningitis and encephalitis"
replace causen=8 if cause1=="Tetanus"
replace causen=9 if cause1=="Pulmonary tuberculosis"
replace causen=10 if cause1=="Pertussis"
replace causen=11 if cause1=="Haemorrhagic fever (non-dengue)"
replace causen=12 if cause1=="Dengue fever"
replace causen=13 if cause1=="Other and unspecified infect dis"
replace causen=14 if cause1=="Oral neoplasms"
replace causen=15 if cause1=="Digestive neoplasms"
replace causen=16 if cause1=="Respiratory neoplasms"
replace causen=17 if cause1=="Breast neoplasms"
replace causen=18 if cause1=="Reproductive neoplasms MF"
replace causen=19 if cause1=="Other and unspecified neoplasms"
replace causen=20 if cause1=="Severe anaemia"
replace causen=21 if cause1=="Severe malnutrition"
replace causen=22 if cause1=="Diabetes mellitus"
replace causen=23 if cause1=="Acute cardiac disease"
replace causen=24 if cause1=="Stroke"
replace causen=25 if cause1=="Sickle cell with crisis"
replace causen=26 if cause1=="Other and unspecified cardiac dis"
replace causen=27 if cause1=="Chronic obstructive pulmonary dis"
replace causen=28 if cause1=="Asthma"
replace causen=29 if cause1=="Acute abdomen"
replace causen=30 if cause1=="Liver cirrhosis"
replace causen=31 if cause1=="Renal failure"
replace causen=32 if cause1=="Epilepsy"
replace causen=33 if cause1=="Ectopic pregnancy"
replace causen=34 if cause1=="Abortion-related death"
replace causen=35 if cause1=="Pregnancy-induced hypertension"
replace causen=36 if cause1=="Obstetric haemorrhage"
replace causen=37 if cause1=="Obstructed labour"
replace causen=38 if cause1=="Pregnancy-related sepsis"
replace causen=39 if cause1=="Anaemia of pregnancy"
replace causen=40 if cause1=="Ruptured uterus"
replace causen=41 if cause1=="Other and unspecified maternal CoD"
replace causen=42 if cause1=="Prematurity"
replace causen=43 if cause1=="Birth asphyxia"
replace causen=44 if cause1=="Neonatal pneumonia"
replace causen=45 if cause1=="Neonatal sepsis"
replace causen=46 if cause1=="Congenital malformation"
replace causen=47 if cause1=="Other and unspecified neonatal CoD"
replace causen=48 if cause1=="Fresh stillbirth"
replace causen=49 if cause1=="Macerated stillbirth"
replace causen=50 if cause1=="Road traffic accident"
replace causen=51 if cause1=="Other transport accident"
replace causen=52 if cause1=="Accid fall"
replace causen=53 if cause1=="Accid drowning and submersion"
replace causen=54 if cause1=="Accid expos to smoke fire & flame"
replace causen=55 if cause1=="Contact with venomous plant/animal"
replace causen=56 if cause1=="Accid poisoning & noxious subs"
replace causen=57 if cause1=="Intentional self-harm"
replace causen=58 if cause1=="Assault"
replace causen=59 if cause1=="Exposure to force of nature"
replace causen=60 if cause1=="Other and unspecified external CoD"
replace causen=61 if cause1=="Other and unspecified NCD"
replace causen=70 if cause1=="Undetermined"
replace causen=70 if causen == . & died == 1
replace lik1=1 if causen == . & died == 1

gen causen2=.
replace causen2=1 if cause2=="Sepsis (non-obstetric)"
replace causen2=2 if cause2=="Acute resp infect incl pneumonia"
replace causen2=3 if cause2=="HIV/AIDS related death"
replace causen2=4 if cause2=="Diarrhoeal diseases"
replace causen2=5 if cause2=="Malaria"
replace causen2=6 if cause2=="Measles"
replace causen2=7 if cause2=="Meningitis and encephalitis"
replace causen2=8 if cause2=="Tetanus"
replace causen2=9 if cause2=="Pulmonary tuberculosis"
replace causen2=10 if cause2=="Pertussis"
replace causen2=11 if cause2=="Haemorrhagic fever (non-dengue)"
replace causen2=12 if cause2=="Dengue fever"
replace causen2=13 if cause2=="Other and unspecified infect dis"
replace causen2=14 if cause2=="Oral neoplasms"
replace causen2=15 if cause2=="Digestive neoplasms"
replace causen2=16 if cause2=="Respiratory neoplasms"
replace causen2=17 if cause2=="Breast neoplasms"
replace causen2=18 if cause2=="Reproductive neoplasms MF"
replace causen2=19 if cause2=="Other and unspecified neoplasms"
replace causen2=20 if cause2=="Severe anaemia"
replace causen2=21 if cause2=="Severe malnutrition"
replace causen2=22 if cause2=="Diabetes mellitus"
replace causen2=23 if cause2=="Acute cardiac disease"
replace causen2=24 if cause2=="Stroke"
replace causen2=25 if cause2=="Sickle cell with crisis"
replace causen2=26 if cause2=="Other and unspecified cardiac dis"
replace causen2=27 if cause2=="Chronic obstructive pulmonary dis"
replace causen2=28 if cause2=="Asthma"
replace causen2=29 if cause2=="Acute abdomen"
replace causen2=30 if cause2=="Liver cirrhosis"
replace causen2=31 if cause2=="Renal failure"
replace causen2=32 if cause2=="Epilepsy"
replace causen2=33 if cause2=="Ectopic pregnancy"
replace causen2=34 if cause2=="Abortion-related death"
replace causen2=35 if cause2=="Pregnancy-induced hypertension"
replace causen2=36 if cause2=="Obstetric haemorrhage"
replace causen2=37 if cause2=="Obstructed labour"
replace causen2=38 if cause2=="Pregnancy-related sepsis"
replace causen2=39 if cause2=="Anaemia of pregnancy"
replace causen2=40 if cause2=="Ruptured uterus"
replace causen2=41 if cause2=="Other and unspecified maternal CoD"
replace causen2=42 if cause2=="Prematurity"
replace causen2=43 if cause2=="Birth asphyxia"
replace causen2=44 if cause2=="Neonatal pneumonia"
replace causen2=45 if cause2=="Neonatal sepsis"
replace causen2=46 if cause2=="Congenital malformation"
replace causen2=47 if cause2=="Other and unspecified neonatal CoD"
replace causen2=48 if cause2=="Fresh stillbirth"
replace causen2=49 if cause2=="Macerated stillbirth"
replace causen2=50 if cause2=="Road traffic accident"
replace causen2=51 if cause2=="Other transport accident"
replace causen2=52 if cause2=="Accid fall"
replace causen2=53 if cause2=="Accid drowning and submersion"
replace causen2=54 if cause2=="Accid expos to smoke fire & flame"
replace causen2=55 if cause2=="Contact with venomous plant/animal"
replace causen2=56 if cause2=="Accid poisoning & noxious subs"
replace causen2=57 if cause2=="Intentional self-harm"
replace causen2=58 if cause2=="Assault"
replace causen2=59 if cause2=="Exposure to force of nature"
replace causen2=60 if cause2=="Other and unspecified external CoD"
replace causen2=61 if cause2=="Other and unspecified NCD"
replace causen2=70 if cause2=="Undetermined"
replace causen2=70 if causen2 == . & died == 1
replace lik1=1 if causen2 == . & died == 1


gen causen3=.
replace causen3=1 if cause3=="Sepsis (non-obstetric)"
replace causen3=2 if cause3=="Acute resp infect incl pneumonia"
replace causen3=3 if cause3=="HIV/AIDS related death"
replace causen3=4 if cause3=="Diarrhoeal diseases"
replace causen3=5 if cause3=="Malaria"
replace causen3=6 if cause3=="Measles"
replace causen3=7 if cause3=="Meningitis and encephalitis"
replace causen3=8 if cause3=="Tetanus"
replace causen3=9 if cause3=="Pulmonary tuberculosis"
replace causen3=10 if cause3=="Pertussis"
replace causen3=11 if cause3=="Haemorrhagic fever (non-dengue)"
replace causen3=12 if cause3=="Dengue fever"
replace causen3=13 if cause3=="Other and unspecified infect dis"
replace causen3=14 if cause3=="Oral neoplasms"
replace causen3=15 if cause3=="Digestive neoplasms"
replace causen3=16 if cause3=="Respiratory neoplasms"
replace causen3=17 if cause3=="Breast neoplasms"
replace causen3=18 if cause3=="Reproductive neoplasms MF"
replace causen3=19 if cause3=="Other and unspecified neoplasms"
replace causen3=20 if cause3=="Severe anaemia"
replace causen3=21 if cause3=="Severe malnutrition"
replace causen3=22 if cause3=="Diabetes mellitus"
replace causen3=23 if cause3=="Acute cardiac disease"
replace causen3=24 if cause3=="Stroke"
replace causen3=25 if cause3=="Sickle cell with crisis"
replace causen3=26 if cause3=="Other and unspecified cardiac dis"
replace causen3=27 if cause3=="Chronic obstructive pulmonary dis"
replace causen3=28 if cause3=="Asthma"
replace causen3=29 if cause3=="Acute abdomen"
replace causen3=30 if cause3=="Liver cirrhosis"
replace causen3=31 if cause3=="Renal failure"
replace causen3=32 if cause3=="Epilepsy"
replace causen3=33 if cause3=="Ectopic pregnancy"
replace causen3=34 if cause3=="Abortion-related death"
replace causen3=35 if cause3=="Pregnancy-induced hypertension"
replace causen3=36 if cause3=="Obstetric haemorrhage"
replace causen3=37 if cause3=="Obstructed labour"
replace causen3=38 if cause3=="Pregnancy-related sepsis"
replace causen3=39 if cause3=="Anaemia of pregnancy"
replace causen3=40 if cause3=="Ruptured uterus"
replace causen3=41 if cause3=="Other and unspecified maternal CoD"
replace causen3=42 if cause3=="Prematurity"
replace causen3=43 if cause3=="Birth asphyxia"
replace causen3=44 if cause3=="Neonatal pneumonia"
replace causen3=45 if cause3=="Neonatal sepsis"
replace causen3=46 if cause3=="Congenital malformation"
replace causen3=47 if cause3=="Other and unspecified neonatal CoD"
replace causen3=48 if cause3=="Fresh stillbirth"
replace causen3=49 if cause3=="Macerated stillbirth"
replace causen3=50 if cause3=="Road traffic accident"
replace causen3=51 if cause3=="Other transport accident"
replace causen3=52 if cause3=="Accid fall"
replace causen3=53 if cause3=="Accid drowning and submersion"
replace causen3=54 if cause3=="Accid expos to smoke fire & flame"
replace causen3=55 if cause3=="Contact with venomous plant/animal"
replace causen3=56 if cause3=="Accid poisoning & noxious subs"
replace causen3=57 if cause3=="Intentional self-harm"
replace causen3=58 if cause3=="Assault"
replace causen3=59 if cause3=="Exposure to force of nature"
replace causen3=60 if cause3=="Other and unspecified external CoD"
replace causen3=61 if cause3=="Other and unspecified NCD"
replace causen3=70 if cause3=="Undetermined"
replace causen3=70 if causen3 == . & died == 1
replace lik1=1 if causen3 == . & died == 1


* define cause of death labels
cap label define causen 1 "Sepsis (non-obstetric)" ,add
cap label define causen 2 "Acute resp infect incl pneumonia" ,add
cap label define causen 3 "HIV/AIDS related death" ,add
cap label define causen 4 "Diarrhoeal diseases" ,add
cap label define causen 5 "Malaria" ,add
cap label define causen 6 "Measles" ,add
cap label define causen 7 "Meningitis and encephalitis" ,add
cap label define causen 8 "Tetanus" ,add
cap label define causen 9 "Pulmonary tuberculosis" ,add
cap label define causen 10 "Pertussis" ,add
cap label define causen 11 "Haemorrhagic fever (non-dengue)" ,add
cap label define causen 12 "Dengue fever" ,add
cap label define causen 13 "Other and unspecified infect dis" ,add
cap label define causen 14 "Oral neoplasms" ,add
cap label define causen 15 "Digestive neoplasms" ,add
cap label define causen 16 "Respiratory neoplasms" ,add
cap label define causen 17 "Breast neoplasms" ,add
cap label define causen 18 "Reproductive neoplasms" ,add
cap label define causen 19 "Other and unspecified neoplasms" ,add
cap label define causen 20 "Severe anaemia" ,add
cap label define causen 21 "Severe malnutrition" ,add
cap label define causen 22 "Diabetes mellitus" ,add
cap label define causen 23 "Acute cardiac disease" ,add
cap label define causen 24 "Stroke" ,add
cap label define causen 25 "Sickle cell with crisis" ,add
cap label define causen 26 "Other and unspecified cardiac dis" ,add
cap label define causen 27 "Chronic obstructive pulmonary dis" ,add
cap label define causen 28 "Asthma" ,add
cap label define causen 29 "Acute abdomen" ,add
cap label define causen 30 "Liver cirrhosis" ,add
cap label define causen 31 "Renal failure" ,add
cap label define causen 32 "Epilepsy" ,add
cap label define causen 33 "Ectopic pregnancy" ,add
cap label define causen 34 "Abortion-related death" ,add
cap label define causen 35 "Pregnancy-induced hypertension" ,add
cap label define causen 36 "Obstetric haemorrhage" ,add
cap label define causen 37 "Obstructed labour" ,add
cap label define causen 38 "Pregnancy-related sepsis" ,add
cap label define causen 39 "Anaemia of pregnancy" ,add
cap label define causen 40 "Ruptured uterus" ,add
cap label define causen 41 "Other and unspecified maternal CoD" ,add
cap label define causen 42 "Prematurity" ,add
cap label define causen 43 "Birth asphyxia" ,add
cap label define causen 44 "Neonatal pneumonia" ,add
cap label define causen 45 "Neonatal sepsis" ,add
cap label define causen 46 "Congenital malformation" ,add
cap label define causen 47 "Other and unspecified neonatal CoD" ,add
cap label define causen 48 "Fresh stillbirth" ,add
cap label define causen 49 "Macerated stillbirth" ,add
cap label define causen 50 "Road traffic accident" ,add
cap label define causen 51 "Other transport accident" ,add
cap label define causen 52 "Accidental fall" ,add
cap label define causen 53 "Accidental drowning and submersion" ,add
cap label define causen 54 "Accidental expos to smoke fire & flame" ,add
cap label define causen 55 "Contact with venomous plant/animal" ,add
cap label define causen 56 "Accid poisoning & noxious subs" ,add
cap label define causen 57 "Intentional self-harm" ,add
cap label define causen 58 "Assault" ,add
cap label define causen 59 "Exposure to force of nature" ,add
cap label define causen 60 "Other and unspecified external CoD" ,add
cap label define causen 61 "Other and unspecified NCD" ,add
cap label define causen 70 "Indeterminate", add

label values causen causen
label values causen2 causen
label values causen3 causen

gen cause_broad = causen
recode cause_broad 1/2=3 3=1 4/8=3 9=2 10/13=3 14/19=4 20/22=5 23/26=6 27/28=7 29/31=8 /// 
					32=9 61=12 33/41=10 42/49=11 50/60=13

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
					32=8 61=11 33/41=9 42/49=10 50/60=12
cap label define cause_broad2_lbl 1 "HIV/AIDS and TB" 2 "Other infectious diseases" ///
								3 "Neoplasms" 4 "Metabolic" ///
								5 "Cardiovascular" 6 "Respiratory" 7 "Abdominal" ///
								8 "Neurological" 9 "Maternal" 10 "Neonatal" 11 "Other NCD" ///
								12 "External causes" 70 "Indeterminate"
label values cause_broad2 cause_broad2_lbl

*GENERATE A BROAD CAUSE CATEGORY WITH NCDS BROKEN INTO SLIGTHLY DIFFERENT GROUPS
gen cause_broad_ncd = causen
recode cause_broad_ncd 1/2=2 3=1 4/8=2 9=1 10/13=2 14/19=3 ///
				20/21=11 22=4 23/24=5 25=11 26=5 27/28=6 29/31=7 /// 
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

gen SexCode = sex 
replace SexCode = 0 if SexCode == 2

capture label drop sex_code
cap label define sex_code 0 "Female" 1 "Male"
label values SexCode sex_code

//age at death
gen age_death = int((dod-dob)/365.25)
gen age_death_grp5 = int(age_death/5)*5 //lower limit of 5 year age groups
//set upper age bound at 80
replace age_death_grp5 = 80  if age_death_grp5 > 80

//create 10 year age groups
recode age_death (0/4=0) (5/14=5) (15/24=15) (25/34=25) ///
	(35/44=35) (45/54=45) (55/64=55) (65/74=65) ///
	(75/max=75), gen(age_death_grp10)

//create standard WHO  age groups
recode age_death (0/4=0) (5/14=5) (15/49=15) (50/64=50) ///
	(65/max=65), gen(age_death_grp_who)
//different age groupings
recode age_death (0/4=0) (5/14=5) (15/29=15) (30/49=30) (50/64=50) ///
	(65/max=65), gen(age_death_grp2)
	
//separate adult age group
recode age_death (0/4=0) (5/14=5) (15/59=15) ///
	(60/max=60), gen(age_death_grp_adult)

//year of death and period of death
gen year_of_death = year(dod)
//create time periods
recode year_of_death (2016/2017=1) (2018/2019=2)  (2020/2021=3), gen(Period)

sort individualid
save "${data}/${sitename}_RawCensoredEpisodes_with_cod", replace
do "${workingdir}/do/CausesOfDeath/csmf".do
do "${workingdir}/do/CausesOfDeath/mortality_rates_by_cause_of_death".do
}

//combine cause-specific mortality rates from all sites

use "${data}/BD011_py_mx_by_cod", clear
drop Mx Lower95Mx Upper95Mx TotD TotPY
gen sitename="BD011"
save "${data}/AllSites_py_mx_by_cod", replace
foreach site in BD013 BD014 BF021 ET041 GH011 KE021 KE022 ///
	MW011 MZ011 ZA011 ZA021 ZA031 { 
		global sitename="`site'"
		use "${data}/${sitename}_py_mx_by_cod", clear
		drop Mx Lower95Mx Upper95Mx TotD TotPY
		gen sitename="`site'"
		append using "${data}/AllSites_py_mx_by_cod"
		save "${data}/AllSites_py_mx_by_cod", replace
	}
merge m:1 sitename using "${data}/Sites"
drop _merge
cap label define period_lab 1 "2016-2017" 2 "2018-2019" 3 "2020-2021"
label values Period period_lab
cap label define age_grp_lbl 0 "0-4 years"  5 "5-14 years" 15 "15-49 years" 50 "50-64 years" 65 "65+ years"
label values agegrp_who age_grp_lbl
order sitename sitename_location Period agegrp_who cause_broad_ncd PersonYears Deaths mx_1000 lb_mx_1000 ub_mx_1000
sort sitename sitename_location Period agegrp_who cause_broad_ncd
save "${data}/AllSites_py_mx_by_cod", replace
//export to excel
quietly export excel using "${output}/Results.xlsx", sheet("py_mx_by_cod")sheetreplace firstrow(variables)
