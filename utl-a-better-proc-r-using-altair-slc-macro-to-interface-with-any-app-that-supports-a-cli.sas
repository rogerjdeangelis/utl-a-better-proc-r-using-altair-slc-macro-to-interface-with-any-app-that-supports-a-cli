%let pgm=utl-a-better-proc-r-using-altair-slc-macro-to-interface-with-any-app-that-supports-a-cli;

%stop_submission;

A better proc r using altair slc macro to interface with any app that supports a CLI

Too long to post here, see github

github
https://github.com/rogerjdeangelis/utl-a-better-proc-r-using-altair-slc-macro-to-interface-with-any-app-that-supports-a-cli

NOTE: macro utl_slc_r64 is avaiable in this repository and in
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories
You need to copy the macro to your autocall library

utl_slc_64 macro
https://github.com/rogerjdeangelis/utl-a-better-proc-r-using-altair-slc-macro-to-interface-with-any-app-that-supports-a-cli/blob/main/utl_slc_r64.sas

THIS TECHNIQUE CAN BE USED WITH

     perl
     powershell
     python
     matlab (octave clone)
     spss ( pspp clone)
     excel
     most sql dialects
     (any application that supports a CLI)

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/************************************************************************************************************************/
/*                           PREDICT WEIGHT GIVEN HEIGHT BY SEX USING R LM FUNCTION                                     */
/*----------------------------------------------------------------------------------------------------------------------*/
/*         INPUT             |             PROCESS                               |             OUTPUT                   */
/*         -----             |             -------                               |             ------                   */
/* d:/sd1/class.sas7bdat     |  %macro rep(                                      |  Macro variable                      */
/*                           |     tblinp=d:/sd1/class.sas7bdat                  |  greetings= Greetings from R         */
/*  NAME    SEX HEIGHT WEIGHT|    ,where=%str(SEX=="M")                          |                                      */
/*                           |    ,tblout=classfit                               |  REGRESSIONS                         */
/*  Alfred   M    14    69.0 |    ,return=greetings                              |                                      */
/*  Alice    F    13    56.5 |    );                                             | Altair SLC (WEIGHT on HEIGHT MALES)  */
/*  Barbara  F    13    65.3 |                                                   |                                      */
/*  Carol    F    14    62.8 |    %utl_slc_r64(pgmx='                            |     NAME SEX HEIGHT WEIGHT  PREDICT  */
/*  Henry    M    14    63.5 |     library(haven);                               |   Alfred   M     14   69.0 65.47787  */
/*  James    M    12    57.3 |     library(dplyr);                               |    Henry   M     14   63.5 65.47787  */
/*  Jane     F    12    59.8 |     want <- read_sas("&tblinp");                  |    James   M     12   57.3 60.25164  */
/*  Janet    F    15    62.5 |     want <- want %>% filter(&where);              |  Jeffrey   M     13   62.5 62.86475  */
/*  Jeffrey  M    13    62.5 |     modl <- lm(WEIGHT ~ HEIGHT, data=want);       |     John   M     12   59.0 60.25164  */
/*  John     M    12    59.0 |     want$PREDICT<-modl$fitted.values;             |   Philip   M     16   72.0 70.70410  */
/*  Joyce    F    11    51.3 |     writeClipboard("Greetings the R");            |   Robert   M     12   64.8 60.25164  */
/*  Judy     F    14    64.3 |     &tblout <- want;'                             |   Ronald   M     15   67.0 68.09098  */
/*  Louise   F    12    56.3 |     ,return=&return                               |   Thomas   M     11   57.5 57.63852  */
/*  Mary     F    15    66.5 |     ,tblinp=&tblinp                               |  William   M     15   66.5 68.09098  */
/*  Philip   M    16    72.0 |     ,tblout=&tblout                               |                                      */
/*  Robert   M    12    64.8 |     );                                            |                                      */
/*  Ronald   M    15    67.0 |                                                   | Altair SLC (WEIGHT on HEIGHT FEMALES */
/*  Thomas   M    11    57.5 |  %mend rep;                                       |                                      */
/*  William  M    15    66.5 |                                                   |     NAME SEX HEIGHT WEIGHT  PREDICT  */
/*                           |  &_init_;                                         |    Alice   F     13   56.5 59.94286  */
/*                           |                                                   |  Barbara   F     13   65.3 59.94286  */
/* libname sd1 sas7bdat      | /*--- for testing and development           ---*/ |    Carol   F     14   62.8 62.85000  */
/*    "d:\sd1";              |   proc datasets lib=work                          |     Jane   F     12   59.8 57.03571  */
/* data sd1.class;           |    delete classfit;                               |    Janet   F     15   62.5 65.75714  */
/*    informat               |  run;quit;                                        |    Joyce   F     11   51.3 54.12857  */
/*      NAME $8.             |                                                   |     Judy   F     14   64.3 62.85000  */
/*      SEX $1.              |  /*--- clear R workspace for testing        ---*/ |   Louise   F     12   56.3 57.03571  */
/*      HEIGHT 8.            |  %utlfkil(d:/wpswrk/workspace.RData)              |     Mary   F     15   66.5 65.75714  */
/*      WEIGHT 8.            |  filename tmp clear;                              |                                      */
/*      ;                    |                                                   |                                      */
/* input                     |  /*--- regress weight on height for males   ---*/ |                                      */
/*  NAME$ SEX$ HEIGHT WEIGHT;|  %rep(                                            |                                      */
/* cards4;                   |     tblinp=d:/sd1/class.sas7bdat                  |                                      */
/* Alfred M 14 69.0 112.5    |    ,where=%str(SEX=="M")                          |                                      */
/* Alice F 13 56.5 84.0      |    ,tblout=fit_m                                  |                                      */
/* Barbara F 13 65.3 98.0    |    );                                             |                                      */
/* Carol F 14 62.8 102.5     |                                                   |                                      */
/* Henry M 14 63.5 102.5     |  /*--- create macro var greetings with            |                                      */
/* James M 12 57.3 83.0      |  /*--- greetings=Greetings from R           ---*/ |                                      */
/* Jane F 12 59.8 84.5       |  %put &=greetings;                                |                                      */
/* Janet F 15 62.5 112.5     |                                                   |                                      */
/* Jeffrey M 13 62.5 84.0    |  %rep(                                            |                                      */
/* John M 12 59.0 99.5       |     tblinp=d:/sd1/class.sas7bdat                  |                                      */
/* Joyce F 11 51.3 50.5      |    ,where=%str(SEX=="F")                          |                                      */
/* Judy F 14 64.3 90.0       |    ,tblout=fit_f                                  |                                      */
/* Louise F 12 56.3 77.0     |    ,return=greetings                              |                                      */
/* Mary F 15 66.5 112.0      |    );                                             |                                      */
/* Philip M 16 72.0 150.0    |                                                   |                                      */
/* Robert M 12 64.8 128.0    |  proc print data=fit_m ;                          |                                      */
/* Ronald M 15 67.0 133.0    |  run;quit;                                        |                                      */
/* Thomas M 11 57.5 85.0     |                                                   |                                      */
/* William M 15 66.5 112.0   |  proc print data=fit_f ;                          |                                      */
/*;;;;                       |  run;quit;                                        |                                      */
/*run;quit;                  |                                                   |                                      */
/* **********************************************************************************************************************/


THERE ARE TWO FLAWS WITH THE SLC PROC R AND SAS PROC R

   1 proc r does not support a macro wrapper
   2 proc r does not provide r packages
      a  read a sas or wpd dataset
      b  create a sas datastep

