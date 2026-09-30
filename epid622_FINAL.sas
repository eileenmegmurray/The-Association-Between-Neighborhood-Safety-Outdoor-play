*--------uploading & cleaing the datasets from NSCH------------------;  
libname rawdata "/home/u64168159/PUBH698/NSCHData"; 

*2023 checking; 
proc contents data = rawdata.nsch_2023e_topical; run; 

proc freq data=rawdata.nsch_2023e_topical;
    tables OUTDOORSWKDAY OUTDOORSWKEND / missing;
run;

*---------formatting----------;
proc format;

value sex /*sex of child*/ 
    1 = "Male" 
    2 = "Female"
    . = "Missing"; 

value sidewalk /*reported sidewalk*/
    1 = "Sidewalk"
    2 = "No Sidewalk"
    . = "Missing";

value povertyfour /*povlev4_23*/
    1 = "0-99% of poverty level"
    2 = "100-199% of poverty level"
    3 = "200-399% of poverty level"
    4 = "400% or more of poverty level";

value safeneigh /*NbhdSafe_23*/ 
    1 = "Safe" 
    2 = "Unsafe" 
    .M = "Missing"; 

value phys_comm /*NbhdDetract_23*/ 
    1 = "No Detracting"
    2 = "Neighborhood has 1 or more detracting element" 
    .M = "Missing";

value educfour /*AdultEduc_23*/
    1 = "Less than high school"
    2 = "High school or GED"
    3 = "Some college or technical school" 
    4 = "College degree or higher"
    .M = "Missing";

value outdoorplaynormal /*Outdoor Play*/
    1 = "Less than 1 hour per day"
    2 = "1 Hour per day"
    3 = "2 Hours per day"
    4 = "3 Hours per day"
    5 = "4 or more per day"
    .N = "Children age 6-17 years"
    .L = "Children age 0-2 years"
    .M = "Missing";

value park_bin
    1 = "Park or playground present"
    2 = "No park or playground"
    .M = "Missing";

value employment /*EmploymentSt_23*/
    1 = "Full-time"
    2 = "Part-time"
    3 = "Unemployed/other"
    .M = "Missing";

value preschool_kindergarten /*startschool*/
    1 = "Preschool"
    2 = "Kindergarten"
    3 = "First Grade"
    4 = "No";

value metro 
    1 = "Metropolitan Area"
    2 = "Non-Metropolitan Area";

run;

*--------------2023 clean dataset--------------------;
data clean23;
set rawdata.nsch_2023e_topical; 

*---Outdoor Play (keep original variables)---;
label OUTDOORSWKDAY = "Weekday outdoor play";
label OUTDOORSWKEND = "Weekend outdoor play";

*---Sex of child---;
sex_23 = .;
if SC_SEX in (1,2) then sex_23 = SC_SEX;
label sex_23 = "Sex of child";

*---FPL---;
povlev4_23 = .;
if 0 < FPL_I1 <= 99 then povlev4_23 = 1;
else if 100 <= FPL_I1 <= 199 then povlev4_23 = 2;
else if 200 <= FPL_I1 <= 399 then povlev4_23 = 3;
else if FPL_I1 >= 400 then povlev4_23 = 4;
label povlev4_23 = "Income level";

*---neighborhood safety---;
NbhdSafe_23 = .; 
if K10Q40_R in (1,2) then NbhdSafe_23 = 1;
else if K10Q40_R in (3,4) then NbhdSafe_23 = 2;
else if K10Q40_R = .M then NbhdSafe_23 = .M;

*---neighborhood detracting elements---;
validcomm = 0;
if K10Q20 in (1,2) then validcomm + 1; 
if K10Q22 in (1,2) then validcomm + 1;
if K10Q23 in (1,2) then validcomm + 1;

comm_cond = 0;
if K10Q20 = 1 then comm_cond + 1; 
if K10Q22 = 1 then comm_cond + 1; 
if K10Q23 = 1 then comm_cond + 1;

