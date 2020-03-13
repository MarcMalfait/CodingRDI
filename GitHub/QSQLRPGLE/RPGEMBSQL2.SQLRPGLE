000100200302     D xEMPLOYEE     E DS                  ExtName(EMPLOYEE)
000101200302     D xEMPHIST      E DS                  ExtName(EMPHIST)
000102200302     D currentKey      S              6S 0
000103200302     D ytdNet          S              9S 2
000104200302     D displayBytes    S             52A
000105200302     C                   eval      currentKey = 400
000106200302     C                   eval      ytdNet = *ZEROS
000107200302     C                   eval      displayBytes = 'Acct('
000108200302     C                             + %trim(%editc(currentKey:'3'))
000109200302     C                             + ')'
000110200302     C*// Run the Query
000111200302     C/EXEC SQL
000112200302     C+ select MCACCT,  MCFNAME,  MCLNAME,  sum(mhnet)
000113200302     C+        into :MCACCT, :MCFNAME, :MCLNAME, :ytdNet
000114200302     C+  from EMPLOYEE
000115200302     C+    join EMPHIST on MCACCT = MHACCT
000116200302     C+      where MCACCT = :currentKey
000117200302     C+  group by MCACCT, MCFNAME, MCLNAME
000118200302     C/END-EXEC
000119200302     C*// Display the Results
000120200302     C                   if        sqlState = *ZEROS
000121200302     C                   eval      displayBytes = %trim(displayBytes)
000122200302     C                                  + ' ' + %trim(MCLNAME)
000123200302     C                                  + ', ' + %trim(MCFNAME)
000124200302     C                                  + ' Net: '
000125200302     C                                  + %trim(%editc(ytdNet: '1'))
000126200302     C                   else
000127200302     C                   eval      displayBytes = %trim(displayBytes)
000128200302     C                                  + ': ' + ' NOT FOUND!'
000129200302     C                   endif
000130200302     C     displayBytes  dsply
000131200302     C                   eval      *inlr = *ON
