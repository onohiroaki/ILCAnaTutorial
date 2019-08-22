!
! Interface to call circe2 from c++/fortran77
!

module circe2_interface_data
   use circe2
   use tao_random_objects
   type(circe2_state) ::c2s
   type(rng_tao) :: rng
end module circe2_interface_data


subroutine circe2_genbeam( x )
   use kinds
   use circe2   
   use circe2_interface_data
   implicit none
   real(kind=default), dimension(2), intent(out) :: x

   call circe2_generate( c2s, rng, x, [11, -11], [0, 0] )

end subroutine circe2_genbeam


subroutine circe2_setfile(filename, design, roots, ierror)
   use kinds
   use circe2
   use circe2_interface_data
   implicit none
   character(*), intent(in) :: filename
   character(*), intent(in) :: design
   real(kind=default), intent(in) :: roots
   integer, intent(out) :: ierror

   print *,'Initializing circe2'
   print *,'  circe2 file=',filename
   print *,'  design=',design
   print *,'  roots=',roots
   call circe2_load( c2s, filename, design, roots, ierror)
   ! print *,' ierror=',ierror

end subroutine circe2_setfile

subroutine circe2_setseed(seed)
   use kinds
   use circe2
   use circe2_interface_data
   implicit none
   integer, intent(in) :: seed
   integer :: seed_value

   seed_value = seed
   call rng%init(seed_value)

end subroutine circe2_setseed

