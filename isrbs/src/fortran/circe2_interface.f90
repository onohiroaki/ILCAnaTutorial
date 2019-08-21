!
! Interface to call circe2 from c++/fortran77
!

module circe2_interface

   use kinds
   use circe2
   use tao_random_objects
   implicit none

   type(circe2_state), save :: c2s
   type(rng_tao), save :: rng

   public :: setseed

contains 
   subroutine load( filename, design, roots, ierror )

   character(*), intent(in) :: filename
   character(*), intent(in) :: design
   real(kind=default), intent(in) :: roots
   integer, intent(out) :: ierror

   print *,' len inputfilename is ',len(filename)
   print *,' input filename is ',filename,'==='
   print *,' filenameA=',trim(filename),'==='
   print *,' designA=',design,'==='
   print *,' rootsA=',roots,'==='
   call circe2_load( c2s, filename, design, roots, ierror)
   print *,' ierror=',ierror

   end subroutine load

   subroutine setseed(seed)
      integer, intent(in) :: seed
      integer :: seed_value
      
      seed_value = seed
      call rng%init(seed_value) 
      
   end subroutine setseed


   subroutine generate(x)
      real(kind=default), dimension(2), intent(out) :: x

      call circe2_generate( c2s, rng, x, [11, -11], [0, 0] )

   end subroutine generate

end module circe2_interface


subroutine circe2_generate( x )
   use kinds
   use circe2_interface
   implicit none
   real(kind=default), dimension(2), intent(out) :: x
   
   call generate(x)   

end subroutine circe2_generate


subroutine circe2_setfile(filename, design, roots, ierror)
   use kinds
   use circe2_interface
   implicit none
   character(*), intent(in) :: filename
   character(*), intent(in) :: design
   real(kind=default), intent(in) :: roots
   integer, intent(out) :: ierror

   call load( filename, design, roots, ierror)

end subroutine circe2_setfile

subroutine circe2_setseed(seed)
    use circe2_interface
    implicit none
    integer seed
    
    call setseed(seed)

end subroutine circe2_setseed