STEPS IN USING A MACRO TO CALL R (WORKS FOR ME. MAY NEED MORE TESTING)

   0  Currently only one input and one output work SAS dataset is supported.
      Howevr the macro can return a sas macro variable with text or r objects.

   1  Using a command pipe you can stream the R program though the R interpreter

   2  The program is contained in a single quoted macro string.
      Macro strings are limited to 64k characters.
      However the maximum here is 32k, because I convert the macro string to a datastep string.
      The new varchar, not implemented in the slc yet. allows about 1gb strings.

   3  The R program can contain macro calls and macro variables.
      However you have to set the macro wrapper resolve argument to "Y"
      to resolve the macro triggers.
      Note SAS 'proc R' and slc 'Proc R' do not allow any kind of block submit
         None of these are supported
            a macro wrapper
            b call execute
            c embedded macro variable
            d dosubl and %dosubl
         The only way to to pass 'information' to R is to
           create a complete slc proc r program, resolved triggers,
           and then %include the file.

   4  You can only use double quotes and backticks for quoting in your R script.
      Backticks will automatically be converted to single quotes before running your R code

   5  The R haven package is used to read sas datasets for R processing.
      This is an improvement over 'proc r' because you can read sas datasets conditionally.
      In addition haven R can read sas format catalogs.

   6  There is no r package to create sas datasets The slc macro saves the entire R workspace.
      In the permanent hardcoded file, d:/wpswrk/workspace.RData. Subsequently, a proc r program
      is created that loads the workspace abd creates the sas dataset.

   7  The macro also uses the clipboard to return text or objects created by R contained in
      a sas macro variable back to sas.

   8  The r workspace, d:/wpswrk/workspace.RData, is then deleted.
/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

&_init_;
options ps=200;
libname sd1 sas7bdat "d:/sd1";

data sd1.class;
   informat
     NAME $8.
     SEX $1.
     HEIGHT 8.
     WEIGHT 8.
     ;
input
 NAME$ SEX$ HEIGHT WEIGHT;
cards4;
Alfred M 14 69.0 112.5
Alice F 13 56.5 84.0
Barbara F 13 65.3 98.0
Carol F 14 62.8 102.5
Henry M 14 63.5 102.5
James M 12 57.3 83.0
Jane F 12 59.8 84.5
Janet F 15 62.5 112.5
Jeffrey M 13 62.5 84.0
John M 12 59.0 99.5
Joyce F 11 51.3 50.5
Judy F 14 64.3 90.0
Louise F 12 56.3 77.0
Mary F 15 66.5 112.0
Philip M 16 72.0 150.0
Robert M 12 64.8 128.0
Ronald M 15 67.0 133.0
Thomas M 11 57.5 85.0
William M 15 66.5 112.0
;;;;
run;quit;

OUTPUT

d:/sd1/class.sas7bdat

 NAME    SEX HEIGHT WEIGHT

 Alfred   M    14    69.0
 Alice    F    13    56.5
 Barbara  F    13    65.3
 Carol    F    14    62.8
 Henry    M    14    63.5
 James    M    12    57.3
 Jane     F    12    59.8
 Janet    F    15    62.5
 Jeffrey  M    13    62.5
 John     M    12    59.0
 Joyce    F    11    51.3
 Judy     F    14    64.3
 Louise   F    12    56.3
 Mary     F    15    66.5
 Philip   M    16    72.0
 Robert   M    12    64.8
 Ronald   M    15    67.0
 Thomas   M    11    57.5
 William  M    15    66.5

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC    14:02 Wednesday, November 12, 2025

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿;;;;
           ^
ERROR: Expected a statement keyword : found "ï"

NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.036
      cpu time  : 0.000


NOTE: AUTOEXEC processing completed

1
2         &_init_;
3         options ps=200;
4         libname sd1 sas7bdat "d:/sd1";
NOTE: Library sd1 assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\sd1

5
6         data sd1.class;
7            informat
8              NAME $8.
9              SEX $1.
10             HEIGHT 8.
11             WEIGHT 8.
12             ;
13        input
14         NAME$ SEX$ HEIGHT WEIGHT;
15        cards4;

NOTE: Data set "SD1.class" has 19 observation(s) and 4 variable(s)
NOTE: The data step took :
      real time : 0.023
      cpu time  : 0.000


16        Alfred M 14 69.0 112.5
17        Alice F 13 56.5 84.0
18        Barbara F 13 65.3 98.0
19        Carol F 14 62.8 102.5
20        Henry M 14 63.5 102.5
21        James M 12 57.3 83.0
22        Jane F 12 59.8 84.5
23        Janet F 15 62.5 112.5
24        Jeffrey M 13 62.5 84.0
25        John M 12 59.0 99.5
26        Joyce F 11 51.3 50.5
27        Judy F 14 64.3 90.0
28        Louise F 12 56.3 77.0
29        Mary F 15 66.5 112.0
30        Philip M 16 72.0 150.0
31        Robert M 12 64.8 128.0
32        Ronald M 15 67.0 133.0
33        Thomas M 11 57.5 85.0
34        William M 15 66.5 112.0
35        ;;;;
36        run;quit;
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.103
      cpu time  : 0.062

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/


%macro rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=classfit
  ,return=greetings
  );

  %utl_slc_r64(pgmx='
   library(haven);
   library(dplyr);
   want <- read_sas("&tblinp");
   want <- want %>% filter(&where);
   modl <- lm(WEIGHT ~ HEIGHT, data=want);
   want$PREDICT<-modl$fitted.values;
   writeClipboard("Greetings the R Interpreter");
   &tblout <- want;'
   ,return=&return
   ,tblinp=&tblinp
   ,tblout=&tblout
   );

%mend rep;

&_init_;

proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=fit_m
  );

%put &=greetings;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="F")
  ,tblout=fit_f
  ,return=greetings
  );

proc print data=fit_m ;
run;quit;

proc print data=fit_f ;
run;quit;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

                                          Altair SLC    14:20 Wednesday, November 12, 2025    1

Altair SLC
> library(haven);   library(dplyr);
want <- read_sas("d:/sd1/class.sas7bdat");
want <- want %>% filter(SEX=="M");
modl <- lm(WEIGHT ~ HEIGHT, data=want);
want$PREDICT<-modl$fitted.values;
writeClipboard("Greetings the R Interpreter");
fit_m <- want;
save.image(file = "d:/wpswrk/workspace.RData");
>

Altair SLC

      NAME SEX HEIGHT WEIGHT  PREDICT
1   Alfred   M     14   69.0 65.47787
2    Henry   M     14   63.5 65.47787
3    James   M     12   57.3 60.25164
4  Jeffrey   M     13   62.5 62.86475
5     John   M     12   59.0 60.25164
6   Philip   M     16   72.0 70.70410
7   Robert   M     12   64.8 60.25164
8   Ronald   M     15   67.0 68.09098
9   Thomas   M     11   57.5 57.63852
10 William   M     15   66.5 68.09098
[1] "fit_m" "modl"  "want"

want <- read_sas("d:/sd1/class.sas7bdat");
want <- want %>% filter(SEX=="F");
modl <- lm(WEIGHT ~ HEIGHT, data=want);
want$PREDICT<-modl$fitted.values;
writeClipboard("Greetings the R Interpreter");

Altair SLC

     NAME SEX HEIGHT WEIGHT  PREDICT
1   Alice   F     13   56.5 59.94286
2 Barbara   F     13   65.3 59.94286
3   Carol   F     14   62.8 62.85000
4    Jane   F     12   59.8 57.03571
5   Janet   F     15   62.5 65.75714
6   Joyce   F     11   51.3 54.12857
7    Judy   F     14   64.3 62.85000
8  Louise   F     12   56.3 57.03571
9    Mary   F     15   66.5 65.75714
[1] "fit_f" "modl"  "want"

Altair SLC

