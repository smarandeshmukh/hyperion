module type_grid_cell

  use type_grid

  implicit none
  private

  public :: preset_cell_id

  public :: grid_cell
  type grid_cell
     integer :: ic         ! unique cell ID
     integer :: ilevel     ! level ID
     integer :: ifab       ! grid ID
     integer :: i1, i2, i3 ! position in grid
  end type grid_cell

  type(grid_cell),parameter,public :: invalid_cell = grid_cell(-1, -1, -1, -1, -1, -1)
  type(grid_cell),parameter,public :: outside_cell = grid_cell(-2, -2, -2, -2, -2, -2)

  public :: operator(.eq.)
  interface operator(.eq.)
     module procedure equal
  end interface operator(.eq.)

  public :: new_grid_cell
  interface new_grid_cell
     module procedure new_grid_cell_1d
     module procedure new_grid_cell_5d
  end interface new_grid_cell

  ! level, fab, and coordinates for each unique ID
  integer,allocatable :: cell_ilevel(:), cell_ifab(:), cell_i1(:), cell_i2(:), cell_i3(:)

contains

  subroutine preset_cell_id(geo)

    implicit none

    type(grid_geometry_desc),intent(in), target :: geo
    type(level_desc), pointer :: level
    type(fab_desc), pointer :: fab
    integer :: ic, i1, i2, i3, ilevel, ifab

    allocate(cell_ilevel(geo%n_cells))
    allocate(cell_ifab(geo%n_cells))
    allocate(cell_i1(geo%n_cells))
    allocate(cell_i2(geo%n_cells))
    allocate(cell_i3(geo%n_cells))

    ic = 0
    do ilevel=1,size(geo%levels)
       level => geo%levels(ilevel)
       do ifab=1,size(level%fabs)
          fab => level%fabs(ifab)
          do i3=1,fab%n3
             do i2=1,fab%n2
                do i1=1,fab%n1
                   ic = ic + 1
                   cell_ilevel(ic) = ilevel
                   cell_ifab(ic) = ifab
                   cell_i1(ic) = i1
                   cell_i2(ic) = i2
                   cell_i3(ic) = i3
                end do
             end do
          end do
       end do
    end do

  end subroutine preset_cell_id

  logical function equal(a,b)
    implicit none
    type(grid_cell), intent(in) :: a,b
    equal = a%ic == b%ic
  end function equal

  type(grid_cell) function new_grid_cell_5d(i1, i2, i3, ilevel, ifab, geo) result(cell)
    implicit none
    integer,intent(in) :: i1, i2, i3, ilevel, ifab
    type(grid_geometry_desc),intent(in), target :: geo
    type(fab_desc),pointer :: fab
    fab => geo%levels(ilevel)%fabs(ifab)
    cell%ic = (fab%start_id-1) + (i3-1)*fab%n1*fab%n2 + (i2-1)*fab%n1 + i1
    cell%ilevel = ilevel
    cell%ifab = ifab
    cell%i1 = i1
    cell%i2 = i2
    cell%i3 = i3
  end function new_grid_cell_5d

  type(grid_cell) function new_grid_cell_1d(ic, geo) result(cell)
    implicit none
    integer,intent(in) :: ic
    type(grid_geometry_desc),intent(in) :: geo
    cell%ic = ic
    cell%ilevel = cell_ilevel(ic)
    cell%ifab = cell_ifab(ic)
    cell%i1 = cell_i1(ic)
    cell%i2 = cell_i2(ic)
    cell%i3 = cell_i3(ic)
  end function new_grid_cell_1d

end module type_grid_cell
