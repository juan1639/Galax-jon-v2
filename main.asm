;===========================================================================
;===                                                                     ===
;===            G A L A X   J O N   -   ZX Spectrum 48K                  ===
;===            Ensamblador Z80 (pasmo --tapbas)                         ===
;===                                                                     ===
;===========================================================================
	org	$8000

	include	"constantes.asm"

;--------------------------------------------------------------------------
;---		ESTABLECE BORDE & ATRIBUTOS GENERALES                   ---
;--------------------------------------------------------------------------
	ld	a,%00000111	; 00BBB000 (B = Borde)
	ld	(BORDCR),a
	call	CLS		; Rutina ROM CLS
	xor	a		; Borde negro
	out	($fe),a

comienzo_ymp:
	call	sub_cls
	call	sub_clsattr
	call	sub_attr
	call	menu_principal	; -------------- Menu Principal -------------------
	call	sub_attr
	call	score

;==========================================================================
;---                                                                    ---
;---	               B U C L E    P R I N C I P A L                   ---
;---                                                                    ---
;==========================================================================
bucle_principal:
	call	espacio			; SUB espacio estrellado

	ld	a,(settings)
	bit	B_LEVELUP,a
	jr	nz,levelup_subs		; Level Up
	bit	B_JUGANDO,a
	jr	z,pausainicial_subs	; Preparado...
	bit	B_COMPLETADO,a
	jp	nz,fin			; Final, juego Completado!

	call	mover_marcianos		; SUB Mover Marcianos
	call	teclado			; SUB Leer Teclado/JoyStick
	call	inicia_marcataque	; SUB Posible inicio Marciano Disparo
	ld	hl,contador_it		; Contar Iteraciones
	inc	(hl)

levelup_subs:
	call	level_up		; SUB Level Up

pausainicial_subs:
	call	dibuja_navejugador	; SUB Dibuja Nave Jugador
	call	disparo			; SUB Disparo
	call	explosion		; SUB Explosion
	call	marc_ataque		; SUB Ataque Marciano (Cayendo Disparo)
	call	pausa_inicial		; SUB Pausa Inicial
	call	imprime_cadencia	; SUB Imprimir cadencia de disparo ON/OFF

	ld	a,(velocidad)
	call	ralentiza		; SUB Ralentiza (halt)
	jr	bucle_principal		; --------- Fin Bucle Principal -----------

;==========================================================================
;=================        S U B R U T I N A S        ======================
;==========================================================================
	include	"texto.asm"
	include	"nave.asm"
	include	"espacio.asm"
	include	"marcianos.asm"
	include	"disparo.asm"
	include	"explosion.asm"
	include	"teclado.asm"
	include	"menu.asm"
	include	"estados.asm"
	include	"score.asm"
	include	"inicializacion.asm"
	include	"sonido.asm"
	include	"musica.asm"

;==========================================================================
;=================            D A T O S              ======================
;==========================================================================
	include	"textos.asm"
	include	"graficos.asm"
	include	"fuente.asm"
	include	"variables.asm"

	end	$8000
