CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C$+									C
C			ROUTINES DI FISICA				C
C$-									C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

	FUNCTION BWEISSKOPF(L,A)

	IF(L.EQ.+1) THEN					
		BWEISSKOPF = 6.45E-02 * A**( 2/3.)	! E1
	ELSE IF(L.EQ.+2) THEN
		BWEISSKOPF = 5.94E-02 * A**( 4/3.)	! E2
	ELSE IF(L.EQ.+3) THEN
		BWEISSKOPF = 5.94E-02 * A**( 6/3.)	! E3
	ELSE IF(L.EQ.+4) THEN
		BWEISSKOPF = 6.29E-02 * A**( 8/3.)	! E4
	ELSE IF(L.EQ.+5) THEN
		BWEISSKOPF = 6.93E-02 * A**(10/3.)	! E5
	ELSE IF(L.EQ.-1) THEN
		BWEISSKOPF = 1.79			! M1
	ELSE IF(L.EQ.-2) THEN
		BWEISSKOPF = 1.65 * A**( 2/3.)		! M2
	ELSE IF(L.EQ.-3) THEN
		BWEISSKOPF = 1.65 * A**( 4/3.)		! M3
	ELSE IF(L.EQ.-4) THEN
		BWEISSKOPF = 1.75 * A**( 6/3.)		! M4
	ELSE IF(L.EQ.-5) THEN
		BWEISSKOPF = 1.92 * A**( 8/3.)		! M5
	ELSE
		BWEISSKOPF = 0
	ENDIF

	RETURN

	END

	FUNCTION PWEISSKOPF(L,EMEV,A)

	IF(L.EQ.+1) THEN					
		PWEISSKOPF = 1.02E+14 * A**( 2/3.) * EMEV**3	! E1
	ELSE IF(L.EQ.+2) THEN
		PWEISSKOPF = 7.23E+07 * A**( 4/3.) * EMEV**5	! E2
	ELSE IF(L.EQ.+3) THEN
		PWEISSKOPF = 3.37E+01 * A**( 6/3.) * EMEV**7	! E3
	ELSE IF(L.EQ.+4) THEN
		PWEISSKOPF = 1.06E-05 * A**( 8/3.) * EMEV**9	! E4
	ELSE IF(L.EQ.+5) THEN
		PWEISSKOPF = 2.38E-10 * A**(10/3.) * EMEV**11	! E5
	ELSE IF(L.EQ.-1) THEN
		PWEISSKOPF = 3.12E+13 *              EMEV**3	! M1
	ELSE IF(L.EQ.-2) THEN
		PWEISSKOPF = 2.21E+07 * A**( 2/3.) * EMEV**5	! M2
	ELSE IF(L.EQ.-3) THEN
		PWEISSKOPF = 1.03E+01 * A**( 4/3.) * EMEV**7	! M3
	ELSE IF(L.EQ.-4) THEN
		PWEISSKOPF = 3.25E-06 * A**( 6/3.) * EMEV**9	! M4
	ELSE IF(L.EQ.-5) THEN
		PWEISSKOPF = 7.29E-13 * A**( 8/3.) * EMEV**11	! M5
	ELSE
		PWEISSKOPF = 0
	ENDIF

	RETURN

	END

