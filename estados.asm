;===========================================================================
;===  GALAX JON - estados.asm                                             ===
;===  Game Over, Fin, Level Up y Pausa inicial                            ===
;===========================================================================

;==========================================================================
;===           G A M E   O V E R  /  F I N  /  L E V E L   U P          ===
;==========================================================================
;---------------------------------------------------------------------------
;---              JR -   B U C L E   G A M E  O V E R                    ---
;---------------------------------------------------------------------------
game_over:
	push	hl
	push	de

	ld	hl,$0c07
	ld	(soni_disp),hl

	ld	h,$50
	ld	a,(navejugador_x)
	ld	l,a

	ld	c,5		; Bucle $05 explosiones repetitivas Nave-Jugador
repeticiones:
	push	bc
	ld	de,nave_explosionsprites
	ld	c,4		; Bucle $04 fotogramas de explosion (2x2 caracteres)

bucle_explonave:
	ld	b,16		; Bucle 16 Scanlines

bucle_scansexplonave:
	ld	a,3
	call	sonido		; Sonido Explosion Nave Jugador

	ld	a,(de)
	ld	(hl),a
	inc	l
	inc	de
	ld	a,(de)
	ld	(hl),a
	inc	l
	ld	(hl),0		; Borrado del 3er Byte (Rotacion)
	dec	l
	dec	l
	inc	h
	ld	a,h
	cp	$58		; Cambio de Linea??
	call	z,linea_siguiente
	inc	de
	djnz	bucle_scansexplonave

	halt
	halt			; Ralentizaciones
	ld	a,l
	sub	$40
	ld	l,a		; Vuelve 2 lineas arriba...
	ld	h,$50		; ...al 1er Scanline
	dec	c
	jr	nz,bucle_explonave

	pop	bc
	dec	c
	jr	nz,repeticiones

	ld	b,$18		; Borrado de Explosion Nave
bucle_borradoexplonave:
	ld	(hl),0
	inc	l
	ld	(hl),0
	dec	l
	inc	h
	ld	a,h
	cp	$58		; Cambio de linea??
	call	z,linea_siguiente
	djnz	bucle_borradoexplonave

;-----------------------------------------------------------------
;---     G A M E   O V E R ??  /  V I D A   M E N O S ??       ---
;-----------------------------------------------------------------
	ld	a,(vidas)
	dec	a
	ld	(vidas),a
	pop	de
	pop	hl
	jr	nz,vida_menos

bucle_gameover:
	call	espacio
	call	mover_marcianos
	call	disparo
	call	explosion
	call	score
	call	mensaje_gameover
	call	pulse_enter

	ld	a,$bf			; Semifila ENTER...H
	in	a,($fe)
	bit	0,a			; Tecla ENTER
	jp	z,updates_generales	; Pulsada: otra partida

	halt
	halt
	jr	bucle_gameover

;---------------------------------------------------------
vida_menos:
	ld	a,PAUSA_INICIAL		; Nueva Pausa Inicial
	ld	(pausa_i),a
	ld	a,(settings)
	res	B_JUGANDO,a		; Pausa Inicial (ON)
	ld	(settings),a
	jp	no_comprobar

;---------------------------------------------------------------------------
mensaje_gameover:
	ld	hl,$486c
	ld	de,txt_gameover
	call	imprimir_cadena
	ld	hl,$596c
	ld	b,$11
	ld	a,%01000101		; AzulClaro Bright
	jp	pintar_attr

pulse_enter:
	ld	hl,$5048
	ld	de,txt_enter
	call	imprimir_cadena
	ld	hl,$5a48
	ld	b,5
	ld	a,$06			; 'ENTER' (Amarillo)
	call	pintar_attr
	ld	hl,$5a4f
	ld	b,$0c
	ld	a,$47			; 'Otra Partida' (Blanco Bright)
	jp	pintar_attr

;---------------------------------------------------------------------------
;---               JR - F I N  (JUEGO COMPLETADO)                        ---
;---------------------------------------------------------------------------
fin:
	call	score
	ld	hl,$50fb
	ld	de,txt_100
	call	imprimir_cadena

bucle_staff:
	call	espacio
	call	disparo
	call	dibuja_navejugador
	call	explosion
	call	mensaje_gameover
	call	mensaje_congrats
	halt
	jr	bucle_staff

mensaje_congrats:
	ld	hl,$40cb
	ld	de,txt_congrats
	call	imprimir_cadena
	ld	hl,$58ca
	ld	b,$0c
	ld	a,$c6			; Amarillo+Bright+Flash
	jp	pintar_attr

;---------------------------------------------------------------------------
;---                    SUB - L E V E L   U P                            ---
;---------------------------------------------------------------------------
level_up:
	ld	a,(settings)
	bit	B_LEVELUP,a
	ret	z

	ld	a,(pausa_i)		; Pausai sirve tb de contador de LevelUp
	dec	a
	jr	z,inicia_pausai_postnivel
	ld	(pausa_i),a

	ld	hl,$488c
	ld	de,txt_levelup
	call	imprimir_cadena
	ld	hl,$598c
	ld	b,8
	ld	a,%11000010		; Rojo Bright Flash
	jp	pintar_attr

inicia_pausai_postnivel:
	ld	a,PAUSA_INICIAL
	ld	(pausa_i),a

	ld	a,(settings)
	res	B_LEVELUP,a		; Level Up (OFF)
	res	B_JUGANDO,a		; Pausa Inicial (ON)
	ld	(settings),a

	xor	a
	ld	(contador_it),a
	ld	(cuantos_marc),a
	call	sub_attr
	call	reseteo_marcianos

	ld	a,(nivel)
	inc	a			; Incremento de Nivel
	ld	(nivel),a
	cp	2
	jr	c,sube_dificultad
	ld	a,1			; Si Nivel >= 2 MaxVelocidad
	ld	(velocidad),a

sube_dificultad:
	ld	a,(dificultad)
	or	a
	ret	z			; Ya en la maxima
	sub	$30
	ld	(dificultad),a
	ret

;---------------------------------------------------------------------------
;---                SUB - P A U S A   I N I C I A L                      ---
;---------------------------------------------------------------------------
pausa_inicial:
	ld	a,(settings)
	bit	B_JUGANDO,a
	ret	nz			; Ya jugando

	ld	a,(pausa_i)
	dec	a
	jr	z,gogogo		; Comenzar a Jugar
	ld	(pausa_i),a

	call	mover_marcianos		; (Se mueven, sin atacar)

	ld	hl,$488b
	ld	de,txt_preparado
	call	imprimir_cadena
	ld	hl,$598b
	ld	b,$0c
	ld	a,$45			; Azul Claro Bright
	jp	pintar_attr

;-------------------- COMENZAR A JUGAR --------------------------
gogogo:
	ld	a,PAUSA_INICIAL
	ld	(pausa_i),a

	ld	a,(settings)
	set	B_JUGANDO,a		; Pausa Inicial= OFF
	ld	(settings),a

	ld	a,2
	call	sonido
	inc	a
	call	sonido

	ld	hl,$488b		; Borrar 'PREPARADO...'
	ld	de,txt_blancos12
	jp	imprimir_cadena
