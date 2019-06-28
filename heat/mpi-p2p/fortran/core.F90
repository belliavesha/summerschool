! Main solver routines for heat equation solver
module core
  use heat

contains

  ! Exchange the boundary data between MPI tasks
  subroutine exchange(field0, parallel)
    use mpi_f08

    implicit none

    type(field), intent(inout) :: field0
    type(parallel_data), intent(in) :: parallel

    integer :: ierr

    integer ny,nx,stat 
    
    print*, MPI_COMM_WORLD

    nx = field0%nx
    ny = field0%ny

    ! TODO start: implement halo exchange
    ! Send to left, receive from right

    ! call MPI_send()
    call MPI_Sendrecv(field0%data(:,ny),nx+2,MPI_double_precision,parallel%nright,1,&
                      field0%data(:,0), nx+2,MPI_double_precision,parallel%rank,  1,&
                      MPI_COMM_WORLD,MPI_STATUS_IGNORE,ierr)
    call MPI_Sendrecv(field0%data(:,1),    nx+2,MPI_double_precision,parallel%nleft,2,&
                      field0%data(:,ny+1), nx+2,MPI_double_precision,parallel%rank, 2,&
                      MPI_COMM_WORLD,MPI_STATUS_IGNORE)
    ! Send to right, receive from left
    ! TODO end
    ! Send to left, receive from right


  end subroutine exchange

  ! Compute one time step of temperature evolution
  ! Arguments:
  !   curr (type(field)): current temperature values
  !   prev (type(field)): values from previous time step
  !   a (real(dp)): update equation constant
  !   dt (real(dp)): time step value
  subroutine evolve(curr, prev, a, dt)

    implicit none

    type(field), intent(inout) :: curr, prev
    real(dp) :: a, dt
    integer :: i, j, nx, ny

    nx = curr%nx
    ny = curr%ny

    do j = 1, ny
       do i = 1, nx
          curr%data(i, j) = prev%data(i, j) + a * dt * &
               & ((prev%data(i-1, j) - 2.0 * prev%data(i, j) + &
               &   prev%data(i+1, j)) / curr%dx**2 + &
               &  (prev%data(i, j-1) - 2.0 * prev%data(i, j) + &
               &   prev%data(i, j+1)) / curr%dy**2)
       end do
    end do
  end subroutine evolve

end module core
