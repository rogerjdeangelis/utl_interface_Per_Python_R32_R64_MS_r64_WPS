Code to interface with Perl, Python, R32, R64, MS_r64 and WPS rom SAS

see version two of R and Python. This code is based
on version 1.0.


%utl_submit_pl64     PERL
%utl_submit_py64     PYTHON
%utl_submit_r64      R 64
%utl_submit_r32      R 32
%utl_submit_msr64    Microsoft muti-threaded mathpack R
%utl_submit_wps64    WPS 64


*____           _
|  _ \ ___ _ __| |
| |_) / _ \ '__| |
|  __/  __/ |  | |
|_|   \___|_|  |_|

;

*Running a perl program (macro below);

* create a spreadsheet;
libname xel "d:/xls/simple.xlsx";
data xel.simple;
  set sashelp.class;
run;quit;
libname xel clear;

* print cells A1 and A2 from an excel worksheet;
%utl_submit_pl64("
#!/usr/bin/perl
use strict;
use warnings;
use 5.14.0;
use Spreadsheet::Read qw(ReadData);
my $book = ReadData ('d:/xls/simple.xlsx');
say 'A1: ' . $book->[1]{A1};
say 'A2: ' . $book->[1]{A2};
");

* in output window;
A1: NAME
A2: Alfred

*____        _   _
|  _ \ _   _| |_| |__   ___  _ __
| |_) | | | | __| '_ \ / _ \| '_ \
|  __/| |_| | |_| | | | (_) | | | |
|_|    \__, |\__|_| |_|\___/|_| |_|
       |___/
;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.class;
  set sashelp.class;
run;quit;

%utl_submit_py64('
import numpy as np;
import pandas as pd;
from sas7bdat import SAS7BDAT;
with SAS7BDAT("d:/sd1/class.sas7bdat") as m:;
.   mdata = m.to_data_frame();
print(mdata);
');

       NAME SEX   AGE  HEIGHT  WEIGHT
0    Alfred   M  14.0    69.0   112.5
1     Alice   F  13.0    56.5    84.0
2   Barbara   F  13.0    65.3    98.0
3     Carol   F  14.0    62.8   102.5
4     Henry   M  14.0    63.5   102.5
5     James   M  12.0    57.3    83.0
6      Jane   F  12.0    59.8    84.5
7     Janet   F  15.0    62.5   112.5
8   Jeffrey   M  13.0    62.5    84.0
9      John   M  12.0    59.0    99.5
10    Joyce   F  11.0    51.3    50.5
11     Judy   F  14.0    64.3    90.0
12   Louise   F  12.0    56.3    77.0
13     Mary   F  15.0    66.5   112.0
14   Philip   M  16.0    72.0   150.0
15   Robert   M  12.0    64.8   128.0
16   Ronald   M  15.0    67.0   133.0
17   Thomas   M  11.0    57.5    85.0
18  William   M  15.0    66.5   112.0


*____
|  _ \
| |_) |
|  _ <
|_| \_\

;

%utl_submit_r64('
library(haven);
class<-read_sas("d:/sd1/class.sas7bdat");
class;
');

# A tibble: 19 × 5
      NAME   SEX   AGE HEIGHT WEIGHT
     <chr> <chr> <dbl>  <dbl>  <dbl>
1   Alfred     M    14   69.0  112.5
2    Alice     F    13   56.5   84.0
3  Barbara     F    13   65.3   98.0
4    Carol     F    14   62.8  102.5
5    Henry     M    14   63.5  102.5
6    James     M    12   57.3   83.0
7     Jane     F    12   59.8   84.5
8    Janet     F    15   62.5  112.5
9  Jeffrey     M    13   62.5   84.0
10    John     M    12   59.0   99.5
11   Joyce     F    11   51.3   50.5
12    Judy     F    14   64.3   90.0
13  Louise     F    12   56.3   77.0
14    Mary     F    15   66.5  112.0
15  Philip     M    16   72.0  150.0
16  Robert     M    12   64.8  128.0
17  Ronald     M    15   67.0  133.0
18  Thomas     M    11   57.5   85.0
19 William     M    15   66.5  112.0


*_        ______  ____     __   _  _
\ \      / /  _ \/ ___|   / /_ | || |
 \ \ /\ / /| |_) \___ \  | '_ \| || |_
  \ V  V / |  __/ ___) | | (_) |__   _|
   \_/\_/  |_|   |____/   \___/   |_|

;

