;===========================================================================
;===  GALAX JON - constantes.asm                                          ===
;===  ROM, constantes, estructuras y bits de settings                     ===
;===========================================================================

;---------------------------------------------------------------------------
;---          R O M   Y   V A R I A B L E S   D E L   S I S T E M A      ---
;---------------------------------------------------------------------------
BORDCR:		equ	$5c48	; Variable sistema: color del borde
CLS:		equ	$0daf	; Rutina ROM: CLS
BEEPER:		equ	$03b5	; Rutina ROM: BEEPER (HL = Nota, DE = Duracion)
				; ...( Altera Registros: AF,BC,DE,HL,IX )

;---------------------------------------------------------------------------
;---                       C O N S T A N T E S                           ---
;---------------------------------------------------------------------------
NUM_MARCIANOS:	equ	25	; Marcianos por nivel ($19)
NUM_ESTRELLAS:	equ	36	; Estrellas del scroll ($24)
FRAMES_ROT:	equ	11	; Fotogramas de rotacion de un marciano
PAUSA_INICIAL:	equ	$59	; Duracion de 'PREPARADO...' y de 'LEVEL UP'
CADENCIA_MAX:	equ	$24	; Cadencia a la que se permite disparar

;--- Estructura de cada marciano en la tabla 'marcianos' (7 bytes) ---
M_H:		equ	0	; Parte alta 'H' de su direccion VRAM
M_L:		equ	1	; Parte baja 'L' de su direccion VRAM
M_NUM:		equ	2	; Numero de marciano
M_ACTIVO:	equ	3	; 1 = vivo / 0 = abatido
M_DIR:		equ	4	; $01 = Derecha / $ff = Izquierda
M_ROT:		equ	5	; Rotacion actual (1..11, 0 = cambio de sentido)
M_ANIM:		equ	6	; Que animacion toca (3,2,1)
M_TAM:		equ	7	; Tamano del registro

;--- Bits de la variable 'settings' ---
B_COMPLETADO:	equ	0	; 1 = Juego completado
B_DISPARO:	equ	1	; 1/0 = Disparo ON/OFF
B_EXPLOSION:	equ	2	; 1/0 = Explosion ON/OFF
B_LEVELUP:	equ	3	; 1/0 = Level Up ON/OFF
B_DIBUJA_DISP:	equ	5	; 1 = Dibuja disparo / 0 = Borra disparo
B_JUGANDO:	equ	7	; 0 = Pausa inicial / 1 = Jugando

;--- Sonidos ( Notas y duraciones ) ---
s_1:		equ	$0f07		; Nota (Vida menos)
s1_dura:	equ	$0082 / $10	; Duracion
s_2:		equ	$066e		; Nota (Pal)
s2_dura:	equ	$0105 / $10	; Duracion
s_3:		equ	$0326		; Nota (Reb)
s3_dura:	equ	$020B / $10	; Duracion
s_4:		equ	$0d0f		; Nota (Pulsa-Menus)
s4_dura:	equ	$0184 / $10	; Duracion

;--- Caracteres especiales de la fuente (ver 'fuente' al final) ---
C_COPY:		equ	'['	; (c) Copyright
