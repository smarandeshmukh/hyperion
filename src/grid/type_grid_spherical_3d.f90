module type_grid

  use core_lib

  implicit none
  save

  private

  public :: grid_geometry_desc
  type grid_geometry_desc
     character(len=32) :: id
     integer :: n_cells, n_dim, n1, n2, n3
     real(dp), allocatable :: volume(:)
     real(dp), allocatable :: area(:, :)
     real(dp), allocatable :: width(:, :)
     real(dp), allocatable :: w1(:), w2(:), w3(:)
     real(dp), allocatable :: wr2(:), wcost(:), wsint(:), wtant(:), wtant2(:), wtanp(:)
     integer :: midplane = -1
     character(len=10) :: type
  end type grid_geometry_desc

end module type_grid
