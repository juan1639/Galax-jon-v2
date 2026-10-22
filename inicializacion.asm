;===========================================================================
;===  GALAX JON - inicializacion.asm                                      ===
;===  Reinicios, atributos generales y CLS                                ===
;===========================================================================

;==========================================================================
;===                  I N I C I A L I Z A C I O N E S                   ===
;==========================================================================
;--------------------------------------------------------------------------
;---           JR -  U P D A T E S   G E N E R A L E S                  ---
;--------------------------------------------------------------------------
updates_generales:
	xor	a
	ld	(cuantos_marc),a
	ld	(settings),a
	ld	(score_012),a
	ld	a,3
	ld	(rota_nave),a
	ld	(vidas),a
	ld	a,4
	ld	(cadencia),a
	call	sonido			; (A=4) Suena al Pulsar ENTER
	ld	a,2
	ld	(velocidad),a
	ld	a,$8f
	ld	(navejugador_x),a

	call	reseteo_marcianos
	jp	comienzo_ymp		; ***** Comienza el juego! *****

;---------------------------------------------------------------
reseteo_marcianos:
	ld	ix,marcianos
	ld	b,NUM_MARCIANOS
	ld	de,M_TAM

bucle_updatemarcianos:
	ld	(ix+M_ACTIVO),1		; Marcianos= ON
	ld	(ix+M_DIR),1		; Movimiento Inicial= a la Dcha
	ld	(ix+M_ROT),0		; Rotacion= 0
	ld	(ix+M_ANIM),3		; Animacion Inicial= 3
	add	ix,de
	djnz	bucle_updatemarcianos
	ret

;---------------------------------------------------------------------------
;---                     SUB - R A L E N T I Z A                         ---
;---  A = Velocidad  (hace A-1 HALTs)                                    ---
;---------------------------------------------------------------------------
ralentiza:
	dec	a
	ret	z
	halt
	jr	ralentiza

;---------------------------------------------------------------------------
;---                   SUB - A T T R   G E N E R A L                     ---
;---------------------------------------------------------------------------
sub_attr:
	ld	hl,$5800		; Attr de Estrellas (Colorines Pseudo Random)
	ld	c,2			; 2 Tercios

bucle_attrestrellastercio:
	ld	b,$ff			; (255 celdas por tercio)
	ld	a,$42			; Primer Color = Rojo Bright

bucle_attrestrellas:
	ld	(hl),a
	inc	l
	inc	a
	cp	$48			; Tras el Blanco, vuelve al Rojo
	jr	nz,color_estrella_ok
	ld	a,$42
color_estrella_ok:
	djnz	bucle_attrestrellas
	inc	h
	dec	c
	jr	nz,bucle_attrestrellastercio

;--- Nave ---
	ld	hl,$5a80
	ld	b,$20
	ld	a,$02			; Nave (parte superior, roja)
	call	pintar_attr
	ld	b,$20
	ld	a,$05			; Nave (Parte inferior, azul claro)
	call	pintar_attr

;--- Marcianos ---
	ld	ix,marcianos
	ld	b,NUM_MARCIANOS
	ld	de,M_TAM
	ld	a,$04			; Verde

bucle_attrmarcianos:
	ld	h,$58
	ld	l,(ix+M_L)
	ld	(hl),a
	inc	l
	ld	(hl),a
	inc	l
	ld	(hl),a
	add	ix,de
	djnz	bucle_attrmarcianos

;--- Marcador ---
	ld	hl,$5aea
	ld	b,3
	ld	a,$06			; ON/OFF (Amarillo)
	call	pintar_attr

	ld	hl,$5af5
	ld	b,6			; Score (Amarillo)
	call	pintar_attr

	ld	hl,$5aee
	ld	a,$44			; Banderitas (Verdes)
	ld	b,4
bucle_attrbanderitas:
	ld	(hl),a
	inc	l
	inc	l
	djnz	bucle_attrbanderitas
	ret

;---------------------------------------------------------------------------
;---                    S U B - C L S  ATRIBUTOS                         ---
;---------------------------------------------------------------------------
sub_clsattr:
	ld	hl,$5800
	ld	(hl),%01000111		; Tinta Blanca Bright
	ld	de,$5801
	ld	bc,$02ff
	ldir
	ret

;--------------------------------------------------------------------------
;---		               SUB -  C L S                             ---
;--------------------------------------------------------------------------
sub_cls:
	ld	hl,$4000
	ld	(hl),0
	ld	de,$4001
	ld	bc,$17ff
	ldir
	ret
