clear all

local data "C:\Users\kaany_000\Desktop\Research\Sam Hwang\Mturk\excel_files\"

import delimited `"`data'testbatch1_repost_Results_from_increasing_assignments.csv"'

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
foreach var of varlist answer1st_dept_other-answer1st_inst {
	replace `var'=lower(`var')
	replace `var'=strtrim(`var')
	replace `var'=stritrim(`var')
}


// creating a variable to see if the answers are the same across workers

sort inputpdf_url
by inputpdf_url: gen consensus = ///
( (answer1st_dept_other[_n] == answer1st_dept_other[_n+1]   ///
 & answer1st_title_other[_n] == answer1st_title_other[_n+1]   ///
 & answer2nd_dept_other[_n] == answer2nd_dept_other[_n+1]   ///
 & answer2nd_inst[_n] == answer2nd_inst[_n+1]   /// 
 & answer2nd_title_other[_n] == answer2nd_title_other[_n+1]   ///
 & answerdept1[_n] == answerdept1[_n+1]   ///
 & answerdept2[_n] == answerdept2[_n+1]   ///
 & answerendyr1[_n] == answerendyr1[_n+1]   ///
 & answerendyr2[_n] == answerendyr2[_n+1]   ///
 & answerstartyr1[_n] == answerstartyr1[_n+1]   ///
 & answerstartyr2[_n] == answerstartyr2[_n+1]   ///
 & answertitle1[_n] == answertitle1[_n+1]   ///
 & answertitle2[_n] == answertitle2[_n+1]   ///
 & answer1st_inst1[_n] == answer1st_inst1[_n+1] ) ///
 | ( ///
   answer1st_dept_other[_n] == answer1st_dept_other[_n+2] ///
 & answer1st_title_other[_n] == answer1st_title_other[_n+2] ///
 & answer2nd_dept_other[_n] == answer2nd_dept_other[_n+2] ///
 & answer2nd_inst[_n] == answer2nd_inst[_n+2] ///
 & answer2nd_title_other[_n] == answer2nd_title_other[_n+2] ///
 & answerdept1[_n] == answerdept1[_n+2] ///
 & answerdept2[_n] == answerdept2[_n+2] ///
 & answerendyr1[_n] == answerendyr1[_n+2] ///
 & answerendyr2[_n] == answerendyr2[_n+2] ///
 & answerstartyr1[_n] == answerstartyr1[_n+2] ///
 & answerstartyr2[_n] == answerstartyr2[_n+2] ///
 & answertitle1[_n] == answertitle1[_n+2] ///
 & answertitle2[_n] == answertitle2[_n+2] ///
 & answer1st_inst1[_n] == answer1st_inst1[_n+2] ))


//rename and reorder variables

rename inputpdf_url pdf_url
rename answer1st_inst1 _1st_inst
rename answer1st_title_other _1st_title_other
rename answer1st_dept_other _1st_dept_other
rename answer2nd_dept_other _2nd_dept_other
rename answer2nd_inst _2nd_inst
rename answer2nd_title_other _2nd_title_other
rename answerdept1 _dept1
rename answerdept2 _dept2
rename answerendyr1 _endyr1
rename answerendyr2 _endyr2
rename answerstartyr1 _startyr1
rename answerstartyr2 _startyr2
rename answertitle1 _title1
rename answertitle2 _title2

order _1st_inst, b(_1st_dept_other)
order _dept1, b(_1st_dept_other)
order _title1, b(_1st_title_other)
order _startyr1, b(_2nd_dept_other)
order _endyr1, b(_2nd_dept_other)
order _2nd_inst, b(_2nd_dept_other)
order _dept2, b(_2nd_dept_other)
order _title2, b(_2nd_title_other)
order _startyr2, b(_endyr2)



egen groupnumber = group(pdf_url)
by pdf_url: egen numconsensus = total(consensus)



// print out the data where a consensus is reached
outsheet hitid-_endyr2 if consensus == 1 using `"`data'agreed_data.csv"', replace comma

 
//exporting the resulting list of CV where a consensus is not reached
by pdf_url: keep if (numconsensus[_n]==0)
// drop if pdf_url[_n] == pdf_url[_n+1]

outsheet hitid-_endyr2 using `"`data'disagreed_data.csv"' , replace comma

	