Obs     NAME      SEX    HEIGHT    WEIGHT    PREDICT

  1    Alfred      M       14       69.0     65.4779
  2    Henry       M       14       63.5     65.4779
  3    James       M       12       57.3     60.2516
  4    Jeffrey     M       13       62.5     62.8648
  5    John        M       12       59.0     60.2516
  6    Philip      M       16       72.0     70.7041
  7    Robert      M       12       64.8     60.2516
  8    Ronald      M       15       67.0     68.0910
  9    Thomas      M       11       57.5     57.6385
 10    William     M       15       66.5     68.0910

Altair SLC

Obs     NAME      SEX    HEIGHT    WEIGHT    PREDICT

 1     Alice       F       13       56.5     59.9429
 2     Barbara     F       13       65.3     59.9429
 3     Carol       F       14       62.8     62.8500
 4     Jane        F       12       59.8     57.0357
 5     Janet       F       15       62.5     65.7571
 6     Joyce       F       11       51.3     54.1286
 7     Judy        F       14       64.3     62.8500
 8     Louise      F       12       56.3     57.0357
 9     Mary        F       15       66.5     65.7571
/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC    14:20 Wednesday, November 12, 2025

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿;;;;
           ^
ERROR: Expected a statement keyword : found "ï"

NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000


NOTE: AUTOEXEC processing completed

1         %macro rep(
2            tblinp=d:/sd1/class.sas7bdat
3           ,where=%str(SEX=="M")
4           ,tblout=classfit
5           ,return=greetings
6           );
7
8           %utl_slc_r64(pgmx='
9            library(haven);
10           library(dplyr);
11           want <- read_sas("&tblinp");
12           want <- want %>% filter(&where);
13           modl <- lm(WEIGHT ~ HEIGHT, data=want);
14           want$PREDICT<-modl$fitted.values;
15           writeClipboard("Greetings the R Interpreter");
16           &tblout <- want;'
17           ,return=&return
18           ,tblinp=&tblinp
19           ,tblout=&tblout
20           );
21
22        %mend rep;
23
24        &_init_;
25
26        proc datasets lib=work nodetails nolist;
27         delete classfit;
28        run;quit;
NOTE: WORK.CLASSFIT (memtype="DATA") was not found, and has not been deleted
NOTE: Procedure datasets step took :
      real time : 0.000
      cpu time  : 0.000


29
30        %utlfkil(d:/wpswrk/workspace.RData)
31        filename tmp clear;
WARNING: The filename "tmp" has not been assigned
32
33        %rep(
34           tblinp=d:/sd1/class.sas7bdat
35          ,where=%str(SEX=="M")
36          ,tblout=fit_m

2                                                                                                                         Altair SLC

37          );
The file d:\wpswrk\_TD36212/r_pgm.txt does not exist
The file d:/wpswrk/workspace.RData does not exist

NOTE: The file _clp is:
      Clipboard

NOTE: 1 record was written to file _clp
      The minimum record length was 1
      The maximum record length was 1
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000



NOTE: The file r_pgm is:
      Filename='d:\wpswrk\_TD36212\r_pgm.txt',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=14:20:15 Nov 12 2025,
      Last Accessed=14:20:15 Nov 12 2025,
      Last Modified=14:20:15 Nov 12 2025,
      Lrecl=32766, Recfm=V

NOTE: 1 record was written to file r_pgm
      The minimum record length was 307
      The maximum record length was 307
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.015



NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=D:\r451\bin\r.exe --vanilla --quiet --no-save < d:\wpswrk\_TD36212\r_pgm.txt,
      Lrecl=32756, Recfm=V

> library(haven);   library(dplyr);   want <- read_sas("d:/sd1/class.sas7bdat");   want <- want %>% filter(SEX=="M");   modl <- lm(WEIGHT ~ HEIGHT, data=want);   want$PREDICT<-modl$fitted.values;   writeClipboard("Greetings the R Interpreter");   fit_m <-
 want; save.image(file = "d:/wpswrk/workspace.RData");
>
NOTE: 3 records were written to file PRINT

NOTE: 2 records were read from file rut
      The minimum record length was 2
      The maximum record length was 309
Stderr output:

Attaching package: 'dplyr'

The following objects are masked from 'package:stats':

    filter, lag

The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union

NOTE: The data step took :
      real time : 1.162
      cpu time  : 0.000


3                                                                                                                         Altair SLC



NOTE: The file tmp is:
      Filename='d:\wpswrk\_TD36212\#LN00002',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=14:20:17 Nov 12 2025,
      Last Accessed=14:20:17 Nov 12 2025,
      Last Modified=14:20:17 Nov 12 2025,
      Lrecl=32767, Recfm=V

NOTE: 9 records were written to file tmp
      The minimum record length was 4
      The maximum record length was 33
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000


Start of %INCLUDE(level 1) tmp is file d:\wpswrk\_TD36212\#LN00002
38      +  options set=RHOME 'D:\d451';
39      +  proc R;
40      +  submit;
41      +  load('d:/wpswrk/workspace.RData')
42      +  want
43      +  ls()
44      +  endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451

NOTE: Submitting statements to R:

> load('d:/wpswrk/workspace.RData')
> want
> ls()

NOTE: Processing of R statements complete

45      +  import r=fit_m data=fit_m;
NOTE: Creating data set 'WORK.fit_m' from R data frame 'fit_m'
NOTE: Data set "WORK.fit_m" has 10 observation(s) and 5 variable(s)

46      +  run;quit;
NOTE: Procedure R step took :
      real time : 0.370
      cpu time  : 0.015


End of %INCLUDE(level 1) tmp

NOTE: The infile clp is:
      Clipboard

macro variable greetings = Greetings the R Interpreter
NOTE: 1 record was read from file clp
      The minimum record length was 27
      The maximum record length was 27
NOTE: The data step took :
      real time : 0.002
      cpu time  : 0.000


47
48        %put &=greetings;

4

/*                                 __
 _ __ ___   __ _  ___ _ __ ___    / _|_ __ ___  _ __ ___    _ __
| `_ ` _ \ / _` |/ __| `__/ _ \  | |_| `__/ _ \| `_ ` _ \  | `__|
| | | | | | (_| | (__| | | (_) | |  _| | | (_) | | | | | | | |
|_| |_| |_|\__,_|\___|_|  \___/  |_| |_|  \___/|_| |_| |_| |_|

*/                                                                                                                      Altair SLC

greetings=Greetings the R Interpreter





49
50        %rep(
51           tblinp=d:/sd1/class.sas7bdat
52          ,where=%str(SEX=="F")
53          ,tblout=fit_f
54          ,return=greetings
55          );

NOTE: The file _clp is:
      Clipboard

NOTE: 1 record was written to file _clp
      The minimum record length was 1
      The maximum record length was 1
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000



NOTE: The file r_pgm is:
      Filename='d:\wpswrk\_TD36212\r_pgm.txt',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=14:20:15 Nov 12 2025,
      Last Accessed=14:20:17 Nov 12 2025,
      Last Modified=14:20:17 Nov 12 2025,
      Lrecl=32766, Recfm=V

NOTE: 1 record was written to file r_pgm
      The minimum record length was 307
      The maximum record length was 307
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015



NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=D:\r451\bin\r.exe --vanilla --quiet --no-save < d:\wpswrk\_TD36212\r_pgm.txt,
      Lrecl=32756, Recfm=V

> library(haven);   library(dplyr);   want <- read_sas("d:/sd1/class.sas7bdat");   want <- want %>% filter(SEX=="F");   modl <- lm(WEIGHT ~ HEIGHT, data=want);   want$PREDICT<-modl$fitted.values;   writeClipboard("Greetings the R Interpreter");   fit_f <-
 want; save.image(file = "d:/wpswrk/workspace.RData");
>
NOTE: 3 records were written to file PRINT

NOTE: 2 records were read from file rut
      The minimum record length was 2
      The maximum record length was 309