if validcomm < 3 then NbhdDetract_23 = .M;
else if comm_cond = 0 then NbhdDetract_23 = 1;
else if comm_cond >= 1 then NbhdDetract_23 = 2;

*---Adult education---;
AdultEduc_23 = HIGRADE_TVIS;

*---Park / playground---;
if K10Q12 in (1,2) then park_bin_23 = K10Q12;
else if K10Q12 = .M then park_bin_23 = .M;

*---Metro Area---;
metro_23 = metro_yn;

*---Parental Employment---;
EmploymentSt_23 = 3;
if A1_EMPLOYED_R = 2 or A2_EMPLOYED_R = 2 then EmploymentSt_23 = 2;
if A1_EMPLOYED_R = 1 or A2_EMPLOYED_R = 1 then EmploymentSt_23 = 1;
if A1_EMPLOYED_R = .M and A2_EMPLOYED_R = .M then EmploymentSt_23 = .M;

*---School status---;
startschool_23 = startschool;
label startschool_23 = "School enrollment";

*---Sidewalk (you were missing this!)---;
sidewalk_23 = .;
if K10Q11 in (1,2) then sidewalk_23 = K10Q11;
else if K10Q11 = .M then sidewalk_23 = .M;
*---domain age---*;
/* preschool-age domain */
age_domain = 0;

if SC_AGE_YEARS in (3,4,5) then age_domain = 1;

*---Formats---;
format
    sex_23 sex.
    povlev4_23 povertyfour.
    NbhdSafe_23 safeneigh.
    NbhdDetract_23 phys_comm.
    AdultEduc_23 educfour.
    OUTDOORSWKDAY outdoorplaynormal.
    OUTDOORSWKEND outdoorplaynormal.
    park_bin_23 park_bin.
    metro_23 metro.
    EmploymentSt_23 employment.
    startschool_23 preschool_kindergarten.
    sidewalk_23 sidewalk.;

run;

*---------MAKING LONG DATASET-------------;
data long23;
set clean23;

/* weekday */
if OUTDOORSWKDAY in (1,2,3,4,5) then do;
    time_type = 0;
    play_level = OUTDOORSWKDAY;
    output;
end;

/* weekend */
if OUTDOORSWKEND in (1,2,3,4,5) then do;
    time_type = 1;
    play_level = OUTDOORSWKEND;
    output;
end;

format play_level outdoorplaynormal.;
run;

*-------FPL IMPUTATION------;
data stacked_long23; 
set long23;

array fpl{6} FPL_I1-FPL_I6;

do _Imputation_ = 1 to 6;
    fpl_i = fpl{_Imputation_};

    if 0 < fpl_i <= 99 then povcat_i = 1;
    else if 100 <= fpl_i <= 199 then povcat_i = 2;
    else if 200 <= fpl_i <= 399 then povcat_i = 3;
    else if fpl_i >= 400 then povcat_i = 4;

    output;
end;

format povcat_i povertyfour.;
run;

proc sort data=stacked_long23;
by _Imputation_;
run;
*==============TABLE 1 FREQUENCIES================;
*--------TABLE 1 FPL----------;
ods output CrossTabs = mi_fpl;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain SC_AGE_YEARS in (3,4,5) /*proc surveyfreq does NOT support domain*/
          and NbhdSafe_23 not in (., .M);
    tables NbhdSafe_23 * povcat_i / row cl;

run;

proc sort data=mi_fpl;
    by NbhdSafe_23 povcat_i;
run;

proc mianalyze data=mi_fpl;

    by NbhdSafe_23 povcat_i;

    modeleffects RowPercent;

    stderr RowStdErr;

run;
*--------TABLE 1 Metro Area----------;
proc surveyfreq data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M);
    tables 
        NbhdSafe_23 * metro_23 / row cl;
run;
*------TABLE 1 Sex of Child------;
proc surveyfreq data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M);
    tables 
        NbhdSafe_23 * sex_23/ row cl;
run;
*-----Table 1 Parental Education-----;
proc surveyfreq data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M);
    tables 
        NbhdSafe_23 * AdultEduc_23 / row cl;
