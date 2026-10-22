;===========================================================================
;===  GALAX JON - menu.asm                                                ===
;===  Menu principal (titulo, creditos, estrella)                         ===
;===========================================================================

;==========================================================================
;===                    M E N U   P R I N C I P A L                     ===
;==========================================================================
;---------------------------------------------------------------------------
;---                SUB - M E N U   P R I N C I P A L                    ---
;---------------------------------------------------------------------------
menu_principal:
	ld	a,1
	ld	(rota_estrella),a	; Inicia animacion estrella
	call	inicia_melodia		; La melodia empieza desde el principio

bucle_menu:
	call	espacio			; Scroll espacial estrellas
	call	estrella		; Animacion Estrella
	call	attr_mp
	call	galax_jon
	call	creditos
	call	pulse_continuar
	call	teclado_mp
	ret	c			; Tecla pulsada: a jugar!
	call	tocar_melodia		; Carry=1 si ha sonado una nota...
	jr	c,menu_un_halt		; ...(la nota ya ocupa ~1 frame)
	halt
menu_un_halt:
	halt
	jr	bucle_menu

;---------------------------------------------------------------------------
;---                SUB - T E C L A D O   MENU PRINCIPAL                 ---
;---                                                                     ---
;---  Cursor '5','6','7','8' o ESPACIO ----> Carry = 1 (Comenzar)       ---
;---------------------------------------------------------------------------
teclado_mp:
	ld	a,$f7			; Semifila 1...5
	in	a,($fe)
	bit	4,a			; Tecla '5'
	jr	z,comenzar_ajugar

	ld	a,$7f			; Semifila ESPACIO...B
	in	a,($fe)
	rra				; Bit0 = ESPACIO
	jr	nc,comenzar_ajugar

	ld	a,$ef			; Semifila 6...0
	in	a,($fe)
	cpl
	and	%00011100		; Teclas '6','7','8'
	ret	z			; Ninguna pulsada (Carry = 0)

comenzar_ajugar:
	ld	a,4
	call	sonido
	call	sub_cls
	call	sub_clsattr
	scf				; Carry = 1
	ret

;---------------------------------------------------------------------------
creditos:
	ld	hl,$50e7
	ld	de,txt_creditos
	call	imprimir_cadena
	ld	hl,$5045
	ld	de,txt_programado
	jp	imprimir_cadena

pulse_continuar:
	ld	hl,$48a6
	ld	de,txt_pulse
	jp	imprimir_cadena

;---------------------------------------------------------------------------
;---  Titulo con letras grandes (2x2 caracteres)                         ---
;---------------------------------------------------------------------------
galax_jon:
	ld	hl,$4069
	ld	de,txt_galax
	call	imprimir_grande
	ld	hl,$40cc
	ld	de,txt_jon
					; ...continua en imprimir_grande
;---------------------------------------------------------------------------
;---         SUB - I M P R I M I R   L E T R A S   G R A N D E S         ---
;---                                                                     ---
;---  HL ---> VRAM (1er tercio)                                          ---
;---  DE ---> Indices de 'letras_grandes' terminados en $ff              ---
;---------------------------------------------------------------------------
imprimir_grande:
	ld	a,(de)
	cp	$ff
	ret	z
	push	de
	push	hl
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl			; HL = Indice * 32
	ld	de,letras_grandes
	add	hl,de
	ex	de,hl
	pop	hl
	call	imprimir_letragrande
	pop	de
	inc	de
	jr	imprimir_grande

imprimir_letragrande:
	ld	b,16			; Bucle 16 Scanlines

bucle_imprimirgalaxjon:
	ld	a,(de)
	ld	(hl),a			; Byte izquierdo...
	inc	l
	inc	de
	ld	a,(de)
	ld	(hl),a			; ...y derecho
	dec	l
	inc	h
	ld	a,h
	cp	$48			; Cambio de Linea??
	call	z,linea_siguiente
	inc	de
	djnz	bucle_imprimirgalaxjon

	ld	a,l
	sub	$40
	ld	l,a			; Vuelve 2 lineas arriba...
	ld	h,$40			; ...al 1er Scanline
	inc	l
	inc	l
	inc	l			; Siguiente letra (2 chars + espacio)
	ret

;---------------------------------------------------------------------------
;---  A = H (que acaba de pasar al siguiente caracter)                   ---
;---------------------------------------------------------------------------
linea_siguiente:
	sub	8			; Vuelve al 1er Scanline...
	ld	h,a
	ld	a,l
	add	a,$20			; ...de la siguiente linea
	ld	l,a
	ret

;---------------------------------------------------------------------------
;---          SUB - A N I M A C I O N   E S T R E L L A                  ---
;---------------------------------------------------------------------------
estrella:
	ld	a,(rota_estrella)
	cp	$1a
	jr	nc,no_estrella		; Estrella "apagada" en estos frames

	dec	a
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl			; HL = (Rotacion - 1) * 8
	ld	de,estrella_anima
	add	hl,de
	ex	de,hl

	ld	h,$48
	ld	b,8
bucle_scansestrella:
	ld	a,(de)
	ld	l,$32
	ld	(hl),a			; 1ra estrella...
	ld	l,$45
	ld	(hl),a			; ...Segunda estrella
	ld	l,$d6
	ld	(hl),a			; ...Tercera
	inc	h
	inc	de
	djnz	bucle_scansestrella

	ld	a,%01000111
	ld	($5932),a		; Attr de la 1ra estrella (Blanco)

no_estrella:
	ld	a,(rota_estrella)
	inc	a
	cp	$50			; llegamos a $50?? ...
	jr	nz,guarda_rotaestrella
	ld	a,1			; ...Reiniciar Rotacion Estrella
guarda_rotaestrella:
	ld	(rota_estrella),a
	ret

;---------------------------------------------------------------------------
;---                 SUB - A T T R  -  MENU PRINCIPAL                    ---
;---------------------------------------------------------------------------
attr_mp:
	ld	hl,$5869
	ld	b,$0e

bucle_attrmp:
	ld	(hl),$04		; Galax (Verde arriba)
	ld	a,l
	add	a,$20
	ld	l,a
	ld	(hl),$06		; Galax (Amarillo abajo)
	add	a,$40
	ld	l,a
	ld	(hl),$04		; Jon (Verde arriba)
	add	a,$20
	ld	l,a
	ld	(hl),$06		; Jon (Amarillo abajo)
	sub	$80
	ld	l,a
	inc	l
	djnz	bucle_attrmp

	ld	hl,$5a45
	ld	b,$10
	ld	a,%01000101		; Programado por (Azul Claro Bright)
	call	pintar_attr

	ld	hl,$5ae7
	ld	b,$11
	ld	a,%01000010		; Creditos (Rojo Bright)
	call	pintar_attr

	ld	hl,$59a6
	ld	b,$15
	ld	a,%10000011		; Pulse... (Magenta Flash)
	jp	pintar_attr
