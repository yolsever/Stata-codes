clear all 

cd "C:\Users\kaany_000\Desktop\Research\Sam Hwang\Mturk\excel_files\to_compare\"

local i=0
cap erase mybigfile.dta
local files : dir . files "*.csv"

foreach f of local files {
drop _all
insheet using "`f'"
if `i'>0 append using mybigfile
save mybigfile, replace
local i=1
}

sort v1

keep if v1[_n] == v1[_n+1] | v1[_n] == v1[_n - 1]

// TRIM THE STRING VARIABLES
foreach var of varlist v2-v15 {
	replace `var'=lower(`var')
	replace `var'=strtrim(`var')
	replace `var'=stritrim(`var')
}
sort v1

by v1: gen consensus = ///
( v13[_n] == v13[_n+1]   ///
 & v2[_n] == v2[_n+1]   ///
 & v3[_n] == v3[_n+1]   ///
 & v4[_n] == v4[_n+1]   /// 
 & v5[_n] == v5[_n+1]   ///
 & v6[_n] == v6[_n+1]   ///
 & v7[_n] == v7[_n+1]   ///
 & v8[_n] == v8[_n+1]   ///
 & v9[_n] == v9[_n+1]   ///
 & v10[_n] == v10[_n+1]   ///
 & v11[_n] == v11[_n+1]   ///
 & v12[_n] == v12[_n+1]   ///
 & v14[_n] == v14[_n+1]   ///
 & v15[_n] == v15[_n+1] )
