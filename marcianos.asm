;===========================================================================
;===  GALAX JON - marcianos.asm                                           ===
;===  Movimiento y ataque de los marcianos                                ===
;===========================================================================

;==========================================================================
;===                        M A R C I A N O S                           ===
;==========================================================================
;---------------------------------------------------------------------------
;---               SUB - M O V E R   M A R C I A N O S                   ---
;---                                                                     ---
;---  Los marcianos no cambian de casilla: se "mueven" dibujando uno de  ---
;---  los 11 fotogramas (desplazados 1 pixel) de 3x1 caracteres.         ---
;---  Al llegar al final cambian de sentido y de animacion (3,2,1).      ---
;---                                                                     ---
;---  IX ---> Registro del marciano  ...  B ---> Bucle Nro. Marcianos    ---
;---------------------------------------------------------------------------
mover_marcianos:
	ld	ix,marcianos
	ld	b,NUM_MARCIANOS

bucle_marcianos:
	ld	a,(ix+M_ACTIVO)
	or	a
	jr	z,siguiente_marciano	; Marciano Inactivo

	inc	(ix+M_ROT)		; Siguiente rotacion
	ld	a,(ix+M_ROT)
	cp	FRAMES_ROT+1
	jr	z,cambia_sentido	; Ha llegado al final

	dec	a			; A = Fotograma (0..10) hacia la DCHA
	bit	7,(ix+M_DIR)
	jr	z,dibuja_marciano	; $01 = Derecha
	ld	c,a
	ld	a,FRAMES_ROT-1
	sub	c			; A = Fotograma (10..0) hacia la IZDA

dibuja_marciano:
	push	bc
	call	sprite_marciano		; DE = Sprite del fotograma
	ld	h,(ix+M_H)
	ld	l,(ix+M_L)
	ld	b,8			; Bucle $08 Scanlines

bucle_dibujamarciano:
	ld	a,(de)
	ld	(hl),a			; 1er Caracter...
	inc	de
	inc	l
	ld	a,(de)
	ld	(hl),a			; ...2do...
	inc	de
	inc	l
	ld	a,(de)
	ld	(hl),a			; ...3er Caracter
	inc	de
	dec	l
	dec	l
	inc	h			; Siguiente Scanline
	djnz	bucle_dibujamarciano
	pop	bc

siguiente_marciano:
	ld	de,M_TAM
	add	ix,de
	djnz	bucle_marcianos
	ret

;---------------------------------------------------------------------------
cambia_sentido:
	ld	(ix+M_ROT),0		; Rotacion = 0
	ld	a,(ix+M_DIR)
	neg				; $01 <---> $ff
	ld	(ix+M_DIR),a
	dec	(ix+M_ANIM)		; Siguiente animacion (3,2,1,3...)
	jr	nz,siguiente_marciano
	ld	(ix+M_ANIM),3
	jr	siguiente_marciano

;---------------------------------------------------------------------------
;---  SUB - Direccion del Sprite del marciano                            ---
;---  A = Fotograma (0..10), IX = Marciano  --->  DE = Sprite (24 bytes) ---
;---------------------------------------------------------------------------
sprite_marciano:
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl			; HL = Fotograma * 8
	ld	d,h
	ld	e,l
	add	hl,hl			; HL = Fotograma * 16
	add	hl,de			; HL = Fotograma * 24

	ld	a,(ix+M_ANIM)
	ld	de,sprites_rotamarciano3	; Animacion 1
	dec	a
	jr	z,suma_sprite
	ld	de,sprites_rotamarciano2	; Animacion 2
	dec	a
	jr	z,suma_sprite
	ld	de,sprites_rotamarciano		; Animacion 3
suma_sprite:
	add	hl,de
	ex	de,hl
	ret

