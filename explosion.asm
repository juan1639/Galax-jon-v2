;===========================================================================
;===  GALAX JON - explosion.asm                                           ===
;===  Explosion de los marcianos                                          ===
;===========================================================================

;==========================================================================
;===                       E X P L O S I O N                            ===
;==========================================================================
;---------------------------------------------------------------------------
;---            SUB - I N I C I A   E X P L O S I O N                    ---
;---  L ---> Posicion X del marciano abatido                             ---
;---------------------------------------------------------------------------
inicia_explosion:
	ld	a,(settings)
	set	B_EXPLOSION,a		; Activa la Explosion...
	res	B_DISPARO,a		; ...y desactiva el disparo
	ld	(settings),a

	ld	a,(score_012)
	inc	a			; Incrementar Score
	cp	100			; Hemos Completado el Juego??
	jr	z,juego_completado
	ld	(score_012),a

	push	hl
	call	score
	pop	hl

	ld	a,(cuantos_marc)
	inc	a
	cp	NUM_MARCIANOS		; Hemos abatido a Todos??
	call	z,activa_levelup
	ld	(cuantos_marc),a
	jr	posiciona_explosion

juego_completado:
	ld	a,(settings)
	set	B_COMPLETADO,a
	ld	(settings),a

posiciona_explosion:
	ld	a,7			; 7 Frames de Explosion
	ld	(contador_explo),a
	ld	a,$40			; (Todos Marcianos en 1er Tercio)
	ld	(explo_y),a
	ld	a,l
	ld	(explo_x),a
	ret

;----------------------------------------------------------------
activa_levelup:
	push	af
	ld	a,(settings)
	set	B_LEVELUP,a
	ld	(settings),a
	ld	a,PAUSA_INICIAL
	ld	(pausa_i),a
	xor	a
	ld	(contador_it),a
	pop	af
	ret

;---------------------------------------------------------------------------
;---                  SUB -  L A   E X P L O S I O N                     ---
;---                                                                     ---
;---  DE ---> Sprite = explosion_sprites + contador * 16  (2x1 chars)    ---
;---  HL ---> Puntero VRAM                                               ---
;---------------------------------------------------------------------------
explosion:
	ld	a,(settings)
	bit	B_EXPLOSION,a
	ret	z			; NO Explosion

	ld	a,(explo_y)
	ld	h,a
	ld	a,(explo_x)
	ld	l,a

	ld	b,8			; Bucle $08 Scanlines
bucle_scansborrado:
	dec	l			; Borrar a izda...
	ld	(hl),0
	inc	l
	inc	l
	inc	l			; ...y dcha
	ld	(hl),0
	dec	l
	dec	l
	inc	h
	djnz	bucle_scansborrado

	ld	a,h			; Regresa al 1er Scanline
	sub	8
	ld	h,a

	ld	a,(contador_explo)	; Frames de la explosion...
	ld	(soni_disp+1),a		; (Nota de la explosion = contador,$07)
	ld	a,7
	ld	(soni_disp),a
	ld	a,(contador_explo)
	dec	a
	ld	(contador_explo),a
	jr	z,anula_explosion	; Fin de la explosion

	push	hl
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl			; HL = Contador * 16
	ld	de,explosion_sprites
	add	hl,de
	ex	de,hl			; DE = Sprite de la explosion
	pop	hl

	ld	a,1
	call	sonido

	ld	b,8			; Bucle $08 Scanlines
bucle_explosion:
	ld	a,(de)
	ld	(hl),a
	inc	l
	inc	de
	ld	a,(de)
	ld	(hl),a
	dec	l
	inc	h
	inc	de
	djnz	bucle_explosion

	halt
	ret

;---------------------------------------------------------------------------
anula_explosion:
	ld	a,(settings)
	res	B_EXPLOSION,a		; Explosion OFF
	ld	(settings),a

	ld	a,7			; Reinicia el Contador de Explosion
	ld	(contador_explo),a

	ld	b,8			; Bucle $08 Scanlines
bucle_borradofinal:
	ld	(hl),0			; Borrado Final
	inc	l
	ld	(hl),0
	dec	l
	inc	h
	djnz	bucle_borradofinal
	ret
