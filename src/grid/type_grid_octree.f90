module type_grid

  use core_lib

  implicit none
  save

  private

  ! Define refinable cell
  type cell
     real(8) :: x,y,z
     real(8) :: dx,dy,dz
     logical :: refined = .false.
     integer,allocatable,dimension(:) :: children
     integer :: parent, parent_subcell
  end type cell

  ! Define Octree descriptor
  public :: grid_geometry_desc
  type grid_geometry_desc
     character(len=32) :: id
     integer :: n_cells, n_dim, n1=0, n2=0, n3=0
     type(cell),allocatable,dimension(:) :: cells
     real(dp), allocatable :: volume(:)
     real(dp), allocatable :: area(:, :)
     real(dp), allocatable :: width(:, :)
     character(len=10) :: type
     real(dp) :: xmin, xmax, ymin, ymax, zmin, zmax
  end type grid_geometry_desc

end module type_grid