run;
*-------Table 1 Parental Employment Status-----;
proc surveyfreq data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M);
    tables 
        NbhdSafe_23 * EmploymentSt_23/ row cl;
run;
*------Table 1 School Status------;
proc surveyfreq data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M);
    tables 
        NbhdSafe_23 * startschool_23/ row cl;
run;
*------Table 1 Park presence----;
proc surveyfreq data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M);
    tables 
        NbhdSafe_23 * park_bin_23;
run;
*-----Table 1 Detracting Elements----;
proc surveyfreq data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M);
    tables 
        NbhdSafe_23 * NbhdDetract_23/ row cl;
run;
*-----Table 1 Sidewalk presence----;
proc surveyfreq data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M);
    tables 
        NbhdSafe_23 * sidewalk_23/ row cl
;
run;
*=======LOGISTIC REGRESSION================;
*------CRUDE WEEKDAY-----------;
ods output ParameterEstimates=pe_mc;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain age_domain;
    format nbhdsafe_23 outdoorswkday;
    where OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    by _Imputation_;
    class NbhdSafe_23 (ref="1") / param=ref;
    model OUTDOORSWKDAY(ref="1") =
        NbhdSafe_23
        / link=glogit;
run;
data pe_mc_domain;
    set pe_mc;
    where domain_age = 1
         and Variable = "NbhdSafe_23";
run;
proc mianalyze parms=pe_mc_domain;
    modeleffects Estimate;
    stderr StdErr;

    ods output ParameterEstimates=pooled_mc;
run;
*--------MODEL 1: Weekday + FPL--------;
ods output ParameterEstimates=pe_m1;
proc surveylogistic data=stacked_long23_dom;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    by _Imputation_;
    format povcat_i nbhdsafe_23 outdoorswkday;
    where OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    class
        NbhdSafe_23 (ref="1")
        povcat_i (ref="4") / param=ref;
    model OUTDOORSWKDAY(ref="1") =
        NbhdSafe_23
        povcat_i
        / link=glogit;
run;
data pe_m1_domain;
    set pe_m1;
    where domain_age = 1
          and Variable = "NbhdSafe_23";
run;
proc mianalyze parms=pe_m1_domain;
    modeleffects Estimate;
    stderr StdErr;
    ods output ParameterEstimates=pooled_m1;
run;
*-----MODEL 2: Weekday + Metro------;
ods output ParameterEstimates=pe_m2;
proc surveylogistic data=stacked_long23_dom;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    by _Imputation_;
    format outdoorswkday nbhdsafe_23 metro_23;
    where OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    class
        NbhdSafe_23 (ref="1")
        metro_23 (ref="1") / param=ref;
    model OUTDOORSWKDAY(ref="1") =
        NbhdSafe_23
        metro_23
        / link=glogit;
run;
data pe_m2_domain;
    set pe_m2;
    where domain_age = 1
          and Variable = "NbhdSafe_23";
run;
proc mianalyze parms=pe_m2_domain;
    modeleffects Estimate;
    stderr StdErr;
    ods output ParameterEstimates=pooled_m2;
run;
*------Model 3: FULL WEEKDAY-------;
ods output ParameterEstimates=pe_m3;
proc surveylogistic data=stacked_long23_dom;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    by _Imputation_;
    format nbhdsafe_23 metro_23 povcat_i outdoorswkday;
    where OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    class
        NbhdSafe_23 (ref="1")
        metro_23 (ref="1")
        povcat_i (ref="4") / param=ref;
    model OUTDOORSWKDAY(ref="1") =
        NbhdSafe_23
        metro_23
        povcat_i
        / link=glogit;
run;
*-----CRUDE WEEKEND--------;
ods output ParameterEstimates=pe_mc_wk;
proc surveylogistic data=stacked_long23_dom;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    format nbhdsafe_23 outdoorswkend;
    where OUTDOORSWKend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    by _Imputation_;
    class NbhdSafe_23 (ref="1") / param=ref;
    model OUTDOORSWKend(ref="1") =
        NbhdSafe_23
        / link=glogit;