Stderr output:

Attaching package: 'dplyr'

The following objects are masked from 'package:stats':

    filter, lag

The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union

5                                                                                                                         Altair SLC


NOTE: The data step took :
      real time : 1.290
      cpu time  : 0.015



NOTE: The file tmp is:
      Filename='d:\wpswrk\_TD36212\#LN00005',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=14:20:18 Nov 12 2025,
      Last Accessed=14:20:18 Nov 12 2025,
      Last Modified=14:20:18 Nov 12 2025,
      Lrecl=32767, Recfm=V

NOTE: 9 records were written to file tmp
      The minimum record length was 4
      The maximum record length was 33
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


Start of %INCLUDE(level 1) tmp is file d:\wpswrk\_TD36212\#LN00005
56      +  options set=RHOME 'D:\d451';
57      +  proc R;
58      +  submit;
59      +  load('d:/wpswrk/workspace.RData')
60      +  want
61      +  ls()
62      +  endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451

NOTE: Submitting statements to R:

> load('d:/wpswrk/workspace.RData')
> want
> ls()

NOTE: Processing of R statements complete

63      +  import r=fit_f data=fit_f;
NOTE: Creating data set 'WORK.fit_f' from R data frame 'fit_f'
NOTE: Data set "WORK.fit_f" has 9 observation(s) and 5 variable(s)

64      +  run;quit;
NOTE: Procedure R step took :
      real time : 0.321
      cpu time  : 0.031


End of %INCLUDE(level 1) tmp

NOTE: The infile clp is:
      Clipboard

macro variable greetings = Greetings the R Interpreter
NOTE: 1 record was read from file clp
      The minimum record length was 27
      The maximum record length was 27
NOTE: The data step took :
      real time : 0.000

6                                                                                                                         Altair SLC

      cpu time  : 0.000


65
66        proc print data=fit_m ;
67        run;quit;
NOTE: 10 observations were read from "WORK.fit_m"
NOTE: Procedure print step took :
      real time : 0.002
      cpu time  : 0.000


68
69        proc print data=fit_f ;
70        run;quit;
NOTE: 9 observations were read from "WORK.fit_f"
NOTE: Procedure print step took :
      real time : 0.000
      cpu time  : 0.000


71
72
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 3.394
      cpu time  : 0.234

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/





















































































































































































































































































































































































































































































































































































       run;quit;

        INPUT                              PROCESS                                                 OUTPUT
        -----                              -------                                                 ------
d:/sd1/class.sas7bdat           %macro rep(                                             Macro variable
                                   tblinp=d:/sd1/class.sas7bdat                          greetings = Greetings the R Interpreter
 NAME    SEX HEIGHT WEIGHT        ,where=%str(SEX=="M")
                                  ,tblout=classfit                                      Altair SLC (WEIGHT on HEIGHT MALES)
 Alfred   M    14    69.0         ,return=greetings
 Alice    F    13    56.5         );                                                          NAME SEX HEIGHT WEIGHT  PREDICT
 Barbara  F    13    65.3                                                               1   Alfred   M     14   69.0 65.47787
 Carol    F    14    62.8         %utl_slc_r64(pgmx='                                   2    Henry   M     14   63.5 65.47787
 Henry    M    14    63.5          library(haven);                                      3    James   M     12   57.3 60.25164
 James    M    12    57.3          library(dplyr);                                      4  Jeffrey   M     13   62.5 62.86475
 Jane     F    12    59.8          want <- read_sas("&tblinp");                         5     John   M     12   59.0 60.25164
 Janet    F    15    62.5          want <- want %>% filter(&where);                     6   Philip   M     16   72.0 70.70410
 Jeffrey  M    13    62.5          modl <- lm(WEIGHT ~ HEIGHT, data=want);              7   Robert   M     12   64.8 60.25164
 John     M    12    59.0          want$PREDICT<-modl$fitted.values;                    8   Ronald   M     15   67.0 68.09098
 Joyce    F    11    51.3          writeClipboard("Greetings the R Interpreter");       9   Thomas   M     11   57.5 57.63852
 Judy     F    14    64.3          &tblout <- want;'                                    10 William   M     15   66.5 68.09098
 Louise   F    12    56.3          ,return=&return
 Mary     F    15    66.5          ,tblinp=&tblinp
 Philip   M    16    72.0          ,tblout=&tblout                                      Altair SLC (WEIGHT on HEIGHT FEMALES)
 Robert   M    12    64.8          );
 Ronald   M    15    67.0                                                               Altair SLC
 Thomas   M    11    57.5       %mend rep;
 William  M    15    66.5                                                                    NAME SEX HEIGHT WEIGHT  PREDICT
                                &_init_;                                                1   Alice   F     13   56.5 59.94286
                                                                                        2 Barbara   F     13   65.3 59.94286
libname sd1 sas7bdat "d:/sd1";  /*--- for testing and development            ---*/      3   Carol   F     14   62.8 62.85000
                                proc datasets lib=work nodetails nolist;                4    Jane   F     12   59.8 57.03571
data sd1.class;                  delete classfit;                                       5   Janet   F     15   62.5 65.75714
   informat                     run;quit;                                               6   Joyce   F     11   51.3 54.12857
     NAME $8.                                                                           7    Judy   F     14   64.3 62.85000
     SEX $1.                    /*--- clear R workspace for testing          ---*/      8  Louise   F     12   56.3 57.03571
     HEIGHT 8.                  %utlfkil(d:/wpswrk/workspace.RData)                     9    Mary   F     15   66.5 65.75714
     WEIGHT 8.                  filename tmp clear;
     ;
input                           /*--- regress weight on height for males     ---*/
 NAME$ SEX$ HEIGHT WEIGHT;      %rep(
cards4;                            tblinp=d:/sd1/class.sas7bdat
Alfred M 14 69.0 112.5            ,where=%str(SEX=="M")
Alice F 13 56.5 84.0              ,tblout=fit_m
Barbara F 13 65.3 98.0            );
Carol F 14 62.8 102.5
Henry M 14 63.5 102.5           /*--- create macro var greetings with
James M 12 57.3 83.0            /*--- greetings=Greetings the R Interpreter  ---*/
Jane F 12 59.8 84.5             %put &=greetings;
Janet F 15 62.5 112.5
Jeffrey M 13 62.5 84.0          %rep(
John M 12 59.0 99.5                tblinp=d:/sd1/class.sas7bdat
Joyce F 11 51.3 50.5              ,where=%str(SEX=="F")
Judy F 14 64.3 90.0               ,tblout=fit_f
Louise F 12 56.3 77.0             ,return=greetings
Mary F 15 66.5 112.0              );
Philip M 16 72.0 150.0
Robert M 12 64.8 128.0          proc print data=fit_m ;
Ronald M 15 67.0 133.0          run;quit;
Thomas M 11 57.5 85.0
William M 15 66.5 112.0         proc print data=fit_f ;
;;;;                            run;quit;
run;quit;


/*               _
| |__   ___  ___| |_
| `_ \ / _ \/ __| __|
| |_) |  __/\__ \ |_
|_.__/ \___||___/\__|

*/

%macro utl_slc_r64(

      pgmx=        /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                     ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  %utlfkil(d:/wpswrk/workspace.RData);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","22"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

  %if %upcase(%substr(&return.,1,1)) ne N %then %do;

    filename clp clipbrd ;

    data _null_;
     infile clp;
     input;
     putlog "macro variable &return = " _infile_;
     call symputx("&return.",_infile_,"G");
    run;quit;

  %end;

%mend utl_slc_r64;


%macro rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=classfit
  ,return=greetings
  );

  %utl_slc_r64(pgmx='
   library(haven);
   library(dplyr);
   want <- read_sas("&tblinp");
   want <- want %>% filter(&where);
   modl <- lm(WEIGHT ~ HEIGHT, data=want);
   want$PREDICT<-modl$fitted.values;
   writeClipboard("Greetings the R Interpreter");
   &tblout <- want;'
   ,return=&return
   ,tblinp=&tblinp
   ,tblout=&tblout
   );

