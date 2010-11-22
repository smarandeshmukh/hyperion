module grid_generic

  use core_lib
  use grid_io
  use grid_geometry, only : geo
  use grid_physics
  use dust_main
  use settings

  implicit none
  save

contains

  subroutine adjust_energy_grid(scale)
    implicit none
    real(dp),intent(in) :: scale
    integer :: id
    if(allocated(specific_energy_abs)) then
       do id=1,n_dust
          specific_energy_abs(:,id) = specific_energy_abs(:,id) * scale / geo%volume
       end do
    end if
  end subroutine adjust_energy_grid

  subroutine grid_reset_energy()
    implicit none
    if(allocated(n_photons)) n_photons = 0
    if(allocated(last_photon_id)) last_photon_id = 0
    if(allocated(specific_energy_abs)) specific_energy_abs = 0._dp
  end subroutine grid_reset_energy

  subroutine output_grid(handle, iter, n_iter)

    implicit none

    integer(hid_t),intent(in) :: handle
    integer,intent(in) :: iter, n_iter
    character(len=100) :: group_name
    integer(hid_t) :: group

    call message(1,'[output_grid] outputting grid arrays for iteration')

    write(group_name, '("Iteration ",I5.5)') iter
    group = hdf5_create_group(handle, group_name)

    ! NUMBER OF PHOTONS IN EACH CELL

    if(trim(output_n_photons)=='all' .or. (trim(output_n_photons)=='last'.and.iter==n_iter)) then
       if(allocated(n_photons)) then
          call write_grid_3d(group, 'n_photons', n_photons, geo)
       else
          call warn("output_grid","n_photons array is not allocated")
       end if
    end if

    ! TEMPERATURE

    if(trim(output_temperature)=='all' .or. (trim(output_temperature)=='last'.and.iter==n_iter)) then
       if(allocated(temperature)) then
          select case(physics_io_type)
          case(sp)  
             call write_grid_4d(group, 'temperature', real(temperature, sp), geo)
          case(dp)
             call write_grid_4d(group, 'temperature', real(temperature, dp), geo)
          case default
             call error("output_grid","unexpected value of physics_io_type (should be sp or dp)")
          end select
       else
          call warn("output_grid","temperature array is not allocated")
       end if
    end if

    ! ENERGY/PATH LENGTHS

    if(trim(output_specific_energy_abs)=='all' .or. (trim(output_specific_energy_abs)=='last'.and.iter==n_iter)) then
       if(allocated(specific_energy_abs)) then
          select case(physics_io_type)
          case(sp)  
             call write_grid_4d(group, 'specific_energy_abs', real(specific_energy_abs, sp), geo)
          case(dp)
             call write_grid_4d(group, 'specific_energy_abs', real(specific_energy_abs, dp), geo)
          case default
             call error("output_grid","unexpected value of physics_io_type (should be sp or dp)")
          end select
       else
          call warn("output_grid","specific_energy_abs array is not allocated")
       end if
    end if

    ! DENSITY

    if(trim(output_density)=='all' .or. (trim(output_density)=='last'.and.iter==n_iter)) then
       if((dust_sublimation_mode == 1 .or. dust_sublimation_mode == 2) .and. allocated(density)) then
          select case(physics_io_type)
          case(sp)  
             call write_grid_4d(group, 'density', real(density, sp), geo)
          case(dp)
             call write_grid_4d(group, 'density', real(density, dp), geo)
          case default
             call error("output_grid","unexpected value of physics_io_type (should be sp or dp)")
          end select
       else
          call warn("output_grid","density array is not allocated")
       end if
    end if

  end subroutine output_grid

end module grid_generic