run;
data pe_mc_wk_domain;
    set pe_mc_wl;
    where domain_age = 1
         and Variable = "NbhdSafe_23";
run;
proc mianalyze parms=pe_mc_wk_domain;
    modeleffects Estimate;
    stderr StdErr;
    ods output ParameterEstimates=pooled_mc_wk;
run;
*-----MODEL 1: WEEKEND + FPL------;
ods output ParameterEstimates=pe_m1_wk;
proc surveylogistic data=stacked_long23_dom;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    by _Imputation_;
    format povcat_i nbhdsafe_23 outdoorswkend;
    where OUTDOORSWKend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    class
        NbhdSafe_23 (ref="1")
        povcat_i (ref="4") / param=ref;
    model OUTDOORSWKend(ref="1") =
        NbhdSafe_23
        povcat_i
        / link=glogit;
run;
data pe_m1_domain_wk;
    set pe_m1_wk;
    where domain_age = 1
          and Variable = "NbhdSafe_23";
run;
proc mianalyze parms=pe_m1_domain_wk;
    modeleffects Estimate;
    stderr StdErr;
    ods output ParameterEstimates=pooled_m1_wk;
run;
*-----MODEL 2: Weekend + Metro------;
ods output ParameterEstimates=pe_m2_wk;
proc surveylogistic data=stacked_long23_dom;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    by _Imputation_;
    format outdoorswkend nbhdsafe_23 metro_23;
    where OUTDOORSWKend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    class
        NbhdSafe_23 (ref="1")
        metro_23 (ref="1") / param=ref;
    model OUTDOORSWKend ref="1") =
        NbhdSafe_23
        metro_23
        / link=glogit;
run;
data pe_m2_domain_wk;
    set pe_m2;
    where domain_age = 1
          and Variable = "NbhdSafe_23";
run;
proc mianalyze parms=pe_m2_domain_wk;
    modeleffects Estimate;
    stderr StdErr;
    ods output ParameterEstimates=pooled_m2_wk;
run;
*-----MODEL 3: FULL WEEKEND------;
ods output ParameterEstimates=pe_m3;
proc surveylogistic data=stacked_long23_dom;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    by _Imputation_;
    format nbhdsafe_23 metro_23 povcat_i outdoorswkday;
    where OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    class
        NbhdSafe_23 (ref="1")
        metro_23 (ref="1")
        povcat_i (ref="4") / param=ref;
    model OUTDOORSWKDAY(ref="1") =
        NbhdSafe_23
        metro_23
        povcat_i
        / link=glogit;
run;
*============---------------EMM---------------------===============;
*-----SEX WEEKDAY EMM------;
ods output ParameterEstimates=pe_emm_m1;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
        domain domain_age;
    where  OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format sex_23 nbhdsafe_23 outdoorswkday;
    class 
        NbhdSafe_23 (ref='1')
        sex_23 (ref='1');
    model OUTDOORSWKDAY (ref='1') =
        NbhdSafe_23
        sex_23
        NbhdSafe_23*sex_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m1;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----SEX WEEKEND EMM------;
ods output ParameterEstimates=pe_emm_m1wk;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where outdoorswkend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format sex_23 nbhdsafe_23 outdoorswkend;
    class 
        NbhdSafe_23 (ref='1')
        sex_23 (ref='1');
    model outdoorswkend (ref='1') =
        NbhdSafe_23
        sex_23
        NbhdSafe_23*sex_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m1wk;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----PARENTAL EDU WEEKDAY EMM------;
ods output ParameterEstimates=pe_emm_m2;

proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where  OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format AdultEduc_23 nbhdsafe_23 outdoorswkday;
    class 
        NbhdSafe_23 (ref='1')
        AdultEduc_23 (ref='1');
    model OUTDOORSWKDAY (ref='1') =
        NbhdSafe_23
        AdultEduc_23
        NbhdSafe_23*AdultEduc_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m2;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----PARENTAL EDU WEEKEND EMM------;