* WPS express does not limit the number of rows returned to SAS;
* if you have one data set in work WOS will return a SAS dataset not a WPD dataset;
%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
class<-read_sas("d:/sd1/class.sas7bdat");
class<-class[class$SEX=="M",];
class;
endsubmit;
import r=class  data=wrk.classwps;
run;quit;
');

INSIDE R
# A tibble: 10 × 5
      NAME   SEX   AGE HEIGHT WEIGHT
     <chr> <chr> <dbl>  <dbl>  <dbl>
1   Alfred     M    14   69.0  112.5
2    Henry     M    14   63.5  102.5
3    James     M    12   57.3   83.0
4  Jeffrey     M    13   62.5   84.0
5     John     M    12   59.0   99.5
6   Philip     M    16   72.0  150.0
7   Robert     M    12   64.8  128.0
8   Ronald     M    15   67.0  133.0
9   Thomas     M    11   57.5   85.0
10 William     M    15   66.5  112.0

proc print data=classwps;
run;quit;

Returned to SAS;

Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

  1    Alfred      M      14     69.0      112.5
  2    Henry       M      14     63.5      102.5
  3    James       M      12     57.3       83.0
  4    Jeffrey     M      13     62.5       84.0
  5    John        M      12     59.0       99.5
  6    Philip      M      16     72.0      150.0
  7    Robert      M      12     64.8      128.0
  8    Ronald      M      15     67.0      133.0
  9    Thomas      M      11     57.5       85.0
 10    William     M      15     66.5      112.0





*____  _____ ____  _
|  _ \| ____|  _ \| |
| |_) |  _| | |_) | |
|  __/| |___|  _ <| |___
|_|   |_____|_| \_\_____|

;

* create a spreadsheet;
libname xel "d:/xls/simple.xlsx";
data xel.simple;
  set sashelp.class;
run;quit;
libname xel clear;

* read the sheet in PERL and output to SAS output window;
%macro utl_submit_pl64(pgm)/des="Semi colon separated set of py commands";
  * write the program to a temporary file;
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recfm=v;
  data _null_;
    length pgm  $32755 cmd $255;
    file py_pgm ;
    pgm=&pgm;
    semi=countc(pgm,';');
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,';'),';');
        put cmd $char96.;
        putlog cmd $char96.;
      end;
  run;
  run;quit;
  %let _loc=%sysfunc(pathname(py_pgm));
  %put &_loc;
  filename rut  pipe "perl -w &_loc > __log.txt";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
  run;quit;
  filename rut clear;
  filename py_pgm clear;
  data _null_;
    infile "__log.txt";
    input;
    put _infile_;
  run;quit;
%mend utl_submit_pl64;


%utl_submit_pl64("
#!/usr/bin/perl
use strict;
use warnings;
use 5.14.0;
use Spreadsheet::Read qw(ReadData);
my $book = ReadData ('d:/xls/simple.xlsx');
say 'A1: ' . $book->[1]{A1};
say 'A2: ' . $book->[1]{A2};
");

A1: NAME
A2: Alfred


*____        _   _
|  _ \ _   _| |_| |__   ___  _ __
| |_) | | | | __| '_ \ / _ \| '_ \
|  __/| |_| | |_| | | | (_) | | | |
|_|    \__, |\__|_| |_|\___/|_| |_|
       |___/
;

%macro utl_submit_py64(pgm)/des="Semi colon separated set of py commands";
  * write the program to a temporary file;
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recfm=v;
  data _null_;
    length pgm  $32755 cmd $255;
    file py_pgm ;
    pgm=&pgm;
    semi=countc(pgm,';');
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,';'));
        if cmd=:'.' then cmd=substr(cmd,2);
        put cmd $char96.;
        putlog cmd $char96.;
      end;
  run;

  run;quit;
  %let _loc=%sysfunc(pathname(py_pgm));
  %put &_loc;
  filename rut pipe  "C:\Python_27_64bit/python.exe &_loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
  run;
  filename rut clear;
  filename py_pgm clear;
%mend utl_submit_py64;

*____   __   _  _
|  _ \ / /_ | || |
| |_) | '_ \| || |_
|  _ <| (_) |__   _|
|_| \_\\___/   |_|

;

%macro utl_submit_R64(pgmx)/des="Semi colon separated set of R commands";
  * write the program to a temporary file;
  filename r_pgm temp lrecl=32766 recfm=v;
  data _null_;
    file r_pgm;
    pgm=&pgmx;
    put pgm;
    putlog pgm;
  run;
  %let __loc=%sysfunc(pathname(r_pgm));
  * pipe file through R;
  filename rut pipe "c:\Progra~1\R\R-3.3.2\bin\x64\R.exe --vanilla --quiet --no-save < &__loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;