%mend rep;

&_init_;

proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=fit_m
  );

%put &=greetings;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="F")
  ,tblout=fit_f
  ,return=greetings
  );

proc print data=fit_m ;
run;quit;

proc print data=fit_f ;
run;quit;



/*               _
| |__   ___  ___| |_
| `_ \ / _ \/ __| __|
| |_) |  __/\__ \ |_
|_.__/ \___||___/\__|

*/

data _null_;
 input;
 file "c:/wpsoto/utl_slc_r64.sas";
 put _infile_;
cards4;
%macro utl_slc_r64(

      pgmx=        /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                     ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  %utlfkil(d:/wpswrk/workspace.RData);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","22"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

  %if %upcase(%substr(&return.,1,1)) ne N %then %do;

    filename clp clipbrd ;

    data _null_;
     infile clp;
     input;
     putlog "macro variable &return = " _infile_;
     call symputx("&return.",_infile_,"G");
    run;quit;

  %end;

%mend utl_slc_r64;
;;;;
run;quit;


%macro rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=classfit
  ,return=greetings
  );

  %utl_slc_r64(pgmx='
   library(haven);
   library(dplyr);
   want <- read_sas("&tblinp");
   want <- want %>% filter(&where);
   modl <- lm(WEIGHT ~ HEIGHT, data=want);
   want$PREDICT<-modl$fitted.values;
   writeClipboard("Greetings the R Interpreter");
   &tblout <- want;'
   ,return=&return
   ,tblinp=&tblinp
   ,tblout=&tblout
   );

%mend rep;

&_init_;

/*--- for testing and development            ---*/
proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

/*--- clear R workspace for testing          ---*/
%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

/*--- regress weight on height for males     ---*/
%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=fit_m
  );

/*--- create macro var greetings with
/*--- greetings=Greetings the R Interpreter  ---*/
%put &=greetings;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="F")
  ,tblout=fit_f
  ,return=greetings
  );

proc print data=fit_m ;
run;quit;

proc print data=fit_f ;
run;quit;


Macro variable
 greetings = Greetings the R Interpreter

Altair SLC (WEIGHT on HEIGHT MALES)

      NAME SEX HEIGHT WEIGHT  PREDICT
1   Alfred   M     14   69.0 65.47787
2    Henry   M     14   63.5 65.47787
3    James   M     12   57.3 60.25164
4  Jeffrey   M     13   62.5 62.86475
5     John   M     12   59.0 60.25164
6   Philip   M     16   72.0 70.70410
7   Robert   M     12   64.8 60.25164
8   Ronald   M     15   67.0 68.09098
9   Thomas   M     11   57.5 57.63852
10 William   M     15   66.5 68.09098


Altair SLC (WEIGHT on HEIGHT FEMALES)

Altair SLC

     NAME SEX HEIGHT WEIGHT  PREDICT
1   Alice   F     13   56.5 59.94286
2 Barbara   F     13   65.3 59.94286
3   Carol   F     14   62.8 62.85000
4    Jane   F     12   59.8 57.03571
5   Janet   F     15   62.5 65.75714
6   Joyce   F     11   51.3 54.12857
7    Judy   F     14   64.3 62.85000
8  Louise   F     12   56.3 57.03571
9    Mary   F     15   66.5 65.75714































/*          _       _             _
  ___  _ __(_) __ _(_)_ __   __ _| |
 / _ \| `__| |/ _` | | `_ \ / _` | |
| (_) | |  | | (_| | | | | | (_| | |
 \___/|_|  |_|\__, |_|_| |_|\__,_|_|
              |___/
*/

%macro utl_slc_r64(

      pgmx=        /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  %utlfkil(d:/wpswrk/workspace.RData);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","22"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

%mend utl_slc_r64;


%macro rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=classfit
  );

 %utl_slc_r64(pgmx='
  library(haven);
  library(dplyr);
  want <- read_sas("&tblinp");
  want <- want %>% filter(&where);
  modl <- lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  &tblout <- want;'
  ,tblinp=&tblinp
  ,tblout=&tblout
  );

%mend rep;


&_init_;

proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=fit_m
  );
%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="F")
  ,tblout=fit_f
  ,return=greetings
  );

proc print data=fit_m ;
run;quit;

proc print data=fit_f ;
run;quit;


/*          _       _             _
  ___  _ __(_) __ _(_)_ __   __ _| |
 / _ \| `__| |/ _` | | `_ \ / _` | |
| (_) | |  | | (_| | | | | | (_| | |
 \___/|_|  |_|\__, |_|_| |_|\__,_|_|
              |___/
*/

/*               _
| |__   ___  ___| |_
| `_ \ / _ \/ __| __|
| |_) |  __/\__ \ |_
|_.__/ \___||___/\__|

*/

%macro utl_slc_r64(

      pgmx=        /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                     ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  %utlfkil(d:/wpswrk/workspace.RData);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","22"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

  %if %upcase(%substr(&return.,1,1)) ne N %then %do;

    filename clp clipbrd ;

    data _null_;
     infile clp;
     input;
     putlog "macro variable &return = " _infile_;
     call symputx("&return.",_infile_,"G");
    run;quit;

  %end;

%mend utl_slc_r64;


%macro rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=classfit
  ,return=greetings
  );

  %utl_slc_r64(pgmx='
   library(haven);
   library(dplyr);
   want <- read_sas("&tblinp");
   want <- want %>% filter(&where);
   modl <- lm(WEIGHT ~ HEIGHT, data=want);
   want$PREDICT<-modl$fitted.values;
   writeClipboard("Greetings the R Interpreter");
   &tblout <- want;'
   ,return=&return
   ,tblinp=&tblinp
   ,tblout=&tblout
   );

%mend rep;

&_init_;

proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=fit_m
  );

%put &=greetings;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="F")
  ,tblout=fit_f
  ,return=greetings
  );

proc print data=fit_m ;
run;quit;

proc print data=fit_f ;
run;quit;





















%macro utl_slc_r64(

      pgmx=        /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  %utlfkil(d:/wpswrk/workspace.RData);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","27"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

%mend utl_slc_r64;


proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

&_init_;
%utl_slc_r64(pgmx='
  library(haven);
  want <- read_sas("&tblinp");
  modl <- lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  &tblout <- want;'
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=classfit
  );

/*          _       _             _
  ___  _ __(_) __ _(_)_ __   __ _| |
 / _ \| `__| |/ _` | | `_ \ / _` | |
| (_) | |  | | (_| | | | | | (_| | |
 \___/|_|  |_|\__, |_|_| |_|\__,_|_|
              |___/
*/

%macro utl_slc_r64(

      pgmx=        /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  %utlfkil(d:/wpswrk/workspace.RData);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","22"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

%mend utl_slc_r64;


%macro rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=classfit
  );

 %utl_slc_r64(pgmx='
  library(haven);
  library(dplyr);
  want <- read_sas("&tblinp");
  want <- want %>% filter(&where);
  modl <- lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  &tblout <- want;'
  ,tblinp=&tblinp
  ,tblout=&tblout
  );

%mend rep;


&_init_;

proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=fit_m
  );
%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="F")
  ,tblout=fit_f
  );

proc print data=fit_m ;
run;quit;

proc print data=fit_f ;
run;quit;




