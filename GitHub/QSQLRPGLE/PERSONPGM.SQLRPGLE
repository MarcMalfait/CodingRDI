000001200303**free
000002200303ctl-opt main(Main)
000003200303          option(*nodebugio:*srcstmt:*nounref)
000004200303          dftactgrp(*no) ;
000005200303
000006200303// dcl-f DSPFILE workstn indds(Dspf)
000007200303dcl-f PERSONDSPF workstn indds(Dspf)
000008200303                sfile(SFL01:ZRRN) usropn ;
000009200303
000010200303dcl-ds Dspf qualified ;
000011200303  Exit ind pos(3) ;
000012200303  Reload ind pos(5) ;
000013200303  PageDown ind pos(25) ;
000014200303  PageUp ind pos(26) ;
000015200303
000016200303  SflInds char(4) pos(30) ;
000017200303    SflDspCtl ind pos(30) ;
000018200303    SflDsp ind pos(31) ;
000019200303    SflEnd ind pos(32) ;
000020200303    SflClr ind pos(33) ;
000021200303end-ds ;
000022200303
000023200303dcl-ds Data qualified dim(32766) ;
000024200303  Last char(30) ;
000025200303  First char(25) ;
000026200303  Name char(40) ;
000027200303end-ds ;
000028200303
000029200303dcl-c lowerCase 'abcdefghijklmnopqrstuvwxyz';
000030200303dcl-c upperCase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
000032200303
000033200303dcl-s DataLookup char(30) dim(%elem(Data)) ascend ;
000034200303dcl-s PosTrim like(ZPOSITION);
000035200303
000036200303dcl-s SflSize like(ZRRN) inz(10) ;
000037200303dcl-s LastRecord packed(8) ;
000038200303dcl-s Pos packed(8) ;
000039200303dcl-s SavedPosition like(ZPOSITION) ;
000040200303
000041200303dcl-proc Main ;
000042200303  exec sql SET OPTION CLOSQLCSR = *ENDMOD ;
000043200303
000044200303  open PERSONDSPF ;
000045200303  GetData() ;
000046200303  SubfileDown() ;
000047200303
000048200303  dow (1 = 1) ;
000049200303    write FOOT01 ;
000050200303    exfmt CTL01 ;
000051200303
000052200303    if (Dspf.Exit) ;
000053200303      leave ;
000054200303    elseif (Dspf.Reload) ;
000055200303      GetData() ;
000056200303      SubfileDown() ;
000057200303    elseif (Dspf.PageDown) ;
000058200303      if not(Dspf.SflEnd) ;
000059200303        SubfileDown() ;
000060200303      endif ;
000061200303    elseif (Dspf.PageUp) ;
000062200303      SubfileUp() ;
000063200303    elseif (ZPOSITION <> SavedPosition) ;
000064200303      Position() ;
000065200303    endif ;
000066200303  enddo ;
000067200303
000068200303  on-exit ;
000069200303    close *all ;
000070200303end-proc ;
000071200303dcl-proc GetData ;
000072200303  dcl-s Elements packed(8) inz(%elem(Data)) ;
000073200303
000074200303  exec sql DECLARE C0 CURSOR FOR
000075200303           SELECT LASTNAME,FIRSTNAME,
000076200303                  RTRIM(LASTNAME) || ', ' || FIRSTNAME
000077200303             FROM PERSONP
000078200303            ORDER BY LASTNAME,FIRSTNAME
000079200303              FOR READ ONLY ;
000080200303
000081200303  exec sql OPEN C0 ;
000082200303
000083200303  exec sql FETCH C0 FOR :Elements ROWS INTO :Data ;
000084200303  exec sql GET DIAGNOSTICS :LastRecord = ROW_COUNT ;
000085200303
000086200303  exec sql CLOSE C0 ;
000087200303
000088200303  DataLookup(*) = Data(*) ;
000089200303  Pos = 0 ;
000090200303  ZPOSITION = ' ' ;
000091200303  SavedPosition = ' ' ;
000092200303end-proc ;
000093200303dcl-proc SubfileDown ;
000094200303  LoadSubfile() ;
000095200303end-proc ;
000096200303dcl-proc SubfileUp ;
000097200303  Pos -= (SflSize + (ZRRN - 1)) ;
000098200303  LoadSubfile() ;
000099200303end-proc ;
000100200303dcl-proc LoadSubfile ;
000101200303  Dspf.SflInds = '0001' ;
000102200303  write CTL01 ;
000103200303  Dspf.SflInds = '1000' ;
000104200303
000105200303  if (Pos < 1) ;
000106200303    Pos = 1 ;
000107200303  elseif (Pos > LastRecord) ;
000108200303    Pos = LastRecord ;
000109200303  endif ;
000110200303
000111200303  for ZRRN = 1 to SflSize ;
000112200303    NAME = Data(Pos).Name ;
000113200303    LASTNAME = Data(Pos).Last ;
000114200303    FIRSTNAME = Data(Pos).First ;
000115200303    ARRAYELEM = Pos ;
000116200303    write SFL01 ;
000117200303
000118200303    if (Pos = LastRecord) ;
000119200303      leave ;
000120200303    else ;
000121200303      Pos += 1 ;
000122200303    endif ;
000123200303  endfor ;
000124200303
000125200303  if (ZRRN > 0) ;
000126200303    Dspf.SflDsp = *on ;
000127200303  endif ;
000128200303
000129200303  if (ARRAYELEM = LastRecord) ;
000130200303    Dspf.SflEnd = *on ;
000131200303  endif ;
000132200303end-proc ;
000133200303 dcl-proc Position ;
000134200303   PosTrim = %TRIM(ZPOSITION);
000135200303   PosTrim = %ScanRpl(' ':'':PosTrim) ;
000136200303   PosTrim = %xlate(uppercase:lowercase:PosTrim:2);
000137200303   Pos = %lookupge(PosTrim:DataLookup:1:LastRecord);
000138200303   LoadSubfile() ;
000139200303   SavedPosition = ZPOSITION ;
000140200303end-proc ;