c	SUBROUTINE XMASS(IZ,IA,EX,DEX)
c
cC	READS FOR GIVEN VALUES OF IZ,IA
cC	THE MASS EXCESS EX AND ITS ERROR DEX, BOTH IN KEV
cC	FROM RANDOM ACCESS FILE MASS.RAN
c
c	CHARACTER NAMNUCL*2
c	DATA NDSK /21/
c	DATA NRSIZ /42/
c	DATA NMASS /257/
c
c	IF (IZ.GE.0) GO TO 2
c1	EX=1000000.
c	DEX=1000000.
c	CLOSE(UNIT=NDSK,ERR=10)
c10	CONTINUE
c	WRITE(5,'(/'' MASS-EXCESS OF '',I3,A2,'' NOT FOUND'')')IA,NAMNUCL(IZ)
c	CALL inp_r2('INPUT MASS-EXCESS AND ERROR (KEV) :',EX,DEX)
c	GOTO 200
c2	IF(IZ.EQ.0 .AND. IA.EQ.0) THEN
c		EX=0
c		DEX=0
c		GOTO 200
c	ENDIF
c	IF (IA.LE.0.OR.IA.GT.NMASS) GO TO 1
c	CLOSE(UNIT=NDSK,ERR=20)
c20	CONTINUE
c	OPEN(UNIT=NDSK,FILE='~/bin/MASS.RAN',ACCESS='DIRECT',STATUS='OLD',
c	1	RECL=NRSIZ,FORM='FORMATTED')
c	READ(NDSK'IA,'(7X,I4)') NR
c	NREC=NR-1
c3	NREC=NREC+1
c	READ(NDSK'NREC,'(12X,2I4,1X,2F10.3)') NZ,NA,EX,DEX
c	IF (NA.NE.IA) GO TO 1
c	IF (NZ.NE.IZ) GO TO 3
c
c200	CLOSE(UNIT=NDSK,ERR=210)
c
c210	RETURN
c
c	END
c

	subroutine xmass(iz,ia,ex,dex)

c	reads for given values of iz,ia
c	the mass excess ex and its error dex, both in MeV
c	from file ~bazzacco/bin/AWMASS.DAT

	character namnucl*2
	data lun /0/
	
	if(lun .LE. 0) call lib$get_lun(lun)

	open(unit=lun,file='~/GASPware/bin/AWMASS.DAT',status='old',form='formatted')
	read(lun,*)
	read(lun,*)
	read(lun,*)

10      read(lun,'(2I3,1X,F11.3,F9.3)',err=100,end=100) na,nz,ex,dex
	if(na.EQ.ia .AND. nz.EQ.iz) then
	  ex=ex/1000.
	  dex=dex/1000.
	  goto 200
	endif
	if(na .LE. ia) goto 10

100	write(6,'(/'' MASS-EXCESS OF '',i3,a2,'' NOT FOUND'')')ia,namnucl(iz)
	call inp_r2('INPUT MASS-EXCESS AND ERROR (MeV) :',ex,dex)
        	
200	close(unit=lun)
	return

	end

	SUBROUTINE CINEMA(MASSP,MASST,MASSD,MASSU,QVAL,EPROJ,THD,
	1 ENED1,THU1,ENEU1,ENED2,THU2,ENEU2,THCMD1,THCMD2)

C	CINEMATICA (NON RELATIVISTICA) A DUE CORPI

	REAL MASSP,MASST,MASSD,MASSU,MASSE

	ENED1=-1
	THU1=-1
	ENEU1=-1
	ENED2=-1
	THU2=-1
	ENEU2=-1
	THCMD1=-1
	THCMD2=-1

	ETOT=EPROJ+QVAL
	IF(ETOT.LE.0) GOTO 100
	SINPSI=SIN(THD)
	COSPSI=COS(THD)
	MASSE=(MASSP+MASST)*(MASSD+MASSU)
	AA=MASSP*MASSU/MASSE*EPROJ/ETOT
	BB=MASSP*MASSD/MASSE*EPROJ/ETOT
	EE=1+MASSP/MASST*QVAL/ETOT
	CC=MASST*MASSD/MASSE*EE
	DD=MASST*MASSU/MASSE*EE
	IF(BB.GE.DD) THEN
		IF((DD/BB).LT.0) GOTO 100
		IF(THD.GT.ASIN(SQRT(DD/BB))) GOTO 100
	ENDIF
	DETER=DD/BB-SINPSI**2
	IF(DETER.LT.0.) GOTO 100
	DETER=SQRT(DETER)

	ENED1=ETOT*BB*(COSPSI+DETER)**2
	IF(THD.EQ.0 .AND. QVAL.EQ.0) ENED1=ETOT
	ENEU1=ETOT-ENED1
	IF(ENED1.LT.0 .OR. ENEU1.LT.0) THEN
		ENED1=-1
		ENEU1=-1
		GOTO 50
	ENDIF
	THU1=0
	IF(ENED1.GT.0 .AND. ENEU1.GT.0) THEN
		SINU=SQRT(MASSD/MASSU*ENED1/ENEU1)*SINPSI
		COSU=(ENEU1+ETOT*(AA-CC))/2./SQRT(AA*ETOT*ENEU1)
		THU1=ATAN2(SINU,COSU)
	ENDIF
	SINDCM=SQRT(ENED1/ETOT/DD)*SINPSI
	COSDCM=(ENED1/ETOT-BB-DD)/2./SQRT(AA*CC)
	THCMD1=ATAN2(SINDCM,COSDCM)

50	IF(DD.GE.BB) GOTO 100
	ENED2=ETOT*BB*(COSPSI-DETER)**2
	IF(ENED2.GT.ETOT) ENED2=ETOT
	ENEU2=ETOT-ENED2
	IF(ENED2.LT.0 .OR. ENEU2.LT.0) THEN
		ENED2=-1
		ENEU2=-1
		GOTO 100
	ENDIF
	THU2=0
	IF(ENED2.GT.0 .AND. ENEU2.GT.0) THEN
		SINU=SQRT(MASSD/MASSU*ENED2/ENEU2)*SINPSI
		COSU=(ENEU2+ETOT*(AA-CC))/2./SQRT(AA*ETOT*ENEU2)
		THU2=ATAN2(SINU,COSU)
	ENDIF
	SINDCM=SQRT(ENED2/ETOT/DD)*SINPSI
	COSDCM=(ENED2/ETOT-BB-DD)/2./SQRT(AA*CC)
	THCMD2=ATAN2(SINDCM,COSDCM)

100	RETURN

	END

	SUBROUTINE NUCLNAM(NOME,IZ,IA)

C	DATO  AD ES. 40CA O CA40  RITORNA Z=20,A=40

	CHARACTER*(*)	NOME
	CHARACTER*2	NUCL

	PARAMETER (MAXZ=105)
        CHARACTER*2 TABLE(0:MAXZ)
        DATA TABLE /
     *  'N ',
     *  'H ','HE','LI','BE','B ','C ','N ','O ','F ','NE',
     *  'NA','MG','AL','SI','P ','S ','CL','AR','K ','CA',
     *  'SC','TI','V ','CR','MN','FE','CO','NI','CU','ZN',
     *  'GA','GE','AS','SE','BR','KR','RB','SR','Y ','ZR',
     *  'NB','MO','TC','RU','RH','PD','AG','CD','IN','SN',
     *  'SB','TE','I ','XE','CS','BA','LA','CE','PR','ND',
     *  'PM','SM','EU','GD','TB','DY','HO','ER','TM','YB',
     *  'LU','HF','TA','W ','RE','OS','IR','PT','AU','HG',
     *  'TL','PB','BI','PO','AT','RN','FR','RA','AC','TH',
     *  'PA','U ','NP','PU','AM','CM','BK','CF','ES','FM',
     *  'MD','NO','LR','RF','HA'/

	IZ=-1
	IA=-1

	I2=LENGTHC(NOME)

	DO II=1,I2		!  ELIMINA LEADING BLANKS
		IF(NOME(II:II).NE.' ') GOTO 8
	ENDDO
	II=I2
8	I1=II

	IC=ICHAR(NOME(I1:I1))-48
	IF(IC.LT.0 .OR. IC.GT.9) GOTO 20

CCCCCCCCCCCCCCCCCCCC FORMATO TIPO 12C CCCCCCCCCCCCCCCCCCCCCCCCCC
10	IA=0
	DO II=I1,I2				! CALCOLA IA DAI DIGITS
		IC=ICHAR(NOME(II:II))-48
		IF(IC.LT.0 .OR. IC.GT.9) GOTO 12
		IA=IA*10+IC
	ENDDO
	II=I2
12	I1=II
	DO II=I1,I2				!  ELIMINA BLANKS FRAMEZZATI
		IF(NOME(II:II).NE.' ') GOTO 14
	ENDDO
	II=I2
14	I1=II
	NUCL=NOME(I1:I2)			! IL RESTO E' NOME
	GOTO 30

CCCCCCCCCCCCCCCCCCCC FORMATO TIPO C12 CCCCCCCCCCCCCCCCCCCCCCCCCC
20	NUCL=' '
	IN=0
	DO II=I1,I1+1				! PRIMA IL NOME
		IC=ICHAR(NOME(II:II))-48
		IF(IC.GE.0 .AND. IC.LE.9) GOTO 22
		IN=IN+1
		NUCL(IN:IN)=NOME(II:II)
	ENDDO
	II=I1+2
22	I1=II
	DO II=I1,I2				!  ELIMINA BLANKS FRAMEZZATI
		IF(NOME(II:II).NE.' ') GOTO 24
	ENDDO
	II=I2
24	IA=0
	DO II=I1,I2				! CALCOLA IA DAI DIGITS
		IC=ICHAR(NOME(II:II))-48
		IF(IC.LT.0 .OR. IC.GT.9) GOTO 30
		IA=IA*10+IC
	ENDDO

30	CALL STR_TOUPPER(NUCL)			! TROVA IZ
	IF(IA.LT.1) THEN
	   IF( NUCL.EQ.'N ') THEN
		IZ=0
		IA=1
		RETURN
	   ELSEIF( NUCL.EQ.'P ') THEN
		IZ=1
		IA=1
		RETURN
	   ELSEIF( NUCL.EQ.'A ') THEN
		IZ=2
		IA=4
		RETURN
	   ENDIF
	ENDIF
	DO IZ=1,MAXZ
		IF(NUCL.EQ.TABLE(IZ)) RETURN
	ENDDO
	IZ=-1

	RETURN

	END

	CHARACTER*(*) FUNCTION NAMNUCL(IZ)

C	DATO Z RITORNA IL NOME DELLA SPECE ATOMICA

	PARAMETER (MAXZ=105)
        CHARACTER*2 TABLE(0:MAXZ)
        DATA TABLE /
     *  'n ',
     *  'H ','He','Li','Be','B ','C ','N ','O ','F ','Ne',
     *  'Na','Mg','Al','Si','P ','S ','Cl','Ar','K ','Ca',
     *  'Sc','Ti','V ','Cr','Mn','Fe','Co','Ni','Cu','Zn',
     *  'Ga','Ge','As','Se','Br','Kr','Rb','Sr','Y ','Zr',
     *  'Nb','Mo','Tc','Ru','Rh','Pd','Ag','Cd','In','Sn',
     *  'Sb','Te','I ','Xe','Cs','Ba','La','Ce','Pr','Nd',
     *  'Pm','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb',
     *  'Lu','Hf','Ta','W ','Re','Os','Ir','Pt','Au','Hg',
     *  'Tl','Pb','Bi','Po','At','Rn','Fr','Ra','Ac','Th',
     *  'Pa','U ','Np','Pu','Am','Cm','Bk','Cf','Es','Fm',
     *  'Md','No','Lr','Rf','Ha'/

	NAMNUCL='**'
	IF(IZ.LT.0.OR.IZ.GT.MAXZ) GOTO 200
	NAMNUCL=TABLE(IZ)

200	RETURN

	END


