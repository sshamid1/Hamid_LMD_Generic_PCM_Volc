!
! $Header$
!
c-----------------------------------------------------------------------
c INCLUDE 'fxyprim.h'
c
c    ................................................................
c    ................  Fonctions in line  ...........................
c    ................................................................
c
      REAL  fy, fx, fxprim, fyprim
      REAL  ri, rj
c
c
      fy    ( rj ) =    pi/REAL(jjm) * ( 0.5 * REAL(jjm) +  1. - rj  )
      fyprim( rj ) =    pi/REAL(jjm)

c     fy(rj)=ASIN(1.+2.*((1.-rj)/REAL(jjm)))
c     fyprim(rj)=1./SQRT((rj-1.)*(jjm+1.-rj))

      fx    ( ri ) = 2.*pi/REAL(iim) * ( ri - 0.5*  REAL(iim) - 1. )
c     fx    ( ri ) = 2.*pi/REAL(iim) * ( ri - 0.5* ( REAL(iim) + 1.) )
      fxprim( ri ) = 2.*pi/REAL(iim)
c
c
c    La valeur de pi est passee par le common/const/ou /const2/ .
c    Sinon, il faut la calculer avant d'appeler ces fonctions .
c
c   ----------------------------------------------------------------
c     Fonctions a changer eventuellement, selon x(x) et y(y) choisis .
c   -----------------------------------------------------------------
c
c    .....  ici, on a l'application particuliere suivante   ........
c
c                **************************************
c                **     x = 2. * pi/iim *  X         **
c                **     y =      pi/jjm *  Y         **
c                **************************************
c
c   ..................................................................
c   ..................................................................
c
c
c
c-----------------------------------------------------------------------