ods output ParameterEstimates=pe_emm_m2wk;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where  outdoorswkend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format AdultEduc_23 nbhdsafe_23 outdoorswkend;
    class 
        NbhdSafe_23 (ref='1')
        AdultEduc_23 (ref='1');
    model outdoorswkend (ref='1') =
        NbhdSafe_23
        AdultEduc_23
        NbhdSafe_23*AdultEduc_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m2wk;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----PARENTAL EMPLOYMENT WEEKDAY EMM------;
ods output ParameterEstimates=pe_emm_m3;

proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where  OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format EmploymentSt_23 nbhdsafe_23 outdoorswkday;
    class 
        NbhdSafe_23 (ref='1')
        EmploymentSt_23 (ref='1');
    model OUTDOORSWKDAY (ref='1') =
        NbhdSafe_23
        EmploymentSt_23
        NbhdSafe_23*EmploymentSt_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m3;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----PARENTAL EMPLOYMENT WEEKEND EMM------;
ods output ParameterEstimates=pe_emm_m3wk;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where outdoorswkend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format EmploymentSt_23 nbhdsafe_23 outdoorswkend;
    class 
        NbhdSafe_23 (ref='1')
        EmploymentSt_23 (ref='1');
    model outdoorswkend (ref='1') =
        NbhdSafe_23
        EmploymentSt_23
        NbhdSafe_23*EmploymentSt_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m3wk;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----SCHOOL STATUS EMM WEEKDAY------;
ods output ParameterEstimates=pe_emm_m4;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where  OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format startschool_23 nbhdsafe_23 outdoorswkday;
    class 
        NbhdSafe_23 (ref='1')
        startschool_23 (ref='1');
    model OUTDOORSWKDAY (ref='1') =
        NbhdSafe_23
        startschool_23
        NbhdSafe_23*startschool_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m4;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----SCHOOL STATUS EMM WEEKEND------;
ods output ParameterEstimates=pe_emm_m4wk;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    where SC_AGE_YEARS in (3,4,5)
          and outdoorswkend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format startschool_23 nbhdsafe_23 outdoorswkend;
    class 
        NbhdSafe_23 (ref='1')
        startschool_23 (ref='1');
    model outdoorswkend (ref='1') =
        NbhdSafe_23
        startschool_23
        NbhdSafe_23*startschool_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m4wk;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----PARK PRESENCE EMM WEEKDAY------;
ods output ParameterEstimates=pe_emm_m5;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format park_bin_23 nbhdsafe_23 outdoorswkday;
    class 
        NbhdSafe_23 (ref='1')
        park_bin_23 (ref='1');
    model OUTDOORSWKDAY (ref='1') =
        NbhdSafe_23
        park_bin_23
        NbhdSafe_23*park_bin_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m5;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----PARK PRESENCE EMM WEEKEND------;
ods output ParameterEstimates=pe_emm_m5wk;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where  outdoorswkend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format park_bin_23 nbhdsafe_23 outdoorswkend;
    class 
        NbhdSafe_23 (ref='1')
        park_bin_23 (ref='1');
    model outdoorswkend (ref='1') =
        NbhdSafe_23
        park_bin_23
        NbhdSafe_23*park_bin_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m5wk;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----DETRACTING EMM WEEKDAY------;
ods output ParameterEstimates=pe_emm_m6;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format NbhdDetract_23 nbhdsafe_23 outdoorswkday;
    class 
        NbhdSafe_23 (ref='1')
        NbhdDetract_23 (ref='1');
    model OUTDOORSWKDAY (ref='1') =
        NbhdSafe_23
        NbhdDetract_23
        NbhdSafe_23*NbhdDetract_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m6;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----DETRACTING EMM WEEKEND------;
ods output ParameterEstimates=pe_emm_m6wk;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where outdoorswkend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format NbhdDetract_23 nbhdsafe_23 outdoorswkend;
    class 
        NbhdSafe_23 (ref='1')
        NbhdDetract_23 (ref='1');
    model outdoorswkend (ref='1') =
        NbhdSafe_23
        NbhdDetract_23
        NbhdSafe_23*NbhdDetract_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m6wk;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----SIDEWALK EMM WEEKDAY------;
