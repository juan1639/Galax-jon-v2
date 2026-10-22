;===========================================================================
;===  GALAX JON - disparo.asm                                             ===
;===  Disparo del jugador y deteccion de blanco                           ===
;===========================================================================

;==========================================================================
;===                  D I S P A R O   J U G A D O R                     ===
;==========================================================================
;---------------------------------------------------------------------------
;---                         SUB - D I S P A R O                         ---
;---                                                                     ---
;---  (Disparo_y): Coordenada Y disparo 'H'                              ---
;---  (Disparo_x): Coordenada X disparo 'L'                              ---
;---------------------------------------------------------------------------
disparo:
	ld	a,(settings)
	bit	B_DISPARO,a
	ret	z			; Disparo OFF

	call	borrar_disparo
	call	dibuja_disparo
	ld	a,3
	jp	sonido

;---------------------------------------------------------------------------
;---                  SUB - I N I C I A   D I S P A R O                  ---
;---------------------------------------------------------------------------
inicia_disparo:
	ld	a,(settings)
	set	B_DISPARO,a		; Disparo ON
	ld	(settings),a

	ld	a,4
	ld	(cadencia),a

	ld	a,(rota_nave)		; Alinea Rotacion Disparo con ...
	or	a			; ... Rotacion Nave-Jugador
	jr	nz,guarda_rotadisparo
	inc	a			; (nunca 0)
guarda_rotadisparo:
	ld	(rota_disparo),a

	ld	a,$50			; Coordenadas Iniciales del Disparo
	ld	(disparo_y),a
	ld	a,(navejugador_x)
	ld	(disparo_x),a
	ret

;---------------------------------------------------------------------------
;---                  SUB - B O R R A R   D I S P A R O                  ---
;---------------------------------------------------------------------------
borrar_disparo:
	ld	a,(settings)
	res	B_DIBUJA_DISP,a		; 'BORRA' Disparo
	ld	(settings),a

	ld	a,(disparo_y)
	ld	h,a
	ld	a,(disparo_x)
	ld	l,a

	inc	l
	ld	b,8			; Bucle $08 Scanlines
bucle_borrardisparo:
	ld	(hl),0
	inc	h
	djnz	bucle_borrardisparo

	call	atributos_disparo
	dec	l
	ret

;---------------------------------------------------------------------------
;---                  SUB - D I B U J A   D I S P A R O                  ---
;---------------------------------------------------------------------------
dibuja_disparo:
	ld	a,(settings)
	set	B_DIBUJA_DISP,a		; 'DIBUJA' Disparo
	ld	(settings),a

	ld	a,(disparo_y)
	ld	h,a

	ld	a,l
	sub	$20			; Sube un caracter
	ld	l,a
	ld	(disparo_x),a
	call	c,tercio_anterior	; Carry=1 ... Cambio de TERCIO

	push	hl
	call	blanco			; Hemos hecho BLANCO??
	pop	hl

	call	sonido_disparo

	ld	a,(settings)
	bit	B_DISPARO,a
	ret	z			; Disparo OFF

	ld	a,(rota_disparo)	; Alinear Rotacion con la Nave-Jugador
	ld	b,a
	ld	a,$80
bucle_rotaciondisparo:
	rrca
	djnz	bucle_rotaciondisparo

	inc	l
	ld	b,8			; Bucle $08 Scanlines
bucle_dibujardisparo:
	ld	(hl),a
	inc	h
	djnz	bucle_dibujardisparo

	jp	atributos_disparo

;-------------------------------------------------------------------
;---        SUB -  A T T R   D E L   D I S P A R O               ---
;-------------------------------------------------------------------
atributos_disparo:
	ld	a,h
	sub	8			; Vuelve al 1er Scanline
	ld	h,a

	cp	$48
	jr	z,attr_disp_t2
	cp	$40
	jr	z,attr_disp_t1

	ld	h,$5a			; 3er tercio
	ld	c,$02
	jr	attr_disp_pinta

attr_disp_t2:
	ld	h,$59			; 2do tercio
	ld	c,$04
	jr	attr_disp_pinta

attr_disp_t1:
	ld	h,$58			; 1er tercio
	ld	c,$04

attr_disp_pinta:
	ld	a,(settings)
	bit	B_DIBUJA_DISP,a
	jr	nz,attr_amarillo
	ld	(hl),c			; Attr al Borrar
	ret

attr_amarillo:
	ld	(hl),$46		; Attr Disparo (Amarillo+Bright)
	ret

;---------------------------------------------------------------------------
;---        SUB - T E R C I O   A N T E R I O R   ( Disparo )            ---
;---------------------------------------------------------------------------
tercio_anterior:
	ld	a,(disparo_y)
	cp	$40
	jr	z,disparo_arriba	; Limite superior alcanzado
	sub	8			; Sube un Tercio ($50 -> $48 -> $40)
	ld	h,a
	ld	(disparo_y),a
	ret

disparo_arriba:
	ld	a,(settings)
	res	B_DISPARO,a		; Desactivar el Disparo
	ld	(settings),a
	ret

;---------------------------------------------------------------------------
;---          SUB -  H E M O S   H E C H O   B L A N C O ??              ---
;---                                                                     ---
;---  Blanco si (L marciano - L disparo) = 0, 1 o 2                      ---
;---------------------------------------------------------------------------
blanco:
	ld	a,h
	cp	$40
	ret	nz		; No es el 1er TERCIO (No hay Marcianos)

	ld	ix,marcianos
	ld	b,NUM_MARCIANOS
	ld	de,M_TAM

bucle_quemarciano_abatido:
	ld	a,(ix+M_ACTIVO)
	or	a
	jr	z,aqui_nohay
	ld	a,(ix+M_L)
	sub	l
	cp	3
	jr	c,desactivar_marciano	; Blanco!
aqui_nohay:
	add	ix,de
	djnz	bucle_quemarciano_abatido
	ret

desactivar_marciano:
	ld	l,(ix+M_L)		; L = Posicion del Marciano
	ld	(ix+M_ACTIVO),0		; Desactiva el Marciano...
	jp	inicia_explosion	; ...e Inicia Explosion

;--------------------------------------------------------------------------
sonido_disparo:
	ld	a,h
	sub	$39
	ld	h,a
	ld	(soni_disp),hl		; Nota segun la altura del disparo
	add	a,$39
	ld	h,a
	ret
