;===========================================================================
;===  GALAX JON - nave.asm                                                ===
;===  Nave del jugador                                                    ===
;===========================================================================

;==========================================================================
;===                      N A V E   J U G A D O R                       ===
;==========================================================================
;---------------------------------------------------------------------------
;---		         SUB - DIBUJA NAVE JUGADOR                      ---
;---                                                                    ---
;---  HL---> Coordenadas Nave (3er tercio, fila fija)                   ---
;---  DE---> Sprite = sprites_rotanavejugador + (rota_nave - 1) * 48    ---
;---  (Sprite de 3x2 caracteres = 48 bytes por rotacion)                ---
;--------------------------------------------------------------------------
dibuja_navejugador:
	ld	h,$50				; H = 3er Tercio FIJO
	ld	a,(navejugador_x)
	ld	l,a				; L = Coordenada X Nave-Jugador
	call	borra_navejugador		; Borra el posible rastro anterior

	push	hl
	ld	a,(rota_nave)
	dec	a
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl				; HL = (rota_nave - 1) * 16
	ld	d,h
	ld	e,l
	add	hl,hl				; HL = (rota_nave - 1) * 32
	add	hl,de				; HL = (rota_nave - 1) * 48
	ld	de,sprites_rotanavejugador
	add	hl,de
	ex	de,hl				; DE = Sprite que toca
	pop	hl

	ld	b,16				; Bucle $10 Scanlines

bucle_dibujanave:
	ld	a,(de)			; Byte izquierdo...
	ld	(hl),a
	inc	l
	inc	de
	ld	a,(de)			; ...central...
	ld	(hl),a
	inc	l
	inc	de
	ld	a,(de)			; ...y derecho
	ld	(hl),a
	inc	de
	dec	l
	dec	l
	call	next_scan		; Siguiente scanline (cambia de linea si toca)
	djnz	bucle_dibujanave
	ret

;---------------------------------------------------------------------------
;---            SUB -  B O R R A   N A V E   J U G A D O R               ---
;---                                                                     ---
;---  Borra la columna a la izquierda de la 2da fila de la nave          ---
;---  (rastro que queda al moverse un caracter a la derecha)             ---
;---------------------------------------------------------------------------
borra_navejugador:
	push	hl
	ld	a,l
	add	a,$1f
	ld	l,a		; Una linea abajo y un caracter a la IZDA
	ld	b,8		; Bucle $08 Scanlines

bucle_borranavejugador:
	ld	(hl),0		; Borrado
	inc	h
	djnz	bucle_borranavejugador
	pop	hl
	ret