ods output ParameterEstimates=pe_emm_m7;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where OUTDOORSWKDAY not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format sidewalk_23 nbhdsafe_23 outdoorswkday;
    class 
        NbhdSafe_23 (ref='1')
        sidewalk_23 (ref='1');
    model OUTDOORSWKDAY (ref='1') =
        NbhdSafe_23
        sidewalk_23
        NbhdSafe_23*sidewalk_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m7;
    modeleffects Estimate;
    stderr StdErr;
run;
*-----SIDEWALK EMM WEEKEND------;
ods output ParameterEstimates=pe_emm_m7wk;
proc surveylogistic data=stacked_long23;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where outdoorswkend not in (., .M, .N, .L)
          and NbhdSafe_23 not in (., .M);
    format sidewalk_23 nbhdsafe_23 outdoorswkend;
    class 
        NbhdSafe_23 (ref='1')
        sidewalk_23 (ref='1');
    model outdoorswkend (ref='1') =
        NbhdSafe_23
        sidewalk_23
        NbhdSafe_23*sidewalk_23
        / link=glogit;
run;
proc mianalyze data=pe_emm_m7wk;
    modeleffects Estimate;
    stderr StdErr;
run;
*=========STRATIFIED RESULTS=======;
*----STRATIFIED SEX WEEKDAY------;
ods output CrossTabs=mi_sex_wkday;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where SNbhdSafe_23 not in (., .M)
          and outdoorswkday not in (., .M, .N, .L);
    tables sex_23 * NbhdSafe_23 * outdoorswkday / row cl;
run;
proc means data=mi_sex_wkday mean n;
    class sex_23 NbhdSafe_23 outdoorswkday;
    var RowPercent;
run;
proc sort data=mi_sex_wkday;
    by sex_23 NbhdSafe_23 outdoorswkday;
run;
proc mianalyze data=mi_sex_wkday;
    by sex_23 NbhdSafe_23 outdoorswkday;
    modeleffects RowPercent;
    stderr RowStdErr;
run;
*----STRATIFIED SEX WEEKEND------;
ods output CrossTabs=mi_sex_wkend;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where SC_AGE_YEARS in (3,4,5)
          and NbhdSafe_23 not in (., .M)
          and outdoorswkend not in (., .M, .N, .L);
    tables sex_23 * NbhdSafe_23 * outdoorswkend / row cl;
run;
proc means data=mi_sex_wkend mean n;
    class sex_23 NbhdSafe_23 outdoorswkend;
    var RowPercent;
run;
proc sort data=mi_sex_wkend;
    by sex_23 NbhdSafe_23 outdoorswkend;
run;
proc mianalyze data=mi_sex_wkend;
    by sex_23 NbhdSafe_23 outdoorswkend;
    modeleffects RowPercent;
    stderr RowStdErr;
run;
*----STRATIFIED PARENTAL EDU WEEKDAY------;
ods output CrossTabs=mi_edu_wkday;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where  NbhdSafe_23 not in (., .M)
          and outdoorswkday not in (., .M, .N, .L);
    tables AdultEduc_23 * NbhdSafe_23 * outdoorswkday / row cl;
run;
proc means data=mi_edu_wkday mean n;
    class AdultEduc_23 NbhdSafe_23 outdoorswkday;
    var RowPercent;
run;
proc sort data=mi_edu_wkday;
    by AdultEduc_23 NbhdSafe_23 outdoorswkday;
run;
proc mianalyze data=mi_edu_wkday;
    by AdultEduc_23 NbhdSafe_23 outdoorswkday;
    modeleffects RowPercent;
    stderr RowStdErr;
