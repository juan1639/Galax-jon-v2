;===========================================================================
;===  GALAX JON - textos.asm                                              ===
;===  Cadenas de texto del juego                                          ===
;===========================================================================

;==========================================================================
;===                          T E X T O S                               ===
;===  (Mayusculas, numeros y signos. Ver equivalencias en 'fuente')     ===
;==========================================================================
txt_on:		defb	"ON ",0
txt_off:	defb	"OFF",0
txt_creditos:	defb	C_COPY," CENTRO IMI 2022",0
txt_programado:	defb	"PROGRAMADO POR: J.EGUIA",0
txt_pulse:	defb	"PULSE CURSOR JOYSTICK",0
txt_gameover:	defb	"GAME OVER",0
txt_enter:	defb	"ENTER OTRA PARTIDA",0
txt_congrats:	defb	"ENHORABUENA!",0
txt_levelup:	defb	"LEVEL UP",0
txt_preparado:	defb	"PREPARADO...",0
txt_blancos12:	defb	"            ",0
txt_score:	defb	"SCORE:",0
txt_100:	defb	"100",0

;--- Indices de 'letras_grandes' ---
txt_galax:	defb	0,1,2,1,3,$ff	; G A L A X
txt_jon:	defb	4,5,6,$ff	; J O N
