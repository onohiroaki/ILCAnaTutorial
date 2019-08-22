      program circe2_print_spectrum_f77
      implicit none
      integer p1, h1, p2, h2, n, nevent, ierror
      character*128 circe2_file
      double precision x1, x2, x(2)
      double precision rng
      integer iseed
c      external random
      nevent = 20
      ierror = 1
      circe2_file = "250-TDR_ws-ee.circe2"
      call circe2_setfile ("250-TDR_ws-ee.circe2",
     & "ILC", 250.0D0, ierror)
      print *," ierror=",ierror
      if (ierror .lt. 0) stop

c
c initialize seed
      iseed = 12345
      call circe2_setseed(iseed)

c generate events
      do 10 n = 1, nevent
        call circe2_genbeam (x)
        write (*, '(F12.10,1X,F12.10)') x
   10 continue
      stop
      end
