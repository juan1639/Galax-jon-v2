;===========================================================================
;===  GALAX JON - espacio.asm                                             ===
;===  Scroll de estrellas y next_scan                                     ===
;===========================================================================

;==========================================================================
;===                E S P A C I O   E S T R E L L A D O                 ===
;==========================================================================
;---------------------------------------------------------------------------
;---                  E S P A C I O   E S T R E L L A S                  ---
;---                                                                     ---
;---  Tabla 'estrellas': 3 bytes por estrella:                           ---
;---  DE(1) = H  ...  DE(2) = L  ...  DE(3) = Pixel (ej: %0000 1000)      ---
;---------------------------------------------------------------------------
espacio:
	ld	de,estrellas
	ld	b,NUM_ESTRELLAS

bucle_estrellas:
	ld	a,(de)
	ld	h,a
	inc	de
	ld	a,(de)
	ld	l,a
	ld	(hl),0		; Borrar estrella

	call	next_scan	; Baja un scanline
	call	scroll		; Vuelve arriba si ha llegado abajo

	inc	de
	ld	a,(de)
	ld	(hl),a		; Dibuja estrella

	dec	de
	ld	a,l
	ld	(de),a
	dec	de
	ld	a,h
	ld	(de),a		; Guarda la nueva posicion HL

	inc	de
	inc	de
	inc	de		; Siguiente estrella
	djnz	bucle_estrellas
	ret

;----------------------------------------------------------------
scroll:
	ld	a,h
	cp	%01010000	; Hipotetico 4to Tercio?
	ret	nz		; No? retorna y la estrella sigue...
	ld	a,l
	and	%11100000
	cp	%11100000
	ret	nz

	ld	h,%01000000	; Reinicia H (1er tercio)
	ld	a,l
	and	%00011111	; Linea 0 (000C CCCC)...
	add	a,$0e		; ...y cambia de columna (Pseudo-RND)
	ld	l,a
	ret

;---------------------------------------------------------------------------
;---                 SUB - N E X T   S C A N L I N E                     ---
;---                                                                     ---
;---   Entrada: HL --> Salida: HL ( Siguiente Scanline, teniendo en...   ---
;---            ...cuenta el posible cambio de Caracter o Tercio)        ---
;---------------------------------------------------------------------------
next_scan:
	inc	h
	ld	a,h		; 010T TSSS
	and	$07
	ret	nz		; Mismo caracter: hemos terminado

	ld	a,l		; LLLC CCCC
	add	a,$20
	ld	l,a
	ret	c		; Carry=1, cambio de tercio

	ld	a,h
	sub	$08
	ld	h,a
	ret