%macro utl_slc_r64(

      pgmx=        /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  %utlfkil(d:/wpswrk/workspace.RData);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","22"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

%mend utl_slc_r64;


%macro rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=classfit
  );

 %utl_slc_r64(pgmx='
  library(haven);
  library(dplyr);
  want <- read_sas("&tblinp");
  want <- want %>% filter(&where);
  modl <- lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  &tblout <- want;'
  ,tblinp=&tblinp
  ,tblout=&tblout
  );

%mend rep;


&_init_;

proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="M")
  ,tblout=fit_m
  );
%rep(
   tblinp=d:/sd1/class.sas7bdat
  ,where=%str(SEX=="F")
  ,tblout=fit_f
  );

proc print data=fit_m ;
run;quit;

proc print data=fit_f ;
run;quit;
















%rep(M,tblout=classfit);

proc print data=fitsex;
run;quit;



/*
| |_ _ __ _   _
| __| `__| | | |
| |_| |  | |_| |
 \__|_|   \__, |
          |___/
*/

%macro utl_slc_r64(

      pgmx         /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "c:/slc/r_pgm.sas" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","22"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

%mend utl_slc_r64;


%macro rep(sexes);

   %local idx sex;

   %do idx=1 %to %sysfunc(countw(&sexes));

     %let sex=%scan(&sexes,&idx);

     proc datasets lib=work nodetails nolist;
      delete fit&sex;
     run;quit;

     %utl_slc_r64('
     library(haven);
     library(sqldf);
     # extensive windows extensions;
     options(sqldf.dll = "d:/dll/sqlean.dll");
     have <- read_sas("&tblinp");
     want <- sqldf("
         select
           name
          ,height
          ,weight
         from
           have
         ");
     modl <- lm(WEIGHT ~ HEIGHT, data=want);
     want$PREDICT<-modl$fitted.values;
     &tblout <- want;

     '
     /*--- substituted in R script ---*/
     ,tblinp=d:/sd1/class.sas7bdat
     ,tblout=fit&sex
     )

   %end;

%mend rep;

proc datasets lib=work nodetails nolist;
 delete &sex;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

&_init_;
%rep(M);




















proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

&_init_;
%utl_slc_r64('
  library(haven);
  want <- read_sas("&tblinp");
  modl <- lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  &tblout <- want;'
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=classfit
  );


/*   _     _                           _
| |_| |__ (_) ___  __      _____  _ __| | _____
| __| `_ \| |/ __| \ \ /\ / / _ \| `__| |/ / __|
| |_| | | | | (__   \ V  V / (_) | |  |   <\__ \
 \__|_| |_|_|\___|   \_/\_/ \___/|_|  |_|\_\___/

*/

%macro utl_slc_r64(

      pgmx         /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %local rwork;

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","27"x);

    put pgm;
    putlog "zzzzzz" pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=want data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

%mend utl_slc_r64;


%macro rep(sexes);

   %local idx sex;

   %do idx=1 %to %sysfunc(countw(&sexes));

     %let sex=%scan(&sexes,&idx);

     proc datasets lib=work nodetails nolist;
      delete fit&sex;
     run;quit;

     %utl_slc_r64('
     library(haven);
     library(sqldf)
     # extensive windows extensions;
     options(sqldf.dll = "d:/dll/sqlean.dll");
     have <- read_sas("&tblinp");
     want <- sqldf(`
         select
           name
          ,height
          ,weight
         from
           have
         where
           sex="&sex"
         `);
     modl <- lm(WEIGHT ~ HEIGHT, data=want);
     want$PREDICT<-modl$fitted.values;
     &tblout <- want;'

     /*--- substituted in R script ---*/
     ,tblinp=d:/sd1/class.sas7bdat
     ,tblout=fit&sex
     )

   %end;

%mend rep;

proc datasets lib=work nodetails nolist;
 delete &sex;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData);

&_init_;
%rep(M F);






%utl_slc_r64('
library(haven);
library(sqldf)
# extensive windows extensions;
options(sqldf.dll = "d:/dll/sqlean.dll");
have <- read_sas("&tblinp");
want <- sqldf(`
    select
      name
     ,height
     ,weight
    from
      have
    where
      sex="&tblout"
    `);
modl <- lm(WEIGHT ~ HEIGHT, data=want);
want$PREDICT<-modl$fitted.values;
&tblout <- want;'
,tblinp=d:/sd1/class.sas7bdat
,tblout=&sex
);


library(haven);
library(sqldf)
# extensive windows extensions;
options(sqldf.dll = "d:/dll/sqlean.dll");
have <- read_sas("d:/sd1/class.sas7bdat");
want <- sqldf('
select
name
,height
,weight
 from
have
where
sex="M"
');
modl <- lm(WEIGHT ~ HEIGHT, data=want);
want$PREDICT<-modl$fitted.values;
fitM <- want;
save.image(file = 'd:/wpswrk/workspace.RData');












     %utl_slc_r64('
       library(haven);
       want <- read_sas("d:/sd1/class.sas7bdat");
       modl = lm(WEIGHT ~ HEIGHT, data=want);
       want$PREDICT<-modl$fitted.values;
       want;
       ls();
       save.image(file = "d:/wpswrk/workspace.RData");'
       ,tblinp=d:/sd1/class.sas7bdat
       ,tblout=&sex
       );

/*            _   _
| |_ ___  ___| |_(_)_ __   __ _
| __/ _ \/ __| __| | `_ \ / _` |
| ||  __/\__ \ |_| | | | | (_| |
 \__\___||___/\__|_|_| |_|\__, |
                          |___/
*/

%macro utl_slc_r64(

      pgmx         /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=classfit /*---- output sas table                ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  %utlfkil(d:/wpswrk/workspace.RData);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm pgmx $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`);");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","27"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "options set=RHOME 'D:\d451';";
    put "proc R;";
    put "submit;";
    put "load('d:/wpswrk/workspace.RData')";
    put "want";
    put "ls()";
    put "endsubmit;";
    put "import r=&tblout data=&tblout;";
    put "run;quit;";
  run;quit;

  %inc tmp;

%mend utl_slc_r64;


proc datasets lib=work nodetails nolist;
 delete classfit;
run;quit;

%utlfkil(d:/wpswrk/workspace.RData)
filename tmp clear;

&_init_;
%utl_slc_r64('
  library(haven);
  want <- read_sas("&tblinp");
  modl <- lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  &tblout <- want;'
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=classfit
  );




&_init_;
%utl_slc_r64('
  library(haven);
  want <- read_sas("&tblinp");
  result <- lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-resul$fitted.values;
  &tblout <- want;'
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=classfit
  );



























save.image(file = "d:/wpswrk/workspace.RData");'

%utl_slc_r64('
   library(haven);
   have <- read_sas("&tblinp");
   have;
   modell = lm(WEIGHT ~ HEIGHT, data=have);
   str(model1);
   &tblout$PREDICT<-model1$fitted.values;
   &tblout;
   save.image(file = "d:/wpswrk/workspace.RData");
   '
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=classfit
  ,return=Value_from_R
  );





write_ClipBoard("Created from my R script");









data _nul_;
pgm=catx(" ","ok","save.image(file = `d:/wpswrk/workspace.RData`)");
put pgm;
if index(pgm,"`") then pgm=tranwrd(pgm,"`","27"x);
put pgm;
run;quit;











%macro utl_slc_r64(
      pgmx         /*---- quoted string containing entire program ----*/
     ,return=N
     ,resolve=Y
     ,tblinp=d:/sd1/class.sas7bdat
     ,tblout=work.classfit
     ,rwork=d:/wpswrk/workspace.RData
     )/des="Semi colon separated set of R commands - drop down to R";

  %local wrk;


  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);

  work

  /* clear clipboard */
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;
  * write the program to a temporary file;
  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;
    length pgm $32756;
    file r_pgm;
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(&pgmx);
     end;
    else do;
        pgm=&pgmx;
     end;
     if index(pgm,"`") then pgm=tranwrd(pgm,"`","27"x);
    put pgm;
    /*putlog pgm;*/
  run;

  * pipe file through R;
  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";
  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;
  * use the clipboard to create macro variable;


filename tmp temp;

data _null_;
  file tmp;
  put "proc R;   ";
  put "submit;   ";
  put "load('&rwork')";
  put "endsubmit;";
  put "import r=want data=&tblout;";
  put "run;quit; ";
run;quit;

%inc tmp;
%mend utl_slc_r64;

proc datasets lib=work.classfit nodetails nolist;
 delete classfit;
run;quit;


%utl_slc_r64('
  library(haven);
  want <- read_sas("&tblinp");
  modl = lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  want;
  write_ClipBoard("Created from my R script');
  '
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=work.classfit
  ,
  );





  want <- read_sas("&tblinp");
  modl = lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  want;



























%macro utl_slc_r64(

      pgmx         /*---- quoted string containing entire program ----*/
     ,return=N     /*---- Y to return a macro variable to slc     ----*/
     ,resolve=Y    /*---- resolve slc macro vars in r program     ----*/
     ,tblinp=d:/sd1/class.sas7bdat /*---- input sas table         ----*/
     ,tblout=work.classfit /*---- output sas table                ----*/
     ,rwork= /*---- r workspace          ----*/

     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);

  /*---- clear clipboard for use later                            ----*/
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;

  /*---- write the program to a temporary file                    ----*/

  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;

    length pgm $32756;
    file r_pgm;

    pgmx=catx(" ",&pgmx,"save.image(file = `d:/wpswrk/workspace.RData`)");

    /*---- turn on/off macro resolution                           ----*/
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(pgmx);
     end;
    else do;
        pgm=pgmx;
     end;

     if index(pgm,"`") then pgm=tranwrd(pgm,"`","27"x);

    put pgm;

  run;

  /*---- pip the program through the slc                          ----*/

  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename r_pgm clear;

  filename tmp temp;

  data _null_;
    file tmp;
    put "proc R;   ";
    put "submit;   ";
    put "load('d:/wpswrk/workspace.RData')";
    put "endsubmit;";
    put "import r=want data=&tblout;";
    put "run;quit; ";
  run;quit;

  %inc tmp;

%mend utl_slc_r64;



%utl_slc_r64('
   library(haven);
   want <- read_sas("&tblinp");
   modl = lm(WEIGHT ~ HEIGHT, data=want);
   want$PREDICT<-modl$fitted.values;
   want;'
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=work.classfit
  ,return=Value_from_R
  );




%macro utl_slc_r64(
      pgmx         /*---- quoted string containing entire program ----*/
     ,return=N
     ,resolve=Y
     ,tblinp=d:/sd1/class.sas7bdat
     ,tblout=work.classfit
     ,rwork=d:/wpswrk/workspace.RData
     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);

  /* clear clipboard */
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;
  * write the program to a temporary file;
  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;
    length pgm $32756;
    file r_pgm;
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(&pgmx);
     end;
    else do;
        pgm=&pgmx;
     end;
     if index(pgm,"`") then pgm=tranwrd(pgm,"`","27"x);
    put pgm;
    /*putlog pgm;*/
  run;

  * pipe file through R;
  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";
  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;
  * use the clipboard to create macro variable;


filename tmp temp;

data _null_;
  file tmp;
  put "proc R;   ";
  put "submit;   ";
  put "load('&rwork')";
  put "endsubmit;";
  put "import r=want data=&tblout;";
  put "run;quit; ";
run;quit;

%inc tmp;
%mend utl_slc_r64;

proc datasets lib=work.classfit nodetails nolist;
 delete classfit;
run;quit;


%utl_slc_r64('
  library(haven);
  want <- read_sas("&tblinp");
  modl = lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  want;
  write_ClipBoard("Created from my R script')
  '
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=work.classfit
  ,
  );







  ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
  ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
  ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
  ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
  ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
  ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;























%macro utl_slc_r64(
      pgmx
     ,return=N
     ,resolve=Y
     ,tblinp=d:/sd1/class.sas7bdat
     ,tblout=work.classfit
     ,rwork=%sysfunc(pathname(work))/workspace.RData
     )/des="Semi colon separated set of R commands - drop down to R";

  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);

  /* clear clipboard */
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;
  * write the program to a temporary file;
  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;
    length pgm $32756;
    file r_pgm;
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(&pgmx);
     end;
    else do;
        pgm=&pgmx;
     end;
     if index(pgm,"`") then pgm=tranwrd(pgm,"`","27"x);
    put pgm;
    /*putlog pgm;*/
  run;
  * pipe file through R;
  filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < %sysfunc(pathname(r_pgm))";
  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;
  * use the clipboard to create macro variable;
  %if %upcase(%substr(&return.,1,1)) ne N %then %do;
    filename clp clipbrd ;
    data _null_;
     infile clp;
     input;
     putlog "macro variable &return = " _infile_;
     call symputx("&return.",_infile_,"G");
    run;quit;
  %end;

%let rwork=xxxx;
%let rwork=xxxx;

%let rcde="
  proc R;
  submit;
  load('&rwork')
  endsubmit;
  import r=want data=&tblout);
  run;quit;";

filename tmp temp;
data _null_;
   file tmp;
   put &rcde;
run;quit;

%inc tmp;


%let rwork=xxxx;
%let rwork=xxxx;

%let rcde="
  proc R;
  submit;
  x=1
  x
  endsubmit;
  import r=want data=&tblout);
  run;quit;";

filename tmp temp;
data _null_;
   file tmp;
   put &rcde;
run;quit;

%inc tmp;


%put &rcde;

&rcde;

%mend utl_slc_r64;


%utl_slc_r64('
  library(haven);
  want <- read_sas("&tblinp");
  modl = lm(WEIGHT ~ HEIGHT, data=want);
  want$PREDICT<-modl$fitted.values;
  want;
  save.image(file = "&rwork")
  '
  ,tblinp=d:/sd1/class.sas7bdat
  ,tblout=work.classfit
  );


data _null_;



  proc R;
  submit;
  load("&rwork")
  endsubmit;
  import r=want data=&tblout);
  run;quit;











 ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
 ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
 ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
 ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;



