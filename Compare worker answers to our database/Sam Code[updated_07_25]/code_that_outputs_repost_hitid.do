clear all

local data "C:\Users\User\Dropbox\9 ECON JOB MARKET WITH HIRO AND KIM\MTURK_CVs\employment_test_results\"

import delimited `"`data'result_1st.csv"'

// get rid of the unnecessary variables

drop hittypeid-last7daysapprovalrate
drop approve-reject


// fix the missing data entries which differ across workers ("NA","N/A","{}")
replace answer1st_dept_other = "NA" if answer1st_dept_other=="{}"
replace answer1st_inst = "NA" if answer1st_inst=="{}"
replace answer1st_title_other = "NA" if answer1st_title_other=="{}"
replace answer2nd_dept_other ="NA" if answer2nd_dept_other =="{}"
replace answer2nd_dept_other ="NA" if answer2nd_dept_other =="N/A"
replace answer2nd_inst ="NA" if answer2nd_inst=="{}"
replace answer2nd_inst ="NA" if answer2nd_inst=="N/A"
replace answer2nd_title_other = "NA" if answer2nd_title_other == "{}"
replace answer2nd_title_other = "NA" if answer2nd_title_other == "N/A"
replace answerdept1 = "NA" if answerdept1 =="{}"
replace answerdept2 = "NA" if answerdept2 =="{}"
replace answerendyr1 = "NA" if answerendyr1=="{}"
replace answerendyr2 = "NA" if answerendyr2=="{}"
replace answerstartyr1 = "NA" if answerstartyr1=="{}"
replace answerstartyr2 = "NA" if answerstartyr2=="{}"
replace answerstartyr2 = "NA" if missing(answerstartyr2) 
replace answerstartyr2 = "NA" if answerstartyr2=="\"
replace answertitle1 = "NA" if answertitle1=="{}"
replace answertitle2 = "NA" if answertitle2=="{}"
split answer1st_inst, p(,)
drop answer1st_inst2
drop answer1st_inst

// TRIM THE STRING VARIABLES
foreach var of varlist answer1st_dept_other-answer1st_inst1 {
	replace `var'=lower(`var')
	replace `var'=strtrim(`var')
	replace `var'=stritrim(`var')
}

// creating a variable to see if the answers are the same across workers


gen consensus = (answer1st_dept_other[_n]==answer1st_dept_other[_n+1] ///
 & answer1st_title_other[_n] == answer1st_title_other[_n+1] & answer2nd_dept_other[_n] == answer2nd_dept_other[_n+1] ///
 & answer2nd_inst[_n] == answer2nd_inst[_n+1] & answer2nd_title_other[_n] == answer2nd_title_other[_n+1] & answerdept1[_n] == answerdept1[_n+1] ///
 & answerdept2[_n] == answerdept2[_n+1] & answerendyr1[_n] == answerendyr1[_n+1] & answerendyr2[_n] == answerendyr2[_n+1] ///
 & answerstartyr1[_n] == answerstartyr1[_n+1] & answerstartyr2[_n] == answerstartyr2[_n+1] & answertitle1[_n] == answertitle1[_n+1] ///
 & answertitle2[_n] == answertitle2[_n+1] & answer1st_inst1[_n] == answer1st_inst1[_n+1])

 
 //exporting the resulting list of CV's in .csv

keep if consensus == 0
drop if inputpdf_url[_n]!=inputpdf_url[_n+1]
outsheet hitid using `"`data'hitid_repost.csv"', replace

	
