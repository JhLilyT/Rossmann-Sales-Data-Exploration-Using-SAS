PROC IMPORT OUT= WORK.store_1
            DATAFILE= "Store_1_a.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

title "Sales of Store_1";
proc sgplot data= Store_1;
    series x=date y=weeklysales / ;

	run;

proc forecast data=Store_1
	                method=expo interval=week.6 lead=6
					out=out_expo outfull outresid outest=est_expo;
			id date;
			var weeklysales;

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Forecast from Exponential Smoothing Method";
proc sgplot data=out_expo;
  series x=date y=Weeklysales / group=_type_ lineattrs=(pattern=1);
  where _type_ ^='RESIDUAL' and date>7/31/2015;

run;


proc forecast data=Store_1
                method=expo trend=2  interval=week.6 lead=6
				out=out_double outfull outresid outest=est;
			id date;
			var Weeklysales;

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Forecast from Double Expo Method";
proc sgplot data=out_double;
  series x=date y=Weeklysales / group=_type_ lineattrs=(pattern=1);
  where _type_ ^='RESIDUAL' and date>7/31/2015;

run;

proc forecast data=Store_1
                method=winters seasons=4 interval=week.6 lead=6
				out=out_seasonal_4 outfull outresid outest=est;
			id date;
			var weeklysales;

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Forecast from Seasonality=4 Method";
proc sgplot data=out_seasonal_4;
  series x=date y=Weeklysales / group=_type_ lineattrs=(pattern=1);
  where _type_ ^='RESIDUAL' and date>7/31/2015;

run;

proc forecast data=Store_1
                method=winters seasons=8 interval=week.6 lead=6
				out=out_seasonal_8 outfull outresid outest=est;
			id date;
			var weeklysales;

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Forecast from Seasonality=8 Method";
proc sgplot data=out_seasonal_8;
  series x=date y=Weeklysales / group=_type_ lineattrs=(pattern=1);
  where _type_ ^='RESIDUAL' and date>7/31/2015;

run;

proc forecast data=Store_1
                method=winters seasons=13 interval=week.6 lead=6
				out=out_seasonal_13 outfull outresid outest=est;
			id date;
			var weeklysales;

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Forecast from Seasonality=13 Method";
proc sgplot data=out_seasonal_13;
  series x=date y=Weeklysales / group=_type_ lineattrs=(pattern=1);
  where _type_ ^='RESIDUAL' and date>7/31/2015;

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Residuals(Expo)";
proc sgplot data=out_expo;
     where _type_ ='RESIDUAL' and date>7/31/2015;
	 needle x=date y=Weeklysales / markers markerattrs=(symbol=circlefi);

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Residuals(Winters)";
proc sgplot data=out_winters;
     where _type_ ='RESIDUAL' and date>7/31/2015;
	 needle x=date y=Weeklysales / markers markerattrs=(symbol=circlefi);

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Residuals(S=4)";
proc sgplot data=out_seasonal_4;
     where _type_ ='RESIDUAL' and date>31/7/2015;
	 needle x=date y=Weekly_sales / markers markerattrs=(symbol=circlefi);

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Residuals(S=8)";
proc sgplot data=out_seasonal_8;
     where _type_ ='RESIDUAL' and date>7/31/2015;
	 needle x=date y=Weeklysales / markers markerattrs=(symbol=circlefi);

run;

title1 "Sales of Store1 type_a";
title2 "Plot of Residuals(S=13)";
proc sgplot data=out_seasonal_13;
     where _type_ ='RESIDUAL' and date>7/31/2015;
	 needle x=date y=Weeklysales / markers markerattrs=(symbol=circlefi);

run;

*-------------------------------------------------------------------------;
* Project        :  Marketing Analytics                                   ;
* Answer         :  
*1.According to 5 pictures, Seasonal Exponential Smoothing
*(seasonality=13) forecasts better since the graph is fit the trend more.
*-------------------------------------------------------------------------;
