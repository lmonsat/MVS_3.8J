//MVS03    JOB (1),'SETUP TSO APPS',CLASS=S,MSGLEVEL=(1,1),             
//             MSGCLASS=X                                               
//*                                                                     
//* ----------------------------------------------------------------- * 
//* This job sets up TSO application programs: QUEUE, RPF (v200),     * 
//* REVIEW (v51.6), DATE. [updated March, 2025]                       * 
//* ----------------------------------------------------------------- * 
//*                                                                     
//STEP01   EXEC PGM=IDCAMS,REGION=1M                                    
//* ----------------------------------------------------------------- * 
//* Define RPF Alias in Master Catalog                                * 
//* ----------------------------------------------------------------- * 
//SYSPRINT DD   SYSOUT=*                                                
//SYSIN    DD   *                                                       
                                                                        
  DEFINE ALIAS(NAME(RPF) RELATE(UCPUB000))             -                
         CATALOG(SYS1.VSAM.MASTER.CATALOG/SYSPROG)                      
//*                                                                     
//STEP02   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore RPF v200 LOADLIB from tape.                               * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPF200MV.XMI,              
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(1,SL)             
//SYSUT2   DD  DSN=RPF.V200.LOADLIB,                                    
//             VOL=SER=PUB000,UNIT=SYSDA,                               
//             SPACE=(TRK,(15,,10),RLSE),                               
//             DISP=(,CATLG,DELETE)                                     
//*                                                                     
//STEP03   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore RPF v200 HELP from tape.                                  * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPF200HE.XMI,              
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(2,SL)             
//SYSUT2   DD  DSN=RPF.V200.HELP,                                       
//             VOL=SER=PUB000,UNIT=SYSDA,                               
//             SPACE=(TRK,(15,,5),RLSE),                                
//             DISP=(,CATLG,DELETE)                                     
//*                                                                     
//STEP04   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore RPF v200 JCL from tape.                                   * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPF200JC.XMI,              
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(3,SL)             
//SYSUT2   DD  DSN=RPF.V200.JCL,                                        
//             VOL=SER=PUB000,UNIT=SYSDA,                               
//             SPACE=(TRK,(15,,5),RLSE),                                
//             DISP=(,CATLG,DELETE)                                     
//*                                                                     
//STEP05   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore RPF v200 SOURCE from tape.                                * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPF200AS.XMI,              
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(4,SL)             
//SYSUT2   DD  DSN=RPF.V200.SOURCE,                                     
//             VOL=SER=PUB000,UNIT=SYSDA,                               
//             SPACE=(TRK,(120,,12),RLSE),                              
//             DISP=(,CATLG,DELETE)                                     
//*                                                                     
//STEP06   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore RPF v200 Panel Library from tape.                         * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPF200PN.XMI,              
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(5,SL)             
//SYSUT2   DD  DSN=RPF.V200.PANELS,                                     
//             VOL=SER=PUB000,UNIT=SYSDA,                               
//             SPACE=(TRK,(15,,5),RLSE),                                
//             DISP=(,CATLG,DELETE)                                     
//*                                                                     
//STEP07   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore RPF v200 Macro Library from tape.                         * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=RPF200S1.XMI,              
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(6,SL)             
//SYSUT2   DD  DSN=RPF.V200.MACLIB,                                     
//             VOL=SER=PUB000,UNIT=SYSDA,                               
//             SPACE=(TRK,(5,,1),RLSE),                                 
//             DISP=(,CATLG,DELETE)                                     
//*                                                                     
//STEP08  EXEC PGM=IEBCOPY                                              
//* ----------------------------------------------------------------- * 
//* Copy RPF v200 load modules to SYS2.CMDLIB  and                    * 
//* Copy RPF v200 help modules to SYS2.HELP.                          * 
//* ----------------------------------------------------------------- * 
//LOAD     DD  DISP=SHR,DSN=RPF.V200.LOADLIB                            
//CMDLIB   DD  DISP=SHR,DSN=SYS2.CMDLIB                                 
//HELPIN   DD  DISP=SHR,DSN=RPF.V200.HELP                               
//HELPOUT  DD  DISP=SHR,DSN=SYS2.HELP                                   
//SYSPRINT DD  SYSOUT=*                                                 
//SYSIN    DD  *                                                        
  COPY INDD=((LOAD,R)),OUTDD=CMDLIB                                     
  COPY INDD=((HELPIN,R)),OUTDD=HELPOUT                                  
  S M=(RPF,RPFV,RPFED,RPFHELP1,RPFHELP2,RPFHELP3,RPFHELP4,RPFHELP5)     