%let rcde='
  proc R;
  submit;
  x=2;
  print(x);
  endsubmit;
  run;quit;';

%put &rcde;

  data _null_;
   call excecute(
 run;quit;


filename tmp temp;

data _null_;
  file tmp;
  put "proc R;   ";
  put "submit;   ";
  put "x=2       ";
  put "print(x)  ";
  put "endsubmit;";
  put "run;quit; ";
run;quit;

%inc tmp;







  call execute('
  call execute('
  call execute('
  call execute('
  proc R;
  submit;
  x=2
  print(x)
  endsubmit;
  run;quit;

















run;












%sysfunc(pathname(work)/workspace.RData


save.image(file = "%sysfunc(pathname(work)/workspace.RData")
load("my_workspace.RData")
























/**************************************************************************************************************************/
/*                            |                                                   |                                       */
/*       INPUT                |            PROCESS                                |            OUTPUT                     */
/*                            |                                                   |                                       */
/* SD1.CLASS total obs=19     |  proc datasets lib=work mt=data                   |                FROM R     FROM SAS    */
/*                            |    mt=view nolist nodetails;                      | HEIGHT WEIGHT  PREDICT    RESIDUAL    */
/* Obs HEIGHT WEIGHT  PREDICT |    delete classfit;                               |                                       */
/*                            |  run;quit;                                        |  69.0   112.5  126.006    -13.5062    */
/*   1  51.3    50.5     .    |                                                   |  56.5    84.0   77.268      6.7317    */
/*   2  56.3    77.0     .    |  %utlfkil("d:/xpt/want.xpt");                     |  65.3    98.0  111.580    -13.5798    */
/*   3  56.5    84.0     .    |                                                   |  62.8   102.5  101.832      0.6678    */
/*   4  57.3    83.0     .    |  data classfit;                                   |  63.5   102.5  104.562     -2.0615    */
/*   5  57.5    85.0     .    |                                                   |  57.3    83.0   80.388      2.6125    */
/*   6  59.0    99.5     .    |   set  sd1.class(obs=1 in=opn)                    |  59.8    84.5   90.135     -5.6351    */
/*   7  59.8    84.5     .    |        xpt.want (in=r) open=defer;                |  62.5   112.5  100.662     11.8375    */
/*   8  62.5   112.5     .    |                                                   |  62.5    84.0  100.662    -16.6625    */
/*   9  62.5    84.0     .    |   * execute r ehile reading sd1.class;            |  59.0    99.5   87.016     12.4841    */
/*  10  62.8   102.5     .    |   if _n_=1 then do;                               |  51.3    50.5   56.993     -6.4933    */
/*  11  63.5   102.5     .    |     rc=dosubl('                                   |  64.3    90.0  107.681    -17.6807    */
/*  12  64.3    90.0     .    |      %utl_submit_r64x("                           |  56.3    77.0   76.488      0.5115    */
/*  13  64.8   128.0     .    |        library(haven);                            |  66.5   112.0  116.259     -4.2586    */
/*  14  65.3    98.0     .    |        library(SASxport);                         |  72.0   150.0  137.703     12.2967    */
/*  15  66.5   112.0     .    |        source(`c:/temp/fn_tosas9.R`);             |  64.8   128.0  109.630     18.3698    */
/*  16  66.5   112.0     .    |        want <- read_sas(`d:/sd1/clas.sas7bdat`);  |  67.0   133.0  118.208     14.7919    */
/*  17  67.0   133.0     .    |        modl = lm(WEIGHT ~ HEIGHT, data=want);     |  57.5    85.0   81.167      3.8327    */
/*  18  69.0   112.5     .    |        str(modl);                                 |  66.5   112.0  116.259     -4.2586    */
/*  19  72.0   150.0     .    |        want$PREDICT<-modl$fitted.values;          |                                       */
/*                            |        want;                                      |                                       */
/*                            |        write.xport(want,file=`d:/xpt/want.xpt`);  |                                       */
/*                            |      ");                                          |                                       */
/*                            |      ');                                          |                                       */
/*                            |                                                   |                                       */
/*                            |   end;                                            |                                       */
/*                            |                                                   |                                       */
/*                            |   * add residual column using new tmp.want;       |                                       */
/*                            |   * tmp.want opened and available;                |                                       */
/*                            |   if r then do;                                   |                                       */
/*                            |       residual=weight-predict;                    |                                       */
/*                            |       output;                                     |                                       */
/*                            |   end;                                            |                                       */
/*                            |                                                   |                                       */
/*                            |   drop rc;                                        |                                       */
/*                            |                                                   |                                       */
/*                            |  run;quit;                                        |                                       */
/*                            |                                                   |                                       */
/*                            |  proc print data=classfit;                        |                                       */
/*                            |  run;quit;                                        |                                       */
/*                            |                                                   |                                       */
/**************************************************************************************************************************/

/*___               _       __                             _        _     _
|___ \   _ __    __| | ___ / _| ___ _ __   ___  __ _ ___  | |_ __ _| |__ | | ___
  __) | | `__|  / _` |/ _ \ |_ / _ \ `__| / __|/ _` / __| | __/ _` | `_ \| |/ _ \
 / __/  | |    | (_| |  __/  _|  __/ |    \__ \ (_| \__ \ | || (_| | |_) | |  __/
|_____| |_|     \__,_|\___|_|  \___|_|    |___/\__,_|___/  \__\__,_|_.__/|_|\___|
*/

/**************************************************************************************************************************/
/*                            |                                                |                                          */
/*       INPUT                |              PROCESS                           |                OUTP                      */
/*                            |                                                |                                          */
/* SD1.CLASS total obs=19     | %utlfkil(c:/temp/want.sas7bdat);               |                FROM R     FROM SAS       */
/*                            |                                                | HEIGHT WEIGHT  PREDICT    RESIDUAL       */
/* Obs HEIGHT WEIGHT  PREDICT | proc datasets lib=work mt=data                 |                                          */
/*                            |   mt=view nolist nodetails;                    |  69.0   112.5  126.006    -13.5062       */
/*   1  51.3    50.5     .    |   delete classfit;                             |  56.5    84.0   77.268      6.7317       */
/*   2  56.3    77.0     .    | run;quit;                                      |  65.3    98.0  111.580    -13.5798       */
/*   3  56.5    84.0     .    |                                                |  62.8   102.5  101.832      0.6678       */
/*   4  57.3    83.0     .    | data classfit;                                 |  63.5   102.5  104.562     -2.0615       */
/*   5  57.5    85.0     .    |  set                                           |  57.3    83.0   80.388      2.6125       */
/*   6  59.0    99.5     .    |    sd1.class(obs=1 in=opn)                     |  59.8    84.5   90.135     -5.6351       */
/*   7  59.8    84.5     .    |    tmp.want (in=r) open=defer;                 |  62.5   112.5  100.662     11.8375       */
/*   8  62.5   112.5     .    |                                                |  62.5    84.0  100.662    -16.6625       */
/*   9  62.5    84.0     .    |  * execute r while reading sd1.class;          |  59.0    99.5   87.016     12.4841       */
/*  10  62.8   102.5     .    |  if _n_=1 then do;                             |  51.3    50.5   56.993     -6.4933       */
/*  11  63.5   102.5     .    |   rc=dosubl('                                  |  64.3    90.0  107.681    -17.6807       */
/*  12  64.3    90.0     .    |    %utl_submit_r64x("                          |  56.3    77.0   76.488      0.5115       */
/*  13  64.8   128.0     .    |      library(haven);                           |  66.5   112.0  116.259     -4.2586       */
/*  14  65.3    98.0     .    |      source(`c:/temp/fn_tosas9.R`);            |  72.0   150.0  137.703     12.2967       */
/*  15  66.5   112.0     .    |      want <-read_sas(`d:/sd1/clas.sas7bdat`);  |  64.8   128.0  109.630     18.3698       */
/*  16  66.5   112.0     .    |      modl = lm(WEIGHT ~ HEIGHT, data=want);    |  67.0   133.0  118.208     14.7919       */
/*  17  67.0   133.0     .    |      str(modl);                                |  57.5    85.0   81.167      3.8327       */
/*  18  69.0   112.5     .    |      want$PREDICT<-modl$fitted.values;         |  66.5   112.0  116.259     -4.2586       */
/*  19  72.0   150.0     .    |      want<-data.frame(want);                   |                                          */
/*                            |      fn_tosas9(dataf=want);                    |                                          */
/*                            |    ");                                         |                                          */
/*                            |   ');                                          |                                          */
/*                            |                                                |                                          */
/*                            |  end;                                          |                                          */
/*                            |                                                |                                          */
/*                            |  * add residual column using new tmp.want;     |                                          */
/*                            |  * tmp.want opened and available;              |                                          */
/*                            |  if r then do;                                 |                                          */
/*                            |      residual=weight-predict;                  |                                          */
/*                            |      output;                                   |                                          */
/*                            |  end;                                          |                                          */
/*                            |                                                |                                          */
/*                            |  drop rc;                                      |                                          */
/*                            | run;quit;                                      |                                          */
/*                            |                                                |                                          */
/*                            | proc print data=classfit;                      |                                          */
/*                            | run;quit;                                      |                                          */
/*                            |                                                |                                          */
/**************************************************************************************************************************/
