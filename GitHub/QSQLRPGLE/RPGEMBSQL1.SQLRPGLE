000100200302     FEMPLOYEE  IF   E           K DISK
000101200302     FEMPHIST   IF   E           K DISK
000102200302     F*
000103200302     D xEMPLOYEE     E DS                  ExtName(EMPLOYEE)
000104200302     D xEMPHIST      E DS                  ExtName(EMPHIST)
000105200302     D currentKey      S              6S 0
000106200302     D ytdNet          S              9S 2
000107200302     D displayBytes    S             52A
000108200302      /free
000109200302       currentKey = 400;
000110200302       ytdNet = *ZEROS;
000111200302       chain currentKey EMPLOYEE;
000112200302       displayBytes = 'Acct('
000113200302                    + %trim(%editc(currentKey: '3')) + ')';
000114200302       if %found();
000115200302         chain currentKey EMPHIST;
000116200302         dou %eof();
000117200302           ytdNet = ytdNet + MHNET;
000118200302           reade currentKey EMPHIST;
000119200302         enddo;
000120200302         displayBytes = %trim(displayBytes) + ' '
000121200302                      + %trim(MCLNAME) + ', '
000122200302                      + %trim(MCFNAME)
000123200302                      + ' Net: ' + %trim(%editc(ytdNet: '1'));
000124200302       else;
000125200302         displayBytes = %trim(displayBytes) + ': '
000126200302                      + ' NOT FOUND!';
000127200302       endif;
000128200302       // Display the Results
000129200302       dsply displayBytes;
000130200302       *inlr = *ON;
