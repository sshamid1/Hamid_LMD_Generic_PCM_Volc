!
! $Header$
!
      SUBROUTINE dteta1 ( teta, pbaru, pbarv, dteta)
      IMPLICIT NONE

c=======================================================================
c
c   Auteur:  P. Le Van
c   -------
c Modif F.Forget 03/94 (on retire q et dq  pour construire dteta1)
c
c   ********************************************************************
c   ... calcul du terme de convergence horizontale du flux d'enthalpie
c        potentielle   ......
c   ********************************************************************
c  .. teta,pbaru et pbarv sont des arguments d'entree  pour le s-pg ....
c     dteta 	          sont des arguments de sortie pour le s-pg ....
c
c=======================================================================



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


      REAL teta( ip1jmp1,llm ),pbaru( ip1jmp1,llm ),pbarv( ip1jm,llm)
      REAL dteta( ip1jmp1,llm )
      INTEGER   l,ij

      REAL hbyv( ip1jm,llm ), hbxu( ip1jmp1,llm )

c

      DO 5 l = 1,llm

      DO 1  ij = iip2, ip1jm - 1
      hbxu(ij,l) = pbaru(ij,l) * 0.5 * ( teta(ij,l) + teta(ij+1,l) )
   1  CONTINUE

c    .... correction pour  hbxu(iip1,j,l)  .....
c    ....   hbxu(iip1,j,l)= hbxu(1,j,l) ....

CDIR$ IVDEP
      DO 2 ij = iip1+ iip1, ip1jm, iip1
      hbxu( ij, l ) = hbxu( ij - iim, l )
   2  CONTINUE


      DO 3 ij = 1,ip1jm
      hbyv(ij,l)= pbarv(ij, l)* 0.5 * ( teta(ij, l)+ teta(ij +iip1,l) )
   3  CONTINUE

   5  CONTINUE


        CALL  convflu ( hbxu, hbyv, llm, dteta )


c    stockage dans  dh de la convergence horizont. filtree' du  flux
c                  ....                           ...........
c           d'enthalpie potentielle .

      CALL filtreg( dteta, jjp1, llm, 2, 2, .true., 1)

c
      RETURN
      END