//*                                                                     
//STEP09   EXEC PGM=PDSLOAD,PARM=NEW                                    
//* ----------------------------------------------------------------- * 
//* Restore QUEUE.ASM source from tape.                               * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//SYSPRINT DD  SYSOUT=*                                                 
//SYSUT2   DD  DISP=(,CATLG),DSN=PUB001.QUEUE.ASM,                      
//             UNIT=SYSDA,VOL=SER=PUB001,SPACE=(CYL,(10,5,20),RLSE),    
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=27920)                    
//OBJECT   DD  DISP=(,CATLG),DSN=PUB001.QUEUE.OBJ,                      
//             VOL=SER=PUB001,                                          
//             UNIT=SYSDA,SPACE=(CYL,(1,1,20)),                         
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)                     
//SYSIN    DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=QUEUE.OFFLOAD,             
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(7,SL)             
//*                                                                     
//STEP10   EXEC PGM=IEBGENER                                            
//* ----------------------------------------------------------------- * 
//* Submit job from QUEUE.ASM(C) to assemble/link QUEUE.              * 
//* ----------------------------------------------------------------- * 
//SYSIN    DD  DUMMY                                                    
//SYSPRINT DD  DUMMY                                                    
//SYSUT1   DD  DISP=SHR,DSN=PUB001.QUEUE.ASM(C)                         
//SYSUT2   DD  SYSOUT=(A,INTRDR)                                        
//*                                                                     
//STEP11   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore Review v51.6 load modules from tape.                      * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=REV370LD.XMI,              
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(8,SL)             
//SYSUT2   DD  DSN=&&REVLD,DISP=(,PASS),                                
//             UNIT=SYSDA,SPACE=(TRK,(60,15))                           
//*                                                                     
//STEP12   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore Review v51.6 help from tape.                              * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=REVHELP.XMI,               
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(9,SL)             
//SYSUT2   DD  DSN=&&REVHE,DISP=(,PASS),                                
//             UNIT=SYSDA,SPACE=(TRK,(60,15))                           
//*                                                                     
//STEP13   EXEC RECV370                                                 
//* ----------------------------------------------------------------- * 
//* Restore Review v51.6 command lists from tape.                     * 
//* ----------------------------------------------------------------- * 
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR                                
//XMITIN   DD  UNIT=TAPE,DISP=(OLD,KEEP),DSN=REVCLIST.XMI,              
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(10,SL)            
//SYSUT2   DD  DSN=&&REVCL,DISP=(,PASS),                                
//             UNIT=SYSDA,SPACE=(TRK,(60,15))                           
//*                                                                     
//STEP14   EXEC PGM=IEBCOPY,REGION=1024K                                
//* ----------------------------------------------------------------- * 
//* Copy Review v51.6 load modules to SYS2.CMDLIB                     * 
//* ----------------------------------------------------------------- * 
//SYSPRINT  DD SYSOUT=*                                                 
//LIBIN     DD DSN=&&REVLD,DISP=(OLD,PASS)                              
//LIBOUT    DD DSN=SYS2.CMDLIB,DISP=SHR                                 
//SYSUT3    DD UNIT=SYSDA,SPACE=(80,(60,45)),DISP=(,DELETE)             
//SYSIN     DD *                                                        
  COPY INDD=((LIBIN,R)),OUTDD=LIBOUT                                    
//*                                                                     
//STEP15   EXEC PGM=IEBCOPY,REGION=1024K                                
//* ----------------------------------------------------------------- * 
//* Copy Review v51.6 help members to SYS2.HELP                       * 
//* ----------------------------------------------------------------- * 
//SYSPRINT  DD SYSOUT=*                                                 
//LIBIN     DD DSN=&&REVHE,DISP=(OLD,PASS)                              
//LIBOUT    DD DSN=SYS2.HELP,DISP=SHR                                   
//SYSUT3    DD UNIT=SYSDA,SPACE=(80,(60,45)),DISP=(,DELETE)             
//SYSIN     DD *                                                        
  COPY INDD=((LIBIN,R)),OUTDD=LIBOUT                                    
