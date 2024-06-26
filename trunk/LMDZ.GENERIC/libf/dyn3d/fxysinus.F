      SUBROUTINE fxysinus (rlatu,yprimu,rlatv,yprimv,rlatu1,yprimu1,
     ,                    rlatu2,yprimu2,
     ,  rlonu,xprimu,rlonv,xprimv,rlonm025,xprimm025,rlonp025,xprimp025)

      USE comconst_mod, ONLY: pi

      IMPLICIT NONE
c
c     Calcul  des longitudes et des latitudes  pour une fonction f(x,y)
c            avec y = Asin( j )  .
c
c     Auteur  :  P. Le Van
c
c
#include "dimensions.h"
#include "paramet.h"

       INTEGER i,j

       REAL rlatu(jjp1), yprimu(jjp1),rlatv(jjm), yprimv(jjm),
     , rlatu1(jjm), yprimu1(jjm), rlatu2(jjm), yprimu2(jjm)
       REAL rlonu(iip1),xprimu(iip1),rlonv(iip1),xprimv(iip1),
     , rlonm025(iip1),xprimm025(iip1), rlonp025(iip1),xprimp025(iip1)

#include "fxy_sin.h"


c    ......  calcul  des  latitudes  et de y'   .....
c
       DO j = 1, jjm + 1 
          rlatu(j) = fy    ( FLOAT( j )        )
         yprimu(j) = fyprim( FLOAT( j )        )
       ENDDO


       DO j = 1, jjm

         rlatv(j)  = fy    ( FLOAT( j ) + 0.5  )
         rlatu1(j) = fy    ( FLOAT( j ) + 0.25 ) 
         rlatu2(j) = fy    ( FLOAT( j ) + 0.75 ) 

        yprimv(j)  = fyprim( FLOAT( j ) + 0.5  ) 
        yprimu1(j) = fyprim( FLOAT( j ) + 0.25 )
        yprimu2(j) = fyprim( FLOAT( j ) + 0.75 )

       ENDDO

c
c     .....  calcul   des  longitudes et de  x'   .....
c
       DO i = 1, iim + 1
           rlonv(i)     = fx    (   FLOAT( i )          )
           rlonu(i)     = fx    (   FLOAT( i ) + 0.5    )
        rlonm025(i)     = fx    (   FLOAT( i ) - 0.25  )
        rlonp025(i)     = fx    (   FLOAT( i ) + 0.25  )

         xprimv  (i)    = fxprim (  FLOAT( i )          )
         xprimu  (i)    = fxprim (  FLOAT( i ) + 0.5    )
        xprimm025(i)    = fxprim (  FLOAT( i ) - 0.25   )
        xprimp025(i)    = fxprim (  FLOAT( i ) + 0.25   )
       ENDDO

c
       RETURN
       END

