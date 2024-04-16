MODULE mod_const_mpi

  INTEGER :: COMM_LMDZ
  INTEGER :: MPI_REAL_LMDZ
 

CONTAINS 

  SUBROUTINE Init_const_mpi
  IMPLICIT NONE
  
    COMM_LMDZ=0
    MPI_REAL_LMDZ=0
  END SUBROUTINE Init_const_mpi

END MODULE mod_const_mpi

