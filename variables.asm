;===========================================================================
;===  GALAX JON - variables.asm                                           ===
;===  Variables y tabla de marcianos                                      ===
;===========================================================================

;--------------------------------------------------------------------------
;---                       V A R I A B L E S                            ---
;--------------------------------------------------------------------------
velocidad	defb $02	; Velocidad del juego (RAPIDO) 1,2,3...(LENTO)
cuantos_marc	defb $00	; Marcianos eliminados en este nivel
score_012	defb $00	; Score (Marcianos eliminados en total)
dificultad	defb $60	; Dificultad (Intensidad de los disparos Marcianos)
vidas		defb $03	; Vidas del Jugador (3 por defecto)
nivel		defb $00	; Nivel actual (Tb cuantas Banderitas)
disparo_y	defb $50	; Posicion Y ('H' L) del disparo
disparo_x	defb $6f	; Posicion "X" (H 'L') del disparo
cadencia	defb $04	; Cadencia del disparo ($04)
explo_y		defb $40	; Posicion Y ('H'--> hl) de la Explosion
explo_x		defb $00	; Posicion X ('L'--> hl) de la Explosion
contador_explo	defb $07	; Contador Fotogramas Explosion
contador_it	defb $00	; Contador General Iteraciones Bucle
navejugador_x	defb $8f	; Coordenada X, 'L' (hl) de la Nave-Jugador
rota_nave	defb $03	; Rotacion de la Nave-Jugador (1,3,5,7)
rota_disparo	defb $03	; Rotacion del Disparo (Depende de RotaNave)
rota_estrella	defb $01	; Rotacion Animacion Estrella (Menu Principal)
pausa_i		defb $59	; Contador Pausa Inicial (Preparado) / Level Up
soni_disp	defw $0407	; Nota del sonido variable (disparo, explosion...)
mus_pos		defw $0000	; Posicion actual en la melodia del menu
mus_espera	defb $00	; Vueltas que faltan para la siguiente nota
settings	defb $00	; Bits: ver constantes B_xxx al principio

ataque_marciano:		; ON/OFF, H, L del disparo marciano
	defb	$00,$40,$02

;--- H, L, Nro, Activo, Direccion, Rotacion, Animacion (ver M_xxx) ---
marcianos:
defb	$40,$22,$01,$01,$01,$00,$03
defb	$40,$26,$02,$01,$01,$00,$03
defb	$40,$2a,$03,$01,$01,$00,$03
defb	$40,$2e,$04,$01,$01,$00,$03
defb	$40,$32,$05,$01,$01,$00,$03
defb	$40,$36,$06,$01,$01,$00,$03
defb	$40,$3a,$07,$01,$01,$00,$03

defb	$40,$64,$08,$01,$01,$00,$03
defb	$40,$68,$09,$01,$01,$00,$03
defb	$40,$6c,$0a,$01,$01,$00,$03
defb	$40,$70,$0b,$01,$01,$00,$03
defb	$40,$74,$0c,$01,$01,$00,$03
defb	$40,$78,$0d,$01,$01,$00,$03
defb	$40,$7c,$0e,$01,$01,$00,$03

defb	$40,$a2,$0f,$01,$01,$00,$03
defb	$40,$aa,$10,$01,$01,$00,$03
defb	$40,$b2,$11,$01,$01,$00,$03
defb	$40,$ba,$12,$01,$01,$00,$03

defb	$40,$e3,$13,$01,$01,$00,$03
defb	$40,$e7,$14,$01,$01,$00,$03
defb	$40,$eb,$15,$01,$01,$00,$03
defb	$40,$ef,$16,$01,$01,$00,$03
defb	$40,$f3,$17,$01,$01,$00,$03
defb	$40,$f7,$18,$01,$01,$00,$03
defb	$40,$fb,$19,$01,$01,$00,$03