run;
*----STRATIFIED PARENTAL EDU WEEKEND------;
ods output CrossTabs=mi_edu_wkend;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where NbhdSafe_23 not in (., .M)
          and outdoorswkend not in (., .M, .N, .L);
    tables AdultEduc_23 * NbhdSafe_23 * outdoorswkend / row cl;
run;
proc means data=mi_edu_wkend mean n;
    class AdultEduc_23 NbhdSafe_23 outdoorswkend;
    var RowPercent;
run;
proc sort data=mi_edu_wkend;
    by AdultEduc_23 NbhdSafe_23 outdoorswkend;
run;
proc mianalyze data=mi_edu_wkend;
    by AdultEduc_23 NbhdSafe_23 outdoorswkend;
    modeleffects RowPercent;
    stderr RowStdErr;
run;
*----STRATIFIED PARENTAL EMPLOYMENT WEEKDAY------;
ods output CrossTabs=mi_emp_wkday;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where NbhdSafe_23 not in (., .M)
          and outdoorswkday not in (., .M, .N, .L);
    tables EmploymentSt_23 * NbhdSafe_23 * outdoorswkday / row cl;
run;
proc means data=mi_emp_wkday mean n;
    class EmploymentSt_23 NbhdSafe_23 outdoorswkday;
    var RowPercent;
run;
proc sort data=mi_emp_wkday;
    by EmploymentSt_23 NbhdSafe_23 outdoorswkday;
run;
proc mianalyze data=mi_emp_wkday;
    by EmploymentSt_23 NbhdSafe_23 outdoorswkday;
    modeleffects RowPercent;
    stderr RowStdErr;
run;
*----STRATIFIED PARENTAL EMPLOYMENT WEEKEND------;
ods output CrossTabs=mi_emp_wkend;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where NbhdSafe_23 not in (., .M)
          and outdoorswkend not in (., .M, .N, .L);
    tables EmploymentSt_23 * NbhdSafe_23 * outdoorswkend / row cl;
run;
proc means data=mi_emp_wkend mean n;
    class EmploymentSt_23 NbhdSafe_23 outdoorswkend;
    var RowPercent;
run;
proc sort data=mi_emp_wkend;
    by EmploymentSt_23 NbhdSafe_23 outdoorswkend;
run;
proc mianalyze data=mi_emp_wkend;
    by EmploymentSt_23 NbhdSafe_23 outdoorswkend;
    modeleffects RowPercent;
    stderr RowStdErr;
run;
*----STRATIFIED SCHOOL STATUS WEEKDAY------;
ods output CrossTabs=mi_school_wkday;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where  NbhdSafe_23 not in (., .M)
          and outdoorswkday not in (., .M, .N, .L);
    tables startschool_23 * NbhdSafe_23 * outdoorswkday / row cl;
run;
proc means data=mi_school_wkday mean n;
    class startschool_23 NbhdSafe_23 outdoorswkday;
    var RowPercent;
run;
proc sort data=mi_school_wkday;
    by startschool_23 NbhdSafe_23 outdoorswkday;
run;
proc mianalyze data=mi_school_wkday;
    by startschool_23 NbhdSafe_23 outdoorswkday;
    modeleffects RowPercent;
    stderr RowStdErr;
run;
*----STRATIFIED SCHOOL STATUS WEEKEND------;
ods output CrossTabs=mi_school_wkend;
proc surveyfreq data=stacked_long23;
    by _Imputation_;
    strata STRATUM;
    cluster HHID;
    weight FWC;
    domain domain_age;
    where  NbhdSafe_23 not in (., .M)
          and outdoorswkend not in (., .M, .N, .L);
    tables startschool_23 * NbhdSafe_23 * outdoorswkend / row cl;
run;
proc means data=mi_school_wkend mean n;
    class startschool_23 NbhdSafe_23 outdoorswkend;
    var RowPercent;
run;
proc sort data=mi_school_wkend;
    by startschool_23 NbhdSafe_23 outdoorswkend;
run;
proc mianalyze data=mi_school_wkend;
    by startschool_23 NbhdSafe_23 outdoorswkend;
    modeleffects RowPercent;
    stderr RowStdErr;
run;