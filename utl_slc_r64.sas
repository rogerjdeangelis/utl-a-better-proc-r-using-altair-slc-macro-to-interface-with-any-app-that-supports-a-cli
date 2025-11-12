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
