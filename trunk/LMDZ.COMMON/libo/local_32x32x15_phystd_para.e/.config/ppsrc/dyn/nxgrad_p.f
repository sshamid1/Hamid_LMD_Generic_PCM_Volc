      SUBROUTINE nxgrad_p (klevel, rot, x, y )
c
c     P. Le Van
c
c   ********************************************************************
c      calcul du gradient tourne de pi/2 du rotationnel du vect.v
c   ********************************************************************
c       rot          est un argument  d'entree pour le s-prog
c       x  et y    sont des arguments de sortie pour le s-prog
c
      USE parallel_lmdz
      IMPLICIT NONE
c

!-----------------------------------------------------------------------
!   INCLUDE 'dimensions.h'
!
!   dimensions.h contient les dimensions du modele
!   ndm est tel que iim=2**ndm
!-----------------------------------------------------------------------

      INTEGER iim,jjm,llm,ndm

      PARAMETER (iim= 32,jjm=32,llm=15,ndm=1)

!-----------------------------------------------------------------------

!
! $Header$
!
!
!  ATTENTION!!!!: ce fichier include est compatible format fixe/format libre
!                 veillez  n'utiliser que des ! pour les commentaires
!                 et  bien positionner les & des lignes de continuation
!                 (les placer en colonne 6 et en colonne 73)
!
!
!-----------------------------------------------------------------------
!   INCLUDE 'paramet.h'

      INTEGER  iip1,iip2,iip3,jjp1,llmp1,llmp2,llmm1
      INTEGER  kftd,ip1jm,ip1jmp1,ip1jmi1,ijp1llm
      INTEGER  ijmllm,mvar
      INTEGER jcfil,jcfllm

      PARAMETER( iip1= iim+1,iip2=iim+2,iip3=iim+3                       &
     &    ,jjp1=jjm+1-1/jjm)
      PARAMETER( llmp1 = llm+1,  llmp2 = llm+2, llmm1 = llm-1 )
      PARAMETER( kftd  = iim/2 -ndm )
      PARAMETER( ip1jm  = iip1*jjm,  ip1jmp1= iip1*jjp1 )
      PARAMETER( ip1jmi1= ip1jm - iip1 )
      PARAMETER( ijp1llm= ip1jmp1 * llm, ijmllm= ip1jm * llm )
      PARAMETER( mvar= ip1jmp1*( 2*llm+1) + ijmllm )
      PARAMETER( jcfil=jjm/2+5, jcfllm=jcfil*llm )

!-----------------------------------------------------------------------

!
! $Header$
!
!CDK comgeom
      COMMON/comgeom/                                                   &
     & cu(ip1jmp1),cv(ip1jm),unscu2(ip1jmp1),unscv2(ip1jm),             &
     & aire(ip1jmp1),airesurg(ip1jmp1),aireu(ip1jmp1),                  &
     & airev(ip1jm),unsaire(ip1jmp1),apoln,apols,                       &
     & unsairez(ip1jm),airuscv2(ip1jm),airvscu2(ip1jm),                 &
     & aireij1(ip1jmp1),aireij2(ip1jmp1),aireij3(ip1jmp1),              &
     & aireij4(ip1jmp1),alpha1(ip1jmp1),alpha2(ip1jmp1),                &
     & alpha3(ip1jmp1),alpha4(ip1jmp1),alpha1p2(ip1jmp1),               &
     & alpha1p4(ip1jmp1),alpha2p3(ip1jmp1),alpha3p4(ip1jmp1),           &
     & fext(ip1jm),constang(ip1jmp1),rlatu(jjp1),rlatv(jjm),            &
     & rlonu(iip1),rlonv(iip1),cuvsurcv(ip1jm),cvsurcuv(ip1jm),         &
     & cvusurcu(ip1jmp1),cusurcvu(ip1jmp1),cuvscvgam1(ip1jm),           &
     & cuvscvgam2(ip1jm),cvuscugam1(ip1jmp1),                           &
     & cvuscugam2(ip1jmp1),cvscuvgam(ip1jm),cuscvugam(ip1jmp1),         &
     & unsapolnga1,unsapolnga2,unsapolsga1,unsapolsga2,                 &
     & unsair_gam1(ip1jmp1),unsair_gam2(ip1jmp1),unsairz_gam(ip1jm),    &
     & aivscu2gam(ip1jm),aiuscv2gam(ip1jm),xprimu(iip1),xprimv(iip1)

!
        REAL                                                            &
     & cu,cv,unscu2,unscv2,aire,airesurg,aireu,airev,unsaire,apoln     ,&
     & apols,unsairez,airuscv2,airvscu2,aireij1,aireij2,aireij3,aireij4,&
     & alpha1,alpha2,alpha3,alpha4,alpha1p2,alpha1p4,alpha2p3,alpha3p4 ,&
     & fext,constang,rlatu,rlatv,rlonu,rlonv,cuvscvgam1,cuvscvgam2     ,&
     & cvuscugam1,cvuscugam2,cvscuvgam,cuscvugam,unsapolnga1,unsapolnga2&
     & ,unsapolsga1,unsapolsga2,unsair_gam1,unsair_gam2,unsairz_gam    ,&
     & aivscu2gam ,aiuscv2gam,cuvsurcv,cvsurcuv,cvusurcu,cusurcvu,xprimu&
     & , xprimv
!

      INTEGER klevel
      REAL rot( ip1jm,klevel ),x( ip1jmp1,klevel ),y(ip1jm,klevel )
      INTEGER   l,ij
      INTEGER :: ijb,ije
c
c
c$OMP DO SCHEDULE(STATIC,OMP_CHUNK)      
      DO 10 l = 1,klevel
c
      ijb=ij_begin
      ije=ij_end
      if (pole_sud)  ije=ij_end-iip1
       
      DO 1  ij = ijb+1, ije
      y( ij,l ) = (  rot( ij,l ) - rot( ij-1,l )  ) * cvsurcuv( ij )
   1  CONTINUE
c
c    ..... correction pour  y ( 1,j,l )  ......
c
c    ....    y(1,j,l)= y(iip1,j,l) ....
CDIR$ IVDEP
      DO 2  ij = ijb, ije, iip1
      y( ij,l ) = y( ij +iim,l )
   2  CONTINUE
c
      ijb=ij_begin
      ije=ij_end+iip1
      
      if (pole_nord)  ijb=ij_begin+iip1
      if (pole_sud)  ije=ij_end-iip1
      
      DO 4  ij = ijb,ije
      x( ij,l ) = (  rot( ij,l ) - rot( ij -iip1,l )  ) * cusurcvu( ij )
   4  CONTINUE
   
      if (pole_nord) then 
        DO ij = 1,iip1
          x(    ij    ,l ) = 0.
        ENDDO
      endif
      
      if (pole_sud) then 
        DO ij = 1,iip1
          x( ij +ip1jm,l ) = 0.
        ENDDO
      endif
c
  10  CONTINUE
c$OMP END DO NOWAIT
      RETURN
      END

