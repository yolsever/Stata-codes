clear all 

import delimited "C:\Users\kaany_000\Desktop\Research\Sam Hwang\Mturk\excel_files\matching\testbatch2_agreed_data_after_post2.csv"

drop if _n == 1

// the code below might need some editing
// set the correct variables v2 must be the institution name, v3 is department type and v4 is department_other_name

gen fullname = v2[_n] + "-" + v4[_n] if v3 == "other" & v4 != "na"

gen n = _n

replace fullname = v2[_n] if v3 == "other" & v4 == "na"

replace fullname = v2[_n] + "-" + "economics" if v3 == "econdept"

rename v2 workers_inst_name

// at this point overwrite the dataset on the results csv
