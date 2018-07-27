proc import out=work.Rossman
	datafile="Rossman.csv"
	dbms=csv replace;
	getnames=yes;
	datarow=2;
run;

data Store_1;
	set Rossman;
	if Store=1 then output Store_1;
run;

/*Delete missing values*/
data Store_openonly;
	set Store_1;
	if Open=0 then delete;
run;

data Store_useful;
	set Store_openonly (keep=DayofWeek Sales Customers Promo SchoolHoliday);
run;

PROC CONTENTS data=Store_useful;
run;

/*Change variable tyep from character to numeric*/
data Store_final;
	Set Store_useful;
    Store_final = input(SchoolHoliday, best12.);
    drop SchoolHoliday;
    rename Store_final=SchoolHoliday;
run;

PROC CONTENTS data=Store_final;
run;

ods graphics on;
proc corr data =Store_final;	
	title'Correlation between variables';
	var Sales DayofWeek Customers Promo SchoolHoliday;
run;
ods graphics off;

ods graphics on;
proc reg data=Store_final;
	title 'Stepwise Logistic Regression for Store_1';
	model Sales=DayofWeek Customers Promo SchoolHoliday /dwprob stb vif 
	selection=stepwise;
quit;
ods graphics off;

DATA Store_interaction;
	SET Store_final;
	Customers_P = Customers*Promo;
RUN;

ods graphics on;
PROC REG data=Store_interaction;
	title 'interaction effects';
	MODEL Sales = Customers Promo Customers_P;
RUN; 
QUIT;
ods graphics off;

ods graphics on;
proc glm data=Store_final order=internal;
title'categorical interaction';
class DayofWeek Promo SchoolHoliday;
model Customers =  DayofWeek | Promo | SchoolHoliday / solution e;
store catcat;
run;
ods graphics off;

ods graphics on;
proc reg data=Store_final;
	title 'linear model on Sales*Customers';
	model Sales = Customers; 
quit;
ods graphics off;


ods graphics on;
proc reg data=Store_interaction;
	title 'Stepwise Logistic Regression for Store_interaction';
	model Sales=Customers Promo Customers_P /dwprob stb vif 
	selection=stepwise;
quit;
ods graphics off;


DATA Store_interaction_All;
	SET Store_final;
	Day_C=DayofWeek*Customers;
	Day_P=DayofWeek*Promo;
	Day_S=DayofWeek*SchoolHoliday;

	Customers_P = Customers*Promo;
	Customers_s = Customers*SchoolHoliday;

	P_Sch=Promo*SchoolHoliday;
RUN;


ods graphics on;
proc reg data=Store_interaction_All;
	title 'Stepwise Logistic Regression for Store_interaction_all';
	model Sales=DayofWeek Customers Promo SchoolHoliday Day_C Day_P Day_S Customers_P Customers_s P_Sch /dwprob stb vif 
	selection=stepwise;
quit;
ods graphics off;
