000100200302     D xEMPLOYEE     E DS                  ExtName(EMPLOYEE)
000101200302     D xEMPHIST      E DS                  ExtName(EMPHIST)
000102200302     D currentKey      S              6S 0
000103200302     D ytdNet          S              9S 2
000104200302     D displayBytes    S             52A
000105200302      /free
000106200302       currentKey = 400;
000107200302       ytdNet = *ZEROS;
000108200302       displayBytes = 'Acct('
000109200302                    + %trim(%editc(currentKey: '3')) + ')';
000110200302       // Run the Query
000111200302       exec sql select MCACCT,  MCFNAME,  MCLNAME,  sum(mhnet)
000112200302                 into :MCACCT, :MCFNAME, :MCLNAME, :ytdNet
000113200302         from EMPLOYEE
000114200302           join EMPHIST on MCACCT = MHACCT
000115200302             where MCACCT = :currentKey
000116200302         group by MCACCT, MCFNAME, MCLNAME;
000117200302       // Display the Results
000118200302       if sqlState = *ZEROS;
000119200302         displayBytes = %trim(displayBytes) + ' '
000120200302                      + %trim(MCLNAME) + ', '
000121200302                      + %trim(MCFNAME)
000122200302                      + ' Net: ' + %trim(%editc(ytdNet: '1'));
000123200302       else;
000124200302         displayBytes = %trim(displayBytes) + ': '
000125200302                      + ' NOT FOUND!';
000126200302       endif;
000127200302       dsply displayBytes;
000128200302       *inlr = *ON;