;---------------------------------------------------------------------------
;---           S U B  -   I N I C I A   ATAQUE MARCIANO                  ---
;---                                                                     ---
;---  Dispara el 1er marciano vivo que este en la misma columna que      ---
;---  la nave del jugador.                                               ---
;---------------------------------------------------------------------------
inicia_marcataque:
	ld	a,(dificultad)
	ld	c,a			; C = Dificultad
	ld	a,(contador_it)
	cp	c
	ret	c			; Aun no toca atacar

	ld	a,(ataque_marciano)
	or	a
	ret	nz			; Ya hay un ataque en curso

	ld	a,(navejugador_x)
	and	%00011111
	ld	c,a			; C = Columna de la Nave-Jugador

	ld	ix,marcianos
	ld	b,NUM_MARCIANOS
	ld	de,M_TAM

bucle_busca_atacante:
	ld	a,(ix+M_ACTIVO)
	or	a
	jr	z,busca_siguiente	; Marciano abatido
	ld	a,(ix+M_L)
	and	%00011111
	cp	c
	jr	z,ataque_on		; Encontrado!
busca_siguiente:
	add	ix,de
	djnz	bucle_busca_atacante
	ret				; No hay atacante

ataque_on:
	ld	hl,ataque_marciano
	ld	(hl),1			; DE(1) Ataque ON
	inc	hl
	ld	(hl),$40		; DE(2) Coordenada 'H' Inicial
	inc	hl
	ld	a,(ix+M_L)
	inc	a			; Centro del marciano
	ld	(hl),a			; DE(3) Coordenada 'L' Inicial

	ld	a,3			; Sonido Ataque Marciano
	jp	sonido

;---------------------------------------------------------------------------
;---           S U B -  E L   A T A Q U E   M A R C I A N O              ---
;---                                                                     ---
;---    DE(1)---> Ataque ON/OFF                                          ---
;---    DE(2)---> Coordenada 'H'  ...  DE(3)---> Coordenada 'L'          ---
;---------------------------------------------------------------------------
marc_ataque:
	ld	de,ataque_marciano
	ld	a,(de)
	or	a
	ret	z			; Ataque=OFF

	inc	de
	ld	a,(de)
	ld	h,a			; H ... DE(2)
	inc	de
	ld	a,(de)
	ld	l,a			; L ... DE(3)

	ld	b,8			; Bucle $08 Scanlines
bucle_borramarcataque:
	ld	(hl),0			; Borrado
	inc	h
	djnz	bucle_borramarcataque

	ld	a,h
	sub	8
	ld	h,a			; Vuelve al 1er Scanline
	dec	de
	ld	(de),a

	ld	a,l
	add	a,$20			; Siguiente Linea
	call	c,aumenta_tercio	; Siguiente Tercio??
	ld	l,a
	inc	de
	ld	(de),a

;----------------------------------------------------
;---               NOS HAN DADO??                 ---
;----------------------------------------------------
	dec	de			; DE en 'H'
	ld	a,(de)
	inc	de
	cp	$50
	jr	nz,no_comprobar

	ld	a,(navejugador_x)
	ld	c,a
	ld	a,(de)
	cp	c
	jp	z,game_over
	inc	c
	cp	c
	jp	z,game_over

no_comprobar:
	ld	a,(ataque_marciano)	; Si Disparo-Marciano= OFF ...
	or	a
	ret	z			; ... Retorna

	ld	b,8			; Bucle $08 Scanlines
bucle_dibujamarcataque:
	ld	(hl),%00011100		; Dibuja Disparo Ataque-Marciano
	inc	h
	djnz	bucle_dibujamarcataque
	ret

;---------------------------------------------------------------------------
aumenta_tercio:
	push	af
	ld	a,h
	add	a,8			; Siguiente Tercio
	cp	$58			; Si $58, Disparo ha llegado abajo...
	call	z,ataque_off		; ... Entonces Disparo= OFF
	ld	h,a
	ld	(de),a
	pop	af
	ret

;-------------------------------------
ataque_off:
	xor	a
	ld	(ataque_marciano),a	; Disparo-Marciano= OFF
	push	de
	call	score			; Redibuja el Marcador
	pop	de
	ret
