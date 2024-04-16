PROGRAM testhist1
!-
!$Id: testhist1.f90 807 2009-11-23 12:11:55Z bellier $
!-
! This software is governed by the CeCILL license
! See IOIPSL/IOIPSL_License_CeCILL.txt
!---------------------------------------------------------------------
!- This program provide a an example of the basic usage of HIST.
!- No secial features are used but just the basics.
!---------------------------------------------------------------------
  USE ioipsl
!
  IMPLICIT NONE
!
  INTEGER,PARAMETER :: iim=96, jjm=96, llm=12, nbreg=200
!
  REAL :: champ1(iim,jjm), champ2(iim,jjm,llm), champ3(iim,jjm)
  REAL :: lon(iim,jjm),lat(iim,jjm), lev(llm)
  REAL :: lon_test(iim),lat_test(jjm)
  REAL :: x
!
  INTEGER :: i, j, l, id, it, ij, sig_id, hori_id
  INTEGER :: day=15, month=2, year=1997
  INTEGER :: itau=0, index(nbreg), start
!
  REAL :: julday
  REAL :: deltat=60., dt_wrt, dt_op
  CHARACTER(LEN=20) :: histname
!
  REAL :: pi=3.1415
!---------------------------------------------------------------------
!-
! 1.0 Define a few variables we will need. These are the coordinates
!     the file name and the date.
!-
  DO i=1,iim
    DO j=1,jjm
      lon(i,j) = ((float(iim/2)+0.5)-float(i))*pi/float(iim/2) &
 &              *(-1.)*180./pi
      lat(i,j) = 180./pi*ASIN(((float(jjm/2)+0.5)-float(j)) &
 &              /float(jjm/2))
    ENDDO
  ENDDO
!-
  lon_test(:) = lon(:,1)
  lat_test(:) = lat(1,:)
!-
  DO l=1,llm
    lev(l) = REAL(l)/llm
  ENDDO
!
  histname = 'testhist1.nc'
!-
! 1.1 The chosen date is 15 Feb. 1997 as stated above.
!     It has to be transformed into julian days using
!     the calendar provided by IOIPSL.
!-
  CALL ymds2ju(year, month, day, 0.,julday)
  dt_wrt = 3*deltat
  dt_op = 3*deltat
!-
! 2.0 Do all the declarations for hist. That is define the file,
!     the vertical coordinate and the variables in the file.
!-
  CALL ioconf_modname('testhist1 produced this file')
!-
  CALL histbeg (histname,iim,lon_test,jjm,lat_test, &
 &              1,iim,1,jjm,itau,julday,deltat,hori_id,id)
!-
  CALL histvert (id,"sigma","Sigma levels"," ",llm,lev,sig_id,pdirect="up")
!-
  CALL histdef (id,"champ1","Some field","m", &
 &       iim,jjm,hori_id,1,1,1,-99,32,"inst(scatter(x))", &
 &       dt_op,dt_wrt,var_range=(/1.,-1./),standard_name='thickness')
!-
  CALL histdef (id,"champ2","Another field","m", &
 &       iim,jjm,hori_id,llm,1,llm,sig_id,32,"t_max(max(x,1.0)*2)", &
 &       deltat,dt_wrt,var_range=(/0.,90./),standard_name='thickness')
!-
  CALL histdef (id,"champ3","A field without time","m", &
 &       iim,jjm,hori_id,1,1,1,-99, 32,"once", &
 &       deltat,dt_wrt,standard_name='thickness')
!-
  CALL histend (id)
!-
! 2.1 The filed we are going to write are computes
!-
  x = 10.
  CALL RANDOM_NUMBER(HARVEST=x)
  CALL RANDOM_NUMBER(champ1)
  champ3 = champ1
  DO l=1,llm
    champ2(:,:,l) = champ1*l
  ENDDO
!-
! 3.0 Start the time steping and write the data as we go along.
!-
  start = 1
!-
  DO it=1,12
!---
!   3.1 In the 2D filed we will have a set of random numbers
!       which move through the map.
!---
    ij = 0
    DO j=1,nbreg/10
      DO i=1,10
        ij = ij+1
        index(ij) = iim*(j+20)+(i+start)
      ENDDO
    ENDDO
!---
    IF (start < iim-10) THEN
      start = start+10
    ELSE
      start = 1
    ENDIF
!---
    itau = itau + 1
!---
!   3.2 Pass the data to HIST for operation and writing.
!---
    CALL histwrite (id,"champ1",itau,champ1,nbreg,index)
    CALL histwrite (id,"champ2",itau,champ2,iim*jjm*llm,index)
    CALL histwrite (id,"champ3",itau,champ3,iim*jjm,index)
    champ1 = champ1+1
    champ2 = champ2+2
  ENDDO
!-
! 4.0 The HIST routines are ended and netCDF is closed
!-
  CALL histclo ()
!--------------------
END PROGRAM testhist1
