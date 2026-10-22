;===========================================================================
;===  GALAX JON - texto.asm                                               ===
;===  Imprimir cadenas, caracteres y atributos                            ===
;===========================================================================

;==========================================================================
;===                 R U T I N A S   D E   T E X T O                    ===
;==========================================================================
;---------------------------------------------------------------------------
;---                SUB - I M P R I M I R   C A D E N A                  ---
;---                                                                     ---
;---  HL ---> Direccion VRAM (1er scanline del 1er caracter)             ---
;---  DE ---> Cadena ASCII terminada en 0                                ---
;---  Sale: HL en la columna siguiente al ultimo caracter                ---
;---------------------------------------------------------------------------
imprimir_cadena:
	ld	a,(de)
	or	a
	ret	z			; Fin de cadena
	push	de
	call	imprimir_ascii
	pop	de
	inc	de
	jr	imprimir_cadena

;---------------------------------------------------------------------------
;---                SUB - I M P R I M I R   A S C I I                    ---
;---                                                                     ---
;---  A  ---> Codigo ASCII (32..95)                                      ---
;---  HL ---> Direccion VRAM  (Sale con L + 1)                           ---
;---------------------------------------------------------------------------
imprimir_ascii:
	push	hl
	sub	32			; La fuente empieza en el ASCII 32
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl			; HL = (ASCII - 32) * 8
	ld	de,fuente
	add	hl,de
	ex	de,hl			; DE = Bytes del caracter
	pop	hl
					; ... y continua en imprimir_char
;---------------------------------------------------------------------------
;---                 SUB - I M P R I M I R   C H A R                     ---
;---                                                                     ---
;---  DE ---> 8 bytes del caracter  ...  HL ---> Direccion VRAM          ---
;---------------------------------------------------------------------------
imprimir_char:
	ld	b,8			; Bucle $08 Scanlines

bucle_imprimir:
	ld	a,(de)			; Carga en A, el Byte a imprimir...
	ld	(hl),a			; ... Imprimelo en HL
	inc	h
	inc	de
	djnz	bucle_imprimir

	ld	a,h
	sub	8
	ld	h,a			; Volver al 1er Scanline
	inc	l			; Siguiente columna
	ret

;---------------------------------------------------------------------------
;---           SUB - P I N T A R   A T R I B U T O S                     ---
;---                                                                     ---
;---  HL ---> Direccion de atributos ... B ---> Nro. celdas ... A ---> Attr ---
;---------------------------------------------------------------------------
pintar_attr:
	ld	(hl),a
	inc	l
	djnz	pintar_attr
	ret
