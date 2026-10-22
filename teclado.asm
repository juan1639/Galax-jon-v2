;===========================================================================
;===  GALAX JON - teclado.asm                                             ===
;===  Lectura de teclado durante la partida                               ===
;===========================================================================

;==========================================================================
;===                         T E C L A D O                              ===
;==========================================================================
;---------------------------------------------------------------------------
;---                    SUB - L E E R   T E C L A D O                    ---
;---                                                                     ---
;---         Disparar ---------> Cursor '6' / '7'  (Abajo / Arriba)      ---
;---         Izquierda --------> Cursor '5'                              ---
;---         Derecha ----------> Cursor '8'                              ---
;---------------------------------------------------------------------------
teclado:
	ld	a,(cadencia)
	inc	a
	cp	CADENCIA_MAX+1
	jr	z,sepuede_disparar
	ld	(cadencia),a
	jr	tecla_izq

sepuede_disparar:
	ld	a,$ef			; Semifila 6...0
	in	a,($fe)
	and	%00011000		; Teclas '6' (Bit4) y '7' (Bit3)
	cp	%00011000
	jr	z,tecla_izq		; Ninguna pulsada

	ld	a,(settings)
	bit	B_DISPARO,a
	ret	nz			; Disparo ya ACTIVO
	jp	inicia_disparo

tecla_izq:
	ld	a,$f7			; Semifila 1...5
	in	a,($fe)
	bit	4,a			; Tecla '5'
	jr	nz,tecla_dcha

	ld	a,(rota_nave)
	sub	2			; Decrementa la Rotacion
	cp	$ff
	call	z,nave_izquierda	; Decrementa un caracter
	ld	(rota_nave),a
	ret

tecla_dcha:
	ld	a,$ef			; Semifila 6...0
	in	a,($fe)
	bit	2,a			; Tecla '8'
	ret	nz

	ld	a,(rota_nave)
	add	a,2			; Incrementa la Rotacion
	cp	9
	call	z,nave_derecha		; Incrementa un caracter
	ld	(rota_nave),a
	ret

;---------------------------------------------------------------------------
;---  Salen con A = nueva rotacion                                       ---
;---------------------------------------------------------------------------
nave_izquierda:
	ld	a,(navejugador_x)
	cp	$80			; Limite Izquierdo??
	ld	a,1
	ret	z
	ld	hl,navejugador_x
	dec	(hl)
	ld	a,7
	ret

nave_derecha:
	ld	a,(navejugador_x)
	cp	$9d			; Limite Derecho??
	ld	a,7
	ret	z
	ld	hl,navejugador_x
	inc	(hl)
	ld	a,1
	ret

;---------------------------------------------------------------------------
;---        SUB -  I M P R I M E   C A D E N C I A  (Disparo)            ---
;---------------------------------------------------------------------------
imprime_cadencia:
	ld	hl,$55e0
	ld	b,9			; Barrita Grafica de Cadencia
	ld	a,%01010101		; Discontinua (OFF)
	call	pintar_attr		; (sirve igual para pixels)

	ld	l,$e0
	ld	a,(cadencia)
	sra	a
	sra	a			; Cadencia / 4
	ld	b,a
	ld	a,%11111111		; Continua (ON)
	call	pintar_attr

	ld	hl,$50ea
	ld	de,txt_off
	ld	a,(cadencia)
	cp	CADENCIA_MAX
	jr	nz,imprime_onoff
	ld	de,txt_on
imprime_onoff:
	jp	imprimir_cadena
