      subroutine subtest(msg)
      character*(*) msg

      print *,msg(1:5)
      print *,' lenmsg =',len(msg)
      print *,msg

      return 
      end