%mend utl_submit_r64;


*____    _________
|  _ \  |___ /___ \
| |_) |   |_ \ __) |
|  _ <   ___) / __/
|_| \_\ |____/_____|

;

%macro utl_submit_R32(pgmx)/des="Semi colon separated set of R commands";
  * write the program to a temporary file;
  filename r_pgm temp lrecl=32766 recfm=v;
  data _null_;
    file r_pgm;
    pgm=&pgmx;
    put pgm;
    putlog pgm;
  run;
  %let __loc=%sysfunc(pathname(r_pgm));
  * pipe file through R;
  filename rut pipe "c:\Progra~1\R\R-3.3.2\bin\i386\R.exe --vanilla --quiet --no-save < &__loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;
%mend utl_submit_r32;

*__  __ ____    ____     __   _  _
|  \/  / ___|  |  _ \   / /_ | || |
| |\/| \___ \  | |_) | | '_ \| || |_
| |  | |___) | |  _ <  | (_) |__   _|
|_|  |_|____/  |_| \_\  \___/   |_|

;

%macro utl_submit_msr64(pgmx)/des="Semi colon separated set of R commands";
  * write the program to a temporary file;
  filename r_pgm temp lrecl=32766 recfm=v;
  data _null_;
    file r_pgm;
    pgm=&pgmx;
    put pgm;
    putlog pgm;
  run;
  %let __loc=%sysfunc(pathname(r_pgm));
  * pipe file through R;
  filename rut pipe "D:\exe\Microsoft\MRO-3.3.1\bin\x64\r.exe --vanilla --quiet --no-save < &__loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;
%mend utl_submit_msr64;

*_        ______  ____     __   _  _
\ \      / /  _ \/ ___|   / /_ | || |
 \ \ /\ / /| |_) \___ \  | '_ \| || |_
  \ V  V / |  __/ ___) | | (_) |__   _|
   \_/\_/  |_|   |____/   \___/   |_|

;

 %macro utl_submit_wps64(pgmx,resolve=Y)/des="submiit a single quoted sas program to wps";
  * write the program to a temporary file;

  %utlfkil(%sysfunc(pathname(work))/wps_pgmtmp.wps);
  %utlfkil(%sysfunc(pathname(work))/wps_pgm.wps);


  filename wps_pgm "%sysfunc(pathname(work))/wps_pgmtmp.wps" lrecl=32756 recfm=v;
  data _null_;
    length pgm  $32756 cmd $32756;
    file wps_pgm ;
    %if %upcase(%substr(&resolve,1,1))=Y %then %do;
       pgm=resolve(&pgmx);
    %end;
    %else %do;
      pgm=&pgmx;
    %end;
    semi=countc(pgm,';');
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,';'),';');
        len=length(strip(cmd));
        put cmd $varying32756. len;
        putlog cmd $varying32756. len;
      end;
  run;
  filename wps_fin "%sysfunc(pathname(work))/wps_pgm.wps" lrecl=255 recfm=v ;
  data _null_ ;
    length textin $ 32767 textout $ 255 ;
    * file "%sysfunc(pathname(work))/wps_pgmtmp.wps" lrecl=255 recfm=v ;
    file wps_fin;
    infile "%sysfunc(pathname(work))/wps_pgmtmp.wps" lrecl=32767 truncover;
    format textin $char32767.;
    input textin $char32767.;
    if lengthn( textin ) <= 255 then put textin ;
    else do while( lengthn( textin ) > 255 ) ;
       textout = reverse( substr( textin, 1, 255 )) ;
       ndx = index( textout, ' ' ) ;
       if ndx then do ;
          textout = reverse( substr( textout, ndx + 1 )) ;
          put textout $char255. ;
          textin = substr( textin, 255 - ndx + 1 ) ;
    end ;
    else do;
      textout = substr(textin,1,255);
      put textout $char255. ;
      textin = substr(textin,255+1);
    end;
    if lengthn( textin ) le 255 then put textin $char255. ;
    end ;
  run ;
  %let _loc=%sysfunc(pathname(wps_fin));
  %let _w=%sysfunc(compbl(C:/Progra~1/worldp~1/bin/wps.exe -autoexec c:\oto\Tut_Otowps.sas -config c:\cfg\wps.cfg));
  %put &_loc;
  filename rut pipe "&_w -sysin &_loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
  run;
  filename rut clear;
  filename wps_pgm clear;
  data _null_;
    infile "wps_pgm.lst";
    input;
    putlog _infile_;
  run;quit;
%mend utl_submit_wps64;



