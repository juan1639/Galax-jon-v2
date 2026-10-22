;===========================================================================
;===  GALAX JON - score.asm                                               ===
;===  Marcador y banderitas de nivel                                      ===
;===========================================================================

;==========================================================================
;===                            S C O R E                               ===
;==========================================================================
score:
	ld	hl,$50f5
	ld	de,txt_score		; 'SCORE:'
	call	imprimir_cadena

	ld	a,(score_012)		; HL = $50fb (Decenas)
	ld	c,'0'
calcula_decenas:
	cp	10
	jr	c,imprime_score
	sub	10
	inc	c
	jr	calcula_decenas

imprime_score:
	push	af			; A = Unidades
	ld	a,c
	call	imprimir_ascii		; Decenas
	pop	af
	add	a,'0'
	call	imprimir_ascii		; Unidades

;------------------------------------------
	ld	a,(nivel)		; Dibuja Banderitas
	or	a
	ret	z			; (Nivel 1)
	ld	hl,$50ed
	ld	b,a

bucle_banderitas:
	push	bc
	ld	de,banderita		; Sprite 2x1 caracteres (bytes intercalados)
	ld	b,8			; Bucle $08 Scanlines
bucle_scansband:
	ld	a,(de)
	ld	(hl),a			; 'Mastil'
	inc	l
	inc	de
	ld	a,(de)
	ld	(hl),a			; 'Bandera'
	dec	l
	inc	h
	inc	de
	djnz	bucle_scansband

	ld	a,h
	sub	8			; Vuelve al 1er Scanline
	ld	h,a
	inc	l
	inc	l			; Siguiente Banderita
	pop	bc
	djnz	bucle_banderitas
	ret
