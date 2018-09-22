clear all

// uncomment next two lines if they are not installed (needs to be installed only once)
// ssc install matchit
// ssc install freqindex

cd "C:\Users\kaany_000\Desktop\Research\Sam Hwang\Mturk\excel_files\matching\"

// general pattern
/*
use agreed_data.dta
matchit id1 txt1 using mike_institutions_table.dta, idu(id2) txtu(txt2) 
br
*/

// use the agreed_data and matchit using n and inst_name from the first dataset and inst_id and inst_name (which is splitted) from mike's data set
// v2 stands for inst_name in workers data
use testbatch2_agreed_data_after_post2.dta
matchit n workers_inst_name using mike_split_space.dta, idu(v1) txtu(v21) 
br

// merge using mike's id 
merge m:m v1 using mike_split_space.dta

gsort n -similscore
by n: keep if _n < 4	

//required to call merge for the second time
drop _merge


rename v1 mike_id
rename similscore similscore_1

merge m:m workers_inst_name using testbatch2_agreed_data_after_post2.dta

drop _merge

save compound_data.dta, replace

clear all

// compare the full institutions' name from worker's dataset and full institutions name from Mike's dataset
use compound_data.dta
matchit n fullname using compound_data.dta, idu(mike_id) txtu(v2)
br

rename similscore similscore_2


// merge to get the similscore_1
merge m:m n mike_id using compound_data.dta  

gsort n -similscore_1 -similscore_2
by n: keep if _n == 1