//*                                                                     
//STEP16   EXEC PGM=IEBCOPY,REGION=1024K                                
//* ----------------------------------------------------------------- * 
//* Copy Review v51.6 command lists to SYS1.CMDPROC.                  * 
//* ----------------------------------------------------------------- * 
//SYSPRINT  DD SYSOUT=*                                                 
//LIBIN     DD DSN=&&REVCL,DISP=(OLD,PASS)                              
//LIBOUT    DD DSN=SYS1.CMDPROC,DISP=SHR                                
//SYSUT3    DD UNIT=SYSDA,SPACE=(80,(60,45)),DISP=(,DELETE)             
//SYSIN     DD *                                                        
  COPY INDD=((LIBIN,R)),OUTDD=LIBOUT                                    
//*                                                                     
//STEP17   EXEC PGM=IKJEFT01,REGION=1024K,DYNAMNBR=50                   
//* ----------------------------------------------------------------- * 
//* The REVINIT CLIST allocates, during TSO LOGON, a profile dataset  * 
//* which is shared by Greg Price's REVIEW, Rob Prins' RPF, and Wally * 
//* McLaughlin's ISPF. If the dataset does not exist for the user,    * 
//* REVINIT will create it.  As shipped, the REVINIT CLIST is lacking * 
//* a VOLUME parameter, so that the dataset would be allocated on a   * 
//* volume selected by MVS. This step simply modifies the REVINIT     * 
//* CLIST in SYS1.CMDPROC to add a VOLUME parameter when the profile  * 
//* dataset is initially created. This change will not take effect    * 
//* until the TSO user logs on the first time after this job is run.  * 
//* ----------------------------------------------------------------- * 
//SYSPRINT DD  SYSOUT=*                                                 
//SYSTSPRT DD  SYSOUT=*                                                 
//SYSTERM  DD  SYSOUT=*                                                 
//SYSTSIN  DD  *                                                        
EDIT 'SYS1.CMDPROC(REVINIT)' CNTL NONUM                                 
LIST                                                                    
TOP                                                                     
F =ALLOC F(ISPPROF) DA('&PROFDSN') NEW =                                
C * =CYL =+   =                                                         
INSERT       CYL VOLUME(PUB000)                                         
LIST                                                                    
END SAVE                                                                
/*                                                                      
//*                                                                     
//STEP18   EXEC ASMFCL,PARM.ASM='LIST,RENT,OBJ,NODECK',                 
//* ----------------------------------------------------------------- * 
//* Assemble/link DATE command from source to SYS2.CMDLIB.            * 
//* ----------------------------------------------------------------- * 
//             PARM.LKED='LIST,RENT,XREF'                               
//ASM.SYSIN DD UNIT=TAPE,DISP=(OLD,KEEP),DSN=DATE.SOURCE,               
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(11,SL)            
//LKED.SYSLMOD DD DSN=SYS2.CMDLIB,DISP=SHR                              
//LKED.SYSLIB DD DSN=SYSC.LINKLIB,DISP=SHR                              
//LKED.SYSIN  DD *                                                      
  NAME DATE(R)                                                          
//*                                                                     
//STEP19   EXEC PGM=IEBGENER,PARM=NEW                                   
//* ----------------------------------------------------------------- * 
//* Copy DATE help to SYS2.HELP.                                      * 
//* ----------------------------------------------------------------- * 
//SYSIN     DD DUMMY                                                    
//SYSPRINT  DD DUMMY                                                    
//SYSUT1    DD UNIT=TAPE,DISP=(OLD,KEEP),DSN=DATE.HELP,                 
//             VOL=(PRIVATE,RETAIN,SER=TSOAPS),LABEL=(12,SL)            
//SYSUT2    DD DISP=SHR,DSN=SYS2.HELP(DATE)                             
//                                                                      
